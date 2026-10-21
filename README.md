# Spotify Listener Insights System (SLIS)

BUS393 Group Project

A relational database for a music-streaming service, modelled after Spotify. It tracks
listeners, their subscriptions and devices, the catalog of artists, albums and songs, and
the listening activity that connects the two — then answers a set of business questions
about that activity with SQL.

Everything lives in one script: [spotify_listeners_insights_db.sql](spotify_listeners_insights_db.sql).

## Contents of the script

The file runs top to bottom in four sections:

| Lines | Section | What it does |
| --- | --- | --- |
| 1–11 | Teardown | `DROP TABLE` for all ten tables, in reverse dependency order, so the script can be re-run |
| 15–148 | Table creation | Ten `CREATE TABLE` statements with primary keys, foreign keys and a check constraint |
| 151–523 | Sample data | 310 `INSERT` rows across all ten tables |
| 526–609 | Business queries | Six analytical `SELECT` queries, line-commented |

## Schema

Ten tables:

**Listeners and accounts**

- **`User`** — listener profile (name, email, phone, address). PK `UserID`.
- **`SubscriptionType`** — one subscription per user, `SubType` constrained to `'Free'` or
  `'Premium'`. PK `SubscriptionID`, FK → `User`.
- **`FreeSubscription`** — subtype of `SubscriptionType`; holds `DaysLeft`. PK/FK `SubscriptionID`.
- **`PremiumSubscription`** — subtype of `SubscriptionType`; holds `RenewDate` and `BillAmount`.
  PK/FK `SubscriptionID`.
- **`Device`** — a device a user listens on (Mobile, Desktop, Tablet, …). PK `DeviceID`, FK → `User`.

**Catalog**

- **`Artist`** — artist name, release count, average monthly listeners. PK `ArtistID` (ISNI-style, 16 chars).
- **`Album`** — album name, length and release date. PK `AlbumID`.
- **`ArtistAlbum`** — associative entity resolving the many-to-many between artists and albums
  (a collaboration or feature puts several artists on one album). Composite PK (`ArtistID`, `AlbumID`).
- **`Song`** — one row per recording: title, duration and genre. PK `ISRC`, FKs → `Artist`, `Album`.

**Listening activity**

- **`Streams`** — one row per play: who listened, what they played, and when. PK `StreamID`,
  FKs → `User`, `Song`. This is the associative entity resolving the many-to-many between
  listeners and songs: a listener plays many songs, and a song is played by many listeners.

Relationships:

```
User ──1:1── SubscriptionType ──┬── FreeSubscription
 │  │                           └── PremiumSubscription
 │  └──1:M── Device
 └──1:M── Streams ──M:1── Song ──M:1── Artist ──┐
                             └──M:1── Album ──M:N (via ArtistAlbum)
```

`User` and `Song` are the two independent ends; `Streams` sits between them, so
`User ──M:N── Song` is resolved through it the same way `Artist ──M:N── Album` is resolved
through `ArtistAlbum`.

### Sample data

| Table | Rows |
| --- | --- |
| `User` | 30 |
| `SubscriptionType` | 30 (one per user) |
| `FreeSubscription` | 14 |
| `PremiumSubscription` | 16 |
| `Device` | 10 |
| `Artist` | 20 |
| `Album` | 15 |
| `ArtistAlbum` | 25 |
| `Song` | 60 |
| `Streams` | 90 |

Every user has at least one play, every song has at least one play, and 24 songs are played by
more than one listener (up to 4), so the many-to-many between listeners and songs is actually
exercised by the data rather than just permitted by the schema.

The catalog data uses real artists, albums and songs; users and contact details are fabricated.

## Business queries

| # | Question | SQL features |
| --- | --- | --- |
| Q1 | Who is the top artist in each genre? | `JOIN`, `GROUP BY`, correlated subquery |
| Q2 | Who are the top 10 listeners by play count? | `JOIN`, `GROUP BY`, `COUNT`, `TOP` |
| Q3 | Which genre has the most plays? | `JOIN`, `GROUP BY`, `COUNT` |
| Q4 | Which subscription type is used most? | `GROUP BY`, `COUNT` |
| Q5 | Which month generated the most subscription revenue? | `JOIN`, `GROUP BY`, `SUM`, `MONTH`/`DATENAME` |
| Q6 | Which genres are most popular among Premium vs. Free users? | multiple `JOIN`s, `GROUP BY`, `COUNT` |

## Running it

Written in **T-SQL for Microsoft SQL Server** — it uses `[User]` bracket quoting, `SELECT TOP n`,
`DATENAME()` and the `DATETIME2` type, none of which are portable to MySQL or PostgreSQL as written.

1. Create or select a database in SQL Server Management Studio or Azure Data Studio.
2. Open `spotify_listeners_insights_db.sql` and run the teardown, creation and insert sections
   (lines 1–523) as one batch.
3. Run the queries in the final section individually, so each result set comes back on its own.

Order matters in both directions. Tables are created parents-first (`Song` before `Streams`,
because `Streams` references it) and dropped children-first, which is why the teardown block is
the reverse of the creation order.

## Design notes

- `User.SubscriptionID` carries no foreign key, because `User` and `SubscriptionType` reference
  each other; the link is enforced only from the `SubscriptionType` side.
- Several date and money columns are typed `VARCHAR`/`CHAR` rather than `DATE` or `DECIMAL`
  (`SubscriptionType.StartDateTime`, `PremiumSubscription.BillAmount`), which is why Q5 has to
  `CAST` them.
- `Streams` stores only what happened, not summaries of it. "Top genre for a user" and similar
  figures are derived at query time (Q3 and Q6) rather than stored as text on the stream row.
- A few songs sit on an album by a different artist than the one the track is credited to, a
  carry-over from the original sample data. The `ArtistAlbum` feature rows cover most of these,
  but not all; the FKs are valid either way.
