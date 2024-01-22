Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B46313F;
	Tue, 23 Jan 2024 01:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975020; cv=none; b=hydyL3100+0uuRpIgDrdEoUmJJSo9wJrNx8X4dztBxB2mIrs27BaQMwASNwWVAANUmoE2prJcKi9bBvHSy+Ljq+Ks3HoP7AAC9ZQC2znYoK4m2OvXOC444MCQZNCXPVygLeGxkmpvaSRbQUG8Z38gccv4vjBGzVI7zDaNjvpQHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975020; c=relaxed/simple;
	bh=Np3qn2IkeW42qhktV/o1y5UHPprgaNnFLAgeGC0drTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shm0j01TabDh8N+8mS5GWdqi17/YnKYFaZVHa6JiqeXXiFvLBrupV02m2LOqVWprjF913S52PuDSSup5nYsSkfYGlqLwi1hH7AjxYp455+5OcAgqaRRchIh0+vgn1dWXJltevhlEyVMFNSsE/++Z+sjDtswI6m9uFhaBZdX+l+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+f8rbGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+f8rbGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C864C43394;
	Tue, 23 Jan 2024 01:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975020;
	bh=Np3qn2IkeW42qhktV/o1y5UHPprgaNnFLAgeGC0drTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+f8rbGa/Xk++tuWT9YOGeA5Ns7aS4YulGDW6NtktbPsUk+cX1u0FBrwW4Ylx9mXG
	 M34SEt4BVQsQC67uL37QjPPg5MKHQg8WzkkVIufelhPTpHPhqw9bMmzal+yTvZy0Gy
	 3VZLS7LxsmT7ghq0gyCcLZ9GnFZ0e9FCtPB3jIxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/583] wifi: iwlwifi: mvm: set siso/mimo chains to 1 in FW SMPS request
Date: Mon, 22 Jan 2024 15:54:10 -0800
Message-ID: <20240122235818.063873304@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5b432bc9e2f..9c582e23ebba 100644
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



