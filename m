Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66134145B14;
	Thu, 11 Apr 2024 10:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830052; cv=none; b=LCfvg2gVfmmTtxKX7eDCaUsfSj0OwipTaInYID2k0lipARzZPOmTQzTARNkliR0dP5x7NwPzAnPS9kGLb1M7mohaGpDqDOQ/OsuO5nte5CxNT3b9uprk4MJsm3ESBG/Ejzh6RW9QaRppOXSk7TMlaJ17IdQhUZ9j79tP0u6/v7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830052; c=relaxed/simple;
	bh=GxQDZZFjahN6mQUoPXSL6LUnWeg7dWC8uXwZFOq8+Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZwB42lwO2nvcnGD6veRl/d2F54YgcxLtdobO20XzKJNPADZmcspz169KXWPKZanNVYpQla6NZi0ul32ySOm58lwdRvHt56qaORzbrhb7uV3q3AEbysMksOlRHATM9J5lRYUOY1ooW88CWQaIhSCV3TXIYmMOoqxV4ROjcO9TVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMA1nRwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMA1nRwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81829C433F1;
	Thu, 11 Apr 2024 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830051;
	bh=GxQDZZFjahN6mQUoPXSL6LUnWeg7dWC8uXwZFOq8+Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMA1nRwVMaiog9y2cYP/S7XuwBYH1PFQQJk2gzQC/TT0X8r/xkFnqLb+861HSYkuj
	 /gjREe5XUYAsBwXx7MB/B+8aC5jew0fIKsz/IOwA+6UNVlaFR5cghLLHbd0+0a/9Uu
	 d1g6CHkSmpt2wQLqAdo/+tUNb2APeJkgmyCP6Swc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 011/143] wifi: iwlwifi: pcie: Add the PCI device id for new hardware
Date: Thu, 11 Apr 2024 11:54:39 +0200
Message-ID: <20240411095421.250774129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 6770eee75148ba10c0c051885379714773e00b48 ]

Add the support for a new PCI device id.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240129211905.fde32107e0a3.I597cff4f340e4bed12b7568a0ad504bd4b2c1cf8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 2c9b98c8184b5..271be64ce19ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -502,6 +502,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* Bz devices */
 	{IWL_PCI_DEVICE(0x2727, PCI_ANY_ID, iwl_bz_trans_cfg)},
+	{IWL_PCI_DEVICE(0x272D, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x272b, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0xA840, PCI_ANY_ID, iwl_bz_trans_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_trans_cfg)},
-- 
2.43.0



