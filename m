Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459A27456;
	Tue, 23 Jan 2024 00:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970928; cv=none; b=S508pB0vWEwJm6bIBhmizhGPTqL/7+XKoJMhkhWghUfZ4EI1VPuRvj/Bntv6Qmg2Faa5Y7RfchJcMnnUmwvllWyzoX4DTmdoJ4Zi09M9Uggtk5ggfaXgpAHWvZTLJK1vX6O0I8NWdZNP9EETN9SIuawNKRfk7aJtQDOMV8dZN1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970928; c=relaxed/simple;
	bh=KXeJcaiJOLBgRQJHi7RoKURD2JLG6W1zp2iehEKoGgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q69qaAw79a3dmWW8IeolDtD6FoL+vwP/WqkqtijJvof8Gs+Zeb03nfs9Zz/byiEnpGAOR6rGvDzA/YiXMWFh8h5vn/Do9uatYBDJl77JA1ac3kqzBqcdJbI4oKLZwS5RDGh8rMGgAHGhrYYX6qdfnK5/o7ZTvHvfcUF7cCAs9hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scbn4jaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scbn4jaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BE7C43390;
	Tue, 23 Jan 2024 00:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970928;
	bh=KXeJcaiJOLBgRQJHi7RoKURD2JLG6W1zp2iehEKoGgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scbn4jaIhdz/oqZwRRSnVg6edEMWATpYaUHrxxoKAAYhORmTxsnUyBehSlv5zw6H4
	 A/lmkA5ODulZOyNZP6JB7d2p8YyQ+uUWwl9uRE5Blwy+SDOo0mIVLfNPxU5TV0zeRm
	 v24tZtoQv+3Led/LG5y4xPMjryA9r1xcZ6j7ywTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/417] wifi: iwlwifi: mvm: set siso/mimo chains to 1 in FW SMPS request
Date: Mon, 22 Jan 2024 15:55:09 -0800
Message-ID: <20240122235756.714962902@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b1a2e5c310e063560760806d2cc5d2233c596067 ]

The firmware changed their mind, don't set the chains to zero,
instead set them to 1 as we normally would for connections to
APs that don't use MIMO.

Fixes: 2a7ce54ccc23 ("iwlwifi: mvm: honour firmware SMPS requests")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231219215605.7f031f1a127f.Idc816e0f604b07d22a9d5352bc23c445512fad14@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index a3cefbc43e80..2c14188f34bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -99,17 +99,6 @@ static void iwl_mvm_phy_ctxt_set_rxchain(struct iwl_mvm *mvm,
 		active_cnt = 2;
 	}
 
-	/*
-	 * If the firmware requested it, then we know that it supports
-	 * getting zero for the values to indicate "use one, but pick
-	 * which one yourself", which means it can dynamically pick one
-	 * that e.g. has better RSSI.
-	 */
-	if (mvm->fw_static_smps_request && active_cnt == 1 && idle_cnt == 1) {
-		idle_cnt = 0;
-		active_cnt = 0;
-	}
-
 	*rxchain_info = cpu_to_le32(iwl_mvm_get_valid_rx_ant(mvm) <<
 					PHY_RX_CHAIN_VALID_POS);
 	*rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
-- 
2.43.0



