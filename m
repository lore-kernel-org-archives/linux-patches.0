Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A835C1BC;
	Sat, 17 Oct 2026 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258041; cv=none; b=OcftagFygyNgwEv7Ucm6sU0wDXBlwsp0TkDiVBoAiLInJgz5tENP3j9LTXkW65+KYFsfi4fJjRZHFj7YyKlyqsgtVJaeY7oqn84AYj8nbkG5Q1VHNNz2uVvfbd77qjVYDAXd+CT5z87sLsuz5D9lKYaoT7edAUw9FZxvSBNMsw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258041; c=relaxed/simple;
	bh=FL+mNAb/QPkIm/5hryUUov3LtQiKnk+Tt/EZrp0tX1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d57HcPODH/AAIaNlNwawwEQvCIIoI6WXRWcsf3r0IqQ6SSOg3atySvk6toT5gXguJw93+FH7vjE89PUdAeG97bESeCTDLKvxyWVRVvnwb/Z8/Iimsiq6GrGfDLTOiIL9Ry2bXOgaW+ldKoav/D9Dw6N4mZ6TTo9Uq7FbGeeANlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=savJPpWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="savJPpWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392451F000C4;
	Sat, 17 Oct 2026 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258039;
	bh=uj9kaEczUxIVakhctgzR+KwaOGHIs+JyVknuvP3439U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=savJPpWFsfIEKnvIsXopC7knbwIRLOlnPUZFNeAiIO2K6JBeGfcOal+4TUcF7QVS1
	 6qN1f1e4Q7g1JWwSsqk9ERhSQcEV7nkhImc6bxRK3pthBfEjtBI2ZegrWuU79xJ6Eg
	 jj4vIF3ChI9xVitfhTnbFJE7eLbbsx671ftaSYz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Yunchuan <yunchuan@nfschina.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0707/1674] wifi: ath12k: Remove unnecessary (void*) conversions
Date: Sat, 17 Oct 2026 17:49:39 +0200
Message-ID: <20261017160449.254046490@linuxfoundation.org>
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

From: Wu Yunchuan <yunchuan@nfschina.com>

[ Upstream commit e5e8b38f0c05a3d0edba76bdee00e753067f4281 ]

No need cast (void*) to (struct hal_rx_ppdu_end_user_stats *),
(struct ath12k_rx_desc_info *) or (struct hal_tx_msdu_ext_desc *).
Change the prototype to remove the local variable.

Signed-off-by: Wu Yunchuan <yunchuan@nfschina.com>
Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230919045142.524226-1-yunchuan@nfschina.com
Stable-dep-of: ecfc13138992 ("wifi: ath12k: Avoid memory leak while enabling statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 12 +++++-------
 drivers/net/wireless/ath/ath12k/dp_rx.c  |  2 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c  |  5 ++---
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 69bf75ebd7518..97f068b0ae7f1 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -13,8 +13,7 @@
 static void ath12k_dp_mon_rx_handle_ofdma_info(void *rx_tlv,
 					       struct hal_rx_user_status *rx_user_status)
 {
-	struct hal_rx_ppdu_end_user_stats *ppdu_end_user =
-				(struct hal_rx_ppdu_end_user_stats *)rx_tlv;
+	struct hal_rx_ppdu_end_user_stats *ppdu_end_user = rx_tlv;
 
 	rx_user_status->ul_ofdma_user_v0_word0 =
 		__le32_to_cpu(ppdu_end_user->usr_resp_ref);
@@ -23,13 +22,12 @@ static void ath12k_dp_mon_rx_handle_ofdma_info(void *rx_tlv,
 }
 
 static void
-ath12k_dp_mon_rx_populate_byte_count(void *rx_tlv, void *ppduinfo,
+ath12k_dp_mon_rx_populate_byte_count(const struct hal_rx_ppdu_end_user_stats *stats,
+				     void *ppduinfo,
 				     struct hal_rx_user_status *rx_user_status)
 {
-	struct hal_rx_ppdu_end_user_stats *ppdu_end_user =
-		(struct hal_rx_ppdu_end_user_stats *)rx_tlv;
-	u32 mpdu_ok_byte_count = __le32_to_cpu(ppdu_end_user->mpdu_ok_cnt);
-	u32 mpdu_err_byte_count = __le32_to_cpu(ppdu_end_user->mpdu_err_cnt);
+	u32 mpdu_ok_byte_count = __le32_to_cpu(stats->mpdu_ok_cnt);
+	u32 mpdu_err_byte_count = __le32_to_cpu(stats->mpdu_err_cnt);
 
 	rx_user_status->mpdu_ok_byte_count =
 		u32_get_bits(mpdu_ok_byte_count,
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 56dda76d066c3..7fef0e8f9d924 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -3808,7 +3808,7 @@ int ath12k_dp_rx_process_wbm_err(struct ath12k_base *ab,
 			continue;
 		}
 
-		desc_info = (struct ath12k_rx_desc_info *)err_info.rx_desc;
+		desc_info = err_info.rx_desc;
 
 		/* retry manual desc retrieval if hw cc is not done */
 		if (!desc_info) {
diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 474e0d4d406ea..dde652dd37cae 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -106,11 +106,10 @@ static struct ath12k_tx_desc_info *ath12k_dp_tx_assign_buffer(struct ath12k_dp *
 	return desc;
 }
 
-static void ath12k_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab, void *cmd,
+static void ath12k_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
+					     struct hal_tx_msdu_ext_desc *tcl_ext_cmd,
 					     struct hal_tx_info *ti)
 {
-	struct hal_tx_msdu_ext_desc *tcl_ext_cmd = (struct hal_tx_msdu_ext_desc *)cmd;
-
 	tcl_ext_cmd->info0 = le32_encode_bits(ti->paddr,
 					      HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO);
 	tcl_ext_cmd->info1 = le32_encode_bits(0x0,
-- 
2.53.0



