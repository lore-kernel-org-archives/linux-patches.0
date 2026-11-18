Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022514;
	b=5UbOgLEI+O+AczNBhIpwKobPawqEu0m/QNwQuM0LrMp7m12eDSvl2gcdzE8sVo/uOjW8
	 EXiwWQ054xQ/NOEc24Ywv54UT4Nvx9o7WhxbBXnyzFpBRpMloiNlwrEgqYxGLJ+9PNX71
	 JHrYk6HsyFXv4gaFn83y9u6qygCzZx7ahOh/UrO10Sp72XRN0EKZNUO1LR99xQ2z9RK4r
	 YxnCO/2B32rXSlwQzyp9lB55GlHR2N/7nbYfaGc9+71zl1u0A9bWV8JZhRDQrGPrl3/ZA
	 So5Z9C1xaVaY54oWchsY84gxOwF1OiLyYEC0TtuPlt0XcYe/li3leCj3YMjElhLaQVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YnxNLQPrIWiMTSKdgY0x1ZUA0dWbz9fahIZ6NlNHInQ=;
	b=LqnmHnceiNOiqIRuAi47TGTEQGtJyajfLhVtSRP/L57DoYNA70Iurzh0qzrekpRyzBmH
	 tZpz6qiGDndfvAYxLcdiygzsVRB3eP0T7X8ZHJ+41Sfapjzf/cf4v6EMc+aeafm6agjuC
	 r1ZnlloFiqzyEfEG9MtheHgqnwjMxkaPYBJ9ospp8SKtqMtTrmUKRzZaKQc2Otix2HhrS
	 DvJlQp7a9rXNzv1zZnNzjT1vi8NC350nuH+wRDpuLjB1yiXVHJrlnjcg5zXZ+ZYhdje89
	 h/JnVv3iPh2KLkuvsQZeXV/967RlkHZqLDHK9Qzbj5Cn3FjtYd0EYfZDncEpjUu/nhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cN/bvruR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B937606A331;
	Wed, 18 Nov 2026 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cN/bvruR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E421F000C5;
	Wed, 18 Nov 2026 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022514;
	bh=YnxNLQPrIWiMTSKdgY0x1ZUA0dWbz9fahIZ6NlNHInQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cN/bvruRsvOtIvlvNDB0kbkbsUI576YZccdte+KPTMAagWbZ2M5+/+9ilpZ+rhXp6
	 qwrC3v3t6ndon65c2NTWN+KHBaSfdYTfn73Wn14cBgf56zoaXtNDwvJ7HaJV9C8knB
	 yO/LaaFcBltNJexzNLQCfDZYsGxGblsmoKZMOQrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0039/2151] apparmor: constify aa_perms parameters that are read-only
Date: Wed, 18 Nov 2026 15:29:34 +0100
Message-ID: <20261118150123.120121320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit e3bc982007fe5e704c6a7f5a189502ece056f68d ]

Several functions take a struct aa_perms * argument that is only ever
read from and never modified through the pointer. Mark those parameters
const struct aa_perms * to document intent and let the compiler enforce
that the permission set is not mutated.

The converted functions are:
  - aa_check_perms()
  - aa_do_perms()
  - do_perms() (af_inet)
  - match_label() (af_unix)
  - verify_perm()
  - aa_perms_accum() / aa_perms_accum_raw() (@addend only)

No functional change.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Assisted-by: Claude:claude-opus-4.8
Stable-dep-of: ce94927fa417 ("apparmor: fix profile leak when a policy load fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_unix.c       |  2 +-
 security/apparmor/include/net.h   |  2 +-
 security/apparmor/include/perms.h | 11 ++++++-----
 security/apparmor/lib.c           |  2 +-
 security/apparmor/net.c           |  2 +-
 security/apparmor/policy_unpack.c |  2 +-
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/af_unix.c b/security/apparmor/af_unix.c
index aa2b31d5598cd..7ba775017586b 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -172,7 +172,7 @@ static aa_state_t match_to_peer(struct aa_policydb *policy, aa_state_t state,
 static aa_state_t match_label(struct aa_profile *profile,
 			      struct aa_ruleset *rule, aa_state_t state,
 			      u32 request, struct aa_profile *peer,
-			      struct aa_perms *p,
+			      const struct aa_perms *p,
 			      struct apparmor_audit_data *ad)
 {
 	AA_BUG(!profile);
diff --git a/security/apparmor/include/net.h b/security/apparmor/include/net.h
index 0d0b0ce427238..021a35b94bd7e 100644
--- a/security/apparmor/include/net.h
+++ b/security/apparmor/include/net.h
@@ -86,7 +86,7 @@ extern struct aa_sfs_entry aa_sfs_entry_network[];
 extern struct aa_sfs_entry aa_sfs_entry_networkv9[];
 
 int aa_do_perms(struct aa_profile *profile, struct aa_policydb *policy,
-		aa_state_t state, u32 request, struct aa_perms *p,
+		aa_state_t state, u32 request, const struct aa_perms *p,
 		struct apparmor_audit_data *ad);
 /* passing in state returned by XXX_mediates_AF() */
 aa_state_t aa_match_to_prot(struct aa_policydb *policy, aa_state_t state,
diff --git a/security/apparmor/include/perms.h b/security/apparmor/include/perms.h
index 37a3781b99a08..695d9b0572d4f 100644
--- a/security/apparmor/include/perms.h
+++ b/security/apparmor/include/perms.h
@@ -105,7 +105,7 @@ extern struct aa_perms allperms;
  * @addend: perms struct to add to @accum
  */
 static inline void aa_perms_accum_raw(struct aa_perms *accum,
-				      struct aa_perms *addend)
+				      const struct aa_perms *addend)
 {
 	accum->deny |= addend->deny;
 	accum->allow &= addend->allow & ~addend->deny;
@@ -132,7 +132,7 @@ static inline void aa_perms_accum_raw(struct aa_perms *accum,
  * @addend: perms struct to add to @accum
  */
 static inline void aa_perms_accum(struct aa_perms *accum,
-				  struct aa_perms *addend)
+				  const struct aa_perms *addend)
 {
 	accum->deny |= addend->deny;
 	accum->allow &= addend->allow & ~accum->deny;
@@ -208,12 +208,13 @@ void aa_audit_perm_mask(struct audit_buffer *ab, u32 mask, const char *chrs,
 			u32 chrsmask, const char * const *names, u32 namesmask);
 void aa_apply_modes_to_perms(struct aa_profile *profile,
 			     struct aa_perms *perms);
-void aa_perms_accum(struct aa_perms *accum, struct aa_perms *addend);
-void aa_perms_accum_raw(struct aa_perms *accum, struct aa_perms *addend);
+void aa_perms_accum(struct aa_perms *accum, const struct aa_perms *addend);
+void aa_perms_accum_raw(struct aa_perms *accum, const struct aa_perms *addend);
 void aa_profile_match_label(struct aa_profile *profile,
 			    struct aa_ruleset *rules, struct aa_label *label,
 			    int type, u32 request, struct aa_perms *perms);
-int aa_check_perms(struct aa_profile *profile, struct aa_perms *perms,
+int aa_check_perms(struct aa_profile *profile, const struct aa_perms *perms,
 		   u32 request, struct apparmor_audit_data *ad,
 		   void (*cb)(struct audit_buffer *, void *));
 #endif /* __AA_PERM_H */
+
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 5d53c15e46a9e..3b982770c4ceb 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -415,7 +415,7 @@ void aa_profile_match_label(struct aa_profile *profile,
  *       error code will indicate whether there was an explicit deny
  *	 with a positive value.
  */
-int aa_check_perms(struct aa_profile *profile, struct aa_perms *perms,
+int aa_check_perms(struct aa_profile *profile, const struct aa_perms *perms,
 		   u32 request, struct apparmor_audit_data *ad,
 		   void (*cb)(struct audit_buffer *, void *))
 {
diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index cf590dd08540c..73a272576d5d6 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -166,7 +166,7 @@ void audit_net_cb(struct audit_buffer *ab, void *va)
 /* standard permission lookup pattern - supports early bailout */
 int aa_do_perms(struct aa_profile *profile, struct aa_policydb *policy,
 		aa_state_t state, u32 request,
-		struct aa_perms *p, struct apparmor_audit_data *ad)
+		const struct aa_perms *p, struct apparmor_audit_data *ad)
 {
 	struct aa_perms perms;
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 391665c27ede1..8dc2adedc7ae1 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1257,7 +1257,7 @@ static bool verify_dfa_accept_index(struct aa_dfa *dfa, int table_size)
 	return true;
 }
 
-static bool verify_perm(struct aa_perms *perm)
+static bool verify_perm(const struct aa_perms *perm)
 {
 	/* TODO: allow option to just force the perms into a valid state */
 	if (perm->allow & perm->deny)
-- 
2.53.0



