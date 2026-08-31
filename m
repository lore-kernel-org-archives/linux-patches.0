Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D104A2055;
	Mon, 31 Aug 2026 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183713; cv=none; b=ReHWUBVRle1A2rpxSgwxQ08VDkqSgNvtIEcRC0URe4O+C9wyyFKKciOmmMMTkLc8o0aCxkgGXnBAzmjHQMQeS9oHg2K5v/+0QSCSSEda8OxBTbR7G/MtUIsIwfRLfrjcBpvPSpj7m5J4ADScEC9+XhLleFtdbboknlo6SDu6X44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183713; c=relaxed/simple;
	bh=lG0ixKQ1mLCxQGPnXgn1lo1cOCb9q3hH11X63UuZKSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wt5+sMq72TxDU+dQ9AgQw138RH7zup/Jb9alfVeNlpXVCTxqjUTBJxVWVqeYmI8J1TuufnebngYFE7X1k+crEVMR78G0V5OJYOgXpmWhZkk1Mc6fyg8zqTjTD9WIU46HdpCpXT5O3vSbtbYPxSK4YHB1MZu2oeWoyLlCyatlvvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqZdnV5E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqZdnV5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239701F00A3F;
	Mon, 31 Aug 2026 13:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183711;
	bh=3NlhHbvyFPMU6mH5r1dGOqevBmHLJaKBG2LBztKcTZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqZdnV5EJBQy4hjrSgodr+nVMGulnJLU9RS4vbC8F3+hmKjVzJjj/7Y8GZuQHQdAU
	 8BWpTjK2JgrCCGvFVabdGVHU6MqWoKH2jf/uSxd1G7ytd3soNgzaRZn3AXYwgdtRiR
	 hLpRJ3QH4elVhEHrgs2FtnD0Aljcaz51WerU+3SjtmMszNF7JurxhtUdluf0yN4Qn6
	 lQ+M2xGTCBlho1jziiVK6Oteva90k+VBRpIPOz418zYQyT5i14G0bx7Nq/L0YhpFkA
	 ETIwR3PA1GnIiovsazJUj5Pqg0qyvlwn5JdtRq9y64PPi7F20nK20/ZBF2RR1s/MbC
	 mGoYQI8fEcDBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: iwlwifi: mvm: validate TX_CMD response layout
Date: Mon, 31 Aug 2026 09:24:47 -0400
Message-ID: <20260831133314.4125787-259-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 8d70881707b47353359df57df12f6de67fdacdd2 ]

TX_CMD parsing uses frame_count to walk status entries and then
read the trailing SCD SSN. Make the minimum-length check follow
that exact runtime layout calculation before parsing the payload.

For new TX API, reject TX_CMD responses with frame_count != 1 and
warn/return in the aggregation handler to document that aggregated
accounting is expected via BA notifications.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.0474ee89bab9.I84f151aabecb8921b587da092f29f78c47128f0f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background lookup finished: commit `5a6d47d1037f5` is on the
`autosel` branch but not in the checked-out **v6.18.44** tree.

**Verdict: YES** — backport this to 6.18.y.

The MVM TX_CMD handler parses variable-length firmware responses using
`frame_count` without checking that the packet is large enough for all
status entries plus the trailing SCD SSN. That can cause an out-of-
bounds read on a common TX completion path. The fix is small (34 lines,
one file), applies cleanly, and matches validation already used in the
MLD path and other iwlwifi handlers already backported to this tree.

 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 34 +++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index bb97837baedaf..30aee52bf9cb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1581,6 +1581,17 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
 	return val & 0xFFF;
 }
 
+static inline size_t iwl_mvm_tx_resp_min_len(struct iwl_mvm *mvm,
+					     struct iwl_tx_resp *tx_resp)
+{
+	struct agg_tx_status *agg_status =
+		iwl_mvm_get_agg_status(mvm, tx_resp);
+
+	/* The aggregate response ends with a trailing SCD SSN __le32 word. */
+	return (u8 *)(agg_status + tx_resp->frame_count) - (u8 *)tx_resp +
+		sizeof(__le32);
+}
+
 static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				     struct iwl_rx_packet *pkt)
 {
@@ -1884,6 +1895,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int queue = SEQ_TO_QUEUE(sequence);
 	struct ieee80211_sta *sta;
 
+	if (WARN_ON_ONCE(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
@@ -1918,6 +1932,26 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
+	size_t min_len;
+
+	if (IWL_FW_CHECK(mvm, !tx_resp->frame_count,
+			 "invalid TX_CMD frame_count %u\n",
+			 tx_resp->frame_count))
+		return;
+
+	if (IWL_FW_CHECK(mvm,
+			 iwl_mvm_has_new_tx_api(mvm) &&
+			 tx_resp->frame_count != 1,
+			 "invalid TX_CMD frame_count %u for new TX API\n",
+			 tx_resp->frame_count))
+		return;
+
+	min_len = iwl_mvm_tx_resp_min_len(mvm, tx_resp);
+	if (IWL_FW_CHECK(mvm, iwl_rx_packet_payload_len(pkt) < min_len,
+			 "invalid TX_CMD len %u (frame_count %u, min %zu)\n",
+			 iwl_rx_packet_payload_len(pkt), tx_resp->frame_count,
+			 min_len))
+		return;
 
 	if (tx_resp->frame_count == 1)
 		iwl_mvm_rx_tx_cmd_single(mvm, pkt);
-- 
2.53.0

