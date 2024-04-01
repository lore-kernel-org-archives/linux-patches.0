Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A71E525;
	Mon,  1 Apr 2024 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989904; cv=none; b=C0UVCM4Hpu8w9tzStZ+GU7zDFn30jOTqS7BtwRxeHUTOCn059IWJzrEyheEweEildYqyu/cgXxAGXzZCR1yQFmomh6C0jNIK1WJO0fDU+3+9KiQ+upxHa3wwhiOs7vX7hskjkL3MHjkg3HOD6RvC41teW4G7gFW0/TBXaiKl8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989904; c=relaxed/simple;
	bh=CND7UNl3T38Hp/wnurvUAPHgRuJRAVkguVIMzCLy9tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlXcJsBKVclmHh1SKmX8c/z7jmdT/Wuk7/EmbtWXIgkc+AqUXYtUVuwi1+7zBgFfK8ux8j7npSsZGHE8svjC5qVcmDZZguNwuDnwqXmbAd5ZLz3i/OSxfofQT0CJcbujOxRQbKZA39uTYT9lMTDq057CCheMiGjL2KMFL51FDNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAToxLUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAToxLUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C9DC433C7;
	Mon,  1 Apr 2024 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989903;
	bh=CND7UNl3T38Hp/wnurvUAPHgRuJRAVkguVIMzCLy9tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAToxLUjo4+e4nRKcOCdaYa9kj+2x5wLdZ/KW4EQmr89ctZsx/IxPjBncQ4F7yfxP
	 e/rza/iK/tKSKMG+MPOQTPHv56USSfQH7vv89tkgGOQ9H3ZKYcES527993YVKBI7SL
	 23eqZXsMCmRZFWlb+ksxPjXLZV4w/cmJt83CTPxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/396] wifi: brcmfmac: Demote vendor-specific attach/detach messages to info
Date: Mon,  1 Apr 2024 17:43:57 +0200
Message-ID: <20240401152553.544193791@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 85da8f71aaa7b83ea7ef0e89182e0cd47e16d465 ]

People are getting spooked by brcmfmac errors on their boot console.
There's no reason for these messages to be errors.

Cc: stable@vger.kernel.org # 6.2.x
Fixes: d6a5c562214f ("wifi: brcmfmac: add support for vendor-specific firmware api")
Signed-off-by: Hector Martin <marcan@marcan.st>
[arend.vanspriel@broadcom.com: remove attach/detach vendor callbacks]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240106103835.269149-2-arend.vanspriel@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/bca/core.c    | 13 ----------
 .../broadcom/brcm80211/brcmfmac/cyw/core.c    | 13 ----------
 .../broadcom/brcm80211/brcmfmac/fwvid.c       |  7 +++--
 .../broadcom/brcm80211/brcmfmac/fwvid.h       | 26 ++-----------------
 .../broadcom/brcm80211/brcmfmac/wcc/core.c    | 15 +----------
 5 files changed, 6 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
index a5d9ac5e67638..a963c242975ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
@@ -11,17 +11,6 @@
 
 #include "vops.h"
 
-static int brcmf_bca_attach(struct brcmf_pub *drvr)
-{
-	pr_err("%s: executing\n", __func__);
-	return 0;
-}
-
-static void brcmf_bca_detach(struct brcmf_pub *drvr)
-{
-	pr_err("%s: executing\n", __func__);
-}
-
 static void brcmf_bca_feat_attach(struct brcmf_if *ifp)
 {
 	/* SAE support not confirmed so disabling for now */
@@ -29,7 +18,5 @@ static void brcmf_bca_feat_attach(struct brcmf_if *ifp)
 }
 
 const struct brcmf_fwvid_ops brcmf_bca_ops = {
-	.attach = brcmf_bca_attach,
-	.detach = brcmf_bca_detach,
 	.feat_attach = brcmf_bca_feat_attach,
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 24670497f1a40..bec5748310b9c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -11,17 +11,6 @@
 
 #include "vops.h"
 
-static int brcmf_cyw_attach(struct brcmf_pub *drvr)
-{
-	pr_err("%s: executing\n", __func__);
-	return 0;
-}
-
-static void brcmf_cyw_detach(struct brcmf_pub *drvr)
-{
-	pr_err("%s: executing\n", __func__);
-}
-
 static int brcmf_cyw_set_sae_pwd(struct brcmf_if *ifp,
 				 struct cfg80211_crypto_settings *crypto)
 {
@@ -49,7 +38,5 @@ static int brcmf_cyw_set_sae_pwd(struct brcmf_if *ifp,
 }
 
 const struct brcmf_fwvid_ops brcmf_cyw_ops = {
-	.attach = brcmf_cyw_attach,
-	.detach = brcmf_cyw_detach,
 	.set_sae_password = brcmf_cyw_set_sae_pwd,
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
index f610818c2b059..b427782554b59 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
@@ -89,8 +89,7 @@ int brcmf_fwvid_register_vendor(enum brcmf_fwvendor fwvid, struct module *vmod,
 	if (fwvid >= BRCMF_FWVENDOR_NUM)
 		return -ERANGE;
 
-	if (WARN_ON(!vmod) || WARN_ON(!vops) ||
-	    WARN_ON(!vops->attach) || WARN_ON(!vops->detach))
+	if (WARN_ON(!vmod) || WARN_ON(!vops))
 		return -EINVAL;
 
 	if (WARN_ON(fwvid_list[fwvid].vmod))
@@ -150,7 +149,7 @@ static inline int brcmf_fwvid_request_module(enum brcmf_fwvendor fwvid)
 }
 #endif
 
-int brcmf_fwvid_attach_ops(struct brcmf_pub *drvr)
+int brcmf_fwvid_attach(struct brcmf_pub *drvr)
 {
 	enum brcmf_fwvendor fwvid = drvr->bus_if->fwvid;
 	int ret;
@@ -175,7 +174,7 @@ int brcmf_fwvid_attach_ops(struct brcmf_pub *drvr)
 	return ret;
 }
 
-void brcmf_fwvid_detach_ops(struct brcmf_pub *drvr)
+void brcmf_fwvid_detach(struct brcmf_pub *drvr)
 {
 	enum brcmf_fwvendor fwvid = drvr->bus_if->fwvid;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
index d9fc76b46db96..dac22534d0334 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
@@ -12,8 +12,6 @@ struct brcmf_pub;
 struct brcmf_if;
 
 struct brcmf_fwvid_ops {
-	int (*attach)(struct brcmf_pub *drvr);
-	void (*detach)(struct brcmf_pub *drvr);
 	void (*feat_attach)(struct brcmf_if *ifp);
 	int (*set_sae_password)(struct brcmf_if *ifp, struct cfg80211_crypto_settings *crypto);
 };
@@ -24,30 +22,10 @@ int brcmf_fwvid_register_vendor(enum brcmf_fwvendor fwvid, struct module *mod,
 int brcmf_fwvid_unregister_vendor(enum brcmf_fwvendor fwvid, struct module *mod);
 
 /* core driver functions */
-int brcmf_fwvid_attach_ops(struct brcmf_pub *drvr);
-void brcmf_fwvid_detach_ops(struct brcmf_pub *drvr);
+int brcmf_fwvid_attach(struct brcmf_pub *drvr);
+void brcmf_fwvid_detach(struct brcmf_pub *drvr);
 const char *brcmf_fwvid_vendor_name(struct brcmf_pub *drvr);
 
-static inline int brcmf_fwvid_attach(struct brcmf_pub *drvr)
-{
-	int ret;
-
-	ret = brcmf_fwvid_attach_ops(drvr);
-	if (ret)
-		return ret;
-
-	return drvr->vops->attach(drvr);
-}
-
-static inline void brcmf_fwvid_detach(struct brcmf_pub *drvr)
-{
-	if (!drvr->vops)
-		return;
-
-	drvr->vops->detach(drvr);
-	brcmf_fwvid_detach_ops(drvr);
-}
-
 static inline void brcmf_fwvid_feat_attach(struct brcmf_if *ifp)
 {
 	const struct brcmf_fwvid_ops *vops = ifp->drvr->vops;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
index 2d8f80bd73829..fd593b93ad404 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
@@ -7,21 +7,10 @@
 #include <core.h>
 #include <bus.h>
 #include <fwvid.h>
-#include <fwil.h>
+#include <cfg80211.h>
 
 #include "vops.h"
 
-static int brcmf_wcc_attach(struct brcmf_pub *drvr)
-{
-	pr_debug("%s: executing\n", __func__);
-	return 0;
-}
-
-static void brcmf_wcc_detach(struct brcmf_pub *drvr)
-{
-	pr_debug("%s: executing\n", __func__);
-}
-
 static int brcmf_wcc_set_sae_pwd(struct brcmf_if *ifp,
 				 struct cfg80211_crypto_settings *crypto)
 {
@@ -30,7 +19,5 @@ static int brcmf_wcc_set_sae_pwd(struct brcmf_if *ifp,
 }
 
 const struct brcmf_fwvid_ops brcmf_wcc_ops = {
-	.attach = brcmf_wcc_attach,
-	.detach = brcmf_wcc_detach,
 	.set_sae_password = brcmf_wcc_set_sae_pwd,
 };
-- 
2.43.0



