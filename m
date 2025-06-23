Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB4E221FD6;
	Mon, 23 Jun 2025 22:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716272; cv=none; b=ZnHhPxkD3ThR/Z2WN2rrBlRmZfRhxwNo4AKUoOskegm1RD5tnmMqrNAiQ8xAaOai6mF33+vms4+R9CVkzlgI2B/y125VTgElADu6CcydUA8JQZ6lGnbGNwvn+eqfX9UXQ5YbFPnADx+8Sp5M1XE3hom1CH6a/hbny3BinMVxVIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716272; c=relaxed/simple;
	bh=sXH0cTzw1PsZzjKXO1lFn0OmJR7boOEAJTC+Xw9IwxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3ZaAoRSVbyNgZOqqOJpntQIu8JsbnL2jgcJY6j8q1krYdHK3irtS3pcBkFU5DW77rCcQ3pbeIGSbh3ZRKx0mXaH7TtdPiUP0YNwu+SWV0Ia8w1RtWWNZHNMXribh/unEQ8f/GC140Icw+ACayK7IrWbXPjVU7yptOVJhjrk7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnt8QBeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnt8QBeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B045C4CEED;
	Mon, 23 Jun 2025 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716272;
	bh=sXH0cTzw1PsZzjKXO1lFn0OmJR7boOEAJTC+Xw9IwxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnt8QBeDbnLcZUigElRk5FHULNhVr27pnve9Wiymdz+vtOyHV//rbB8I049dI7pJk
	 y0d2i89mSzyVFzGrlq5rB/nb7tUfSo3EZW7nvfPtfpw0bvfPdCN73Q8hYlUIAaxOaH
	 GcrNpjsNm/Krc/7R3at3VOy9Xm6WdxTYTCfF/SmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/414] wifi: iwlwifi: mvm: fix beacon CCK flag
Date: Mon, 23 Jun 2025 15:06:17 +0200
Message-ID: <20250623130648.047637419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e96ddaeeeeff5..d013de30e7ed6 100644
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
@@ -962,7 +962,7 @@ u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 	u16 flags = iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
 	bool is_new_rate = iwl_fw_lookup_cmd_ver(fw, BEACON_TEMPLATE_CMD, 0) > 10;
 
-	if (rate_idx <= IWL_FIRST_CCK_RATE)
+	if (rate_idx <= IWL_LAST_CCK_RATE)
 		flags |= is_new_rate ? IWL_MAC_BEACON_CCK
 			  : IWL_MAC_BEACON_CCK_V1;
 
-- 
2.39.5



