Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9731D041D;
	Wed,  2 Oct 2024 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875280; cv=none; b=Ff/uUQgYUKZl7D9L4wNsbRzn7rPGd6pOCRZGOC+Z1O8iktnThXvDqSsWOfBEcn27Ewm+rMRFwmKNtmSuXuzSznYW85sxifrjm7lNM8dhH8ABWqSodLDMK7+TvcRJjP6bXTuTsoBfSFv73f5DYS6WL+BoG0Qe9Yug2PvbTqC/dpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875280; c=relaxed/simple;
	bh=FJmbTlTjbJESrJ8dWtbQrSQYKZwOB2ASglmYBdFU2U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORsxYmCu2bOnihnZsTy0epp6QUJClIl+afWZQgkKEleshciZGgwl4uWr1z/S9h5RIHEs/Dm1KQzLXUURJXhTSAlWpFkbHajFl2m33mm4GYKdM0CYxiPBQHZQSNWQMPW8R+quLJFByMBxDOwZgyNAUUFUjGUJHuq+g63Q0IVDzIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NevQHmzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NevQHmzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13503C4CECF;
	Wed,  2 Oct 2024 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875280;
	bh=FJmbTlTjbJESrJ8dWtbQrSQYKZwOB2ASglmYBdFU2U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NevQHmztPO7hWNkZbrOzrG++7L6N7s5ZAPYx+J6mqqZbK1ujmwXW7H8m26yk11q9u
	 +2JvF2//XdnP/toTospnV2av3ertgtz2KtZEPO2JGsGyb4n2IDEHV/bV8pscQ/dglz
	 TkEbH7Ic9lElmEcwRIYKGVOi09bWz+i1qQvaNJJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 047/695] wifi: iwlwifi: config: label gl devices as discrete
Date: Wed,  2 Oct 2024 14:50:45 +0200
Message-ID: <20241002125824.367230576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3b6b8b410be58..b230441abc16a 100644
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
index b2abd4fd19444..34c91deca57b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -504,6 +504,7 @@ extern const struct iwl_cfg_trans_params iwl_so_long_latency_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_so_long_latency_imr_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_ma_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_bz_trans_cfg;
+extern const struct iwl_cfg_trans_params iwl_gl_trans_cfg;
 extern const struct iwl_cfg_trans_params iwl_sc_trans_cfg;
 extern const char iwl9162_name[];
 extern const char iwl9260_name[];
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 84fd93278450b..805fb249a0c6a 100644
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



