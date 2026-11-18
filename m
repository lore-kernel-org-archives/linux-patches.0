Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033365;
	b=cGo1h+ByAg8cjTnalis7cxuLhnGelcUs8EedZqcx+/eWlE88c5jbuV5gbKMsx1c5SMXQ
	 PautmUntZXW0EwlhFPUlIPHeyteRHZQmwUr78zqX/NJS64p4AgAo8K5K7FuvwecRdhlg7
	 XqViFH1igL/MK1cxBu4KENqu3oP23MMrpaQ12+YWN8I/J2nUQGRm8Hh5Ne+dpH83MUaHQ
	 yivHlcrfxK8Tcd2F7OoDu97mwzwyoVske/1ctxRgW4b8qYVdpPd1U67YBBTCNB94+zMB6
	 heNQtO90pMy0Uk6MlbgTyPPmBOxHIde686Ti2QPPKFziVGJkyEOiHtanOPDNYfAH2ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mmC6QBBE2YyORH/Vnm6BTUfOVWPD1ZOFP8wmB66RZzs=;
	b=VWvJ73Qh1msefpi6OGQEFvxkz17R6nZN1AV8d7tnKur4RNeA7rogex/1/VJMD9Abv9aN
	 JQuvPB0sketTcpo5ayw5LccKVXrAN5Evh6HUFwjvCUADtNiFMniIKpnqEhVi/9/6UnoJC
	 hrKW3RR9jBRTJN0u5BMqoPd/+lYc5pFPZZAUIIWbTwwqfqUvfTE7g9657iXmhNEtlacBN
	 rvMalVzjRM1pJ2ggO2smXTHWM8W9ZnmsUF0ohSBw3MYHSiY79YiCOzLQpMs+aBrlonbZh
	 BX8tWn8pZ1Zxzu+XPJuPKIYF6BOP5+CMziPhtlWzyTpxquoVCPILSgjstFj268f8nKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRNuVcvl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC4E606A32A;
	Wed, 18 Nov 2026 20:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRNuVcvl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E52F1F000CD;
	Wed, 18 Nov 2026 20:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033365;
	bh=mmC6QBBE2YyORH/Vnm6BTUfOVWPD1ZOFP8wmB66RZzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRNuVcvlehOB3zHaSfLBF8LZ/DatEw6YKYA9jgMAkkil8zHzjgHIrsT1ujqtk1AB9
	 bv/dTDTUoTh2c78fKPHPUa1JnejEYqtfHyAX2R47jFRQZdCMVvgnIvbkGPqPpXSr1v
	 lQUxWc4vn/CnJqoMx5jOB5ssPtXdOPnYkoTSBha0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1690/1756] apparmor: add support for 2^24 states to the dfa state machine.
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150116.955107642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 449195a4bb7d ("apparmor: fix table_size() integer overflow on 32 bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c    |  1 +
 security/apparmor/include/match.h |  8 ++-
 security/apparmor/match.c         | 99 ++++++++++++++++++++++++-------
 3 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index eeed8047b12ff..eee116b42f27c 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2480,6 +2480,7 @@ static struct aa_sfs_entry aa_sfs_entry_policy[] = {
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
index b43aaad86b249..b2a4bee4e3939 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -264,6 +264,42 @@ void aa_dfa_free_kref(struct kref *kref)
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
@@ -346,8 +382,10 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
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
@@ -362,6 +400,23 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
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
@@ -415,10 +470,10 @@ do {							\
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
@@ -459,10 +514,10 @@ aa_state_t aa_dfa_match_len(struct aa_dfa *dfa, aa_state_t start,
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
@@ -502,10 +557,10 @@ aa_state_t aa_dfa_match(struct aa_dfa *dfa, aa_state_t start, const char *str)
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
@@ -520,10 +575,10 @@ aa_state_t aa_dfa_next(struct aa_dfa *dfa, aa_state_t state, const char c)
 
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
@@ -551,10 +606,10 @@ aa_state_t aa_dfa_outofband_transition(struct aa_dfa *dfa, aa_state_t state)
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
 
@@ -612,10 +667,10 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
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
 
@@ -689,10 +744,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
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



