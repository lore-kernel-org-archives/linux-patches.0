Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8489E14375A;
	Wed, 19 Jun 2024 13:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803442; cv=none; b=U16pSQfF01wNNdV3vEaF+rflax4hjPN4II0YM03GyNf192ovV4zxaQmtzet4npORVwd+kCrM3hf/cYpFmvweWz2grdD4QQmgN8V71s/4dzSeBWyemIsWOtcNWZFR5yyaRMcOg+XXpaUO0eodmHeN7WRiIHVeteqX7xhpNzT3yJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803442; c=relaxed/simple;
	bh=WhDhwgwOJIh4aDa3ZjntOr7c6IZWXONfcQOFTV0l9YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICnvtQ+mEjVZgpMFi8aQIRGyXysQtC7n8eOSe3hG2ZEjNP857m4kCw+pNoMgQ6E5eA7w9kkocYwvKM6uPD4h9rXJLUniAU3yoREG7+hRtbYHT7IxV14oY0dLNy06482VMGEcQB4jIWLIvX+7dI6PlyI5sG91NW4XzezNaUGAZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqJtvB/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqJtvB/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC6BC2BBFC;
	Wed, 19 Jun 2024 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803442;
	bh=WhDhwgwOJIh4aDa3ZjntOr7c6IZWXONfcQOFTV0l9YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqJtvB/8tjWAWbsTSf6t5KggyPNQKIgrSJyh/prT4yY9CblGYi5Tls2Bj/6wC684i
	 UZrjQw3hgxNj3yKCWZhIxpVyXH3lRdkrif4Y1Wj4rAMd/NfBh6rrE2YTwOruK6/4pw
	 7UZ0gkV35vF54uwriJKX9j64Mp/Xu3ENt7K0v9NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.9 268/281] wifi: iwlwifi: mvm: support iwl_dev_tx_power_cmd_v8
Date: Wed, 19 Jun 2024 14:57:07 +0200
Message-ID: <20240619125620.292835314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8f892e225f416fcf2b55a0f9161162e08e2b0cc7 upstream.

This just adds a __le32 that we (currently) don't use.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.29ff7a88ddac.I39cf2ff1d1ddf0fa62722538698dc7f21aaaf39e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218963
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h |   30 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |    4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    4 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -385,6 +385,33 @@ struct iwl_dev_tx_power_cmd_v7 {
 	__le32 timer_period;
 	__le32 flags;
 } __packed; /* TX_REDUCED_POWER_API_S_VER_7 */
+
+/**
+ * struct iwl_dev_tx_power_cmd_v8 - TX power reduction command version 8
+ * @per_chain: per chain restrictions
+ * @enable_ack_reduction: enable or disable close range ack TX power
+ *	reduction.
+ * @per_chain_restriction_changed: is per_chain_restriction has changed
+ *	from last command. used if set_mode is
+ *	IWL_TX_POWER_MODE_SET_SAR_TIMER.
+ *	note: if not changed, the command is used for keep alive only.
+ * @reserved: reserved (padding)
+ * @timer_period: timer in milliseconds. if expires FW will change to default
+ *	BIOS values. relevant if setMode is IWL_TX_POWER_MODE_SET_SAR_TIMER
+ * @flags: reduce power flags.
+ * @tpc_vlp_backoff_level: user backoff of UNII5,7 VLP channels in USA.
+ *	Not in use.
+ */
+struct iwl_dev_tx_power_cmd_v8 {
+	__le16 per_chain[IWL_NUM_CHAIN_TABLES_V2][IWL_NUM_CHAIN_LIMITS][IWL_NUM_SUB_BANDS_V2];
+	u8 enable_ack_reduction;
+	u8 per_chain_restriction_changed;
+	u8 reserved[2];
+	__le32 timer_period;
+	__le32 flags;
+	__le32 tpc_vlp_backoff_level;
+} __packed; /* TX_REDUCED_POWER_API_S_VER_8 */
+
 /**
  * struct iwl_dev_tx_power_cmd - TX power reduction command (multiversion)
  * @common: common part of the command
@@ -392,6 +419,8 @@ struct iwl_dev_tx_power_cmd_v7 {
  * @v4: version 4 part of the command
  * @v5: version 5 part of the command
  * @v6: version 6 part of the command
+ * @v7: version 7 part of the command
+ * @v8: version 8 part of the command
  */
 struct iwl_dev_tx_power_cmd {
 	struct iwl_dev_tx_power_common common;
@@ -401,6 +430,7 @@ struct iwl_dev_tx_power_cmd {
 		struct iwl_dev_tx_power_cmd_v5 v5;
 		struct iwl_dev_tx_power_cmd_v6 v6;
 		struct iwl_dev_tx_power_cmd_v7 v7;
+		struct iwl_dev_tx_power_cmd_v8 v8;
 	};
 };
 
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -886,11 +886,13 @@ int iwl_mvm_sar_select_profile(struct iw
 	u32 n_subbands;
 	u8 cmd_ver = iwl_fw_lookup_cmd_ver(mvm->fw, cmd_id,
 					   IWL_FW_CMD_VER_UNKNOWN);
-	if (cmd_ver == 7) {
+	if (cmd_ver >= 7) {
 		len = sizeof(cmd.v7);
 		n_subbands = IWL_NUM_SUB_BANDS_V2;
 		per_chain = cmd.v7.per_chain[0][0];
 		cmd.v7.flags = cpu_to_le32(mvm->fwrt.reduced_power_flags);
+		if (cmd_ver == 8)
+			len = sizeof(cmd.v8);
 	} else if (cmd_ver == 6) {
 		len = sizeof(cmd.v6);
 		n_subbands = IWL_NUM_SUB_BANDS_V2;
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1399,7 +1399,9 @@ int iwl_mvm_set_tx_power(struct iwl_mvm
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
 		cmd.common.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
 
-	if (cmd_ver == 7)
+	if (cmd_ver == 8)
+		len = sizeof(cmd.v8);
+	else if (cmd_ver == 7)
 		len = sizeof(cmd.v7);
 	else if (cmd_ver == 6)
 		len = sizeof(cmd.v6);


