Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7771C1E25E3;
	Tue, 27 May 2025 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367939; cv=none; b=EGKYBBQSL8XFBPFjzN3EN0p7yCdc31w96GlXS8ERgmpu2uEuadKyZ8zbZ/z1Z8EzCz59P+VDKHCYcuRdSsYpKAFsDFMJc1i0jwEp+qhQo0zLwmv3lRK9Zs+mV8iRKCNnUhgqoz54jA+uCpyAwQdXMxSS8LAOOU8tTNdBq0Ojtkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367939; c=relaxed/simple;
	bh=hebOLvR1NTMNQGZDWpH6OtupAbJbqZ5AbwUXp5QH20I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXTVGFJjp2GpsySl751W5lG8dwAMoeOCtb7qjJmp7dRuhFMANA6Ll8RsO0X8fjoYz+M5c1Uld8UTj7UBiP50Ya2pTlEN2PO/iF8XNBviUVzzCMu+rVOeu1lRSszG3qOuiw1YGHACPn3NA+feaM/LINnxFplXE2jXn8KLJReGHME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWxeG2nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWxeG2nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1606C4CEEB;
	Tue, 27 May 2025 17:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367939;
	bh=hebOLvR1NTMNQGZDWpH6OtupAbJbqZ5AbwUXp5QH20I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWxeG2njd3BRfgq8YM/K+PxFzNXc8WFhU0T0pcoJPudZ29ZiXiZq4KdV59n59wylj
	 BNFp2Q79C55t/NScpTK0I37C31m53tVJIJvfycZ/WAC1uYR4+UHxlZ7QfPsYTduVTL
	 9+JsVUStgJd7PWgi0+dQItTL5K6OHmp3S/88361w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 518/783] wifi: iwlwifi: use correct IMR dump variable
Date: Tue, 27 May 2025 18:25:15 +0200
Message-ID: <20250527162534.239482337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 21e4d29ac0def546d57bacebe4a51cbed1209b03 ]

We shouldn't dump the reg_data here which dumps the last
entry again, it should use the imr_reg_data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205145347.3313b18667d1.Iaa9ab66b1d397912a573525e060d39ea01b29d19@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6594216f873c4..cd284767ff4ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2005-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2025 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -2691,7 +2691,7 @@ static u32 iwl_dump_ini_trigger(struct iwl_fw_runtime *fwrt,
 	}
 	/* collect DRAM_IMR region in the last */
 	if (imr_reg_data.reg_tlv)
-		size += iwl_dump_ini_mem(fwrt, list, &reg_data,
+		size += iwl_dump_ini_mem(fwrt, list, &imr_reg_data,
 					 &iwl_dump_ini_region_ops[IWL_FW_INI_REGION_DRAM_IMR]);
 
 	if (size) {
-- 
2.39.5



