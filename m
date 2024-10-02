Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6C0198A1A;
	Wed,  2 Oct 2024 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877407; cv=none; b=RA4+h9DjgGeY5V1e3FNh2PW5RluqNmAXcOpQ+vd9U6kLT1Q/JcsTOCEzYZ0SHXPGg4RhZiB3Phgfasm4XvS11dS9JKN2YZoJekDTve520I96+OlV8834trXpx76kbiXq/YguKgoP0kLi7NS0bJwTGwRSBFWzn5mHnJF+YINMkJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877407; c=relaxed/simple;
	bh=i/lYADUcs7Hamk4oC/RLTTOtNvuAa3sCW2W4YCLBCEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOExiZFmXi2VqoegknzZoITbOzqGpijFLtUbdU8MCIxDLQ1d+zomKxW7h+l0wiKb7gjdT4lcIKSXJh4DAPxoeTwiMbvIYbcxQ/swYL/+w/MiAOTF2S5A+4ScVVSsy2MNK1qMqkoZ60FZLzJsSaOqBA1OsNP79OaskhlbEVpc1eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cev7pGQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cev7pGQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25665C4CED3;
	Wed,  2 Oct 2024 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877407;
	bh=i/lYADUcs7Hamk4oC/RLTTOtNvuAa3sCW2W4YCLBCEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cev7pGQNLSkqmq5cAExjjDCGt22HgVg6lG6jDcbQt3IUJQJd4/w7OHzckIlBoFnH8
	 oKKUnZ5cLaJzjZgmnE46C4FyzGXfgFQcUgg60WCBCzSg6tBnWtW7RSrSSqxFakGi2P
	 HtNAfVy6yONzmE5AXlzJoqGvfmqHMZNglk6qY1Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golan Ben Ami <golan.ben.ami@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/634] wifi: iwlwifi: remove AX101, AX201 and AX203 support from LNL
Date: Wed,  2 Oct 2024 14:52:18 +0200
Message-ID: <20241002125812.602137014@linuxfoundation.org>
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
index fed2754be6802..9863292fddde7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -503,7 +503,37 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
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
 	{IWL_PCI_DEVICE(0x4D40, PCI_ANY_ID, iwl_bz_trans_cfg)},
 
-- 
2.43.0



