Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620155;
	b=VI20s3kHziDDqjRp0PeuHpqTgal7XRe2lnR1VPi76zoZ7LxfU2vDjB3cmuYWDEnlQgC4
	 mRERCNclrM7AJgVhl3zB/cYNOp3rfMFUdNEYDPnabEuDIeX7ynbTfjilf4qHUpzY+lrNu
	 PRvJgXTHOc8fxGO/MsQ4OOXPjCbCkj63BGrVUqxcsv8gRNzcSmRyTxzaQXX/vkYsdpAfu
	 PN73Z3otOF9DWur2/9TildTIH959ih0k/MtMQ6xD1E1PbguauGHbuz/hgXU7/uaeHTjlM
	 G2EKxVTFL+V1EqDzriquv0VRM4eVqMk2lKYBedZMiVZgd8rbl2lXzotHjQhALMKOEHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BC6wQ4XbIAeYfOKjQWD1dOod9luEHVohCP5fk4/B/iY=;
	b=SmIqPQ7aWA+CILyLWVkBeK5obioMTezDaFDUfcD2noodUuAJ9wGw2nqqODsDXsanSApz
	 dKdqQsk2p3xa+NLiG2JaATgCLU7+99IDRn9/fUDaR0QcyApjHE03T1eT6/goLO1t1o5lf
	 9dT2pV+IFQdVfnow7UX/NHvhVv7Ou9voqMyJnmSLx0ZB1EYGKfhimKQALgbeu4jwjr0vX
	 WbzDnSOzv2Zco5L5FwGWFfvEL89iXtXYiFW6zS4grNU44ssmo6t11mdFLkhfMA2MT2mtF
	 R70QhgllA4hCEUX8zzxczw7BxtQylh1CdbX/Cl4Gxu7XfCbD7j9ETXYwskX9j/cnfow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GFC0IGz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BF4606A32A;
	Wed, 25 Nov 2026 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GFC0IGz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EDC1F000C4;
	Wed, 25 Nov 2026 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620155;
	bh=BC6wQ4XbIAeYfOKjQWD1dOod9luEHVohCP5fk4/B/iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GFC0IGzNduVlpWyXc3L8rhGRxFEFnqGQb4cEx2Av3Q4bDlp0BQtlDfRDaE6405y5
	 Dife6KLS406MV8Z4JqyUGpkj03zg45ph6ZStZm/ldkSyR285Kg+TrG7gHPLC0/49s6
	 Ozp66oj8c13o0PqF0RSTSlsfeIoFcrFiXiZrrNHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0826/1005] ovl: report the requested redirect_dir mode in conflicting options
Date: Wed, 25 Nov 2026 15:36:04 +0100
Message-ID: <20261125143841.073748256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 248503755b3cab89742edcc3cfd53adbcf7bfec2 upstream.

Since the redirect_dir mode is stored as an enum, "off" is translated to
"follow" or "nofollow" when parsing the option and redirect_dir=follow is
translated to "on" for a non-upper mount, so the errors about options
that conflict with an explicit redirect_dir= report a mode that the user
did not request.

Translate "off" when verifying the mount options instead of when parsing
them and report the requested mode in those errors.

Fixes: af5f2396b671 ("ovl: store enum redirect_mode in config instead of a string")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/overlayfs.h |   10 +++++++---
 fs/overlayfs/params.c    |   43 ++++++++++++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 16 deletions(-)

--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -74,9 +74,13 @@ enum ovl_entry_flag {
 };
 
 enum {
-	OVL_REDIRECT_OFF,	/* "off" mode is never used. In effect	*/
-	OVL_REDIRECT_FOLLOW,	/* ...it translates to either "follow"	*/
-	OVL_REDIRECT_NOFOLLOW,	/* ...or "nofollow".			*/
+	/*
+	 * "off" mode is never used after mount options are verified. In effect
+	 * it translates to either "follow" or "nofollow".
+	 */
+	OVL_REDIRECT_OFF,
+	OVL_REDIRECT_FOLLOW,
+	OVL_REDIRECT_NOFOLLOW,
 	OVL_REDIRECT_ON,
 };
 
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -112,18 +112,28 @@ const struct constant_table ovl_paramete
 	{}
 };
 
+static const char *ovl_redirect_mode_name(int redirect_mode)
+{
+	return ovl_parameter_redirect_dir[redirect_mode].name;
+}
+
 static const char *ovl_redirect_mode(struct ovl_config *config)
 {
-	return ovl_parameter_redirect_dir[config->redirect_mode].name;
+	return ovl_redirect_mode_name(config->redirect_mode);
 }
 
-static int ovl_redirect_mode_def(void)
+static int ovl_redirect_follow_mode(void)
 {
-	return ovl_redirect_dir_def	  ? OVL_REDIRECT_ON :
-	       ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
+	return ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
 					    OVL_REDIRECT_NOFOLLOW;
 }
 
+static int ovl_redirect_mode_def(void)
+{
+	return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
+				      ovl_redirect_follow_mode();
+}
+
 static const struct constant_table ovl_parameter_verity[] = {
 	{ "off",	OVL_VERITY_OFF     },
 	{ "on",		OVL_VERITY_ON      },
@@ -659,11 +669,6 @@ static int ovl_parse_param(struct fs_con
 		break;
 	case Opt_redirect_dir:
 		config->redirect_mode = result.uint_32;
-		if (config->redirect_mode == OVL_REDIRECT_OFF) {
-			config->redirect_mode = ovl_redirect_always_follow ?
-						OVL_REDIRECT_FOLLOW :
-						OVL_REDIRECT_NOFOLLOW;
-		}
 		ctx->set.redirect = true;
 		break;
 	case Opt_index:
@@ -819,7 +824,13 @@ int ovl_init_fs_context(struct fs_contex
 	if (!ofs)
 		goto out_err;
 
-	ofs->config.redirect_mode	= ovl_redirect_mode_def();
+	/*
+	 * The module default determines only if new redirects are created in
+	 * upper dir.  If they are not, the redirect follow mode will be
+	 * determined after parsing mount options.
+	 */
+	ofs->config.redirect_mode	= ovl_redirect_dir_def ?
+					  OVL_REDIRECT_ON : OVL_REDIRECT_OFF;
 	ofs->config.index		= ovl_index_def;
 	ofs->config.uuid		= ovl_uuid_def();
 	ofs->config.nfs_export		= ovl_nfs_export_def;
@@ -877,6 +888,8 @@ int ovl_fs_params_verify(const struct ov
 			 struct ovl_config *config)
 {
 	struct ovl_opt_set set = ctx->set;
+	/* The requested redirect_dir=, for reporting conflicts with it */
+	int redirect_opt = config->redirect_mode;
 
 	/* Workdir/index are useless in non-upper mount */
 	if (!config->upperdir) {
@@ -903,6 +916,10 @@ int ovl_fs_params_verify(const struct ov
 		config->uuid = OVL_UUID_NULL;
 	}
 
+	/* Resolve redirect_dir=off to the default redirect follow mode */
+	if (config->redirect_mode == OVL_REDIRECT_OFF)
+		config->redirect_mode = ovl_redirect_follow_mode();
+
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
 	 * difference, since redirect_dir=on is only used for upper.
@@ -914,7 +931,7 @@ int ovl_fs_params_verify(const struct ov
 	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
 		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
+			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
 		}
 		if (set.redirect) {
@@ -923,7 +940,7 @@ int ovl_fs_params_verify(const struct ov
 			 * in this conflict.
 			 */
 			pr_info("disabling metacopy due to redirect_dir=%s\n",
-				ovl_redirect_mode(config));
+				ovl_redirect_mode_name(redirect_opt));
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
@@ -990,7 +1007,7 @@ int ovl_fs_params_verify(const struct ov
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
+			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
 		}
 		if (config->metacopy && set.metacopy) {


