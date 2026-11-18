Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042721;
	b=qqAQtC8I7sUS8Jryaphv1P5Z/G9LdtiBc5kjr0cH+m4szfOjrZu9/6QXrem8am7yKDYQ
	 QH7Sebm089rwOxy9bYPLq89MFZ1/OzxUc5IxQWLzgHW+iZs6BX2y0uKaWJZn0kpbLmexY
	 W1LQRLGl2m0dw/V9c+7m7kqGluY4rl3dY7P7snzTYFrQXVmOFKdc6if2JRCTIx6VoyXz9
	 bhaC/qAgrwuSwF1yxFiuNVkadYAtvX747eKxkSwCZrlkBkWvhyOvkg3ltBHuNAQDKefqK
	 Gg3o6B1KirHO3X4++gQlkvEfbQoV/UgIQeexADPmTXoaOiPuLk6HKPkjRElP0VbKoCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WX3Agqasj9uznc1oZ5mBR6yfRBhkUCwzyfmxvmwDcE=;
	b=jhf3Xuz7PwJX0ofTB/JVjus34YWL5N7cUkgKK7dzt2MsDeeXACy1296qMU3rqmNlOu9s
	 LQI/jz2+/1GkMn+lvNH0t84BdXUbpszDvt+WN28F02QVH4+T31qjwQb/WQ5mvZFmT1PmM
	 FUattNYkuCD/FwcGG4c/J3F7bYx+F85GB0LBNU7cNYjDxDGI5TU0aDPCUDioHEs/f7C2g
	 XOra27bfAXS3niiTu9yXMOHzsxXRqadIw814p8PydJGVIJZGN52ZPwXKYByAeh58aNwOH
	 79bHf89FYe7lsrKkA0ZotHSMlWxAo5gtisIakvEXty0w8zVXv9jTyHQUkBkXX70eQRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAnh6WNs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BF3606A32A;
	Wed, 18 Nov 2026 22:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAnh6WNs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15411F000C4;
	Wed, 18 Nov 2026 22:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042721;
	bh=6WX3Agqasj9uznc1oZ5mBR6yfRBhkUCwzyfmxvmwDcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAnh6WNsxgUGDeufrt45XFUGNYQSDE13pu3zbnlyWphisZ7INOk3CRLnLQhMjE6Qw
	 fOIxHYofcEB7O62i5QbuR6+eD3S9XtyIxQAaow+UxoHmqydzlBu1kkLb27LlXyswRx
	 gaa94EYJuPGaNdto7WJ+ryXnlW+ol1YNOcmkiP4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3271/3318] apparmor: add support for 2^24 states to the dfa state machine.
Date: Wed, 18 Nov 2026 16:04:53 +0100
Message-ID: <20261118150457.746097155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 9208c05f9fdfd927ea160b97dfef3c379049fff2 ]

Currently the dfa state machine is limited by its default, next, and
check tables using u16. Allow loading of u32 tables, and if u16 tables
are loaded map them to u32.

The number of states allowed does not increase to 2^32 because the
base table uses the top 8 bits of its u32 for flags. Moving the flags
into a separate table allowing a full 2^32 bit range wil be done in
a separate patch.

Link: https://gitlab.com/apparmor/apparmor/-/issues/419
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: e667fc72f7f4 ("apparmor: convert duplicated dfa transitions to match_char()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c    |  1 +
 security/apparmor/include/match.h |  8 ++-
 security/apparmor/match.c         | 99 ++++++++++++++++++++++++-------
 3 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 0d340da15ce74..f901b1881146d 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2433,6 +2433,7 @@ static struct aa_sfs_entry aa_sfs_entry_policy[] = {
 	AA_SFS_FILE_U64("outofband",		MAX_OOB_SUPPORTED),
 	AA_SFS_FILE_U64("permstable32_version",	1),
 	AA_SFS_FILE_STRING("permstable32", PERMS32STR),
+	AA_SFS_FILE_U64("state32",	1),
 	AA_SFS_DIR("unconfined_restrictions",   aa_sfs_entry_unconfined),
 	{ }
 };
diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index 14c0401f97c1b..da03d1404335a 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -87,10 +87,12 @@ struct table_header {
 	char td_data[];
 };
 
-#define DEFAULT_TABLE(DFA) ((u16 *)((DFA)->tables[YYTD_ID_DEF]->td_data))
+#define TABLE_DATAU16(TABLE) ((u16 *)((TABLE)->td_data))
+#define TABLE_DATAU32(TABLE) ((u32 *)((TABLE)->td_data))
+#define DEFAULT_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_DEF]->td_data))
 #define BASE_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_BASE]->td_data))
-#define NEXT_TABLE(DFA) ((u16 *)((DFA)->tables[YYTD_ID_NXT]->td_data))
-#define CHECK_TABLE(DFA) ((u16 *)((DFA)->tables[YYTD_ID_CHK]->td_data))
+#define NEXT_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_NXT]->td_data))
+#define CHECK_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_CHK]->td_data))
 #define EQUIV_TABLE(DFA) ((u8 *)((DFA)->tables[YYTD_ID_EC]->td_data))
 #define ACCEPT_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_ACCEPT]->td_data))
 #define ACCEPT_TABLE2(DFA) ((u32 *)((DFA)->tables[YYTD_ID_ACCEPT2]->td_data))
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 0a3307cd41076..5d2fe77e6ab96 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -263,6 +263,42 @@ void aa_dfa_free_kref(struct kref *kref)
 	dfa_free(dfa);
 }
 
+
+
+/**
+ * remap_data16_to_data32 - remap u16 @old table to a u32 based table
+ * @old: table to remap
+ *
+ * Returns: new table with u32 entries instead of u16.
+ *
+ * Note: will free @old so caller does not have to
+ */
+static struct table_header *remap_data16_to_data32(struct table_header *old)
+{
+	struct table_header *new;
+	size_t tsize;
+	u32 i;
+
+	tsize = table_size(old->td_lolen, YYTD_DATA32);
+	new = kvzalloc(tsize, GFP_KERNEL);
+	if (!new) {
+		kvfree(old);
+		return NULL;
+	}
+	new->td_id = old->td_id;
+	new->td_flags = YYTD_DATA32;
+	new->td_lolen = old->td_lolen;
+
+	for (i = 0; i < old->td_lolen; i++)
+		TABLE_DATAU32(new)[i] = (u32) TABLE_DATAU16(old)[i];
+
+	kvfree(old);
+	if (is_vmalloc_addr(new))
+		vm_unmap_aliases();
+
+	return new;
+}
+
 /**
  * aa_dfa_unpack - unpack the binary tables of a serialized dfa
  * @blob: aligned serialized stream of data to unpack  (NOT NULL)
@@ -342,8 +378,10 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 		case YYTD_ID_DEF:
 		case YYTD_ID_NXT:
 		case YYTD_ID_CHK:
-			if (table->td_flags != YYTD_DATA16)
+			if (!(table->td_flags == YYTD_DATA16 ||
+			      table->td_flags == YYTD_DATA32)) {
 				goto fail;
+			}
 			break;
 		case YYTD_ID_EC:
 			if (table->td_flags != YYTD_DATA8)
@@ -358,6 +396,23 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 		dfa->tables[table->td_id] = table;
 		data += table_size(table->td_lolen, table->td_flags);
 		size -= table_size(table->td_lolen, table->td_flags);
+
+		/*
+		 * this remapping has to be done after incrementing data above
+		 * for now straight remap, later have dfa support both
+		 */
+		switch (table->td_id) {
+		case YYTD_ID_DEF:
+		case YYTD_ID_NXT:
+		case YYTD_ID_CHK:
+			if (table->td_flags == YYTD_DATA16) {
+				table = remap_data16_to_data32(table);
+				if (!table)
+					goto fail;
+			}
+			dfa->tables[table->td_id] = table;
+			break;
+		}
 		table = NULL;
 	}
 	error = verify_table_headers(dfa->tables, flags);
@@ -411,10 +466,10 @@ do {							\
 aa_state_t aa_dfa_match_len(struct aa_dfa *dfa, aa_state_t start,
 			    const char *str, int len)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 	aa_state_t state = start;
 
 	if (state == DFA_NOMATCH)
@@ -455,10 +510,10 @@ aa_state_t aa_dfa_match_len(struct aa_dfa *dfa, aa_state_t start,
  */
 aa_state_t aa_dfa_match(struct aa_dfa *dfa, aa_state_t start, const char *str)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 	aa_state_t state = start;
 
 	if (state == DFA_NOMATCH)
@@ -498,10 +553,10 @@ aa_state_t aa_dfa_match(struct aa_dfa *dfa, aa_state_t start, const char *str)
  */
 aa_state_t aa_dfa_next(struct aa_dfa *dfa, aa_state_t state, const char c)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 
 	/* current state is <state>, matching character *str */
 	if (dfa->tables[YYTD_ID_EC]) {
@@ -516,10 +571,10 @@ aa_state_t aa_dfa_next(struct aa_dfa *dfa, aa_state_t state, const char c)
 
 aa_state_t aa_dfa_outofband_transition(struct aa_dfa *dfa, aa_state_t state)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 	u32 b = (base)[(state)];
 
 	if (!(b & MATCH_FLAG_OOB_TRANSITION))
@@ -547,10 +602,10 @@ aa_state_t aa_dfa_outofband_transition(struct aa_dfa *dfa, aa_state_t state)
 aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
 				const char *str, const char **retpos)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
 	aa_state_t state = start, pos;
 
@@ -608,10 +663,10 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
 aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 				 const char *str, int n, const char **retpos)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
 	aa_state_t state = start, pos;
 
@@ -685,10 +740,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
 				 const char *str, struct match_workbuf *wb,
 				 unsigned int *count)
 {
-	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *def = DEFAULT_TABLE(dfa);
 	u32 *base = BASE_TABLE(dfa);
-	u16 *next = NEXT_TABLE(dfa);
-	u16 *check = CHECK_TABLE(dfa);
+	u32 *next = NEXT_TABLE(dfa);
+	u32 *check = CHECK_TABLE(dfa);
 	aa_state_t state = start, pos;
 
 	AA_BUG(!dfa);
-- 
2.53.0



