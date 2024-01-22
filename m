Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3728135A6D;
	Tue, 23 Jan 2024 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969431; cv=none; b=R+a3JL+eeNi7b3UNxeHgkZ9h7aqyeRS4T22GR+1UFpGM2ADwrhHBtIvovNogjCuY7/2wPvVdG9HWh9yksn5dbvwmcEda6kuvbQjZE/aUH+1rcFqJmevQGlytVrkbLyGSOwZsJC8O60n88dqeHj5HyFQvI9xSimxsobVmT8nI4I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969431; c=relaxed/simple;
	bh=LHu4U9gfXQHPHIZcIxc2oHwQXxljAWdi6exjAQO8txE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug242XN8ePYXgOz2nBkmjuLocem+C6TX0nHjMfYTtF8UKNMMmPSN7gnOysxLtH8YGfrf8U/b3ML9/glgX+yy0KYz5VCRc2L4b9Ak1er2PxTlV5VmtzwGlnRITMC8ay1nfMlWB6yE/PVEJgRBmbPqoFJ3o7jGKLN72OCIoFFOnZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn9o4Qfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn9o4Qfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7C5C43399;
	Tue, 23 Jan 2024 00:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969430;
	bh=LHu4U9gfXQHPHIZcIxc2oHwQXxljAWdi6exjAQO8txE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn9o4Qfh4M7Xfli/FVdtAUvg+dj6qjewXifso8xiqSndi7FRNbIT47939AG07qypq
	 sOWaG+BEa8G1+Za8gWx4+6XdvL60DS+TPs2asxAV/ISxRdOk5JPGzGBQENZoL4KjZV
	 EqXBXOhyeeOrO7oYCcf0ThZ+Xv5ewINv0vs0yK9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 216/641] wifi: iwlwifi: mvm: set siso/mimo chains to 1 in FW SMPS request
Date: Mon, 22 Jan 2024 15:52:00 -0800
Message-ID: <20240122235824.707718309@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 4e1fccff3987..334d1f59f6e4 100644
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



