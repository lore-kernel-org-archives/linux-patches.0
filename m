Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E5731A802;
	Wed, 17 Sep 2025 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112749; cv=none; b=gMJode5exuRJVHF68ihBZcF9mBe96C324j16y33t8EJkYbY5jMucbo53ynOmsmgs1sz5swc/MNdtGj6H57S6vTnbmHU26vBr3Ek7KSgb8Kofu+dRFD38PT5o9vv94qzsKfj3V+ZxYGa+XJllOwcggvdpBsiVUZrW79e0+vCG3lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112749; c=relaxed/simple;
	bh=kXz8hQj7Y4Yry2zbyIUHnm3EIMT9yB8+wPwuazpVX3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pouZudwAIM2TTVG1N9VNREfdUdg+Bq+DVFG57z/j/wP93sqACqE51YWxmkOICzvHfSk5v3NVEkCayDxXGJK/XeL029/MCJiicRF8weMkUI6kSC9QvTBxZjf164nyQVoefEN462Q+Kh8v+nnO4tvkDGPc3Wpl0zkvtiyYJwhyhkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDxguXQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDxguXQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE935C4CEF0;
	Wed, 17 Sep 2025 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112749;
	bh=kXz8hQj7Y4Yry2zbyIUHnm3EIMT9yB8+wPwuazpVX3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDxguXQQDTC8gtguM4tJcaiyPi02U9GXJuHUZfxZyQ3j78wbyb2n8N1jcw7Z91V3W
	 7OwSyjqBl41hW5JshkWRvPgNpAjfzPU5k5MmfTqJIB8MdVMbnAyGhZt8+U/fAoD/4P
	 9LeYlkIvrNwHqyKb3Bs3jlwJ/B2HcUtuBxkUoW8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.16 066/189] wifi: iwlwifi: fix 130/1030 configs
Date: Wed, 17 Sep 2025 14:32:56 +0200
Message-ID: <20250917123353.486164641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2682e7a317504a9d81cbb397249d4299e84dfadd upstream.

The 130/1030 devices are really derivatives of 6030,
with some small differences not pertaining to the MAC,
so they must use the 6030 MAC config.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220472
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220517
Fixes: 35ac275ebe0c ("wifi: iwlwifi: cfg: finish config split")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250909121728.8e4911f12528.I3aa7194012a4b584fbd5ddaa3a77e483280f1de4@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f9e2095d6490..7e56e4ff7642 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -124,13 +124,13 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_mac_cfg)},/* low 5GHz active */
 	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_mac_cfg)},/* high 5GHz active */
 
-/* 6x30 Series */
-	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl1000_mac_cfg)},
+/* 1030/6x30 Series */
+	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl6030_mac_cfg)},
 	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6030_mac_cfg)},
 	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6030_mac_cfg)},
 	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6030_mac_cfg)},
@@ -181,12 +181,12 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x08AE, 0x1027, iwl1000_mac_cfg)},
 
 /* 130 Series WiFi */
-	{IWL_PCI_DEVICE(0x0896, 0x5005, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x0896, 0x5007, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x0897, 0x5015, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x0897, 0x5017, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x0896, 0x5025, iwl1000_mac_cfg)},
-	{IWL_PCI_DEVICE(0x0896, 0x5027, iwl1000_mac_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5005, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5007, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x0897, 0x5015, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x0897, 0x5017, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5025, iwl6030_mac_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5027, iwl6030_mac_cfg)},
 
 /* 2x00 Series */
 	{IWL_PCI_DEVICE(0x0890, 0x4022, iwl2000_mac_cfg)},
-- 
2.51.0



