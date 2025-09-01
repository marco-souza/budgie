CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE IF NOT EXISTS "users" ("id" TEXT PRIMARY KEY, "email" TEXT NOT NULL COLLATE NOCASE, "hashed_password" TEXT, "confirmed_at" TEXT, "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL, "name" TEXT);
CREATE UNIQUE INDEX "users_email_index" ON "users" ("email");
CREATE TABLE IF NOT EXISTS "users_tokens" ("id" TEXT PRIMARY KEY, "user_id" TEXT NOT NULL CONSTRAINT "users_tokens_user_id_fkey" REFERENCES "users"("id") ON DELETE CASCADE, "token" BLOB NOT NULL, "context" TEXT NOT NULL, "sent_to" TEXT, "authenticated_at" TEXT, "inserted_at" TEXT NOT NULL);
CREATE INDEX "users_tokens_user_id_index" ON "users_tokens" ("user_id");
CREATE UNIQUE INDEX "users_tokens_context_token_index" ON "users_tokens" ("context", "token");
INSERT INTO schema_migrations VALUES(20250901204006,'2025-09-01T22:13:18');
INSERT INTO schema_migrations VALUES(20250901205149,'2025-09-01T22:13:18');
