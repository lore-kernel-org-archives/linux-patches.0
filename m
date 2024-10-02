Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC61D042F;
	Wed,  2 Oct 2024 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877312; cv=none; b=EZF0jmh4FQzZxKPP/GHs4PyqyiSmBkUlfJgTtosufXavMl28yvMdX17RXWXnUoY7dnxbjpWpmYow2B1mwAGDx8OGg8Xq2bp2zt6aWE6syyi2tKSAAwKVO7E/2j09/T43en19HqJ+sXXz+s6EI624V/vn8eDHnp7eqzUhtkcY9EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877312; c=relaxed/simple;
	bh=ifFzMqI/CSaYiukjJsCfupd/Zy1nrV3kfEtvI+rhYL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrSqB3DP2FzM47BkutthdjVSNY17OtjWOqGEwuCkvuR4OeLFphoGf/b9oX7Du/VPzRVwtKLO8Wo4cKejpmqHpsHNKgZpVSIE4uyIoJbXvVQQIF/oKTqShh11vW1P6EwP+uJpTpcrbMSLAyN6XJNu7AVOP1MYMGBTMSXv9aVVPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjDNRt8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjDNRt8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F074C4AF54;
	Wed,  2 Oct 2024 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877311;
	bh=ifFzMqI/CSaYiukjJsCfupd/Zy1nrV3kfEtvI+rhYL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjDNRt8aoShIhFJXaeXxN/H1BOMEJwJDS8EP/eYfVErxXAeVECD94kXZKuVNxJAL7
	 mMlYmWyYGSeTHDGVQUSuE9QTeIoLJ8+2IXc2BOqB/2iFiAmIH1lhLrT6US8BC6LpTx
	 2e/WgAA/i9Lbr1shZREsyCAP+BfJy5qzquROBxmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 039/634] wifi: iwlwifi: config: label gl devices as discrete
Date: Wed,  2 Oct 2024 14:52:19 +0200
Message-ID: <20241002125812.641691020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc98b87cf2a13..02a95bf72740b 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -148,6 +148,17 @@ const struct iwl_cfg_trans_params iwl_bz_trans_cfg = {
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
 const char iwl_fm_name[] = "Intel(R) Wi-Fi 7 BE201 320MHz";
 const char iwl_gl_name[] = "Intel(R) Wi-Fi 7 BE200 320MHz";
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 732889f96ca27..29a28b5c28114 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -503,6 +503,7 @@ extern const struct iwl_cfg_trans_params iwl_so_long_latency_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_so_long_latency_imr_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_ma_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_bz_trans_cfg;
+extern const struct iwl_cfg_trans_params iwl_gl_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_sc_trans_cfg;
 extern const char iwl9162_name[];
 extern const char iwl9260_name[];
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 9863292fddde7..d93eec242204f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -500,9 +500,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
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



