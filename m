Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8897E15884E;
	Tue, 23 Jul 2024 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760299; cv=none; b=n7aLXNnAGr7kRWZWk6khW8Ppfk5DxYbsv1tAk2jtpaQoo8zMdlFPiRjzJ6/B1e8i+wBsaeDaQheR4c8Td4jqCo/pFXxtJAA+I2wltifCWsPvtunfbgVbW8EUB5A7MnUrF/UV2239t4WmC7Crr1xXQGNVltpEldZ1/yTQJHWy8ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760299; c=relaxed/simple;
	bh=MQ2hb1ZJE79JIAw3nqqasFS9X9Z1Bcnevf4MoUgJuZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1QZl1UwSVoyWqrIt5cSHKlIjqHVtnzcydC8wDSCZxB+qYJYvo7Rc5TGbkdL9ieqkWbllqvPpVb4K70J8nOY7UeflH4c/Tezdyb0moDfl8VOykv+Dmhxa0CXbzZpMxmagwy4FvJIWh1wmNFYWO0ZvBsLfOGP3us6+XYy3i5MOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRKBcDR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRKBcDR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0858CC4AF0B;
	Tue, 23 Jul 2024 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760299;
	bh=MQ2hb1ZJE79JIAw3nqqasFS9X9Z1Bcnevf4MoUgJuZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRKBcDR39TcsmxVlOXu/iU3SusMuz2KkWh59hfz1KvOvMrj+P3cq8PiLFAKFKylG3
	 yGSctR6B8QTp7M1sbWI5WxvDsL4czJ2rSZ0QXO0Ffd4hLCvTYJsBroVQtV7bzxof+T
	 p6gn8bjVCD6KQxQThTK2tWTeYrMi7hB8VH2sTCOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 141/163] wifi: iwlwifi: properly set WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK
Date: Tue, 23 Jul 2024 20:24:30 +0200
Message-ID: <20240723180148.921522974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 4ec17ce716bdaf680288ce680b4621b52483cc96 ]

The WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK should be set based on the
WOWLAN_KEK_KCK_MATERIAL command version. Currently, the command
version in the firmware has advanced to 4, which prevents the
flag from being set correctly, fix that.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240703064026.a0f162108575.If1a9785727d2a1b0197a396680965df1b53d4096@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d3db883dfaa5b..a61d5e7c08e04 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -651,7 +651,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_WFA_TPC_IE_IN_PROBES;
 
 	if (iwl_fw_lookup_cmd_ver(mvm->fw, WOWLAN_KEK_KCK_MATERIAL,
-				  IWL_FW_CMD_VER_UNKNOWN) == 3)
+				  IWL_FW_CMD_VER_UNKNOWN) >= 3)
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK;
 
 	if (fw_has_api(&mvm->fw->ucode_capa,
-- 
2.43.0



