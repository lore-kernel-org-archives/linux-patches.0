Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BD74F3ED6;
	Thu, 17 Sep 2026 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664085; cv=none; b=sVNlJkiog2ksCiszy9M+wZ1ROIpe9o7oV0gJlly8v99mq+MvmT4zYIAMgOGAPGUAj6Dca5YFHonGl/NIaWq+fGW7UFQyrbI2T+9mqOg8u/lGyvohneP8OlT3KlPf2E0VUsQDLfLbYmDL+eUb8XZYCS0jEThEAr4IAjHHN9LpWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664085; c=relaxed/simple;
	bh=o/T/Lf3nQ9vEWjeawZYzlI4BoRZse4Shaszgvo/gXkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBcT1f3bNcwdYuF96UAAbP0SXTKY0CszguowxCCS0Qu8Vj9eK2RHR545RT0LcuiXk+KIqh52BYFetbuJjrDBw4cb676cZLPHJOYktnhwKRLeGf40aZy+w3sViWMAYGQU+K8qy4bgl65LKo7oxpx5guI+oTBSSSDHxUncbxf1mf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4u8T71I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4u8T71I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176751F00893;
	Thu, 17 Sep 2026 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664084;
	bh=YdSRinTYLKx2bprcK8nL3ckYwsAi83x7qhF1kVDoACs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4u8T71I4vlwtt4qmGKn0pxUh7I6D8N8S3lgfNIXjyeiWT7Cl1LU5PjbFQ3ehHenC
	 D5OBzI8l9O8MJcfWom39o04FEKddzpLFOpZzpIJnCYF7mfS67yw6ynOLDKvzSebJ22
	 g5yFCVXNIrn8mwpg6Dp5Sgi47E93AqfP1Dsk9Ea8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0216/1250] wifi: iwlwifi: pcie: add two LNL PCI IDs
Date: Thu, 17 Sep 2026 16:00:11 +0100
Message-ID: <20260917151557.990176195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5f88b045d959f8a51757e0fde29d5d204da1176f ]

Add two PCI IDs for two WiFi-7 BE1735x Killer devices (these
are CRFs) so they work when put into the LNL platform.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260515150751.d2e3c380227a.I791eef3dedc11a8b246ce3130a34018886e63d3f@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 706dc7bb9a18d..cd0c416e927a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -537,6 +537,8 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA840, 0x4314, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x1775, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x1776, iwl_bz_mac_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1735, iwl_bz_mac_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1736, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0x4D40, PCI_ANY_ID, iwl_bz_mac_cfg)},
 
-- 
2.53.0



