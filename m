Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042718;
	b=2xTaKF/uvnO/8lymqwk0xRUzMEAhvwu3FMTJgpnJKVUvk2F1MQgjEzvYMD6U86RlLNUq
	 Cn91xxUA0h3NsECvxCvQOG5uWkFBV1w2Zt9UJg6V4sbhurQPXMJ+aiAxJMq25s/TQRnBw
	 mAUteP+HBE+qlgFw7eqOUpvjb6+1k74rO/jFbOAuAV6WAiOiKCUrCf2HUYyQwDJiLESMx
	 uRNoa4cj8rhJiBKyRk/D810fQFswAeEo2Tgmk9LeYUa9Z7S7WJIAutMGaDaLwmLsZssAD
	 ZeSwORiTdlw8vSuXkwQroTjkWrDGeyZPMjlroMuiCKSLYvU6gpVv0QALwgofvuWGhSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v4oqNHxG8hjFuaA+EW1shVEo0opDBUi7soTGa06DEA8=;
	b=A0qzkfSenEFVq8hY/EZ2Riw7rJg6wdTPXnUWvtvPoHv9gKap25H40nN0t9Izl+ONrwnI
	 z/38n0pc7MQjZXV56+1KwIH9J4mMEnXpfJ8KlWe6/wpNDlVHCPOH48LtTMpZBZRUA1/Y+
	 Sdn5bU1p9JDr0MwV6xT0IH644e8CuDb0tpTQsCeg7n1Yfq2nXrpeM6/OWHjQ0qOjk8gHL
	 ZhSOpiikLe1t1AfNXGpzdm7QgeHgqGHEcU1CAPPU76BYNLpVF1NA2OzhJWcYtMAvk97ib
	 dQoaKs6okQpU3BLNKYqAcJNyVdBDeqDXXmGG3pFB9IcRpLzjvfItXbC2+9CzKKqVOxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19Y+9PEd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D994606A320;
	Wed, 18 Nov 2026 22:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19Y+9PEd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5151F000C4;
	Wed, 18 Nov 2026 22:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042718;
	bh=v4oqNHxG8hjFuaA+EW1shVEo0opDBUi7soTGa06DEA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19Y+9PEdd2Ny3AM48yIFpUHyz4KBut9q3N10FWnwNwaX6tOdfmrIGxjH8XfbGiZ3a
	 0XfhchwxIzVR7p1DCzx1fcianAGzz7olF/uPCMqChndVsdoTvk2kyFt5e4FctJ0nmv
	 iMoMtzPtiJjYD7qqavon02QrrqHHt08lDwVRyflg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3270/3318] apparmor: allow restricting unprivileged change_profile
Date: Wed, 18 Nov 2026 16:04:52 +0100
Message-ID: <20261118150457.715508760@linuxfoundation.org>
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

[ Upstream commit 2d9da9b188b8cd3b579d7ef5ba5d334be9dd38fc ]

unprivileged unconfined can use change_profile to alter the confinement
set by the mac admin.

Allow restricting unprivileged unconfined by still allowing change_profile
but stacking the change against unconfined. This allows unconfined to
still apply system policy but allows the task to enter the new confinement.

If unprivileged unconfined is required a sysctl is provided to switch
to the previous behavior.

Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: e667fc72f7f4 ("apparmor: convert duplicated dfa transitions to match_char()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c     |  6 ++++++
 security/apparmor/domain.c         | 24 ++++++++++++++++++++++++
 security/apparmor/include/policy.h |  1 +
 security/apparmor/lsm.c            |  7 +++++++
 security/apparmor/policy.c         |  1 +
 5 files changed, 39 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 725f249d294bf..0d340da15ce74 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2411,6 +2411,11 @@ static struct aa_sfs_entry aa_sfs_entry_domain[] = {
 	{ }
 };
 
+static struct aa_sfs_entry aa_sfs_entry_unconfined[] = {
+	AA_SFS_FILE_BOOLEAN("change_profile", 1),
+	{ }
+};
+
 static struct aa_sfs_entry aa_sfs_entry_versions[] = {
 	AA_SFS_FILE_BOOLEAN("v5",	1),
 	AA_SFS_FILE_BOOLEAN("v6",	1),
@@ -2428,6 +2433,7 @@ static struct aa_sfs_entry aa_sfs_entry_policy[] = {
 	AA_SFS_FILE_U64("outofband",		MAX_OOB_SUPPORTED),
 	AA_SFS_FILE_U64("permstable32_version",	1),
 	AA_SFS_FILE_STRING("permstable32", PERMS32STR),
+	AA_SFS_DIR("unconfined_restrictions",   aa_sfs_entry_unconfined),
 	{ }
 };
 
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 5baf694d6a5ef..33f53dd6b635e 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -1347,6 +1347,8 @@ static int change_profile_perms_wrapper(const char *op, const char *name,
 	return error;
 }
 
+const char *stack_msg = "change_profile unprivileged unconfined converted to stacking";
+
 /**
  * aa_change_profile - perform a one-way profile transition
  * @fqname: name of profile may include namespace (NOT NULL)
@@ -1406,6 +1408,28 @@ int aa_change_profile(const char *fqname, int flags)
 			op = OP_CHANGE_PROFILE;
 	}
 
+	/* This should move to a per profile test. Requires pushing build
+	 * into callback
+	 */
+	if (!stack && unconfined(label) &&
+	    label == &labels_ns(label)->unconfined->label &&
+	    aa_unprivileged_unconfined_restricted &&
+	    /* TODO: refactor so this check is a fn */
+	    cap_capable(current_cred(), &init_user_ns, CAP_MAC_OVERRIDE,
+			CAP_OPT_NOAUDIT)) {
+		/* regardless of the request in this case apparmor
+		 * stacks against unconfined so admin set policy can't be
+		 * by-passed
+		 */
+		stack = true;
+		perms.audit = request;
+		(void) fn_for_each_in_ns(label, profile,
+				aa_audit_file(subj_cred, profile, &perms, op,
+					      request, auditname, NULL, target,
+					      GLOBAL_ROOT_UID, stack_msg, 0));
+		perms.audit = 0;
+	}
+
 	if (*fqname == '&') {
 		stack = true;
 		/* don't have label_parse() do stacking */
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index 0d100f26b746b..17d5492fdc832 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -34,6 +34,7 @@
 struct aa_ns;
 
 extern int unprivileged_userns_apparmor_policy;
+extern int aa_unprivileged_unconfined_restricted;
 
 extern const char *const aa_profile_mode_names[];
 #define APPARMOR_MODE_NAMES_MAX_INDEX 4
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 22f4f6bf5c99b..20b60b8d93159 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1816,6 +1816,13 @@ static struct ctl_table apparmor_sysctl_table[] = {
 		.mode           = 0600,
 		.proc_handler   = apparmor_dointvec,
 	},
+	{
+		.procname       = "apparmor_restrict_unprivileged_unconfined",
+		.data           = &aa_unprivileged_unconfined_restricted,
+		.maxlen         = sizeof(int),
+		.mode           = 0600,
+		.proc_handler   = apparmor_dointvec,
+	},
 
 	{ }
 };
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 79e7c7cb26b33..eeece851c2c57 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -88,6 +88,7 @@
 #include "include/resource.h"
 
 int unprivileged_userns_apparmor_policy = 1;
+int aa_unprivileged_unconfined_restricted;
 
 const char *const aa_profile_mode_names[] = {
 	"enforce",
-- 
2.53.0



