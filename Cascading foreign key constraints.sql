ALTER TABLE `bridge` DROP FOREIGN KEY `bridge_ibfk_1`; 
ALTER TABLE `bridge` ADD CONSTRAINT `bridge_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `bridge` DROP FOREIGN KEY `bridge_ibfk_2`; ALTER TABLE `bridge` ADD CONSTRAINT `bridge_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;