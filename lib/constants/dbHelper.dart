import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> db() async {
    return openDatabase(
      join(await getDatabasesPath(), 'ndcu'),
      onCreate: ((db, version) async {
        await db.execute(
            'CREATE TABLE ndcu_surveys (id INT NOT NULL PRIMARY KEY,name VARCHAR(50) NOT NULL,contribution INT NOT NULL,description VARCHAR(200) DEFAULT NULL,type INT NOT NULL,category INT NOT NULL,survey_technique INT NOT NULL,district INT NOT NULL,moh INT NOT NULL,rdhs INT NOT NULL,phi INT NOT NULL,lead_by VARCHAR(100) NOT NULL,created_by VARCHAR(100) NOT NULL, finished INT DEFAULT 0, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL)');
        await db.execute(
            'CREATE TABLE ndcu_survey_gns (survey_id INT NOT NULL,gn INT NOT NULL,created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL,PRIMARY KEY(survey_id, gn))');
        await db.execute(
            'CREATE TABLE ndcu_survey_surveyors (survey_id INT NOT NULL, username VARCHAR(100) NOT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, username))');
        await db.execute(
            'CREATE TABLE ndcu_survey_localities (survey_id INT NOT NULL, gn INT NOT NULL, locality TEXT NOT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, gn, locality))');
        await db.execute(
            'CREATE TABLE ndcu_survey_premises (survey_id INT NOT NULL, locality TEXT NOT NULL, address TEXT NOT NULL, type VARCHAR(10) NOT NULL, lat REAL NOT NULL, lng REAL NOT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, locality, address))');
        await db.execute(
            'CREATE TABLE ndcu_larval_surveys (survey_id INT NOT NULL, address TEXT NOT NULL, container_id INT NOT NULL, breeding_type VARCHAR(10) NOT NULL, type INT NOT NULL, environment INT NOT NULL, observation INT NOT NULL, samples TEXT DEFAULT NULL, breeding INT DEFAULT NULL, identified INT DEFAULT NULL, identified_type INT DEFAULT NULL, identified_other TEXT DEFAULT NULL, note TEXT DEFAULT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, address, container_id))');
        await db.execute(
            'CREATE TABLE ndcu_adult_surveys (survey_id INT NOT NULL, address TEXT NOT NULL, container_id INT NOT NULL, environment INT NOT NULL, resting_area INT NOT NULL, other_area TEXT DEFAULT NULL, resting_place INT NOT NULL, other_place TEXT DEFAULT NULL, wall_type INT DEFAULT NULL, wall_other TEXT DEFAULT NULL, resting_height INT NOT NULL, ae_female INT NOT NULL, albo_female INT NOT NULL, non_fed INT NOT NULL, blood_fed INT NOT NULL, semi_gravid INT NOT NULL, gravid INT NOT NULL, ae_male INT NOT NULL, albo_male INT NOT NULL, note TEXT DEFAULT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, address, container_id))');
        await db.execute(
            'CREATE TABLE ndcu_ovitrap_surveys (survey_id INT NOT NULL, address TEXT NOT NULL, container_id INT NOT NULL, environment INT NOT NULL, collected INT NOT NULL, identification INT DEFAULT NULL, fecundity INT DEFAULT NULL, note TEXT DEFAULT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, address, container_id))');
        await db.execute(
            'CREATE TABLE ndcu_pupal_surveys (survey_id INT NOT NULL, address TEXT NOT NULL, container_id INT NOT NULL, breeding_type VARCHAR(10) NOT NULL, environment INT NOT NULL, observation INT NOT NULL, samples TEXT DEFAULT NULL, identified INT DEFAULT NULL, identified_type INT DEFAULT NULL, identified_other TEXT DEFAULT NULL, note TEXT DEFAULT NULL, created TEXT DEFAULT NULL, updated TEXT DEFAULT NULL, last_sync TEXT DEFAULT NULL, PRIMARY KEY(survey_id, address, container_id))');

        await db.execute(
            'CREATE TABLE ndcu_geo_districts (id INT NOT NULL,name VARCHAR(100) NOT NULL)');
        await db.execute(
            'CREATE TABLE ndcu_geo_rdhs (id INT NOT NULL,district INT NOT NULL,name VARCHAR(100) NOT NULL)');
        await db.execute(
            'CREATE TABLE ndcu_geo_moh (id INT NOT NULL,district INT NOT NULL,rdhs INT NOT NULL,name VARCHAR(100) NOT NULL)');
        await db.execute(
            'CREATE TABLE ndcu_geo_phi (id INT NOT NULL,district INT NOT NULL,rdhs INT NOT NULL,moh INT NOT NULL,name VARCHAR(100) NOT NULL)');
        await db.execute(
            'CREATE TABLE ndcu_geo_gn (id INT NOT NULL,district INT NOT NULL,rdhs INT NOT NULL,moh INT NOT NULL,phi INT NOT NULL,name VARCHAR(100) NOT NULL)');
        return;
      }),
      version: 1,
    );
  }
}
