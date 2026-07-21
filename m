Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD1F47126E;
	Tue, 21 Jul 2026 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657217; cv=none; b=Yh1lKheEzcS7nnmQEOU2MpzwrMxP4cCzdwzLZ+KJbptq4suLVGhvppxkXP7lTCY1/787+mkRyzgAdm62zs4wJ5tdgJ5RicsytI2mQj4dcqgfvHDTsTCphkuiITh5kq9w7KVJwrRELThfS+/bzb7ZeqLzvfoVw9lAk3zsWILyCYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657217; c=relaxed/simple;
	bh=HU9lQkfxQHzZEN0UB0KTWbH3u07Q7QmJCtOR2aRUCTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shS+wiexbzvjfKcMQKm4sjVydCoCC1feCohnvJbUCagXo6G/krDVDPHQylNQ9OdaURQm0qfg/fy+hs15ytf6a7Olapu2svtaJCcioHg8kVFz0TbQXQQ9ukMf0Pkqj2wJLeJ/Giy+lArUtKcExgRnJiDZ2mLzxXTCXnlSWxTKuIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kp7qEdMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kp7qEdMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A5A1F00A3A;
	Tue, 21 Jul 2026 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657215;
	bh=fZMmtjXDTef63DitLJCOkav52Ko8Gkbwi+DsQ+FH1uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp7qEdMG33KAwvpl1/hYlKqLs0rXxSePQdW2COdMNONtafCPL4bouozWnmzegn9YS
	 HvoUfd0qkW6kGeVhYKLHgKD6kM2xrFRshHIVxa8mgyMi5GQvPJ7LY6gjpp29h5hRaC
	 xUyP2YgukZgdHCZySML5DXVIG5Xel6PpciQnbzuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Pardee <xi.pardee@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0680/1611] platform/x86:intel/pmc: Add support for multiple DMU GUIDs
Date: Tue, 21 Jul 2026 17:13:16 +0200
Message-ID: <20260721152530.677157613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Pardee <xi.pardee@linux.intel.com>

[ Upstream commit 3b603955f2423cf668ebd5ba670019a5b4960cc5 ]

Enable support for multiple DMU GUIDs to accommodate Arrow
Lake H/U platforms. Arrow Lake U/H may have several GUIDs
pointing to a single telemetry region providing die C6 value
Add support to search for available GUIDs.

Signed-off-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/20251014214548.629023-3-xi.pardee@linux.intel.com
[ij: add include & reverse logic in a loop]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 375bbbbd112a ("platform/x86/intel/vsec: Restore BAR fallback for header walk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/arl.c  |  6 ++++--
 drivers/platform/x86/intel/pmc/core.c | 22 ++++++++++++++++++----
 drivers/platform/x86/intel/pmc/core.h |  6 +++---
 drivers/platform/x86/intel/pmc/mtl.c  |  3 ++-
 4 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/arl.c b/drivers/platform/x86/intel/pmc/arl.c
index 17ad87b392abef..cc05a168c37213 100644
--- a/drivers/platform/x86/intel/pmc/arl.c
+++ b/drivers/platform/x86/intel/pmc/arl.c
@@ -720,9 +720,10 @@ static int arl_h_core_init(struct pmc_dev *pmcdev, struct pmc_dev_info *pmc_dev_
 	return generic_core_init(pmcdev, pmc_dev_info);
 }
 
+static u32 ARL_PMT_DMU_GUIDS[] = {ARL_PMT_DMU_GUID, 0x0};
 struct pmc_dev_info arl_pmc_dev = {
 	.pci_func = 0,
-	.dmu_guid = ARL_PMT_DMU_GUID,
+	.dmu_guids = ARL_PMT_DMU_GUIDS,
 	.regmap_list = arl_pmc_info_list,
 	.map = &arl_socs_reg_map,
 	.sub_req_show = &pmc_core_substate_req_regs_fops,
@@ -732,9 +733,10 @@ struct pmc_dev_info arl_pmc_dev = {
 	.sub_req = pmc_core_pmt_get_lpm_req,
 };
 
+static u32 ARL_H_PMT_DMU_GUIDS[] = {ARL_PMT_DMU_GUID, 0x0};
 struct pmc_dev_info arl_h_pmc_dev = {
 	.pci_func = 2,
-	.dmu_guid = ARL_PMT_DMU_GUID,
+	.dmu_guids = ARL_H_PMT_DMU_GUIDS,
 	.regmap_list = arl_pmc_info_list,
 	.map = &mtl_socm_reg_map,
 	.sub_req_show = &pmc_core_substate_req_regs_fops,
diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index ac3d19ae8c56d5..ca126a253f9d0d 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -20,6 +20,7 @@ enum header_type {
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -1281,7 +1282,20 @@ int get_primary_reg_base(struct pmc *pmc)
 	return 0;
 }
 
-void pmc_core_punit_pmt_init(struct pmc_dev *pmcdev, u32 guid)
+static struct telem_endpoint *pmc_core_register_endpoint(struct pci_dev *pcidev, u32 *guids)
+{
+	struct telem_endpoint *ep;
+	unsigned int i;
+
+	for (i = 0; guids[i]; i++) {
+		ep = pmt_telem_find_and_register_endpoint(pcidev, guids[i], 0);
+		if (!IS_ERR(ep))
+			return ep;
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+void pmc_core_punit_pmt_init(struct pmc_dev *pmcdev, u32 *guids)
 {
 	struct telem_endpoint *ep;
 	struct pci_dev *pcidev;
@@ -1292,7 +1306,7 @@ void pmc_core_punit_pmt_init(struct pmc_dev *pmcdev, u32 guid)
 		return;
 	}
 
-	ep = pmt_telem_find_and_register_endpoint(pcidev, guid, 0);
+	ep = pmc_core_register_endpoint(pcidev, guids);
 	pci_dev_put(pcidev);
 	if (IS_ERR(ep)) {
 		dev_err(&pmcdev->pdev->dev,
@@ -1689,8 +1703,8 @@ int generic_core_init(struct pmc_dev *pmcdev, struct pmc_dev_info *pmc_dev_info)
 	}
 
 	pmc_core_get_low_power_modes(pmcdev);
-	if (pmc_dev_info->dmu_guid)
-		pmc_core_punit_pmt_init(pmcdev, pmc_dev_info->dmu_guid);
+	if (pmc_dev_info->dmu_guids)
+		pmc_core_punit_pmt_init(pmcdev, pmc_dev_info->dmu_guids);
 
 	if (ssram) {
 		ret = pmc_core_get_telem_info(pmcdev, pmc_dev_info);
diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index d6818bd34768ec..83d6e2e833785f 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -481,7 +481,7 @@ enum pmc_index {
 /**
  * struct pmc_dev_info - Structure to keep PMC device info
  * @pci_func:		Function number of the primary PMC
- * @dmu_guid:		Die Management Unit GUID
+ * @dmu_guids:		List of Die Management Unit GUID
  * @regmap_list:	Pointer to a list of pmc_info structure that could be
  *			available for the platform. When set, this field implies
  *			SSRAM support.
@@ -495,7 +495,7 @@ enum pmc_index {
  */
 struct pmc_dev_info {
 	u8 pci_func;
-	u32 dmu_guid;
+	u32 *dmu_guids;
 	struct pmc_info *regmap_list;
 	const struct pmc_reg_map *map;
 	const struct file_operations *sub_req_show;
@@ -532,7 +532,7 @@ int pmc_core_send_ltr_ignore(struct pmc_dev *pmcdev, u32 value, int ignore);
 int pmc_core_resume_common(struct pmc_dev *pmcdev);
 int get_primary_reg_base(struct pmc *pmc);
 void pmc_core_get_low_power_modes(struct pmc_dev *pmcdev);
-void pmc_core_punit_pmt_init(struct pmc_dev *pmcdev, u32 guid);
+void pmc_core_punit_pmt_init(struct pmc_dev *pmcdev, u32 *guids);
 void pmc_core_set_device_d3(unsigned int device);
 
 int generic_core_init(struct pmc_dev *pmcdev, struct pmc_dev_info *pmc_dev_info);
diff --git a/drivers/platform/x86/intel/pmc/mtl.c b/drivers/platform/x86/intel/pmc/mtl.c
index 0b87e10f864e6f..19470ca311cf72 100644
--- a/drivers/platform/x86/intel/pmc/mtl.c
+++ b/drivers/platform/x86/intel/pmc/mtl.c
@@ -992,9 +992,10 @@ static int mtl_core_init(struct pmc_dev *pmcdev, struct pmc_dev_info *pmc_dev_in
 	return generic_core_init(pmcdev, pmc_dev_info);
 }
 
+static u32 MTL_PMT_DMU_GUIDS[] = {MTL_PMT_DMU_GUID, 0x0};
 struct pmc_dev_info mtl_pmc_dev = {
 	.pci_func = 2,
-	.dmu_guid = MTL_PMT_DMU_GUID,
+	.dmu_guids = MTL_PMT_DMU_GUIDS,
 	.regmap_list = mtl_pmc_info_list,
 	.map = &mtl_socm_reg_map,
 	.sub_req_show = &pmc_core_substate_req_regs_fops,
-- 
2.53.0



