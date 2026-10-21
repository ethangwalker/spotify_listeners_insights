-- Drop in reverse dependency order: a table is dropped before the tables it references.
DROP TABLE IF EXISTS Streams;
DROP TABLE IF EXISTS Song;
DROP TABLE IF EXISTS ArtistAlbum;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Artist;
DROP TABLE IF EXISTS Device;
DROP TABLE IF EXISTS FreeSubscription;
DROP TABLE IF EXISTS PremiumSubscription;
DROP TABLE IF EXISTS SubscriptionType;
DROP TABLE IF EXISTS [User];



-- BUS393 Midterm Group Project - Squad 7
-- Spotify Listener Insights System (SLIS)
-- SQL Table Creation Script

-- =============================================
-- 1. User (parent table)
-- =============================================
CREATE TABLE [User] (
    UserID          CHAR(10)        NOT NULL,
    FirstName       VARCHAR(50)     NOT NULL,
    LastName        VARCHAR(50)     NOT NULL,
    Email           VARCHAR(50)     NOT NULL,
    PhoneNumber     VARCHAR(11)     NOT NULL,
    Address         VARCHAR(100)    NOT NULL,
    SubscriptionID  CHAR(10)        NOT NULL,
    CONSTRAINT PK_User PRIMARY KEY (UserID)
);

-- =============================================
-- 2. SubscriptionType (child of User)
-- =============================================
CREATE TABLE SubscriptionType (
    SubscriptionID  CHAR(10)        NOT NULL,
    SubType         VARCHAR(50)     NOT NULL,
    StartDateTime   CHAR(10)        NOT NULL,
    EndDateTime     CHAR(10)        NOT NULL,
    UserID          CHAR(10)        NOT NULL,
    CONSTRAINT PK_SubscriptionType PRIMARY KEY (SubscriptionID),
    CONSTRAINT CK_SubType CHECK (SubType IN ('Free', 'Premium')),
    CONSTRAINT FK_SubType_User FOREIGN KEY (UserID)
        REFERENCES [User](UserID)
);

-- =============================================
-- 3. FreeSubscription (subtype)
-- =============================================
CREATE TABLE FreeSubscription (
    SubscriptionID  CHAR(10)        NOT NULL,
    DaysLeft        VARCHAR(30)     NOT NULL,
    CONSTRAINT PK_FreeSubscription PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_FreeSub_SubType FOREIGN KEY (SubscriptionID)
        REFERENCES SubscriptionType(SubscriptionID)
);

-- =============================================
-- 4. PremiumSubscription (subtype)
-- =============================================
CREATE TABLE PremiumSubscription (
    SubscriptionID  CHAR(10)        NOT NULL,
    RenewDate       VARCHAR(50)     NOT NULL,
    BillAmount      VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_PremiumSubscription PRIMARY KEY (SubscriptionID),
    CONSTRAINT FK_PremSub_SubType FOREIGN KEY (SubscriptionID)
        REFERENCES SubscriptionType(SubscriptionID)
);

-- =============================================
-- 5. Device
-- =============================================
CREATE TABLE Device (
    DeviceID    VARCHAR(50)     NOT NULL,
    Type        VARCHAR(50)     NOT NULL,
    UserID      CHAR(10)        NOT NULL,
    CONSTRAINT PK_Device PRIMARY KEY (DeviceID),
    CONSTRAINT FK_Device_User FOREIGN KEY (UserID)
        REFERENCES [User](UserID)
);

-- =============================================
-- 6. Artist
-- =============================================
CREATE TABLE Artist (
    ArtistID            CHAR(16)        NOT NULL,
    ArtistName          VARCHAR(50)     NOT NULL,
    Releases            INT             NOT NULL,
    AvgMonthlyListeners DECIMAL         NOT NULL,
    CONSTRAINT PK_Artist PRIMARY KEY (ArtistID)
);

-- =============================================
-- 7. Album
-- =============================================
CREATE TABLE Album (
    AlbumID     CHAR(16)        NOT NULL,
    AlbumName   VARCHAR(50)     NOT NULL,
    Length      TIME            NOT NULL,
    ReleaseDate DATETIME2       NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY (AlbumID)
);

-- =============================================
-- 8. ArtistAlbum (associative entity for M:N between Artist and Album)
-- =============================================
CREATE TABLE ArtistAlbum (
    ArtistID    CHAR(16)        NOT NULL,
    AlbumID     CHAR(16)        NOT NULL,
    CONSTRAINT PK_ArtistAlbum PRIMARY KEY (ArtistID, AlbumID),
    CONSTRAINT FK_ArtistAlbum_Artist FOREIGN KEY (ArtistID)
        REFERENCES Artist(ArtistID),
    CONSTRAINT FK_ArtistAlbum_Album FOREIGN KEY (AlbumID)
        REFERENCES Album(AlbumID)
);

-- =============================================
-- 9. Song (catalog entry for a recording; references Artist and Album)
-- =============================================
CREATE TABLE Song (
    ISRC        CHAR(12)        NOT NULL,
    Title       VARCHAR(50)     NOT NULL,
    ArtistID    CHAR(16)        NOT NULL,
    Duration    TIME            NOT NULL,
    AlbumID     CHAR(16)        NOT NULL,
    Genre       VARCHAR(30)     NOT NULL,
    CONSTRAINT PK_Song PRIMARY KEY (ISRC),
    CONSTRAINT FK_Song_Artist FOREIGN KEY (ArtistID)
        REFERENCES Artist(ArtistID),
    CONSTRAINT FK_Song_Album FOREIGN KEY (AlbumID)
        REFERENCES Album(AlbumID)
);

-- =============================================
-- 10. Streams (one row per play: associative entity between User and Song)
-- =============================================
CREATE TABLE Streams (
    StreamID    CHAR(10)        NOT NULL,
    UserID      CHAR(10)        NOT NULL,
    ISRC        CHAR(12)        NOT NULL,
    PlayedAt    DATETIME2       NOT NULL,
    CONSTRAINT PK_Streams PRIMARY KEY (StreamID),
    CONSTRAINT FK_Streams_User FOREIGN KEY (UserID)
        REFERENCES [User](UserID),
    CONSTRAINT FK_Streams_Song FOREIGN KEY (ISRC)
        REFERENCES Song(ISRC)
);


-- BUS393 Midterm Group Project - Squad 7
-- Spotify Listener Insights System (SLIS)
-- INSERT Data Script

-- =============================================
-- 1. User (30 records)
-- =============================================
INSERT INTO [User] (UserID, FirstName, LastName, Email, PhoneNumber, Address, SubscriptionID)
VALUES
('U000000001', 'James', 'Mitchell', 'james.mitchell@gmail.com', '14155551001', '123 Market St, San Francisco, CA 94105', 'S000000001'),
('U000000002', 'Sofia', 'Ramirez', 'sofia.ramirez@yahoo.com', '13105551002', '456 Sunset Blvd, Los Angeles, CA 90028', 'S000000002'),
('U000000003', 'Liam', 'Chen', 'liam.chen@outlook.com', '12125551003', '789 Broadway, New York, NY 10003', 'S000000003'),
('U000000004', 'Olivia', 'Johnson', 'olivia.j@gmail.com', '17735551004', '321 Michigan Ave, Chicago, IL 60601', 'S000000004'),
('U000000005', 'Noah', 'Williams', 'noah.will@gmail.com', '12065551005', '654 Pike St, Seattle, WA 98101', 'S000000005'),
('U000000006', 'Emma', 'Davis', 'emma.davis@yahoo.com', '13035551006', '987 Colfax Ave, Denver, CO 80202', 'S000000006'),
('U000000007', 'Ethan', 'Garcia', 'ethan.garcia@gmail.com', '15125551007', '147 Congress Ave, Austin, TX 78701', 'S000000007'),
('U000000008', 'Ava', 'Martinez', 'ava.martinez@outlook.com', '16025551008', '258 Camelback Rd, Phoenix, AZ 85012', 'S000000008'),
('U000000009', 'Mason', 'Lee', 'mason.lee@gmail.com', '14045551009', '369 Peachtree St, Atlanta, GA 30301', 'S000000009'),
('U000000010', 'Isabella', 'Thompson', 'isabella.t@yahoo.com', '16175551010', '741 Boylston St, Boston, MA 02116', 'S000000010'),
('U000000011', 'Lucas', 'Anderson', 'lucas.a@gmail.com', '15035551011', '852 Burnside St, Portland, OR 97204', 'S000000011'),
('U000000012', 'Mia', 'Taylor', 'mia.taylor@outlook.com', '16155551012', '963 Broadway, Nashville, TN 37203', 'S000000012'),
('U000000013', 'Alexander', 'Thomas', 'alex.thomas@gmail.com', '17045551013', '174 Trade St, Charlotte, NC 28202', 'S000000013'),
('U000000014', 'Charlotte', 'Hernandez', 'charlotte.h@yahoo.com', '12145551014', '285 Main St, Dallas, TX 75201', 'S000000014'),
('U000000015', 'Benjamin', 'Moore', 'ben.moore@gmail.com', '13055551015', '396 Canal St, New Orleans, LA 70112', 'S000000015'),
('U000000016', 'Amelia', 'Jackson', 'amelia.j@outlook.com', '14435551016', '507 High St, Columbus, OH 43215', 'S000000016'),
('U000000017', 'Daniel', 'White', 'daniel.white@gmail.com', '16125551017', '618 Hennepin Ave, Minneapolis, MN 55401', 'S000000017'),
('U000000018', 'Harper', 'Harris', 'harper.h@yahoo.com', '18165551018', '729 Granby St, Norfolk, VA 23510', 'S000000018'),
('U000000019', 'Jack', 'Clark', 'jack.clark@gmail.com', '18015551019', '830 State St, Salt Lake City, UT 84101', 'S000000019'),
('U000000020', 'Evelyn', 'Lewis', 'evelyn.lewis@outlook.com', '14105551020', '941 Ocean Ave, San Diego, CA 92101', 'S000000020'),
('U000000021', 'Henry', 'Robinson', 'henry.r@gmail.com', '13125551021', '152 Elm St, Cincinnati, OH 45202', 'S000000021'),
('U000000022', 'Luna', 'Walker', 'luna.walker@yahoo.com', '14125551022', '263 King St, Charleston, SC 29401', 'S000000022'),
('U000000023', 'Sebastian', 'Young', 'seb.young@gmail.com', '17025551023', '374 Fremont St, Las Vegas, NV 89101', 'S000000023'),
('U000000024', 'Chloe', 'Allen', 'chloe.allen@outlook.com', '13175551024', '485 Monument Ave, Richmond, VA 23220', 'S000000024'),
('U000000025', 'Owen', 'King', 'owen.king@gmail.com', '14075551025', '596 Central Ave, St Petersburg, FL 33701', 'S000000025'),
('U000000026', 'Ella', 'Wright', 'ella.wright@yahoo.com', '12025551026', '607 K St NW, Washington, DC 20001', 'S000000026'),
('U000000027', 'Aiden', 'Lopez', 'aiden.lopez@gmail.com', '13475551027', '718 Main St, Hartford, CT 06103', 'S000000027'),
('U000000028', 'Riley', 'Hill', 'riley.hill@outlook.com', '14145551028', '829 J St, Sacramento, CA 95814', 'S000000028'),
('U000000029', 'Matthew', 'Scott', 'matt.scott@gmail.com', '12065551029', '930 1st Ave, Seattle, WA 98104', 'S000000029'),
('U000000030', 'Zoey', 'Green', 'zoey.green@yahoo.com', '19045551030', '141 Meeting St, Savannah, GA 31401', 'S000000030');

-- =============================================
-- 2. SubscriptionType (30 records - one per user)
-- =============================================
INSERT INTO SubscriptionType (SubscriptionID, SubType, StartDateTime, EndDateTime, UserID)
VALUES
('S000000001', 'Premium', '2024-01-15', '2025-01-15', 'U000000001'),
('S000000002', 'Free',    '2024-03-10', '2025-03-10', 'U000000002'),
('S000000003', 'Premium', '2024-02-20', '2025-02-20', 'U000000003'),
('S000000004', 'Free',    '2024-05-01', '2025-05-01', 'U000000004'),
('S000000005', 'Premium', '2024-01-01', '2025-01-01', 'U000000005'),
('S000000006', 'Premium', '2024-06-15', '2025-06-15', 'U000000006'),
('S000000007', 'Free',    '2024-04-20', '2025-04-20', 'U000000007'),
('S000000008', 'Premium', '2024-07-01', '2025-07-01', 'U000000008'),
('S000000009', 'Free',    '2024-08-10', '2025-08-10', 'U000000009'),
('S000000010', 'Premium', '2024-03-25', '2025-03-25', 'U000000010'),
('S000000011', 'Free',    '2024-09-05', '2025-09-05', 'U000000011'),
('S000000012', 'Premium', '2024-02-14', '2025-02-14', 'U000000012'),
('S000000013', 'Free',    '2024-10-01', '2025-10-01', 'U000000013'),
('S000000014', 'Premium', '2024-04-15', '2025-04-15', 'U000000014'),
('S000000015', 'Free',    '2024-11-20', '2025-11-20', 'U000000015'),
('S000000016', 'Premium', '2024-01-30', '2025-01-30', 'U000000016'),
('S000000017', 'Free',    '2024-06-01', '2025-06-01', 'U000000017'),
('S000000018', 'Premium', '2024-05-15', '2025-05-15', 'U000000018'),
('S000000019', 'Free',    '2024-07-20', '2025-07-20', 'U000000019'),
('S000000020', 'Premium', '2024-08-01', '2025-08-01', 'U000000020'),
('S000000021', 'Free',    '2024-09-15', '2025-09-15', 'U000000021'),
('S000000022', 'Premium', '2024-03-01', '2025-03-01', 'U000000022'),
('S000000023', 'Free',    '2024-10-10', '2025-10-10', 'U000000023'),
('S000000024', 'Premium', '2024-02-28', '2025-02-28', 'U000000024'),
('S000000025', 'Free',    '2024-11-01', '2025-11-01', 'U000000025'),
('S000000026', 'Premium', '2024-04-05', '2025-04-05', 'U000000026'),
('S000000027', 'Free',    '2024-12-01', '2025-12-01', 'U000000027'),
('S000000028', 'Premium', '2024-06-20', '2025-06-20', 'U000000028'),
('S000000029', 'Free',    '2024-08-15', '2025-08-15', 'U000000029'),
('S000000030', 'Premium', '2024-05-10', '2025-05-10', 'U000000030');

-- =============================================
-- 3. FreeSubscription (14 records - one per Free subscription)
-- =============================================
INSERT INTO FreeSubscription (SubscriptionID, DaysLeft)
VALUES
('S000000002', '45'),
('S000000004', '120'),
('S000000007', '90'),
('S000000009', '200'),
('S000000011', '250'),
('S000000013', '300'),
('S000000015', '330'),
('S000000017', '150'),
('S000000019', '180'),
('S000000021', '260'),
('S000000023', '310'),
('S000000025', '335'),
('S000000027', '365'),
('S000000029', '210');

-- =============================================
-- 4. PremiumSubscription (16 records - one per Premium subscription)
-- =============================================
INSERT INTO PremiumSubscription (SubscriptionID, RenewDate, BillAmount)
VALUES
('S000000001', '2025-01-15', '10.99'),
('S000000003', '2025-02-20', '10.99'),
('S000000005', '2025-01-01', '10.99'),
('S000000006', '2025-06-15', '10.99'),
('S000000008', '2025-07-01', '10.99'),
('S000000010', '2025-03-25', '10.99'),
('S000000012', '2025-02-14', '10.99'),
('S000000014', '2025-04-15', '10.99'),
('S000000016', '2025-01-30', '10.99'),
('S000000018', '2025-05-15', '10.99'),
('S000000020', '2025-08-01', '10.99'),
('S000000022', '2025-03-01', '10.99'),
('S000000024', '2025-02-28', '10.99'),
('S000000026', '2025-04-05', '10.99'),
('S000000028', '2025-06-20', '10.99'),
('S000000030', '2025-05-10', '10.99');

-- =============================================
-- 5. Artist (20 records - real artists with ISNI-style IDs)
-- =============================================
INSERT INTO Artist (ArtistID, ArtistName, Releases, AvgMonthlyListeners)
VALUES
('0000000121468188', 'Drake',            295, 78500000),
('0000000079626028', 'Taylor Swift',     274, 82300000),
('0000000084796559', 'Kendrick Lamar',   102, 54200000),
('0000000039210785', 'The Weeknd',       118, 75100000),
('0000000055673920', 'Bad Bunny',        136, 62400000),
('0000000012345678', 'Billie Eilish',     56, 68700000),
('0000000098765432', 'Post Malone',       98, 55800000),
('0000000011223344', 'Dua Lipa',          64, 61200000),
('0000000055667788', 'Ed Sheeran',       152, 73400000),
('0000000099887766', 'Ariana Grande',    134, 70100000),
('0000000033445566', 'Travis Scott',      78, 52600000),
('0000000077889900', 'SZA',               45, 48900000),
('0000000022334455', 'Harry Styles',      42, 45300000),
('0000000066778899', 'Doja Cat',          68, 51700000),
('0000000044556677', 'Morgan Wallen',     85, 39200000),
('0000000088990011', 'Olivia Rodrigo',    34, 47600000),
('0000000015263748', 'Metro Boomin',      62, 41800000),
('0000000037485960', 'Tyler the Creator', 89, 36500000),
('0000000059607182', 'Sabrina Carpenter', 48, 44100000),
('0000000071829304', 'Peso Pluma',        72, 35800000);

-- =============================================
-- 6. Album (15 records - real albums)
-- =============================================
INSERT INTO Album (AlbumID, AlbumName, Length, ReleaseDate)
VALUES
('ALB0000000000001', 'For All The Dogs',                     '01:17:00', '2023-10-06'),
('ALB0000000000002', 'Midnights',                            '00:44:26', '2022-10-21'),
('ALB0000000000003', 'GNX',                                  '01:05:32', '2024-11-22'),
('ALB0000000000004', 'Dawn FM',                              '01:42:00', '2022-01-07'),
('ALB0000000000005', 'nadie sabe lo que va a pasar manana',  '00:55:10', '2023-05-12'),
('ALB0000000000006', 'HIT ME HARD AND SOFT',                 '00:43:49', '2024-05-17'),
('ALB0000000000007', 'Austin',                               '00:46:57', '2023-08-18'),
('ALB0000000000008', 'Radical Optimism',                     '00:50:08', '2025-01-17'),
('ALB0000000000009', 'Subtract',                             '00:48:12', '2023-06-16'),
('ALB0000000000010', 'Eternal Sunshine',                     '00:36:11', '2024-03-22'),
('ALB0000000000011', 'Utopia',                               '01:16:20', '2023-10-27'),
('ALB0000000000012', 'SOS',                                  '00:42:50', '2021-09-03'),
('ALB0000000000013', 'Harrys House',                         '00:34:46', '2023-06-30'),
('ALB0000000000014', 'Scarlet',                              '00:53:16', '2024-08-23'),
('ALB0000000000015', 'One Thing at a Time',                  '00:46:23', '2024-06-21');

-- =============================================
-- 7. ArtistAlbum (25 records - linking artists to albums)
-- =============================================
INSERT INTO ArtistAlbum (ArtistID, AlbumID)
VALUES
('0000000121468188', 'ALB0000000000001'),  -- Drake - For All The Dogs
('0000000079626028', 'ALB0000000000002'),  -- Taylor Swift - Midnights
('0000000084796559', 'ALB0000000000003'),  -- Kendrick Lamar - GNX
('0000000039210785', 'ALB0000000000004'),  -- The Weeknd - Dawn FM
('0000000055673920', 'ALB0000000000005'),  -- Bad Bunny - nadie sabe lo que va a pasar manana
('0000000012345678', 'ALB0000000000006'),  -- Billie Eilish - HIT ME HARD AND SOFT
('0000000098765432', 'ALB0000000000007'),  -- Post Malone - Austin
('0000000011223344', 'ALB0000000000008'),  -- Dua Lipa - Radical Optimism
('0000000055667788', 'ALB0000000000009'),  -- Ed Sheeran - Subtract
('0000000099887766', 'ALB0000000000010'),  -- Ariana Grande - Eternal Sunshine
('0000000033445566', 'ALB0000000000011'),  -- Travis Scott - Utopia
('0000000077889900', 'ALB0000000000012'),  -- SZA - SOS
('0000000022334455', 'ALB0000000000013'),  -- Harry Styles - Harrys House
('0000000066778899', 'ALB0000000000014'),  -- Doja Cat - Scarlet
('0000000044556677', 'ALB0000000000015'),  -- Morgan Wallen - One Thing at a Time
('0000000015263748', 'ALB0000000000003'),  -- Metro Boomin on GNX (collab)
('0000000033445566', 'ALB0000000000001'),  -- Travis Scott on For All The Dogs (feature)
('0000000077889900', 'ALB0000000000010'),  -- SZA on Eternal Sunshine (feature)
('0000000121468188', 'ALB0000000000011'),  -- Drake on Utopia (feature)
('0000000098765432', 'ALB0000000000015'),  -- Post Malone on One Thing at a Time (collab)
('0000000088990011', 'ALB0000000000002'),  -- Olivia Rodrigo on Midnights (feature)
('0000000037485960', 'ALB0000000000001'),  -- Tyler the Creator on For All The Dogs (feature)
('0000000059607182', 'ALB0000000000010'),  -- Sabrina Carpenter on Eternal Sunshine (feature)
('0000000055667788', 'ALB0000000000007'),  -- Ed Sheeran on Austin (collab)
('0000000011223344', 'ALB0000000000006');  -- Dua Lipa on HIT ME HARD AND SOFT

-- =============================================
-- 8. Device (10 records)
-- =============================================
INSERT INTO Device (DeviceID, Type, UserID)
VALUES
('DEV000001', 'Mobile',         'U000000001'),
('DEV000002', 'Desktop',        'U000000002'),
('DEV000003', 'Tablet',         'U000000003'),
('DEV000004', 'Smart Speaker',  'U000000004'),
('DEV000005', 'Smart TV',       'U000000005'),
('DEV000006', 'Mobile',         'U000000006'),
('DEV000007', 'Desktop',        'U000000010'),
('DEV000008', 'Mobile',         'U000000015'),
('DEV000009', 'Tablet',         'U000000020'),
('DEV000010', 'Smart Speaker',  'U000000025');

-- =============================================
-- 9. Song (60 records - the catalog; one row per recording)
-- =============================================
INSERT INTO Song (ISRC, Title, ArtistID, Duration, AlbumID, Genre)
VALUES
('USUG12400001', 'Rich Flex',               '0000000121468188', '00:03:58', 'ALB0000000000001', 'Hip-Hop'),
('USUG12400002', 'Anti-Hero',               '0000000079626028', '00:03:20', 'ALB0000000000002', 'Pop'),
('USUG12400003', 'HUMBLE.',                 '0000000084796559', '00:02:57', 'ALB0000000000003', 'Hip-Hop'),
('USUG12400004', 'Blinding Lights',         '0000000039210785', '00:03:22', 'ALB0000000000004', 'R&B'),
('USUG12400005', 'Titi Me Pregunto',        '0000000055673920', '00:04:03', 'ALB0000000000005', 'Reggaeton'),
('USUG12400006', 'Birds of a Feather',      '0000000012345678', '00:03:30', 'ALB0000000000006', 'Pop'),
('USUG12400007', 'Sunflower',               '0000000098765432', '00:02:38', 'ALB0000000000007', 'Pop'),
('USUG12400008', 'Levitating',              '0000000011223344', '00:03:23', 'ALB0000000000008', 'Pop'),
('USUG12400009', 'Shape of You',            '0000000055667788', '00:03:53', 'ALB0000000000009', 'Pop'),
('USUG12400010', 'Thank U Next',            '0000000099887766', '00:03:27', 'ALB0000000000010', 'Pop'),
('USUG12400011', 'SICKO MODE',              '0000000033445566', '00:05:12', 'ALB0000000000011', 'Hip-Hop'),
('USUG12400012', 'Kill Bill',               '0000000077889900', '00:02:33', 'ALB0000000000012', 'R&B'),
('USUG12400013', 'Watermelon Sugar',        '0000000022334455', '00:02:54', 'ALB0000000000013', 'Pop'),
('USUG12400014', 'Say So',                  '0000000066778899', '00:03:57', 'ALB0000000000014', 'Pop'),
('USUG12400015', 'Last Night',              '0000000044556677', '00:02:43', 'ALB0000000000015', 'Country'),
('USUG12400016', 'Good 4 U',                '0000000088990011', '00:02:58', 'ALB0000000000002', 'Pop Rock'),
('USUG12400017', 'Creepin',                 '0000000015263748', '00:03:41', 'ALB0000000000003', 'Hip-Hop'),
('USUG12400018', 'See You Again',           '0000000037485960', '00:03:01', 'ALB0000000000001', 'Hip-Hop'),
('USUG12400019', 'Espresso',                '0000000059607182', '00:02:55', 'ALB0000000000010', 'Pop'),
('USUG12400020', 'Ella Baila Sola',         '0000000071829304', '00:03:15', 'ALB0000000000005', 'Regional Mexican'),
('USUG12400021', 'Gods Plan',               '0000000121468188', '00:03:18', 'ALB0000000000001', 'Hip-Hop'),
('USUG12400022', 'Lavender Haze',           '0000000079626028', '00:03:44', 'ALB0000000000002', 'Pop'),
('USUG12400023', 'DNA.',                    '0000000084796559', '00:03:39', 'ALB0000000000003', 'Hip-Hop'),
('USUG12400024', 'Save Your Tears',         '0000000039210785', '00:03:35', 'ALB0000000000004', 'R&B'),
('USUG12400025', 'Dakiti',                  '0000000055673920', '00:03:10', 'ALB0000000000005', 'Reggaeton'),
('USUG12400026', 'Bad Guy',                 '0000000012345678', '00:03:14', 'ALB0000000000006', 'Pop'),
('USUG12400027', 'Circles',                 '0000000098765432', '00:03:34', 'ALB0000000000007', 'Pop'),
('USUG12400028', 'Dont Start Now',          '0000000011223344', '00:03:15', 'ALB0000000000008', 'Pop'),
('USUG12400029', 'Perfect',                 '0000000055667788', '00:04:41', 'ALB0000000000009', 'Pop'),
('USUG12400030', 'Positions',               '0000000099887766', '00:02:52', 'ALB0000000000010', 'Pop'),
('USUG12400031', 'Goosebumps',              '0000000033445566', '00:04:03', 'ALB0000000000011', 'Hip-Hop'),
('USUG12400032', 'Snooze',                  '0000000077889900', '00:03:21', 'ALB0000000000012', 'R&B'),
('USUG12400033', 'As It Was',               '0000000022334455', '00:02:47', 'ALB0000000000013', 'Pop'),
('USUG12400034', 'Kiss Me More',            '0000000066778899', '00:03:28', 'ALB0000000000014', 'Pop'),
('USUG12400035', 'Wasted on You',           '0000000044556677', '00:03:50', 'ALB0000000000015', 'Country'),
('USUG12400036', 'Drivers License',         '0000000088990011', '00:03:39', 'ALB0000000000002', 'Pop Rock'),
('USUG12400037', 'Superhero',               '0000000015263748', '00:03:12', 'ALB0000000000003', 'Hip-Hop'),
('USUG12400038', 'EARFQUAKE',               '0000000037485960', '00:03:10', 'ALB0000000000001', 'Hip-Hop'),
('USUG12400039', 'Feather',                 '0000000059607182', '00:02:49', 'ALB0000000000010', 'Pop'),
('USUG12400040', 'La Bebe',                 '0000000071829304', '00:03:22', 'ALB0000000000005', 'Regional Mexican'),
('USUG12400041', 'One Dance',               '0000000121468188', '00:02:54', 'ALB0000000000001', 'Hip-Hop'),
('USUG12400042', 'Cruel Summer',            '0000000079626028', '00:02:58', 'ALB0000000000002', 'Pop'),
('USUG12400043', 'Money Trees',             '0000000084796559', '00:06:26', 'ALB0000000000003', 'Hip-Hop'),
('USUG12400044', 'Die For You',             '0000000039210785', '00:04:20', 'ALB0000000000004', 'R&B'),
('USUG12400045', 'Me Porto Bonito',         '0000000055673920', '00:02:58', 'ALB0000000000005', 'Reggaeton'),
('USUG12400046', 'Lovely',                  '0000000012345678', '00:03:20', 'ALB0000000000006', 'Pop'),
('USUG12400047', 'Rockstar',                '0000000098765432', '00:03:38', 'ALB0000000000007', 'Hip-Hop'),
('USUG12400048', 'New Rules',               '0000000011223344', '00:03:29', 'ALB0000000000008', 'Pop'),
('USUG12400049', 'Thinking Out Loud',       '0000000055667788', '00:04:41', 'ALB0000000000009', 'Pop'),
('USUG12400050', 'No Tears Left to Cry',    '0000000099887766', '00:03:25', 'ALB0000000000010', 'Pop'),
('USUG12400051', 'Highest in the Room',     '0000000033445566', '00:02:55', 'ALB0000000000011', 'Hip-Hop'),
('USUG12400052', 'Good Days',               '0000000077889900', '00:04:39', 'ALB0000000000012', 'R&B'),
('USUG12400053', 'Late Night Talking',      '0000000022334455', '00:02:57', 'ALB0000000000013', 'Pop'),
('USUG12400054', 'Woman',                   '0000000066778899', '00:02:52', 'ALB0000000000014', 'Pop'),
('USUG12400055', 'Thought You Should Know', '0000000044556677', '00:02:52', 'ALB0000000000015', 'Country'),
('USUG12400056', 'Vampire',                 '0000000088990011', '00:03:39', 'ALB0000000000002', 'Pop Rock'),
('USUG12400057', 'Rich Spirit',             '0000000084796559', '00:03:12', 'ALB0000000000003', 'Hip-Hop'),
('USUG12400058', 'Starboy',                 '0000000039210785', '00:03:50', 'ALB0000000000004', 'R&B'),
('USUG12400059', 'Please Please Please',    '0000000059607182', '00:03:06', 'ALB0000000000010', 'Pop'),
('USUG12400060', 'BZRP Music Session 55',   '0000000071829304', '00:03:33', 'ALB0000000000005', 'Regional Mexican');

-- =============================================
-- 10. Streams (90 records - play events; a song may be streamed by many users)
-- =============================================
INSERT INTO Streams (StreamID, UserID, ISRC, PlayedAt)
VALUES
('ST00000001', 'U000000001', 'USUG12400001', '2025-02-08 05:13:00'),  -- Rich Flex
('ST00000002', 'U000000002', 'USUG12400002', '2025-03-15 10:26:00'),  -- Anti-Hero
('ST00000003', 'U000000003', 'USUG12400003', '2025-04-22 15:39:00'),  -- HUMBLE.
('ST00000004', 'U000000004', 'USUG12400004', '2025-05-01 20:52:00'),  -- Blinding Lights
('ST00000005', 'U000000005', 'USUG12400005', '2025-06-08 01:05:00'),  -- Titi Me Pregunto
('ST00000006', 'U000000006', 'USUG12400006', '2025-07-15 06:18:00'),  -- Birds of a Feather
('ST00000007', 'U000000007', 'USUG12400007', '2025-08-22 11:31:00'),  -- Sunflower
('ST00000008', 'U000000008', 'USUG12400008', '2025-09-01 16:44:00'),  -- Levitating
('ST00000009', 'U000000009', 'USUG12400009', '2025-10-08 21:57:00'),  -- Shape of You
('ST00000010', 'U000000010', 'USUG12400010', '2025-11-15 02:10:00'),  -- Thank U Next
('ST00000011', 'U000000011', 'USUG12400011', '2025-12-22 07:23:00'),  -- SICKO MODE
('ST00000012', 'U000000012', 'USUG12400012', '2025-01-01 12:36:00'),  -- Kill Bill
('ST00000013', 'U000000013', 'USUG12400013', '2025-02-08 17:49:00'),  -- Watermelon Sugar
('ST00000014', 'U000000014', 'USUG12400014', '2025-03-15 22:02:00'),  -- Say So
('ST00000015', 'U000000015', 'USUG12400015', '2025-04-22 03:15:00'),  -- Last Night
('ST00000016', 'U000000016', 'USUG12400016', '2025-05-01 08:28:00'),  -- Good 4 U
('ST00000017', 'U000000017', 'USUG12400017', '2025-06-08 13:41:00'),  -- Creepin
('ST00000018', 'U000000018', 'USUG12400018', '2025-07-15 18:54:00'),  -- See You Again
('ST00000019', 'U000000019', 'USUG12400019', '2025-08-22 23:07:00'),  -- Espresso
('ST00000020', 'U000000020', 'USUG12400020', '2025-09-01 04:20:00'),  -- Ella Baila Sola
('ST00000021', 'U000000001', 'USUG12400021', '2025-10-08 09:33:00'),  -- Gods Plan
('ST00000022', 'U000000002', 'USUG12400022', '2025-11-15 14:46:00'),  -- Lavender Haze
('ST00000023', 'U000000003', 'USUG12400023', '2025-12-22 19:59:00'),  -- DNA.
('ST00000024', 'U000000005', 'USUG12400024', '2025-01-01 00:12:00'),  -- Save Your Tears
('ST00000025', 'U000000006', 'USUG12400025', '2025-02-08 05:25:00'),  -- Dakiti
('ST00000026', 'U000000008', 'USUG12400026', '2025-03-15 10:38:00'),  -- Bad Guy
('ST00000027', 'U000000009', 'USUG12400027', '2025-04-22 15:51:00'),  -- Circles
('ST00000028', 'U000000010', 'USUG12400028', '2025-05-01 20:04:00'),  -- Dont Start Now
('ST00000029', 'U000000012', 'USUG12400029', '2025-06-08 01:17:00'),  -- Perfect
('ST00000030', 'U000000014', 'USUG12400030', '2025-07-15 06:30:00'),  -- Positions
('ST00000031', 'U000000016', 'USUG12400031', '2025-08-22 11:43:00'),  -- Goosebumps
('ST00000032', 'U000000018', 'USUG12400032', '2025-09-01 16:56:00'),  -- Snooze
('ST00000033', 'U000000020', 'USUG12400033', '2025-10-08 21:09:00'),  -- As It Was
('ST00000034', 'U000000022', 'USUG12400034', '2025-11-15 02:22:00'),  -- Kiss Me More
('ST00000035', 'U000000024', 'USUG12400035', '2025-12-22 07:35:00'),  -- Wasted on You
('ST00000036', 'U000000026', 'USUG12400036', '2025-01-01 12:48:00'),  -- Drivers License
('ST00000037', 'U000000028', 'USUG12400037', '2025-02-08 17:01:00'),  -- Superhero
('ST00000038', 'U000000030', 'USUG12400038', '2025-03-15 22:14:00'),  -- EARFQUAKE
('ST00000039', 'U000000021', 'USUG12400039', '2025-04-22 03:27:00'),  -- Feather
('ST00000040', 'U000000023', 'USUG12400040', '2025-05-01 08:40:00'),  -- La Bebe
('ST00000041', 'U000000004', 'USUG12400041', '2025-06-08 13:53:00'),  -- One Dance
('ST00000042', 'U000000007', 'USUG12400042', '2025-07-15 18:06:00'),  -- Cruel Summer
('ST00000043', 'U000000011', 'USUG12400043', '2025-08-22 23:19:00'),  -- Money Trees
('ST00000044', 'U000000013', 'USUG12400044', '2025-09-01 04:32:00'),  -- Die For You
('ST00000045', 'U000000015', 'USUG12400045', '2025-10-08 09:45:00'),  -- Me Porto Bonito
('ST00000046', 'U000000017', 'USUG12400046', '2025-11-15 14:58:00'),  -- Lovely
('ST00000047', 'U000000019', 'USUG12400047', '2025-12-22 19:11:00'),  -- Rockstar
('ST00000048', 'U000000021', 'USUG12400048', '2025-01-01 00:24:00'),  -- New Rules
('ST00000049', 'U000000023', 'USUG12400049', '2025-02-08 05:37:00'),  -- Thinking Out Loud
('ST00000050', 'U000000025', 'USUG12400050', '2025-03-15 10:50:00'),  -- No Tears Left to Cry
('ST00000051', 'U000000027', 'USUG12400051', '2025-04-22 15:03:00'),  -- Highest in the Room
('ST00000052', 'U000000029', 'USUG12400052', '2025-05-01 20:16:00'),  -- Good Days
('ST00000053', 'U000000004', 'USUG12400053', '2025-06-08 01:29:00'),  -- Late Night Talking
('ST00000054', 'U000000007', 'USUG12400054', '2025-07-15 06:42:00'),  -- Woman
('ST00000055', 'U000000011', 'USUG12400055', '2025-08-22 11:55:00'),  -- Thought You Should Know
('ST00000056', 'U000000013', 'USUG12400056', '2025-09-01 16:08:00'),  -- Vampire
('ST00000057', 'U000000015', 'USUG12400057', '2025-10-08 21:21:00'),  -- Rich Spirit
('ST00000058', 'U000000017', 'USUG12400058', '2025-11-15 02:34:00'),  -- Starboy
('ST00000059', 'U000000019', 'USUG12400059', '2025-12-22 07:47:00'),  -- Please Please Please
('ST00000060', 'U000000022', 'USUG12400060', '2025-01-01 12:00:00'),  -- BZRP Music Session 55
('ST00000061', 'U000000005', 'USUG12400001', '2025-02-08 17:13:00'),  -- Rich Flex
('ST00000062', 'U000000012', 'USUG12400001', '2025-03-15 22:26:00'),  -- Rich Flex
('ST00000063', 'U000000019', 'USUG12400001', '2025-04-22 03:39:00'),  -- Rich Flex
('ST00000064', 'U000000007', 'USUG12400003', '2025-05-01 08:52:00'),  -- HUMBLE.
('ST00000065', 'U000000014', 'USUG12400003', '2025-06-08 13:05:00'),  -- HUMBLE.
('ST00000066', 'U000000002', 'USUG12400004', '2025-07-15 18:18:00'),  -- Blinding Lights
('ST00000067', 'U000000009', 'USUG12400004', '2025-08-22 23:31:00'),  -- Blinding Lights
('ST00000068', 'U000000022', 'USUG12400004', '2025-09-01 04:44:00'),  -- Blinding Lights
('ST00000069', 'U000000011', 'USUG12400005', '2025-10-08 09:57:00'),  -- Titi Me Pregunto
('ST00000070', 'U000000025', 'USUG12400006', '2025-11-15 14:10:00'),  -- Birds of a Feather
('ST00000071', 'U000000003', 'USUG12400011', '2025-12-22 19:23:00'),  -- SICKO MODE
('ST00000072', 'U000000027', 'USUG12400011', '2025-01-01 00:36:00'),  -- SICKO MODE
('ST00000073', 'U000000006', 'USUG12400012', '2025-02-08 05:49:00'),  -- Kill Bill
('ST00000074', 'U000000008', 'USUG12400015', '2025-03-15 10:02:00'),  -- Last Night
('ST00000075', 'U000000030', 'USUG12400016', '2025-04-22 15:15:00'),  -- Good 4 U
('ST00000076', 'U000000013', 'USUG12400020', '2025-05-01 20:28:00'),  -- Ella Baila Sola
('ST00000077', 'U000000016', 'USUG12400021', '2025-06-08 01:41:00'),  -- Gods Plan
('ST00000078', 'U000000024', 'USUG12400023', '2025-07-15 06:54:00'),  -- DNA.
('ST00000079', 'U000000001', 'USUG12400026', '2025-08-22 11:07:00'),  -- Bad Guy
('ST00000080', 'U000000010', 'USUG12400031', '2025-09-01 16:20:00'),  -- Goosebumps
('ST00000081', 'U000000026', 'USUG12400041', '2025-10-08 21:33:00'),  -- One Dance
('ST00000082', 'U000000018', 'USUG12400043', '2025-11-15 02:46:00'),  -- Money Trees
('ST00000083', 'U000000028', 'USUG12400044', '2025-12-22 07:59:00'),  -- Die For You
('ST00000084', 'U000000020', 'USUG12400045', '2025-01-01 12:12:00'),  -- Me Porto Bonito
('ST00000085', 'U000000029', 'USUG12400047', '2025-02-08 17:25:00'),  -- Rockstar
('ST00000086', 'U000000002', 'USUG12400051', '2025-03-15 22:38:00'),  -- Highest in the Room
('ST00000087', 'U000000017', 'USUG12400052', '2025-04-22 03:51:00'),  -- Good Days
('ST00000088', 'U000000005', 'USUG12400055', '2025-05-01 08:04:00'),  -- Thought You Should Know
('ST00000089', 'U000000009', 'USUG12400057', '2025-06-08 13:17:00'),  -- Rich Spirit
('ST00000090', 'U000000014', 'USUG12400060', '2025-07-15 18:30:00');  -- BZRP Music Session 55


-- Spotify Listener Insights System (SLIS)
-- Strategic Business Queries

-- =============================================
-- Q1: Who is the top artist for each genre?
-- (Uses JOIN + GROUP BY + SUBQUERY)
-- =============================================
SELECT s.Genre, a.ArtistName, a.AvgMonthlyListeners   -- Show genre, artist name, and their average monthly listeners
FROM Song s                                           -- Start with the Song table to access genres
JOIN Artist a ON s.ArtistID = a.ArtistID              -- Join with Artist to get artist details
WHERE a.AvgMonthlyListeners = (                       -- Subquery to find the max average monthly listeners for the genre of the current song
    SELECT MAX(a2.AvgMonthlyListeners)                -- Find the maximum average monthly listeners among all artists in the same genre
    FROM Song s2                                      -- Use a second instance of the Song table to compare genres
    JOIN Artist a2 ON s2.ArtistID = a2.ArtistID       -- Join with Artist again to get the average monthly listeners for artists in the subquery
    WHERE s2.Genre = s.Genre                          -- Ensure we are comparing artists within the same genre as the current song in the outer query
)
GROUP BY s.Genre, a.ArtistName, a.AvgMonthlyListeners -- Group by genre and artist to ensure we get distinct artists for each genre
ORDER BY a.AvgMonthlyListeners DESC;

-- =============================================
-- Q2: Who are the top 10 listeners by total streams?
-- (Uses JOIN + GROUP BY + AGGREGATE COUNT)
-- =============================================
SELECT TOP 10                                         -- Select the top 10 users based on total streams
    u.UserID,                                         -- Show user ID
    u.FirstName,                                      -- Show first name
    u.LastName,                                       -- Show last name
    COUNT(st.StreamID) AS TotalStreams                -- Count total streams for each user
FROM [User] u                                         -- Start with the User table to access user details
JOIN Streams st ON u.UserID = st.UserID               -- Join with Streams to count the number of streams for each user
GROUP BY u.UserID, u.FirstName, u.LastName            -- Group by user ID and name to get total streams per user
ORDER BY TotalStreams DESC;

-- =============================================
-- Q3: Which genre has the highest listening streams?
-- (Uses JOIN + GROUP BY + AGGREGATE COUNT)
-- =============================================
SELECT TOP 1                                          -- Select the top genre based on total streams
    so.Genre,                                         -- Show the genre, read from the song that was played
    COUNT(st.StreamID) AS TotalStreams                -- Count total plays for each genre
FROM Streams st                                       -- Start with Streams, which holds one row per play
JOIN Song so ON st.ISRC = so.ISRC                     -- Join to Song to get the genre of the track played
GROUP BY so.Genre                                     -- Group by genre to count total plays for each genre
ORDER BY TotalStreams DESC;                           -- Order the results by total streams in descending order to show the most popular genre at the top

-- =============================================
-- Q4: What type of subscription is being used the most currently?
-- (Uses GROUP BY + AGGREGATE COUNT)
-- =============================================
SELECT TOP 1                                          -- Select the most common subscription type based on total users
    SubType,                                          -- Show the subscription type (Free or Premium)
    COUNT(SubscriptionID) AS TotalUsers               -- Count total users for each subscription type
FROM SubscriptionType                                 -- SubscriptionType table to access subscription types
GROUP BY SubType                                      -- Group by subscription type to count total users for each type
ORDER BY TotalUsers DESC;                             -- Order the results by total users in descending order to show the most popular subscription type at the top

-- =============================================
-- Q5: Which month generated the most amount of money from subscriptions?
-- (Uses JOIN + GROUP BY + AGGREGATE SUM)
-- =============================================
SELECT TOP 1                                                                                    -- Select the month that generated the most revenue from subscriptions
    MONTH(CAST(st.StartDateTime AS DATE)) AS SubscriptionMonth,                                 -- Extract the month number from the subscription start date
    DATENAME(MONTH, CAST(st.StartDateTime AS DATE)) AS MonthName,                               -- Get the month name for better readability
    SUM(CAST(ps.BillAmount AS DECIMAL(10,2))) AS TotalRevenue                                   -- Sum the bill amounts for all premium subscriptions that started in the same month to calculate total revenue
FROM SubscriptionType st                                                                        -- Start with the SubscriptionType table to access subscription details
JOIN PremiumSubscription ps ON st.SubscriptionID = ps.SubscriptionID                            -- Join with PremiumSubscription to access billing amounts for premium subscriptions
GROUP BY MONTH(CAST(st.StartDateTime AS DATE)), DATENAME(MONTH, CAST(st.StartDateTime AS DATE)) -- Group by month number and month name to calculate total revenue for each month
ORDER BY TotalRevenue DESC;                                                                     -- Order the results by total revenue in descending order to show the month that generated the most revenue at the top

-- =============================================
-- Q6: Which genres are most popular among Premium users vs Free users?
-- (Uses multiple JOINs + GROUP BY + AGGREGATE COUNT)
-- =============================================
SELECT                                                -- Select subscription type, genre, and total plays for each combination
    sub.SubType,                                      -- Show the subscription type (Free or Premium)
    so.Genre,                                         -- Show the genre of the track played
    COUNT(st.StreamID) AS TotalStreams                -- Count total plays for each subscription type and genre pairing
FROM Streams st                                       -- Start with Streams, which holds one row per play
JOIN Song so ON st.ISRC = so.ISRC                     -- Join to Song to get the genre of the track played
JOIN [User] u ON st.UserID = u.UserID                 -- Join to User to link each play to a listener
JOIN SubscriptionType sub ON u.UserID = sub.UserID    -- Join to SubscriptionType to get that listener's plan
GROUP BY sub.SubType, so.Genre                        -- Group by subscription type and genre
ORDER BY sub.SubType, TotalStreams DESC;              -- Order by plan, then by plays descending, so each plan's top genres come first
