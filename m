Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033241;
	b=3YSTBeveYgHx0A6oBvITkLsfpyEvZRW7OsjPVxcxUjQXASqW59L7XZN3gi0KeYKsNOFf
	 Wg08gslfvyP6EvFoUSuegF3K2WoPuJEw4pSe5lPU4/ZkVjusfzY8DBN1RTfTzZg41/hoP
	 XVvYR6sTTLwK2rh9+MDlmP8ZPDJQsEN9rjuwQlg9rS7juFYTSFJr7u2p4eTXDMzxjDVcM
	 u/69fbO2D8gkSgMOS59jIKT4fASjYqXHu7W7XG2uVFdh8t8azEPvqhfaKg1BnGN0jSXpV
	 PYbddX4pSwaO2Q//R5im7pSL9UpOUVKkTMUGIvsXEp4pl4dPR8iZapL7XCZ+OjrhGWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VjQKc7+qkoj/eNxsbtIiNTOUBXWqvP+bKFCRI7hkDjw=;
	b=I0XApufwWk12IfwKA7uto4ghrnuTYoi466d8baiXCPya81cP3g+V1zVBGNU50/tAIJKd
	 /+6OeIs8inCvZi185RwEe1CDDY8VcgGEze4FKF3uz212w2l3B4GGuvM3WskgaN0Oufzma
	 UyuuRq/9lM4v6KXsy+CrsbYosZeT5xbZuZXrDnKw/kSdWn/aJSLPOhalO2DNsTuylaUvR
	 f/NSxA/eG0F1swggOWnJQPKDMQFnEb+haqIVlb7DTlvGwhNy6jtCzZ4AJa/y0QoOE6+eo
	 xGwxFnM08dg40f311NKajOF170p/PESMXQFxSYouVfNa/NaBZJYNPLzqaHLHXpZA6Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7K8KI3a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5E7606A330;
	Wed, 18 Nov 2026 20:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7K8KI3a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D1A1F000C4;
	Wed, 18 Nov 2026 20:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033240;
	bh=VjQKc7+qkoj/eNxsbtIiNTOUBXWqvP+bKFCRI7hkDjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7K8KI3aPZOHM17RZSjvrNtZxtJ684K5Nk1CVnmp8w4oph6N2tVGLuSf+pNrJKloi
	 3qOVaaSlF4doloueXJhnbEEL5WCscTfnlG8X4aNVb4/Mx94QeXc8p7F9OYhl2Hv4Qy
	 t44mt4PwZtSBwR12jjWw8UqOo4jG9a63FB9g6QYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1691/1756] apparmor: add additional flags to extended permission.
Date: Wed, 18 Nov 2026 16:03:38 +0100
Message-ID: <20261118150116.994259393@linuxfoundation.org>
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

[ Upstream commit 2e12c5f060176ede209673e4f63ea5d0e3c5814c ]

This is a step towards merging the file and policy state machines.

With the switch to extended permissions the state machine's ACCEPT2
table became unused freeing it up to store state specific flags. The
first flags to be stored are FLAG_OWNER and FLAG other which paves the
way towards merging the file and policydb perms into a single
permission table.

Currently Lookups based on the objects ownership conditional will
still need separate fns, this will be address in a following patch.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 449195a4bb7d ("apparmor: fix table_size() integer overflow on 32 bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c     |  5 +++--
 security/apparmor/domain.c         |  9 ++++++---
 security/apparmor/file.c           | 23 ++++++++++++++---------
 security/apparmor/include/file.h   |  5 +++--
 security/apparmor/include/policy.h |  7 ++++++-
 security/apparmor/policy_compat.c  |  6 +++---
 security/apparmor/policy_unpack.c  | 20 +++++++++++++++++++-
 7 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index eee116b42f27c..ac1507391686b 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -707,7 +707,8 @@ static void profile_query_cb(struct aa_profile *profile, struct aa_perms *perms,
 		if (state) {
 			struct path_cond cond = { };
 
-			tmp = *(aa_lookup_fperms(rules->file, state, &cond));
+			tmp = *(aa_lookup_condperms(current_fsuid(),
+						    rules->file, state, &cond));
 		}
 	} else if (rules->policy->dfa) {
 		if (!RULE_MEDIATES(rules, *match_str))
@@ -2478,7 +2479,7 @@ static struct aa_sfs_entry aa_sfs_entry_policy[] = {
 	AA_SFS_FILE_BOOLEAN("set_load",		1),
 	/* number of out of band transitions supported */
 	AA_SFS_FILE_U64("outofband",		MAX_OOB_SUPPORTED),
-	AA_SFS_FILE_U64("permstable32_version",	1),
+	AA_SFS_FILE_U64("permstable32_version",	3),
 	AA_SFS_FILE_STRING("permstable32", PERMS32STR),
 	AA_SFS_FILE_U64("state32",	1),
 	AA_SFS_DIR("unconfined_restrictions",   aa_sfs_entry_unconfined),
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 8685c10e6754c..66bea805e7f39 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -155,7 +155,8 @@ static int label_compound_match(struct aa_profile *profile,
 		if (!state)
 			goto fail;
 	}
-	*perms = *(aa_lookup_fperms(rules->file, state, &cond));
+	*perms = *(aa_lookup_condperms(current_fsuid(), rules->file, state,
+				       &cond));
 	aa_apply_modes_to_perms(profile, perms);
 	if ((perms->allow & request) != request)
 		return -EACCES;
@@ -210,7 +211,8 @@ static int label_components_match(struct aa_profile *profile,
 	return 0;
 
 next:
-	tmp = *(aa_lookup_fperms(rules->file, state, &cond));
+	tmp = *(aa_lookup_condperms(current_fsuid(), rules->file, state,
+				    &cond));
 	aa_apply_modes_to_perms(profile, &tmp);
 	aa_perms_accum(perms, &tmp);
 	label_for_each_cont(i, label, tp) {
@@ -219,7 +221,8 @@ static int label_components_match(struct aa_profile *profile,
 		state = match_component(profile, tp, stack, start);
 		if (!state)
 			goto fail;
-		tmp = *(aa_lookup_fperms(rules->file, state, &cond));
+		tmp = *(aa_lookup_condperms(current_fsuid(), rules->file, state,
+					    &cond));
 		aa_apply_modes_to_perms(profile, &tmp);
 		aa_perms_accum(perms, &tmp);
 	}
diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 62bc46e037588..35bd22a778baf 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -169,7 +169,8 @@ static int path_name(const char *op, const struct cred *subj_cred,
 struct aa_perms default_perms = {};
 /**
  * aa_lookup_fperms - convert dfa compressed perms to internal perms
- * @file_rules: the aa_policydb to lookup perms for  (NOT NULL)
+ * @subj_uid: uid to use for subject owner test
+ * @rules: the aa_policydb to lookup perms for  (NOT NULL)
  * @state: state in dfa
  * @cond:  conditions to consider  (NOT NULL)
  *
@@ -177,18 +178,21 @@ struct aa_perms default_perms = {};
  *
  * Returns: a pointer to a file permission set
  */
-struct aa_perms *aa_lookup_fperms(struct aa_policydb *file_rules,
-				 aa_state_t state, struct path_cond *cond)
+struct aa_perms *aa_lookup_condperms(kuid_t subj_uid, struct aa_policydb *rules,
+				     aa_state_t state, struct path_cond *cond)
 {
-	unsigned int index = ACCEPT_TABLE(file_rules->dfa)[state];
+	unsigned int index = ACCEPT_TABLE(rules->dfa)[state];
 
-	if (!(file_rules->perms))
+	if (!(rules->perms))
 		return &default_perms;
 
-	if (uid_eq(current_fsuid(), cond->uid))
-		return &(file_rules->perms[index]);
+	if ((ACCEPT_TABLE2(rules->dfa)[state] & ACCEPT_FLAG_OWNER)) {
+		if (uid_eq(subj_uid, cond->uid))
+			return &(rules->perms[index]);
+		return &(rules->perms[index + 1]);
+	}
 
-	return &(file_rules->perms[index + 1]);
+	return &(rules->perms[index]);
 }
 
 /**
@@ -207,7 +211,8 @@ aa_state_t aa_str_perms(struct aa_policydb *file_rules, aa_state_t start,
 {
 	aa_state_t state;
 	state = aa_dfa_match(file_rules->dfa, start, name);
-	*perms = *(aa_lookup_fperms(file_rules, state, cond));
+	*perms = *(aa_lookup_condperms(current_fsuid(), file_rules, state,
+				       cond));
 
 	return state;
 }
diff --git a/security/apparmor/include/file.h b/security/apparmor/include/file.h
index 6e8f2aa66cd63..06d9899098a65 100644
--- a/security/apparmor/include/file.h
+++ b/security/apparmor/include/file.h
@@ -77,8 +77,9 @@ int aa_audit_file(const struct cred *cred,
 		  const char *target, struct aa_label *tlabel, kuid_t ouid,
 		  const char *info, int error);
 
-struct aa_perms *aa_lookup_fperms(struct aa_policydb *file_rules,
-				  aa_state_t state, struct path_cond *cond);
+struct aa_perms *aa_lookup_condperms(kuid_t subj_uid,
+				     struct aa_policydb *file_rules,
+				     aa_state_t state, struct path_cond *cond);
 aa_state_t aa_str_perms(struct aa_policydb *file_rules, aa_state_t start,
 			const char *name, struct path_cond *cond,
 			struct aa_perms *perms);
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 47199bead884b..552b885b64a60 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -59,6 +59,11 @@ extern const char *const aa_profile_mode_names[];
 
 #define on_list_rcu(X) (!list_empty(X) && (X)->prev != LIST_POISON2)
 
+/* flags in the dfa accept2 table */
+enum dfa_accept_flags {
+	ACCEPT_FLAG_OWNER = 1,
+};
+
 /*
  * FIXME: currently need a clean way to replace and remove profiles as a
  * set.  It should be done at the namespace level.
@@ -124,6 +129,7 @@ static inline void aa_put_pdb(struct aa_policydb *pdb)
 		kref_put(&pdb->count, aa_pdb_free_kref);
 }
 
+/* lookup perm that doesn't have and object conditional */
 static inline struct aa_perms *aa_lookup_perms(struct aa_policydb *policy,
 					       aa_state_t state)
 {
@@ -135,7 +141,6 @@ static inline struct aa_perms *aa_lookup_perms(struct aa_policydb *policy,
 	return &(policy->perms[index]);
 }
 
-
 /* struct aa_data - generic data structure
  * key: name for retrieving this data
  * size: size of data in bytes
diff --git a/security/apparmor/policy_compat.c b/security/apparmor/policy_compat.c
index 423227670e685..cfc2207e5a12e 100644
--- a/security/apparmor/policy_compat.c
+++ b/security/apparmor/policy_compat.c
@@ -286,10 +286,10 @@ static void remap_dfa_accept(struct aa_dfa *dfa, unsigned int factor)
 
 	AA_BUG(!dfa);
 
-	for (state = 0; state < state_count; state++)
+	for (state = 0; state < state_count; state++) {
 		ACCEPT_TABLE(dfa)[state] = state * factor;
-	kvfree(dfa->tables[YYTD_ID_ACCEPT2]);
-	dfa->tables[YYTD_ID_ACCEPT2] = NULL;
+		ACCEPT_TABLE2(dfa)[state] = factor > 1 ? ACCEPT_FLAG_OWNER : 0;
+	}
 }
 
 /* TODO: merge different dfa mappings into single map_policy fn */
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 0928c064ee9f9..ac03011501dc6 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -731,6 +731,7 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 	void *pos = e->pos;
 	int i, flags, error = -EPROTO;
 	ssize_t size;
+	u32 version = 0;
 
 	pdb = aa_alloc_pdb(GFP_KERNEL);
 	if (!pdb)
@@ -748,6 +749,9 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 	if (pdb->perms) {
 		/* perms table present accept is index */
 		flags = TO_ACCEPT1_FLAG(YYTD_DATA32);
+		if (aa_unpack_u32(e, &version, "permsv") && version > 2)
+			/* accept2 used for dfa flags */
+			flags |= TO_ACCEPT2_FLAG(YYTD_DATA32);
 	} else {
 		/* packed perms in accept1 and accept2 */
 		flags = TO_ACCEPT1_FLAG(YYTD_DATA32) |
@@ -795,6 +799,20 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 		}
 	}
 
+	if (pdb->perms && version <= 2) {
+		/* add dfa flags table missing in v2 */
+		u32 noents = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_lolen;
+		u16 tdflags = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_flags;
+		size_t tsize = table_size(noents, tdflags);
+
+		pdb->dfa->tables[YYTD_ID_ACCEPT2] = kvzalloc(tsize, GFP_KERNEL);
+		if (!pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
+			*info = "failed to alloc dfa flags table";
+			goto out;
+		}
+		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_lolen = noents;
+		pdb->dfa->tables[YYTD_ID_ACCEPT2]->td_flags = tdflags;
+	}
 	/*
 	 * Unfortunately due to a bug in earlier userspaces, a
 	 * transition table may be present even when the dfa is
@@ -810,7 +828,7 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 
 	/* TODO: move compat mapping here, requires dfa merging first */
 	/* TODO: move verify here, it has to be done after compat mappings */
-
+out:
 	*policy = pdb;
 	return 0;
 
-- 
2.53.0



