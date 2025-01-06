Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2470C70812;
	Mon,  6 Jan 2025 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177772; cv=none; b=UowakemMjS/+6QXJ/FzqHYSyxUS8oHR/nr7SM8/58Wf5zCnwee0SW2wO5wTkVkWUTzKVRlifugi3QjEjhKJvGZ8uw0p6eAxc7bFplvzU9bGMP+WmLs/93h2FaB4IsDLLVuROyFYVOTavIs8ohQ51JruQkKz9igTTqofRQxZWL/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177772; c=relaxed/simple;
	bh=9FDOd8j9gu0c9rCmitgYln1JPUhfDyTk5kSCjXX9kKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIA/zIrYuhzUOPIMPG6U7iLC3b4rKqwo2L3qeLlPpYDlj+tz4N/rhyfIQEThZCNlaqyC5W37YvRf3pefqBty6NtH+BJRv4Ea7tQtB8xITxp4IYBiCNqMOMLN1E9ULqQmREYhI5wilYpn7orRopPyvo4oQdCsqvkvWxV5Jp5dgNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4sQ+2Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4sQ+2Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64001C4CED6;
	Mon,  6 Jan 2025 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177771;
	bh=9FDOd8j9gu0c9rCmitgYln1JPUhfDyTk5kSCjXX9kKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4sQ+2ZuUysX7hvwK9OR4i3hUO0UBr5AfJnoGgUcUwdm1JbDb1C6lJ3JSEUMQm9Qw
	 DK0febaMB28qJQkhyIRFp0H4IVVw/u72S9+bEFcVTpjFdxNOCXZon3mWm3rX5ULh2O
	 QMEXSkT7+bSe9CK4daDJCpn2QvJwNZmxqG5pocbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/156] wifi: iwlwifi: fix CRF name for Bz
Date: Mon,  6 Jan 2025 16:15:06 +0100
Message-ID: <20250106151142.504449753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0e8c52091633b354b12d0c29a27a22077584c111 ]

We had BE201 hard coded.
Look at the RF_ID and decide based on its value.

Fixes: 6795a37161fb ("wifi: iwlwifi: Print a specific device name.")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241212132940.b9eebda1ca60.I36791a134ed5e538e059418eb6520761da97b44c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c   |  1 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 37 ++++++++++++++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index fa1be8c54d3c..c18c6e933f47 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -161,6 +161,7 @@ const struct iwl_cfg_trans_params iwl_gl_trans_cfg = {
 
 const char iwl_bz_name[] = "Intel(R) TBD Bz device";
 const char iwl_fm_name[] = "Intel(R) Wi-Fi 7 BE201 320MHz";
+const char iwl_wh_name[] = "Intel(R) Wi-Fi 7 BE211 320MHz";
 const char iwl_gl_name[] = "Intel(R) Wi-Fi 7 BE200 320MHz";
 const char iwl_mtp_name[] = "Intel(R) Wi-Fi 7 BE202 160MHz";
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 34c91deca57b..17721bb47e25 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -545,6 +545,7 @@ extern const char iwl_ax231_name[];
 extern const char iwl_ax411_name[];
 extern const char iwl_bz_name[];
 extern const char iwl_fm_name[];
+extern const char iwl_wh_name[];
 extern const char iwl_gl_name[];
 extern const char iwl_mtp_name[];
 extern const char iwl_sc_name[];
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 805fb249a0c6..8fb2aa282242 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1106,19 +1106,54 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_name),
 
 /* Bz */
-/* FIXME: need to change the naming according to the actual CRF */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_BZ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_bz, iwl_ax201_name),
+
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_BZ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_GF, IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_bz, iwl_ax211_name),
+
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_BZ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_FM, IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_cfg_bz, iwl_fm_name),
 
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_BZ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_WH, IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_bz, iwl_wh_name),
+
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_BZ_W, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_bz, iwl_ax201_name),
+
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_BZ_W, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_GF, IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_bz, iwl_ax211_name),
+
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_BZ_W, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_FM, IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_cfg_bz, iwl_fm_name),
 
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_BZ_W, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_WH, IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,
+		      iwl_cfg_bz, iwl_wh_name),
+
 /* Ga (Gl) */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_GL, IWL_CFG_ANY,
-- 
2.39.5



