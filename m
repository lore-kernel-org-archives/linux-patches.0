Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1692356A12;
	Sat, 17 Oct 2026 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260357; cv=none; b=RK8FP7AZP+85wHMd5zxXDelOxZwwyrawueY1r40sWkFddGhfgpHTPkhjKkYX8V4+trGTP0sLUWGJuIbsQn8HKlr0RjtWy1GdSgC7MbXDyv9Lg56/JBjv1UuJum57n2wkMk58qzzYSU0FH7+ufsJlnUQES2pCeXwTNqOzjnF1aOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260357; c=relaxed/simple;
	bh=cjmJZZG8+4MkeQlbog0eQHMojZ3XPIOrFuKEINiBIFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAkMxbERloAHrn1AZzB4SlUUQrfQuz4VKR1sXtVkZQNMoINiMsMnLgOXbh01F/A+ADFAappSZ0HazIGVlU86i7FVJuUnn+fGeVPgegk72B65ydFzUSNFCszmpkTZCFARCLA+6QwBXo7TxX9/A84NYThWTNgqTdbHvZoPDZzNnmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DK+RrBwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DK+RrBwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F25B1F000C4;
	Sat, 17 Oct 2026 18:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260356;
	bh=f9XmaXQ3axiGKQEBlAqJUQw6HVLhUTomzXOLtzCmReA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DK+RrBwdMUCG+y43/3yclF1En31kpBRLdPonrFponVcZBVD20z1bWlXqUTuXz8cGs
	 6JYahYVXte3vZLp6QegDmOBMMdo19x2gHizpbuL0qk6evqRF/JdDSSaXi4qOZTWlT9
	 b7Vhoxct8Coo+Omd3dMyQxoAs9eODnseYGRjkKW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1518/1674] wifi: iwlwifi: mvm: remove mvm prefix from iwl_mvm_tx_resp*
Date: Sat, 17 Oct 2026 18:03:10 +0200
Message-ID: <20261017160510.085318924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 5b0c478378e5c82c4c372cf194a2438f8743abcf ]

These are not mvm specific

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20240901071542.22e28b56da2c.Ib859a05ed133fa5a1426c5feffa8999a18bba6f2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 8d70881707b4 ("wifi: iwlwifi: mvm: validate TX_CMD response layout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h       | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          | 12 ++++++------
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 13cb0d53a1a37..196f88564f54a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -141,8 +141,8 @@ enum iwl_legacy_cmds {
 	/**
 	 * @TX_CMD: uses &struct iwl_tx_cmd or &struct iwl_tx_cmd_gen2 or
 	 *	&struct iwl_tx_cmd_gen3,
-	 *	response in &struct iwl_mvm_tx_resp or
-	 *	&struct iwl_mvm_tx_resp_v3
+	 *	response in &struct iwl_tx_resp or
+	 *	&struct iwl_tx_resp_v3
 	 */
 	TX_CMD = 0x1c,
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 842360b1e995c..b98a9d19ba007 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -484,7 +484,7 @@ struct agg_tx_status {
 #define IWL_MVM_TX_RES_GET_RA(_ra_tid) ((_ra_tid) >> 4)
 
 /**
- * struct iwl_mvm_tx_resp_v3 - notifies that fw is TXing a packet
+ * struct iwl_tx_resp_v3 - notifies that fw is TXing a packet
  * ( REPLY_TX = 0x1c )
  * @frame_count: 1 no aggregation, >1 aggregation
  * @bt_kill_count: num of times blocked by bluetooth (unused for agg)
@@ -515,7 +515,7 @@ struct agg_tx_status {
  * After the array of statuses comes the SSN of the SCD. Look at
  * %iwl_mvm_get_scd_ssn for more details.
  */
-struct iwl_mvm_tx_resp_v3 {
+struct iwl_tx_resp_v3 {
 	u8 frame_count;
 	u8 bt_kill_count;
 	u8 failure_rts;
@@ -541,7 +541,7 @@ struct iwl_mvm_tx_resp_v3 {
 } __packed; /* TX_RSP_API_S_VER_3 */
 
 /**
- * struct iwl_mvm_tx_resp - notifies that fw is TXing a packet
+ * struct iwl_tx_resp - notifies that fw is TXing a packet
  * ( REPLY_TX = 0x1c )
  * @frame_count: 1 no aggregation, >1 aggregation
  * @bt_kill_count: num of times blocked by bluetooth (unused for agg)
@@ -573,7 +573,7 @@ struct iwl_mvm_tx_resp_v3 {
  * After the array of statuses comes the SSN of the SCD. Look at
  * %iwl_mvm_get_scd_ssn for more details.
  */
-struct iwl_mvm_tx_resp {
+struct iwl_tx_resp {
 	u8 frame_count;
 	u8 bt_kill_count;
 	u8 failure_rts;
@@ -814,7 +814,7 @@ struct iwl_mac_beacon_cmd {
 	     */
 
 struct iwl_beacon_notif {
-	struct iwl_mvm_tx_resp beacon_notify_hdr;
+	struct iwl_tx_resp beacon_notify_hdr;
 	__le64 tsf;
 	__le32 ibss_mgr_status;
 } __packed;
@@ -827,7 +827,7 @@ struct iwl_beacon_notif {
  * @gp2: last beacon time in gp2
  */
 struct iwl_extended_beacon_notif_v5 {
-	struct iwl_mvm_tx_resp beacon_notify_hdr;
+	struct iwl_tx_resp beacon_notify_hdr;
 	__le64 tsf;
 	__le32 ibss_mgr_status;
 	__le32 gp2;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 60472c89fca38..b086300bbafed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1496,7 +1496,7 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
 
 	if (!iwl_mvm_is_short_beacon_notif_supported(mvm)) {
-		struct iwl_mvm_tx_resp *beacon_notify_hdr =
+		struct iwl_tx_resp *beacon_notify_hdr =
 			&beacon_v5->beacon_notify_hdr;
 
 		if (unlikely(pkt_len < sizeof(*beacon_v5)))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bace9d01fd583..c70b458ee2d60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1526,9 +1526,9 @@ static inline struct agg_tx_status *
 iwl_mvm_get_agg_status(struct iwl_mvm *mvm, void *tx_resp)
 {
 	if (iwl_mvm_has_new_tx_api(mvm))
-		return &((struct iwl_mvm_tx_resp *)tx_resp)->status;
+		return &((struct iwl_tx_resp *)tx_resp)->status;
 	else
-		return ((struct iwl_mvm_tx_resp_v3 *)tx_resp)->status;
+		return ((struct iwl_tx_resp_v3 *)tx_resp)->status;
 }
 
 static inline bool iwl_mvm_is_tt_in_fw(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 431f97c5aedc5..fdebe570ab8cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -309,7 +309,7 @@ struct iwl_rx_handlers {
  */
 static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(TX_CMD, iwl_mvm_rx_tx_cmd, RX_HANDLER_SYNC,
-		   struct iwl_mvm_tx_resp),
+		   struct iwl_tx_resp),
 	RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, RX_HANDLER_SYNC,
 		   struct iwl_mvm_ba_notif),
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2594e8a977e94..b75baa163ce2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1622,7 +1622,7 @@ static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
  * For 22000-series and lower, this is just 12 bits. For later, 16 bits.
  */
 static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
-				      struct iwl_mvm_tx_resp *tx_resp)
+				      struct iwl_tx_resp *tx_resp)
 {
 	u32 val = le32_to_cpup((__le32 *)iwl_mvm_get_agg_status(mvm, tx_resp) +
 			       tx_resp->frame_count);
@@ -1638,8 +1638,8 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	struct ieee80211_sta *sta;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	/* struct iwl_mvm_tx_resp_v3 is almost the same */
-	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
+	/* struct iwl_tx_resp_v3 is almost the same */
+	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
 	int sta_id = IWL_MVM_TX_RES_GET_RA(tx_resp->ra_tid);
 	int tid = IWL_MVM_TX_RES_GET_TID(tx_resp->ra_tid);
 	struct agg_tx_status *agg_status =
@@ -1895,7 +1895,7 @@ static const char *iwl_get_agg_tx_status(u16 status)
 static void iwl_mvm_rx_tx_cmd_agg_dbg(struct iwl_mvm *mvm,
 				      struct iwl_rx_packet *pkt)
 {
-	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
+	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
 	struct agg_tx_status *frame_status =
 		iwl_mvm_get_agg_status(mvm, tx_resp);
 	int i;
@@ -1929,7 +1929,7 @@ static void iwl_mvm_rx_tx_cmd_agg_dbg(struct iwl_mvm *mvm,
 static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 				  struct iwl_rx_packet *pkt)
 {
-	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
+	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
 	int sta_id = IWL_MVM_TX_RES_GET_RA(tx_resp->ra_tid);
 	int tid = IWL_MVM_TX_RES_GET_TID(tx_resp->ra_tid);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -1970,7 +1970,7 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
+	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
 
 	if (tx_resp->frame_count == 1)
 		iwl_mvm_rx_tx_cmd_single(mvm, pkt);
-- 
2.53.0



