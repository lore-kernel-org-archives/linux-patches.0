Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBF315ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F14C433C7;
	Tue, 25 Jul 2023 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282926;
	bh=ynJJD6FwcqujZG6UvscyvqaK3WvHYqLLXmmXQiroT0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwQ765VFbW80yS3HTs2aZJhNBV91otV59A9YXlRgf4PnW3pSCWryaikaU1f7dTVDF
	 d7E/nb7sbdvMgtYYdGDDXQ3WeU4u8Urh1B5GYTxhuU4HPtZ5sXn4/7VQ/sTIaJ9kNk
	 897MYexxuM1e+srbreMvW7B4Li+1kP2ocgVAE/X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/183] wifi: iwlwifi: Add support for new PCI Id
Date: Tue, 25 Jul 2023 12:45:05 +0200
Message-ID: <20230725104510.735252599@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 35bd6f1d043d089fcb60450e1287cc65f0095787 ]

Add support for the PCI Id 51F1 without IMR support.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230620125813.9800e652e789.Ic06a085832ac3f988c8ef07d856c8e281563295d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f6872b2a0d9d0..d5bd869086458 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -495,6 +495,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x7AF0, PCI_ANY_ID, iwl_so_trans_cfg)},
 	{IWL_PCI_DEVICE(0x51F0, PCI_ANY_ID, iwl_so_long_latency_trans_cfg)},
 	{IWL_PCI_DEVICE(0x51F1, PCI_ANY_ID, iwl_so_long_latency_imr_trans_cfg)},
+	{IWL_PCI_DEVICE(0x51F1, PCI_ANY_ID, iwl_so_long_latency_trans_cfg)},
 	{IWL_PCI_DEVICE(0x54F0, PCI_ANY_ID, iwl_so_long_latency_trans_cfg)},
 	{IWL_PCI_DEVICE(0x7F70, PCI_ANY_ID, iwl_so_trans_cfg)},
 
@@ -543,6 +544,7 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x51F0, 0x1551, iwl9560_2ac_cfg_soc, iwl9560_killer_1550i_160_name),
 	IWL_DEV_INFO(0x51F0, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
 	IWL_DEV_INFO(0x51F0, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
+	IWL_DEV_INFO(0x51F1, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 	IWL_DEV_INFO(0x54F0, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
 	IWL_DEV_INFO(0x54F0, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 	IWL_DEV_INFO(0x7A70, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
-- 
2.39.2



