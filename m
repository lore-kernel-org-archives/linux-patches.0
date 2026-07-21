Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448012DBF75;
	Tue, 21 Jul 2026 18:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657222; cv=none; b=FBudN6WDIn+na/w0xM2w+Tu1RfF5JiXb7bV3kQaFYPjwOXQvIP+E0/oLAyY/cQ96OvGauJ+GU6K0QWzUPU6kJoFWUlIprPHYdChFj4mpmjJCNvQ22wVajWXslnkJPhOMKOpaKLxQFnjRQBKaBwWbEZ8LmQcEpBlApgw0r7cgoZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657222; c=relaxed/simple;
	bh=Fvp/ZTAMJIkzrpW6FPHyINddR9m4U0RvzM8XqX7uqvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ksnt0r7AvwMhNoVjEqldSufEm+1mG5HZ/LJ12ME3WwIj63MyuZd0lfzpSLGRGY1hXiTWYbWaWQyt5j4gD+k1xDNQmb29hGAH3hn9iekskU39XNZ+TRNbu9us5iixmrRxjwieW1VzLvvg8xQdHO7EMh1nCC1OPwyHi1q30ylFF8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaZ8Qrpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaZ8Qrpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5391F000E9;
	Tue, 21 Jul 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657221;
	bh=U6HlpeU+7EQVDyEl+NhHAt5GOrkVGOYpJackRlBMlmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaZ8QrpwuIi6Zar6KUsOjib0CJaMenB/eV28RxA4FCWk5VVDneUWcVIVAHm/+CJO3
	 Ot6IfWI9qBpXlyVcUm77B3s3vfifeBcdGt1iiQw3DUXiz/c1oh/wPyt/lXdfFFNWYV
	 uzPZJi0OvaNYlYMI77y+xUXXFYTOCXnPNumMrtW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Pardee <xi.pardee@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0682/1611] platform/x86:intel/pmc: Relocate lpm_req_guid to pmc_reg_map
Date: Tue, 21 Jul 2026 17:13:18 +0200
Message-ID: <20260721152530.720534067@linuxfoundation.org>
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

[ Upstream commit c2bc11f1f204ef916ec96e45cf329e42873b37d6 ]

Relocate the lpm_req_guid field from pmc_info to pmc_reg_map. The
previous implementation stored lpm_req_guid in pmc_info and relied
on pmc_core_find_guid() to retrieve the correct GUID, which was
unnecessary. Since lpm_req_guid is specific to PMC, pmc_reg_map is
a more appropriate location for this information.

Signed-off-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/20251014214548.629023-6-xi.pardee@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 375bbbbd112a ("platform/x86/intel/vsec: Restore BAR fallback for header walk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/arl.c  |  6 ++----
 drivers/platform/x86/intel/pmc/core.c | 15 ++-------------
 drivers/platform/x86/intel/pmc/core.h |  4 +++-
 drivers/platform/x86/intel/pmc/lnl.c  |  2 +-
 drivers/platform/x86/intel/pmc/mtl.c  |  6 +++---
 drivers/platform/x86/intel/pmc/ptl.c  |  3 +--
 6 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/arl.c b/drivers/platform/x86/intel/pmc/arl.c
index cc05a168c37213..7a802b799e0ae6 100644
--- a/drivers/platform/x86/intel/pmc/arl.c
+++ b/drivers/platform/x86/intel/pmc/arl.c
@@ -281,6 +281,7 @@ static const struct pmc_reg_map arl_socs_reg_map = {
 	.etr3_offset = ETR3_OFFSET,
 	.pson_residency_offset = TGL_PSON_RESIDENCY_OFFSET,
 	.pson_residency_counter_step = TGL_PSON_RES_COUNTER_STEP,
+	.lpm_req_guid = SOCS_LPM_REQ_GUID,
 };
 
 static const struct pmc_bit_map arl_pchs_ltr_show_map[] = {
@@ -648,26 +649,23 @@ static const struct pmc_reg_map arl_pchs_reg_map = {
 	.lpm_num_maps = ADL_LPM_NUM_MAPS,
 	.lpm_reg_index = ARL_LPM_REG_INDEX,
 	.etr3_offset = ETR3_OFFSET,
+	.lpm_req_guid = PCHS_LPM_REQ_GUID,
 };
 
 static struct pmc_info arl_pmc_info_list[] = {
 	{
-		.guid	= IOEP_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_ARL_IOEP,
 		.map	= &mtl_ioep_reg_map,
 	},
 	{
-		.guid	= SOCS_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_ARL_SOCS,
 		.map	= &arl_socs_reg_map,
 	},
 	{
-		.guid	= PCHS_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_ARL_PCHS,
 		.map	= &arl_pchs_reg_map,
 	},
 	{
-		.guid	= SOCM_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_ARL_SOCM,
 		.map	= &mtl_socm_reg_map,
 	},
diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 5f58dfa989ad5c..e272c971d73a53 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1444,15 +1444,6 @@ static void pmc_core_dbgfs_register(struct pmc_dev *pmcdev, struct pmc_dev_info
 	}
 }
 
-static u32 pmc_core_find_guid(struct pmc_info *list, const struct pmc_reg_map *map)
-{
-	for (; list->map; ++list)
-		if (list->map == map)
-			return list->guid;
-
-	return 0;
-}
-
 /*
  * This function retrieves low power mode requirement data from PMC Low
  * Power Mode (LPM) table.
@@ -1568,7 +1559,6 @@ static int pmc_core_get_telem_info(struct pmc_dev *pmcdev, struct pmc_dev_info *
 	struct pci_dev *pcidev __free(pci_dev_put) = NULL;
 	struct telem_endpoint *ep;
 	unsigned int pmc_idx;
-	u32 guid;
 	int ret;
 
 	pcidev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(20, pmc_dev_info->pci_func));
@@ -1582,11 +1572,10 @@ static int pmc_core_get_telem_info(struct pmc_dev *pmcdev, struct pmc_dev_info *
 		if (!pmc)
 			continue;
 
-		guid = pmc_core_find_guid(pmcdev->regmap_list, pmc->map);
-		if (!guid)
+		if (!pmc->map->lpm_req_guid)
 			return -ENXIO;
 
-		ep = pmt_telem_find_and_register_endpoint(pcidev, guid, 0);
+		ep = pmt_telem_find_and_register_endpoint(pcidev, pmc->map->lpm_req_guid, 0);
 		if (IS_ERR(ep)) {
 			dev_dbg(&pmcdev->pdev->dev, "couldn't get telem endpoint %pe", ep);
 			return -EPROBE_DEFER;
diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index 83d6e2e833785f..7d2ad88324b840 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -355,6 +355,7 @@ struct pmc_bit_map {
  * @s0ix_blocker_offset PWRMBASE offset to S0ix blocker counter
  * @num_s0ix_blocker:	Number of S0ix blockers
  * @blocker_req_offset:	Telemetry offset to S0ix blocker low power mode substate requirement table
+ * @lpm_req_guid:	Telemetry GUID to read low power mode substate requirement table
  *
  * Each PCH has unique set of register offsets and bit indexes. This structure
  * captures them to have a common implementation.
@@ -396,6 +397,8 @@ struct pmc_reg_map {
 	const u8  *lpm_reg_index;
 	const u32 pson_residency_offset;
 	const u32 pson_residency_counter_step;
+	/* GUID for telemetry regions */
+	const u32 lpm_req_guid;
 };
 
 /**
@@ -405,7 +408,6 @@ struct pmc_reg_map {
  *			specific attributes
  */
 struct pmc_info {
-	u32 guid;
 	u16 devid;
 	const struct pmc_reg_map *map;
 };
diff --git a/drivers/platform/x86/intel/pmc/lnl.c b/drivers/platform/x86/intel/pmc/lnl.c
index 6fa027e7071f4b..1cd81ee54dcf8e 100644
--- a/drivers/platform/x86/intel/pmc/lnl.c
+++ b/drivers/platform/x86/intel/pmc/lnl.c
@@ -533,11 +533,11 @@ static const struct pmc_reg_map lnl_socm_reg_map = {
 	.s0ix_blocker_maps = lnl_blk_maps,
 	.s0ix_blocker_offset = LNL_S0IX_BLOCKER_OFFSET,
 	.lpm_reg_index = LNL_LPM_REG_INDEX,
+	.lpm_req_guid = SOCM_LPM_REQ_GUID,
 };
 
 static struct pmc_info lnl_pmc_info_list[] = {
 	{
-		.guid	= SOCM_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_LNL_SOCM,
 		.map	= &lnl_socm_reg_map,
 	},
diff --git a/drivers/platform/x86/intel/pmc/mtl.c b/drivers/platform/x86/intel/pmc/mtl.c
index 19470ca311cf72..57508cbf9cd429 100644
--- a/drivers/platform/x86/intel/pmc/mtl.c
+++ b/drivers/platform/x86/intel/pmc/mtl.c
@@ -473,6 +473,7 @@ const struct pmc_reg_map mtl_socm_reg_map = {
 	.lpm_status_offset = MTL_LPM_STATUS_OFFSET,
 	.lpm_live_status_offset = MTL_LPM_LIVE_STATUS_OFFSET,
 	.lpm_reg_index = MTL_LPM_REG_INDEX,
+	.lpm_req_guid = SOCP_LPM_REQ_GUID,
 };
 
 static const struct pmc_bit_map mtl_ioep_pfear_map[] = {
@@ -797,6 +798,7 @@ const struct pmc_reg_map mtl_ioep_reg_map = {
 	.lpm_en_offset = MTL_LPM_EN_OFFSET,
 	.lpm_sts_latch_en_offset = MTL_LPM_STATUS_LATCH_EN_OFFSET,
 	.lpm_reg_index = MTL_LPM_REG_INDEX,
+	.lpm_req_guid = IOEP_LPM_REQ_GUID,
 };
 
 static const struct pmc_bit_map mtl_ioem_pfear_map[] = {
@@ -944,21 +946,19 @@ static const struct pmc_reg_map mtl_ioem_reg_map = {
 	.lpm_res_counter_step_x2 = TGL_PMC_LPM_RES_COUNTER_STEP_X2,
 	.lpm_residency_offset = MTL_LPM_RESIDENCY_OFFSET,
 	.lpm_reg_index = MTL_LPM_REG_INDEX,
+	.lpm_req_guid = IOEM_LPM_REQ_GUID,
 };
 
 static struct pmc_info mtl_pmc_info_list[] = {
 	{
-		.guid	= SOCP_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_MTL_SOCM,
 		.map	= &mtl_socm_reg_map,
 	},
 	{
-		.guid	= IOEP_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_MTL_IOEP,
 		.map	= &mtl_ioep_reg_map,
 	},
 	{
-		.guid	= IOEM_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_MTL_IOEM,
 		.map	= &mtl_ioem_reg_map
 	},
diff --git a/drivers/platform/x86/intel/pmc/ptl.c b/drivers/platform/x86/intel/pmc/ptl.c
index 1b35b84e06fa2f..1f48e2bbc699f5 100644
--- a/drivers/platform/x86/intel/pmc/ptl.c
+++ b/drivers/platform/x86/intel/pmc/ptl.c
@@ -528,16 +528,15 @@ static const struct pmc_reg_map ptl_pcdp_reg_map = {
 	.s0ix_blocker_offset = LNL_S0IX_BLOCKER_OFFSET,
 	.num_s0ix_blocker = PTL_NUM_S0IX_BLOCKER,
 	.blocker_req_offset = PTL_BLK_REQ_OFFSET,
+	.lpm_req_guid = PCDP_LPM_REQ_GUID,
 };
 
 static struct pmc_info ptl_pmc_info_list[] = {
 	{
-		.guid	= PCDP_LPM_REQ_GUID,
 		.devid	= PMC_DEVID_PTL_PCDH,
 		.map	= &ptl_pcdp_reg_map,
 	},
 	{
-		.guid   = PCDP_LPM_REQ_GUID,
 		.devid  = PMC_DEVID_PTL_PCDP,
 		.map    = &ptl_pcdp_reg_map,
 	},
-- 
2.53.0



