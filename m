Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F43DC2E0;
	Mon, 23 Jun 2025 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714306; cv=none; b=YlO8AHRtq91DphKIyhgzLx3qGKzKWD1wNqtjFsiXsYoc5pDVeXSVqGJfftn9ft0PeqzGKjvOcCeeiB9m2Bc78a+zIWFumqTYdoLXLfviQ/5cXU8H6M0AQo8/TUCG1cchpz9Hu6cIt8ULveVeTyhXJ5ZPhYmC1AInMlDyeK5yapc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714306; c=relaxed/simple;
	bh=sW52VtgbloQ0PmdN/59wBMHQryqpZXWlwkOJ787KEdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvm249H9g8rDOoMYQDK/Qz/wd6wHlpfGgj8NYv/d3dDofLvbP9WpXIlxwaHfmoI8wpeHuSJd5l0OmYNr9thMXXIzKPw7+NCI1HvIuoTnZ4CxDez+x/ieqk8HHgu3Mz0W2wvl1WplGgq3Hcs/3YG06iVAJq0Ma0wO+ZxPc+z4pQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t98704ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t98704ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E37C4CEEA;
	Mon, 23 Jun 2025 21:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714306;
	bh=sW52VtgbloQ0PmdN/59wBMHQryqpZXWlwkOJ787KEdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t98704ka58Lj+5WD2mvvfo/uJHtg5o8TxM3DSFq9x3S8ukSK/WoJHh9+QPxqxTs2e
	 RCuGv91euaaSCrNkP2iAoagSet+nUloeANMlTDXGHx19UMLge8nkcy/zB4uvI+BFqB
	 aHdseVPoH0xeDEsLwyLOh1cK2tMAeKPd2asRy6sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 373/592] wifi: iwlwifi: mvm: fix beacon CCK flag
Date: Mon, 23 Jun 2025 15:05:31 +0200
Message-ID: <20250623130709.312944052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8d7f08922a8cb621aa5d00bdce6a7afe57af1665 ]

The beacon CCK flag should be set for any CCK rate, not
just for 1 Mbps. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20250505215513.fe18b7d92d7d.I7bb40a92cea102677b695beb1e2a62a5ea72678b@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index bec18d197f310..83f1ed94ccab9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -941,7 +941,7 @@ u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 	u16 flags = iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
 	bool is_new_rate = iwl_fw_lookup_cmd_ver(fw, BEACON_TEMPLATE_CMD, 0) > 10;
 
-	if (rate_idx <= IWL_FIRST_CCK_RATE)
+	if (rate_idx <= IWL_LAST_CCK_RATE)
 		flags |= is_new_rate ? IWL_MAC_BEACON_CCK
 			  : IWL_MAC_BEACON_CCK_V1;
 
-- 
2.39.5



