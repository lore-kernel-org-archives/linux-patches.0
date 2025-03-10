Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A451E519;
	Mon, 10 Mar 2025 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626700; cv=none; b=O2VvC9XLcDImfSI/BFzIC7/9myyTYRhm/TDlsUywrqakwPLNhapqLeED5/g1ZNguZjXef7Q26donpNyt74+wuxXYbwdtvU774LS5+aFkmy+UBLChFGOhF27P1oZLaVNW1KobC23GHuYraqGv/s0rxmqqW+8VDwYcMg5SAK3NZqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626700; c=relaxed/simple;
	bh=yrLK4/EAMW64ZsK5FTq2T5QDwkkGkyeq7nMgTsEdy1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lu4ufnmABFI3VFISmhE/2IHMzeg3mWHqlt3xpB5WVLREQ/QVI84W5R+/ozHPaSAYl6QAaNAC5D5VDcv2yC+ZBV1SWl0C/qc/zs8R5TwSkXWyGQ4zU3DcUB8Cj75mBnE9SFClogG6o8jrZAPAvfbVVAt2hmOd3cDAXYfWMtR75C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U762HFPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U762HFPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBD1C4CEE5;
	Mon, 10 Mar 2025 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626700;
	bh=yrLK4/EAMW64ZsK5FTq2T5QDwkkGkyeq7nMgTsEdy1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U762HFPkqnObSdvJmM8ET0yg1hz08CeAVA4am1V7s4ivsjwfpqnc4AZL4IaF08S+U
	 FLYJ0heJgrQaBEiX1Ga4Lin/Raxq9QdfRFFW7qigN239bUduJZYKbfjwmm65rTCWOU
	 aVOJzA7uHepO2Q6nD90LUmI04vl3DTh/ViPK4vV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 083/207] wifi: iwlwifi: mvm: log error for failures after D3
Date: Mon, 10 Mar 2025 18:04:36 +0100
Message-ID: <20250310170451.061279580@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit f8f13ea27fffff51ee257171a8604f944c876fd4 ]

We only logged an error in the fast resume path. However, as the
hardware is being restarted it makes sense to log an error to make it
easier to understand what is happening.

Add a new error message into the normal resume path and update the
error in the fast resume path to match.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241226174257.df1e451d4928.Ibe286bc010ad7fecebba5650097e16ed22a654e4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d48ff3ce9225 ("wifi: iwlwifi: mvm: don't dump the firmware state upon RFKILL while suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 4d1daff1e070d..33794780d5c9e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -3523,6 +3523,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
 	if (iwl_mvm_check_rt_status(mvm, vif)) {
+		IWL_ERR(mvm, "FW Error occurred during suspend. Restarting.\n");
 		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
 		iwl_mvm_dump_nic_error_log(mvm);
 		iwl_dbg_tlv_time_point(&mvm->fwrt,
@@ -3695,8 +3696,7 @@ int iwl_mvm_fast_resume(struct iwl_mvm *mvm)
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
 	if (iwl_mvm_check_rt_status(mvm, NULL)) {
-		IWL_ERR(mvm,
-			"iwl_mvm_check_rt_status failed, device is gone during suspend\n");
+		IWL_ERR(mvm, "FW Error occurred during suspend. Restarting.\n");
 		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
 		iwl_mvm_dump_nic_error_log(mvm);
 		iwl_dbg_tlv_time_point(&mvm->fwrt,
-- 
2.39.5



