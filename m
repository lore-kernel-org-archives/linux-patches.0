Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E111D0DF5;
	Wed,  2 Oct 2024 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879282; cv=none; b=gadSkdrKTdDBuph0wLmzHFUiitMYrmu0gFK+6yHZfLxEQbMaxVpSw6duglbj4vwHYt5SVS9HExPmM26rF3QOnimqqe6/SIyJ+JSxs2XF7QDPz8viBwDIwW8OYlbQvoKbZSZFrS33f1Ucuoh6le397hnpHtDLmglElPmfFZ55fjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879282; c=relaxed/simple;
	bh=4or7EhgzLpDRsy4Y7jH2ojaGACWywkZheakL3YWNqXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6DEJwafJ0ljgNxG/VyHXQWtaTWCp4Zojkgmy0bj5Y/YXrpzuMSrXizT6KFAUQqW0u8RM79G4V0MBcVHzDx7StOMkQdFxy0C6XqgRrhK/K3fzzT8RF3jIT79/TSsAkn8s6Die9rxmLN62abMg7ywafUgpnCtl2QMZOsN9r/0skw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL0q9ieL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL0q9ieL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34293C4CEC2;
	Wed,  2 Oct 2024 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879282;
	bh=4or7EhgzLpDRsy4Y7jH2ojaGACWywkZheakL3YWNqXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL0q9ieL8hWCsCwjViBwapgICgcUx4C63+AjVVz5NeOB5IFEXf7PgtBZGxF6EQ3Ih
	 pqf42MF9ELy7y3+uJf1BSfj0Hcz7lVO77otdxnsLZeylIdaxv9AdwQ4Ma2jm7HJ/aZ
	 LnTt/ZPQ2BBiDXG/z3d7ab1egGwAnPgLyG0lSqPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golan Ben Ami <golan.ben.ami@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/538] wifi: iwlwifi: remove AX101, AX201 and AX203 support from LNL
Date: Wed,  2 Oct 2024 14:54:23 +0200
Message-ID: <20241002125752.970948907@linuxfoundation.org>
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

From: Golan Ben Ami <golan.ben.ami@intel.com>

[ Upstream commit 6adae0b081454393ca5f7363fd3c7379c8e2a7a1 ]

LNL is the codename for the upcoming Series 2 Core Ultra
processors designed by Intel. AX101, AX201 and AX203 devices
are not shiped on LNL platforms, so don't support them.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240613171043.f24a228dfd96.I989a2d3f1513211bc49ac8143ee4e9e341e1ee67@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 8131dd52810d ("wifi: iwlwifi: config: label 'gl' devices as discrete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 32 ++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index dea4d6478b4f4..365e19314f2ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -504,7 +504,37 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2727, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x272D, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x272b, PCI_ANY_ID, iwl_bz_trans_cfg)},
-	{IWL_PCI_DEVICE(0xA840, PCI_ANY_ID, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0000, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0090, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0094, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0098, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x009C, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x00C0, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x00C4, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x00E0, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x00E4, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x00E8, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x00EC, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0100, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0110, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0114, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0118, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x011C, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0310, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0314, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0510, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x0A10, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1671, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1672, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1771, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1772, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1791, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1792, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x4090, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x40C4, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x40E0, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x4110, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x4314, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_trans_cfg)},
 
 /* Sc devices */
-- 
2.43.0



