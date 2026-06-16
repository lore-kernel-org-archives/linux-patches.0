Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E43E46AEF2;
	Tue, 16 Jun 2026 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624733; cv=none; b=SqSIDk1EOnlYDgORH+ITIP69RL9n4DlvT7U0cuzSisADKKXQ7S5Yqtu/7YMd4XtS83Lqv5rgjrqCpHjOqzILVTMg+wC2PyHzhJBLewDJCX5RPdA8zth6BrlK0j7928fZC9vqWriitW7a8z2UD2mySr4OC1wbEGSnp0zHj3S7b74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624733; c=relaxed/simple;
	bh=xHDIFi8Yf2cRNLnluWCdzzFy665IHhhWqzaZW0+S0QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+A/dEcH73hkx3KPxwS13lG8f47N58mXKs5FkgNHJf9Uo8lehTosWqeakrqTCGGKzhavFzKhUUH6XXIXdPou2Hu+/BtCMnGdpJl9nLgaOQJU1qEVL26CstZn603MRwwTZC+UkAmsOwvjD9hE8nv6q4oAOu+wYy0rJGwgk/MLu5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2pAo2ks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2pAo2ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95F21F000E9;
	Tue, 16 Jun 2026 15:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624730;
	bh=XeGNvLzc/McAIt9lE+aHn3L5hH5VQxjUi55/RTkaeII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2pAo2kspwdoP2FteeFoVVHHn0p/8iQi0vEcRNSjJGXvPZGN4cCMaySrPPw0IImmu
	 dchTeotoUrgOw1cZXXPCB1Sm4VWpYCdamIYNIlaGTmLtHcF5iYf0VCDRoiE5k7V9cz
	 aZGmAPz3nwhgs8QQeDp+ro0vdOU3ifAtgfyeRAJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/325] wifi: iwlwifi: mvm: dont support the reset handshake for old firmwares
Date: Tue, 16 Jun 2026 20:26:55 +0530
Message-ID: <20260616145058.750924406@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0eaa1f245ac03ed0c6394159360532726f666811 ]

-77.ucode doesn't contain the fixes for this flow it seems.
Don't use the firmware reset handshake even if the firmware claims
support for it.

Fixes: 906d4eb84408 ("iwlwifi: support firmware reset handshake")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220600
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260529085453.9307b81d9b02.I21bba9e649f4cd0e35d3ea6cd97a03258be5832f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5ebd046371f50d..8e6913c7712f09 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1416,6 +1416,12 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 		fw_has_capa(&mvm->fw->ucode_capa,
 			    IWL_UCODE_TLV_CAPA_FW_RESET_HANDSHAKE);
 
+	/* Those firmware versions claim to support the fw_reset_handshake
+	 * but they are buggy.
+	 */
+	if (IWL_UCODE_MAJOR(mvm->fw->ucode_ver) <= 77)
+		trans->conf.fw_reset_handshake = false;
+
 	trans->conf.queue_alloc_cmd_ver =
 		iwl_fw_lookup_cmd_ver(mvm->fw,
 				      WIDE_ID(DATA_PATH_GROUP,
-- 
2.53.0



