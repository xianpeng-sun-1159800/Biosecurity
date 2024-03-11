-- Role table
CREATE TABLE role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

-- Inserting roles
INSERT IGNORE INTO role (role_name) VALUES
('Horticulturalists'),
('Staff'),
('Administrator');

-- User table
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    password varchar(1000) NOT NULL,
    phone_number VARCHAR(20),
    date_joined DATE,
    status ENUM('active', 'inactive') DEFAULT 'active',
    role INT,
    FOREIGN KEY (role) REFERENCES role(role_id)
);

-- Horticulture Pest and Disease Guide table
CREATE TABLE guide (
    horticulture_id INT AUTO_INCREMENT PRIMARY KEY,
    horticulture_item_type ENUM('pest', 'disease') NOT NULL,
    present_in_NZ ENUM('yes', 'no') NOT NULL,
    common_name VARCHAR(100),
    scientific_name VARCHAR(100),
    key_characteristics TEXT,
    biology_description TEXT,
    symptoms TEXT,
    primary_image VARCHAR(255) -- assuming image paths will be stored
);

INSERT INTO user (first_name, last_name, email, name, phone_number, date_joined, status, role, password) VALUES
('Authur', 'Smith', 'Authur.Smith@example.com', 'Authur.Smith', '123-456-7890', '2024-02-29', 'active', 1, '*'),
('Harry', 'Jones', 'Harry.Jones@example.com', 'Harry.Jones', '234-567-8901', '2023-07-06', 'active', 1, '*'),
('Edith', 'Williams', 'Edith.Williams@example.com', 'Edith.Williams', '345-678-9012', '2022-01-02', 'active', 1, '*'),
('Oliver', 'Brown', 'Oliver.Brown@example.com', 'Oliver.Brown', '456-789-0123', '2024-01-16', 'active', 1, '*'),
('Noah', 'Taylor', 'Noah.Taylor@example.com', 'Noah.Taylor', '567-890-1234', '2019-06-25', 'active', 1, '*'),
('Ellis', 'Davies', 'Ellis.Davies@example.com', 'Ellis.Davies', '678-901-2345', '2022-10-10', 'active', 1, '*'),
('Archie', 'Evans', 'Archie.Evans@example.com', 'Archie.Evans', '789-012-3456', '2021-07-27', 'active', 2, '*'),
('Avery', 'Thomas', 'Avery.Thomas@example.com', 'Avery.Thomas', '890-123-4567', '2022-04-01', 'active', 2, '*'),
('George', 'Johnson', 'George.Johnson@example.com', 'George.Johnson', '901-234-5678', '2018-08-28', 'active', 2, '*'),
('Hazel', 'Roberts', 'Hazel.Roberts@example.com', 'Hazel.Roberts', '012-345-6789', '2024-09-30', 'active', 3, '*');

-- horticultural pests/diseases present in NZ
INSERT INTO guide (horticulture_item_type, present_in_NZ, common_name, scientific_name, key_characteristics, biology_description, symptoms, primary_image) VALUES
('pest', 'yes', 'pea weevil', 'Bruchus pisorum', 'small (4mm to 4.5mm long) insects, brownish-grey in colour with white flecks', 'The pea weevil (Bruchus pisorum) is a small insect that can damage growing peas. It is an unwanted organism under the Biosecurity Act 1993.', 'Pea weevil larvae feed on young peas, damaging crops. Larvae tunnel inside the peas, eating the contents as they mature. ', '/images/pea-weevil-main-240x156.jpg'),
('disease', 'yes', 'Armillaria root disease', 'Armillaria novae-zelandiae', 'Armillaria spp. are widespread in New Zealand and occur naturally in indigenous forests, both beech and podocarp/broadleaf.', 'Wood decayed by these fungi is wet, yellowish, and divided into large pockets by black lines.', 'They are found on rotten logs, snags or other decaying debris, and occasionally appear near the base of living trees.', '/images/Armillaria root disease.jpg'),
('pest', 'yes', 'Fir adelgid', 'Adelges nordmannianae', 'This insect, originally from the Caucasus, is present throughout Europe and has also become established in North America and Tasmania.', 'The Adelgidae, which are closely related to the aphids, occur only on conifers.', 'Sapsucking activity by the fir adelgid can cause loss of vigour in and sometimes death of a tree. ', '/images/fir adelgid.jpg'),
('pest', 'yes', 'Large Cicadas', 'nymphs', 'Young cicadas (nymphs) and adults both have piercing-sucking mouth-parts with which they take up plant sap. ', 'Nymphs live in the soil and feed on roots while adults feed on above-ground parts of plants, but this seems to have little effect on plant growth. ', 'The major damage is caused by the female piercing plant tissues with her ovipositor to lay eggs.', '/images/cicadas.jpg'),
('disease', 'yes', 'Cyttaria galls on silver beech', 'Nothofagus menziesii', 'The fungi produce galls on branches and stems of silver beech', 'Branch galls roughly spherical, rarely more than twice the diameter of the host branch, and usually occupying about two-thirds of its circumference.', 'Gall surface under the bark contorted and projected into sharp spines.', '/images/Cyttaria galls.jpg'),
('disease', 'yes', 'Cypress canker', 'Cypress canker', 'Cankers form on stems, branches and in branch axils, causing dieback of leading and lateral shoots ', 'Dark brown or purple patches on bark in early stages of infection.', 'Cankers (sunken areas) appear on branches and stem and in branch axils and may become swollen and distorted as surrounding healthy tissue continues to grow ', '/images/Cypress canker.jpg'),
('disease', 'yes', 'Elm leaf spot', 'Phloeospora ulmi', 'Irregular brown spots on Ulmus glabra caused by Phloeospora ulmi', 'It is found throughout the North Island of New Zealand. Its presence in the South Island is unknown.', 'Causes irregular brown spots', '/images/Elm leaf spot.jpg'),
('pest', 'yes', 'Greenheaded leafroller', 'Planotortrix excessana ', 'They kill the needles, which then turn brown and hard, by eating part or all of the cuticle.', 'The greenheaded and blacklegged leafrollers are native insects. The light brown apple moth came from Australia and was first discovered in New Zealand in 1891.', 'damage to young trees causes malformation and stunted growth, and this is probably more serious than loss of growth through defoliation.', '/images/Greenheaded leafroller.jpg'),
('disease', 'yes', 'Oak powdery mildew', 'Microsphaera alphitoides', 'The fungus overwinters as mycelium in the dormant buds.', 'The mycelium grows and infects the expanding leaves in the spring and quickly begins to sporulate.', 'A powdery, white coating of hyphae and conidiospores forms on the surface of young twigs and leaves.', '/images/Oak powdery mildew.jpg'),
('disease', 'yes', 'Junghuhnia root disease', 'Junghuhnia root disease', 'Death of trees, singly or occasionally in small groups.', 'Progressive yellowing and browning of foliage with older foliage dying first.', 'an uneven distribution of yellowing and browning branches in the crown.', '/images/Junghuhnia root disease.jpg');

-- horticultural pests/diseases not present in NZ
INSERT INTO guide (horticulture_item_type, present_in_NZ, common_name, scientific_name, key_characteristics, biology_description, symptoms, primary_image) VALUES
('disease', 'no', 'Black rot', 'Guignardia bidwellii', 'small brown circular spots on young grape leaves ', 'This is a fungus that causes diseases on grapes and some ornamental plants. It is native to North America and parts of Europe.', 'see light brown spots that become dark brown', '/images/Black-rot-1__ResizedImageWzQyNCwyOTNd.jpg'),
('pest', 'no', 'Citrus longhorn beetle', 'Anoplophora chinensis', 'Both males and females are black and shiny with white to blue spots', 'This beetle is one of the most destructive pests of fruit trees, especially citrus. It is native to lowland China and other parts of Asia. It has invaded parts of Europe, including Italy, Turkey, France, Germany, and Croatia.', 'weakening the trees and making them susceptible to disease and wind damage', '/images/citrus-longhorn-beetle-1.jpg'),
('disease', 'no', 'aster yellows phytoplasma', 'Candidatus Phytoplasma asteris', 'leaf-like structures instead of flowers', 'unusual greening of flowers ', 'overall stunting', '/images/aster-yellows-phytoplasma-1.jpg'),
('pest', 'no', 'Kanzawa spider mite', 'Tetranychus kanzawai', 'greenish-cream,up to 1.5mm long and have 8 legs', 'The kanzawa spider mite causes damage to plants by feeding on leaves and sometimes fruit. It forms a mass of webbing over leaves and fruit, making it harder for the plant to thrive.', 'Damaged leaves show yellow spots.', '/images/kanzawa spider mite.jpg'),
('disease', 'no', 'avocado sunblotch', 'Avocado sunblotch viroid', 'stunted growth and fewer fruit', 'yellow, red, or white discolorations on the skin', 'red, pink, white, or yellow streaks on the tree bark or twigs', '/images/avocado-sunblotch.jpg'),
('disease', 'no', 'Maize lethal necrosis disease', 'Maize dwarf mosaic virus', 'yellower than normal leaves', 'MDMV alone can cause serious disease in maize, sweetcorn, and sorghum. But it is also one of the viruses that cause maize lethal necrosis disease. ', 'slow growth, so plants are often dwarfed', '/images/maize-lethal-1__ResizedImageWzQwMCw1MzNd.jpg'),
('pest', 'no', 'Melon fly', 'Zeugodacus cucurbitae', 'have a dark stripe or T-shaped mark on their abdomen', 'The melon fly is native to central Asia but has spread across Asia and into Africa. Although melon fly has been found at our border a few times, it has not been detected inside New Zealand.', 'Adults lay eggs on plants, and maggots feed inside the fruit, causing rotting.', '/images/male-melon-fly.jpg'),
('disease', 'no', 'bacterial leaf scorch','Xylella fastidiosa', 'scorched leaves', 'over time, dieback and death of the plant', 'reduced fruit size', '/images/XylellaFastidiosa.jpg'),
('pest', 'no', 'Oriental fruit fly', 'Bactrocera dorsalis', 'usually have a bright yellow and orange abdomen ', 'It is native to Asia, but has now spread to many warmer countries. It is one of the most destructive and widespread of all fruit flies.', 'Adult flies lay eggs into fruit. The young stages (maggots) feed inside the fruit, causing it to rot and become unmarketable.', '/images/oriental-fruit-fly-1.jpg'),
('disease', 'no', 'Bacterial soft rot', 'Pantoea ananatis', 'stalk rot, bacterial wilt, and leaf blight in maize', 'bacterial leaf blight and shoot tip dieback in 2 types of eucalyptus', 'internal rot in melons', '/images/black-soft-rot-2.jpg');