Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216728;
	b=rZ2C6XvgH3KE5Ovw0cpLbPetzmPqCXMDOyHv+EVt6BaHg+/s0Ot6IKPrW6oBdnqTh9US
	 ImE5JtKEfL/oXRvv/nrLY292UzyXDCme/tHHZHcI7OHwawqcTrSyIEPHL9JGNdV3XDTWb
	 74T7vRTqAA1jeNCt/A+iDFImVg96PGouR3qEu1n6r0kLhMUMkVd7ipJgw2rasgipCrDll
	 07GDlVfmXl74i1qOgsTO85QTWm2Otw6aTW17gXexli/yKtCEt6hmLYtrnDYEkUDCkjpIA
	 A65ek4mHKR94Hncafz0Au4JTnldXqsC8mS9huDeu+2vfHCSMzKf5eBIEf1ysp8PKGTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iGB0ESMXQ9hdeHhR24H717j1E5QmscD2wU558eJ3Ns4=;
	b=NfO0ZpDlhBiRq/xgHgoo7Bsj64QfuAn3nogRQT1mnfr6KEG30oz9fgDoZvzecslqmIY3
	 fEDdq4ye1LzEwlqNfqIRujP268ML/QDQJwps/jCVHTuBVhL1VrQm4xqMk7Qp5N+Ta9P6y
	 0KMQa8uk+sbIyw6txdzO1rdf/NBpQGA/dyxSoW7n+FSj8sxrRrcujFInA43cx1W6Pnd3I
	 UgmjsTnNdxnOcexw4uQzde40D82bGHFrDXPUWFFboX6F7I8AKxRYoDaWHnrFBbrPU12Nn
	 8RglC+1cP7DeiUyhrofdn52521yOmuV7ZpKJFVbD0FjoJ6kX71QgIgBMNOut9ignYrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2S8bJig;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F454606A31A;
	Wed, 28 Oct 2026 19:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2S8bJig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9021F01825;
	Wed, 28 Oct 2026 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216728;
	bh=iGB0ESMXQ9hdeHhR24H717j1E5QmscD2wU558eJ3Ns4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2S8bJigZLlaLRuQeI5EVUxxYjs2AwHiCJDv+N0dtEd3QAiKWFrVjJN6T70hjXjDM
	 vLCFToDRFQuprMaMVWsIxVSH7TyKYk/WalAgLJqYgaLyNmJWPzw4VRrz4GJFfKJQus
	 mRH6R2fmjjU+y8ihLLiuBrcFFmR7/6P+4s2RvMUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1659/1887] wifi: iwlwifi: mvm: validate TX_CMD response layout
Date: Wed, 28 Oct 2026 18:02:35 +0100
Message-ID: <20261028170537.210876035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 35 +++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 456cd91d56216..a8036e14c0590 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1550,6 +1550,17 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
 			    tx_resp->frame_count) & 0xfff;
 }
 
+static inline size_t iwl_mvm_tx_resp_min_len(struct iwl_mvm *mvm,
+					     struct iwl_mvm_tx_resp *tx_resp)
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
@@ -1854,6 +1865,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int queue = SEQ_TO_QUEUE(sequence);
 	struct ieee80211_sta *sta;
 
+	if (WARN_ON_ONCE(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
@@ -1888,6 +1902,27 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
+	size_t min_len;
+
+	if (!tx_resp->frame_count) {
+		IWL_WARN(mvm, "invalid TX_CMD frame_count %u\n",
+			 tx_resp->frame_count);
+		return;
+	}
+
+	if (iwl_mvm_has_new_tx_api(mvm) && tx_resp->frame_count != 1) {
+		IWL_WARN(mvm, "invalid TX_CMD frame_count %u for new TX API\n",
+			 tx_resp->frame_count);
+		return;
+	}
+
+	min_len = iwl_mvm_tx_resp_min_len(mvm, tx_resp);
+	if (iwl_rx_packet_payload_len(pkt) < min_len) {
+		IWL_WARN(mvm, "invalid TX_CMD len %u (frame_count %u, min %zu)\n",
+			 iwl_rx_packet_payload_len(pkt), tx_resp->frame_count,
+			 min_len);
+		return;
+	}
 
 	if (tx_resp->frame_count == 1)
 		iwl_mvm_rx_tx_cmd_single(mvm, pkt);
-- 
2.53.0



