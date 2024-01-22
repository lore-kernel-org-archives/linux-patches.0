Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5980D2B9B7;
	Tue, 23 Jan 2024 01:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974100; cv=none; b=Qquhdu4XEsIqtSEoja4mkmSsTNfhFH/96cwV81v8CqNcTLxKpMS9M1JcYlYfz0XHcQovH+LL8aBqKLogXyE2OmGwSD2Cs5MIaRwaPGqfQU+210SkqGgp4dYCBdRWuyHK2XGf5y0Izw7Kkz2dQVvgpaapFH4USQUhYlKO6D/T4dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974100; c=relaxed/simple;
	bh=siULYyd6sn4kxKk5ZuXEEX+KWBkpR5pIWDSQD7DWMNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lorg1WBW2EwVYlIHqC2I6foXlVCO+tFpjLtONTAPEkJMHF1tm8tVub956ucOgYQrcfR4hsxV04eGpffPYoTQdmoJahLOc8W5pPmdmwKyb1jwktSxutbJwkhRs5GWYdskjY6zi2Hzmh8Xhlc26F2NA6zDBNQk5Alnza+rsjrPt18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXI/T1g3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXI/T1g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB08C433C7;
	Tue, 23 Jan 2024 01:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974099;
	bh=siULYyd6sn4kxKk5ZuXEEX+KWBkpR5pIWDSQD7DWMNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXI/T1g3JuFPnLcnA4wcBS0X57f3+JP9U22olWcQP4CVwjPPPXMYqDDnYjMIIU+lu
	 +ZKH1noVlRExuEPYdm3X4wXaNr7UF3kmn+jS6vjD2Bt1nTvrCqWMgTYjk2Mi/HX3aP
	 cetnym2xq0JnTIiuy4WQo+uTM1zVDS+vFxZ3x1Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/374] wifi: iwlwifi: mvm: set siso/mimo chains to 1 in FW SMPS request
Date: Mon, 22 Jan 2024 15:56:59 -0800
Message-ID: <20240122235750.276192954@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d82725cb87d..32ed8227d985 100644
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



