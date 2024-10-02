Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4082E1D0DD5;
	Wed,  2 Oct 2024 14:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879186; cv=none; b=OwsaEeAi+yqCgxDBtDSrsQpQdcxDPag2D4LLKEV7WUsRQwBpEz54EerMBb4/jqybt9SZ0eIDpWq+J8noM8NbWb/fMsXzllrAyYVl4zomiOLsX2y08ZppbJ8RPByKcIUz8nzOr4SbB8Ehdsnn5J7KiaXubXsrl7UO16ZidvjUtQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879186; c=relaxed/simple;
	bh=FsNkc1vQQ54KrGSq2BhjEy8NEoAMLAybQgi/6Q1fRhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo2VTjp1w05Ha5XJtmA1IdjMV+ekBZTmhGMxnjGk9n/rTSxpxZJF/rVGA9b3YsZQMx9kejfW+1Vg7E5njEti9rzLTG8shwucQrttp+W9a/RI4L0if36/MaFTF7bl9ED24Z6dfeh4+t+/1Ta/rm4mGIOXNr85jXmaW61R3zzoqrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNJ1VS66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNJ1VS66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EE5C4CEC2;
	Wed,  2 Oct 2024 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879186;
	bh=FsNkc1vQQ54KrGSq2BhjEy8NEoAMLAybQgi/6Q1fRhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNJ1VS66YJ/PDvka/TW6rElTuSN2SOm4rUZd28hoF50Xkul5/oHL2gdRLkXRYHMp8
	 vIEFwyDy8FpnjgG1bgmEYop7l9GUJtKg0+IXIqS6xzNxXT4bM+WJF+GVtb2Ql7a4pU
	 gFJaIYNO6M+jexVsMUHhpRm3mceKO5nxg6oNFLe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/538] wifi: iwlwifi: config: label gl devices as discrete
Date: Wed,  2 Oct 2024 14:54:24 +0200
Message-ID: <20241002125753.010784903@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8131dd52810dfcdb49fcdc78f5e18e1538b6c441 ]

The 'gl' devices are in the bz family, but they're not,
integrated, so should have their own trans config struct.
Fix that, also necessitating the removal of LTR config,
and while at it remove 0x2727 and 0x272D IDs that were
only used for test chips.

Fixes: c30a2a64788b ("wifi: iwlwifi: add a new PCI device ID for BZ device")ticket=none
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.95aed0620080.Ib9129512c95aa57acc9876bdff8b99dd41e1562c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c     | 11 +++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  4 +---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index cc71b513adf98..cebd3c91756fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -152,6 +152,17 @@ const struct iwl_cfg_trans_params iwl_bz_trans_cfg = {
 	.ltr_delay = IWL_CFG_TRANS_LTR_DELAY_2500US,
 };
 
+const struct iwl_cfg_trans_params iwl_gl_trans_cfg = {
+	.device_family = IWL_DEVICE_FAMILY_BZ,
+	.base_params = &iwl_bz_base_params,
+	.mq_rx_supported = true,
+	.rf_id = true,
+	.gen2 = true,
+	.umac_prph_offset = 0x300000,
+	.xtal_latency = 12000,
+	.low_latency_xtal = true,
+};
+
 const char iwl_bz_name[] = "Intel(R) TBD Bz device";
 
 const struct iwl_cfg iwl_cfg_bz = {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f45f645ca6485..dd3913617bb0b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -493,6 +493,7 @@ extern const struct iwl_cfg_trans_params iwl_so_long_latency_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_so_long_latency_imr_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_ma_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_bz_trans_cfg;
+extern const struct iwl_cfg_trans_params iwl_gl_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_sc_trans_cfg;
 extern const char iwl9162_name[];
 extern const char iwl9260_name[];
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 365e19314f2ca..4a2de79f2e864 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -501,9 +501,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x7E40, PCI_ANY_ID, iwl_ma_trans_cfg)},
 
 /* Bz devices */
-	{IWL_PCI_DEVICE(0x2727, PCI_ANY_ID, iwl_bz_trans_cfg)},
-	{IWL_PCI_DEVICE(0x272D, PCI_ANY_ID, iwl_bz_trans_cfg)},
-	{IWL_PCI_DEVICE(0x272b, PCI_ANY_ID, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0x272b, PCI_ANY_ID, iwl_gl_trans_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x0000, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x0090, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x0094, iwl_bz_trans_cfg)},
-- 
2.43.0



