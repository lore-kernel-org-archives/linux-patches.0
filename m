Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017361;
	b=cFX7ImtK/RXEUmAUsi2mvnhCUTFj0a56QUNOxdCsKBYHOBve8IE/ADQobIcwsCTeQ4gh
	 Vcu4Cnfxd6W63zY7LPn1MGIZ3hzdIS9Zjhgboyliocb8w7hFbKNKLrEE7OGG8+PZ4zxT4
	 JRRFJrJB7b8IdmHlCcCFeE/QDlY3a3j5G67yKXQjaM41UP62tPAWes2j8OPem+r9iWmQV
	 w+8JxSGu8BlS0sAuCnmDHOeSSPiq/IC4RJKTPz0Tg5pFQhDipouaQJrzNFTj0fZ3iBOXw
	 4pKAYckA1vpbOu/R2tfUm277VpF5y4sgfAIqzTGTMhpf1Ow4XIcOC2uiBC6zTETNmmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUszaNODiWW+VglhqHgyBpgY5CnVMaq7xDETL4sc4aU=;
	b=jaY3/kCF90mvgQsQ/ath3+8L0pu+H4gGh3ei3fUndQacf7YiU6W/WXwW18fQklp/TTdC
	 BGzgmniFkAckbo9NcYHK66HPBotXPogceM6GoOpZ/A1pyBsSr80uZkfWTzwQ9/ceBZHjG
	 cs4bkUU0kOUff9ocWLbPhQnNXon9HCAkFQslQbbYEM+dUYwncXyJftK2eVzCp89Dnxeav
	 oZjGduz0oMUZqG1Toy3gwNDfYd2REHm2iMxoZpVfN1q9ZhJYYXpLyge+tOTqMgb2tdu2d
	 NZxMF063uxiBOYEdKtVhNUwlvWiqROJ7RfDm+ywiimtzEGrc+CKBk+JqzuffYgt3ibA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyaZQIY1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E267606A31C;
	Wed, 18 Nov 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyaZQIY1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F37D1F000C4;
	Wed, 18 Nov 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017361;
	bh=nUszaNODiWW+VglhqHgyBpgY5CnVMaq7xDETL4sc4aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyaZQIY10Pod7fO5Uvp/WmWJWmSizEnu+Du91/wWHdzINdzXyz27vncvwjILr/Wg8
	 Cf0t10r1VYbUkPv4YB4ZStZ1y0cqEvfyh7Vlr/WD1qhfwJ7gBpDsEQGVRjwZ3Fk2pf
	 u0bDlJUlhOi3quIbVkZPXBKfsvAmAIbT5cNDRooI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0856/2651] wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
Date: Wed, 18 Nov 2026 15:34:56 +0100
Message-ID: <20261118150318.685611747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 97b144b82e2388efef1f78269626d61de0480feb ]

ath12k_dp_mon_comp_ppduid() updates *ppdu_id and returns
msdu_ppdu_id to indicate that a PPDU transition was detected.

When PPDU IDs wrap around, msdu_ppdu_id can be 0. In that case
the function updates *ppdu_id but returns 0, causing
ath12k_wifi7_dp_rx_mon_mpdu_pop() to interpret the result as
"no PPDU update" and continue processing the MPDU.

The MSDUs are then linked into head_msdu while their RX
descriptors have already been detached. Later,
ath12k_wifi7_dp_rx_mon_dest_process() detects the PPDU
mismatch and exits with the partially built MSDU chain,
leaking the SKBs.

kmemleak reports the leak through:
  kmemleak_alloc()
  __netdev_alloc_skb()
  ath12k_dp_rx_bufs_replenish()
  ath12k_wifi7_dp_rx_mon_dest_process()

Fix this by returning a boolean value from
ath12k_dp_mon_comp_ppduid() so the update notification is
independent of the actual PPDU ID value.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-6-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 15 +++++++--------
 drivers/net/wireless/ath/ath12k/dp_mon.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 7d5be77b081f8..db20d27b63338 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -81,24 +81,23 @@ struct sk_buff
 }
 EXPORT_SYMBOL(ath12k_dp_rx_alloc_mon_status_buf);
 
-u32 ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id)
+bool ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id)
 {
-	u32 ret = 0;
-
 	if ((*ppdu_id < msdu_ppdu_id) &&
 	    ((msdu_ppdu_id - *ppdu_id) < DP_NOT_PPDU_ID_WRAP_AROUND)) {
 		/* Hold on mon dest ring, and reap mon status ring. */
 		*ppdu_id = msdu_ppdu_id;
-		ret = msdu_ppdu_id;
-	} else if ((*ppdu_id > msdu_ppdu_id) &&
-		((*ppdu_id - msdu_ppdu_id) > DP_NOT_PPDU_ID_WRAP_AROUND)) {
+		return true;
+	}
+	if ((*ppdu_id > msdu_ppdu_id) &&
+	    ((*ppdu_id - msdu_ppdu_id) > DP_NOT_PPDU_ID_WRAP_AROUND)) {
 		/* PPDU ID has exceeded the maximum value and will
 		 * restart from 0.
 		 */
 		*ppdu_id = msdu_ppdu_id;
-		ret = msdu_ppdu_id;
+		return true;
 	}
-	return ret;
+	return false;
 }
 EXPORT_SYMBOL(ath12k_dp_mon_comp_ppduid);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.h b/drivers/net/wireless/ath/ath12k/dp_mon.h
index 162cdcaa57a77..f352655eae9de 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.h
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.h
@@ -100,7 +100,7 @@ struct sk_buff
 *ath12k_dp_rx_alloc_mon_status_buf(struct ath12k_base *ab,
 				   struct dp_rxdma_mon_ring *rx_ring,
 				   int *buf_id);
-u32 ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id);
+bool ath12k_dp_mon_comp_ppduid(u32 msdu_ppdu_id, u32 *ppdu_id);
 int
 ath12k_dp_mon_parse_status_buf(struct ath12k_pdev_dp *dp_pdev,
 			       struct ath12k_mon_data *pmon,
-- 
2.53.0



