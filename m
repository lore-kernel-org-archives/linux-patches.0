Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022511;
	b=t86pENlW44MRKi0EAuGzs5FbCHbv310O3+7cxICD3/c7Vdtlcf/c9V8Vcc/l62brbkhE
	 GmT8d74hrGF04SslT7PzQMjFu/M9BskktIR/OJW6+8UBP/1oyXR5UR1LTqACN8lFMGwyA
	 WMcgn+9iPE/4HJOz0jJG+U6WuWJ0C35KBHbXYfa25Ll+ADTP1m2V4evacA+LHsE4huYPW
	 kF9yYOp+a7dgmGH/QtDdwmCTAyOI063J1CMVH9cVGvEpZUh8EqS6cKw2HZ0rMf8gMMisg
	 nFCyZRWvXlnMmUN2JIitrl2dbuJH2UjlbgByqN2mIHnwQrDDVMLMHWC1Lm3Em8txByw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=32GrzAe/IR6H66UrMHYWQqzTDIy7qXyS+seQby2WpH0=;
	b=ay6Xm8yzwaybwOBFLNg442T4ZSLvJRHlqPUOfQayMnJ13U2by9yL4L3waYi3yqgZsLEJ
	 CEZgZpACXz3c1a7LFVharl+G1TlwCK/9Q1IA6lVqoPeL+CNZfDUrMzcBXs9c531QRLKnd
	 40Los1hgNBPXB2zu1+oSf4shvKq5EZe2pUYr0/aTjWkEDsWxfFPA2+w13rxDSMmNzFjxY
	 NfOFJj7mmCr9k9wuohXKMfY6Lq1/ymFyXWCmSB1L9rWM1F38QhSfhLGxk4rxCMDsbLMgZ
	 GAsSoDBeE/UcyGGf0/VVrukXXb3OmWm/eR3ITS6D0Puvr+hSRTy/Z9UNtx6JysXOv6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmapQSFf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C6C606A320;
	Wed, 18 Nov 2026 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmapQSFf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A471F000C4;
	Wed, 18 Nov 2026 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022511;
	bh=32GrzAe/IR6H66UrMHYWQqzTDIy7qXyS+seQby2WpH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmapQSFfTiHvq1nU3+oVXoEjh1crFTpAnpSk3cK4+nwtnaRBFgQf+eSGPVZ7z9VxO
	 f625B7H56eVxxkE0aoKseC9TnjPBIWUwMZ359bHW5CR4dI8BHdwYC4RBtstsTty3ja
	 plQde2VUGh7tVaf3EHjJg8saTHDz3+juVg0KXsI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0038/2151] apparmor: refactor xattr attachment, to take the file path
Date: Wed, 18 Nov 2026 15:29:33 +0100
Message-ID: <20261118150123.082406642@linuxfoundation.org>
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

[ Upstream commit 812aa0aa67d50c251d9788f1d225438e747507f0 ]

The full bprm does not need to be passed into xattrs_match, so only
pass in the path, and propagate the change backup the call stack until
bprm is actually needed.

Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: ce94927fa417 ("apparmor: fix profile leak when a policy load fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 8e478ac99ff6d..57e886b8ef461 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -303,28 +303,31 @@ static int change_profile_perms(struct aa_profile *profile,
 
 /**
  * aa_xattrs_match - check whether a file matches the xattrs defined in profile
- * @bprm: binprm struct for the process to validate
+ * @path: path for file being matched (NOT NULL)
  * @profile: profile to match against (NOT NULL)
  * @state: state to start match in
  *
  * Returns: number of extended attributes that matched, or < 0 on error
  */
-static int aa_xattrs_match(const struct linux_binprm *bprm,
+static int aa_xattrs_match(const struct path *path,
 			   struct aa_profile *profile, aa_state_t state)
 {
+	AA_BUG(!path);
+	AA_BUG(!profile);
+
 	int i;
 	struct dentry *d;
 	char *value = NULL;
 	struct aa_attachment *attach = &profile->attach;
 	int size, value_size = 0, ret = attach->xattr_count;
 
-	if (!bprm || !attach->xattr_count)
+	if (!attach->xattr_count)
 		return 0;
 	might_sleep();
 
 	/* transition from exec match to xattr set */
 	state = aa_dfa_outofband_transition(attach->xmatch->dfa, state);
-	d = bprm->file->f_path.dentry;
+	d = path->dentry;
 
 	for (i = 0; i < attach->xattr_count; i++) {
 		size = vfs_getxattr_alloc(&nop_mnt_idmap, d, attach->xattrs[i],
@@ -372,7 +375,7 @@ static int aa_xattrs_match(const struct linux_binprm *bprm,
 
 /**
  * find_attach - do attachment search for unconfined processes
- * @bprm: binprm structure of transitioning task
+ * @path: path of file in question (NOT NULL)
  * @ns: the current namespace  (NOT NULL)
  * @head: profile list to walk  (NOT NULL)
  * @name: to match against  (NOT NULL)
@@ -387,7 +390,7 @@ static int aa_xattrs_match(const struct linux_binprm *bprm,
  *
  * Returns: label or NULL if no match found
  */
-static struct aa_label *find_attach(const struct linux_binprm *bprm,
+static struct aa_label *find_attach(const struct path *path,
 				    struct aa_ns *ns, struct list_head *head,
 				    const char *name, const char **info)
 {
@@ -395,6 +398,7 @@ static struct aa_label *find_attach(const struct linux_binprm *bprm,
 	bool conflict = false;
 	struct aa_profile *profile, *candidate = NULL;
 
+	AA_BUG(!path);
 	AA_BUG(!name);
 	AA_BUG(!head);
 
@@ -434,13 +438,13 @@ static struct aa_label *find_attach(const struct linux_binprm *bprm,
 				if (count < candidate_len)
 					continue;
 
-				if (bprm && attach->xattr_count) {
+				if (attach->xattr_count) {
 					long rev = READ_ONCE(ns->revision);
 
 					if (!aa_get_profile_not0(profile))
 						goto restart;
 					rcu_read_unlock();
-					ret = aa_xattrs_match(bprm, profile,
+					ret = aa_xattrs_match(path, profile,
 							      state);
 					rcu_read_lock();
 					aa_put_profile(profile);
@@ -556,7 +560,7 @@ struct aa_label *x_table_lookup(struct aa_profile *profile, u32 xindex,
 /**
  * x_to_label - get target label for a given xindex
  * @profile: current profile  (NOT NULL)
- * @bprm: binprm structure of transitioning task
+ * @path: path of file in question
  * @name: name to lookup (NOT NULL)
  * @xindex: index into x transition table
  * @lookupname: returns: name used in lookup if one was specified (NOT NULL)
@@ -567,7 +571,7 @@ struct aa_label *x_table_lookup(struct aa_profile *profile, u32 xindex,
  * Returns: refcounted label or NULL if not found available
  */
 static struct aa_label *x_to_label(struct aa_profile *profile,
-				   const struct linux_binprm *bprm,
+				   const struct path *path,
 				   const char *name, u32 xindex,
 				   const char **lookupname,
 				   const char **info)
@@ -598,11 +602,11 @@ static struct aa_label *x_to_label(struct aa_profile *profile,
 	case AA_X_NAME:
 		if (xindex & AA_X_CHILD)
 			/* released by caller */
-			new = find_attach(bprm, ns, &profile->base.profiles,
+			new = find_attach(path, ns, &profile->base.profiles,
 					  name, info);
 		else
 			/* released by caller */
-			new = find_attach(bprm, ns, &ns->base.profiles,
+			new = find_attach(path, ns, &ns->base.profiles,
 					  name, info);
 		*lookupname = name;
 		break;
@@ -690,7 +694,7 @@ static struct aa_label *profile_transition(const struct cred *subj_cred,
 	}
 
 	if (profile_unconfined(profile)) {
-		new = find_attach(bprm, profile->ns,
+		new = find_attach(&bprm->file->f_path, profile->ns,
 				  &profile->ns->base.profiles, name, &info);
 		/* info set -> something unusual that we should report
 		 * Currently this is only conflicting attachments, but other
@@ -720,8 +724,8 @@ static struct aa_label *profile_transition(const struct cred *subj_cred,
 	state = aa_str_perms(rules->file, state, name, cond, &perms);
 	if (perms.allow & MAY_EXEC) {
 		/* exec permission determine how to transition */
-		new = x_to_label(profile, bprm, name, perms.xindex, &target,
-				 &info);
+		new = x_to_label(profile, &bprm->file->f_path, name,
+				 perms.xindex, &target, &info);
 		if (new && new->proxy == profile->label.proxy && info) {
 			/* Force audit on conflicting attachment fallback
 			 * Because perms is never used again after this audit
-- 
2.53.0



