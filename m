Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625939;
	b=ZWhAlFuwL2DV309Y6zemrUcMn5nuHEdfb93Ru3Byd95TPRl9An8gu59uw4Rx5Fg2ORJL
	 NTwkz9aOCZTOiLqlcxxEKxAiZBh2QnUZnup7nnNjIp07lV0bK3lRIHOa9m5KMRAtyyj8/
	 mgpkm8SS3nd6Hj1IUDojbbZSvWj7AgWJcdqlzH9N4LF6BlAadmxBK9pJ3OYObTJjCjm2C
	 3UqtY4NJb0wf3noHG/nlnm6DHqX6Rp9fyHDNLgt9u4QVUCDgirVLNjN87uSAxQCHyx2tG
	 G1cWYxZ3HS5M96EhnBKh+/FK80i1WE3V1yjoAHXHQL7DgwJ7kDcToM2iIiO5wHAqlwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qN1tgo7c7ckpgw3ds9+ct6ozaSq1TJRZn/U0RdFBRtY=;
	b=fKqjue7WdKI6z92UOzH/EXJ6xhgYvt17+n6w9boTzS4qrLxzpae3/RDF8CgTztRFSOlT
	 5P3yTa5jRovbfyhy7+TNehBYUoG9u6D0BOkr8KCiInL2SQ1UqH/aw0FV2tcd5eyCJtlfA
	 fKxd4Unvba1yC6TTUNlxTvpd+SRfgHIbIAUfWz5S6Cp2MUYAfdBhHwbFl0tIZnhiNm+1w
	 ocRp42dz9zaB5ectS9WKvJO+K8PVMg/gTFYmEV1/OY1VEAPoNkUqvQi3Ni+fzB+Z/wE/e
	 uKCOlNU4xG8F4D2uM9yOHmdk3pt1D0Z9dXAkK5ARKjjo7wzmCKNvewDOpAYaOHPH9Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3qGVxBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE078606A31E;
	Wed, 25 Nov 2026 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3qGVxBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0452A1F000C0;
	Wed, 25 Nov 2026 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625939;
	bh=qN1tgo7c7ckpgw3ds9+ct6ozaSq1TJRZn/U0RdFBRtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3qGVxBpuWR0MS88i7JBX5XfBj3aGKPpj8OEkDcYr5/PJNKqLuWgEnAt/pXQ6wNld
	 qh1edz8CUWDNCyMC0m24eyCfBhJrFKYdLnQCq9HWh0rMaPxESLzIT/Uq864EgzFT/q
	 2adNfXeCuAm4tEkGWc1+7xzKcRHqC5OyDofK6r8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 679/816] ovl: report the requested redirect_dir mode in conflicting options
Date: Wed, 25 Nov 2026 15:37:07 +0100
Message-ID: <20261125143904.897304943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -111,18 +111,28 @@ const struct constant_table ovl_paramete
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
@@ -581,11 +591,6 @@ static int ovl_parse_param(struct fs_con
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
@@ -718,7 +723,13 @@ int ovl_init_fs_context(struct fs_contex
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
@@ -774,6 +785,8 @@ int ovl_fs_params_verify(const struct ov
 			 struct ovl_config *config)
 {
 	struct ovl_opt_set set = ctx->set;
+	/* The requested redirect_dir=, for reporting conflicts with it */
+	int redirect_opt = config->redirect_mode;
 
 	/* Workdir/index are useless in non-upper mount */
 	if (!config->upperdir) {
@@ -812,6 +825,10 @@ int ovl_fs_params_verify(const struct ov
 		config->metacopy = true;
 	}
 
+	/* Resolve redirect_dir=off to the default redirect follow mode */
+	if (config->redirect_mode == OVL_REDIRECT_OFF)
+		config->redirect_mode = ovl_redirect_follow_mode();
+
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
 	 * difference, since redirect_dir=on is only used for upper.
@@ -823,7 +840,7 @@ int ovl_fs_params_verify(const struct ov
 	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
 		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
+			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
 		}
 		if (config->verity_mode && set.redirect) {
@@ -837,7 +854,7 @@ int ovl_fs_params_verify(const struct ov
 			 * in this conflict.
 			 */
 			pr_info("disabling metacopy due to redirect_dir=%s\n",
-				ovl_redirect_mode(config));
+				ovl_redirect_mode_name(redirect_opt));
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
@@ -904,7 +921,7 @@ int ovl_fs_params_verify(const struct ov
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
+			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
 		}
 		if (config->metacopy && set.metacopy) {


