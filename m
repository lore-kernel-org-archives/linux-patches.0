Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026272;
	b=0ixylYeG7uJFTNJqP0jBt2n74ZxBtEAXxSv3getm3jIoKxX2jwt43D4BDEoIs7gRL0fu
	 NolUug8EDGuhtLXLLJaO98f5AWomRkiYjlNSf/W51Nj/OK3M+ON3R9g43eSpEP4tFu8fh
	 z1H/ETO2g+Db3+EoIEOS7l0Buzc63eZxFEdaHWuNjRZRbaTcHCg8gzvJ3X3utj61gXuXB
	 NYYXdlnTcMr4LYzI+1zTnMi89bmuJG2E99zG5Z2A4q61ee2O8urOGHoKc1D7PkQLq2puG
	 rJKCPQICpIs7sGIU2ZylyUi3xTHjr66LCjqotOac59P3scdVgUyRNt5xw1tWC2yw8YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuGYXyPeE5ckrK1eF9tkKOxB1g+XbHWiDPjt5yqwXDM=;
	b=1pCSnEdAwJuKwgT8cJb7kFqnrlOwhU5QLu45UB6QMi6jJJROHa+cqlhy1P5g8i8ZUZfl
	 EVRZYOEWhR9rOi4kN8ziF+GxK+bA4Ey2kW1hfLV45Bi1FPWbpvIX5i01x03nxvhdNHIdd
	 uDEzrkhQpoJUvEgJZcXCPr7OToHkuCAg9kpdQrj9/VFOIxzrd2jNF/3pSeJxUIqvmMpep
	 SuQAJePJyJiJO72VPGqkf5EdVUwsA7Wcml768dwIP58X3qTvs7rz9jCXuOiLCu8SnRrAD
	 nj3lgprBC0XfrOsGMUT6zeBpOWZWrRITP0zYpsG3S4SH9q2/8UjgwBry3frvq86bHaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMZnPqsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2727606A32A;
	Wed, 18 Nov 2026 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMZnPqsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC2E1F000C6;
	Wed, 18 Nov 2026 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026271;
	bh=MuGYXyPeE5ckrK1eF9tkKOxB1g+XbHWiDPjt5yqwXDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMZnPqsRVwbqWJ25X9ZJEcQy4VvneyyGK1/sH0T9TZ5qQ5RveoLvzOAi/+7GGw3xT
	 a6Muu/AK04GbwGFXd7Tv6O2wFr4ymj8y6Hjj1EYV2FekrhzivoA/2ptBjBjgW+VLPa
	 KOAZr+p0CCepYZchBpq/RJ2xM1Txg5RIkwknEC0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1374/2151] wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:51:49 +0100
Message-ID: <20261118150212.069221733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit dc29226dada34a6d19af77b4b51e90f8a3a8de34 ]

ath11k_mac_op_remove_interface() walks txmgmt_idr with idr_for_each(),
and its callback removes each entry belonging to the interface. Removing
the current entry can invalidate the radix-tree iterator retained by
idr_for_each().

Move the walk into a helper that uses idr_for_each_entry(). It performs a
fresh lookup for every iteration, so each matching entry can be removed
through the locked removal helper without retaining iterator state across
the removal.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-4-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 6f620265bf924..b47e86201a3b9 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6041,16 +6041,18 @@ void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
 		ath11k_mac_tx_mgmt_free(ar, buf_id);
 }
 
-static int ath11k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
+static void ath11k_mac_vif_txmgmt_cleanup(struct ath11k *ar,
+					  struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = ctx;
-	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB((struct sk_buff *)skb);
-	struct ath11k *ar = skb_cb->ar;
-
-	if (skb_cb->vif == vif)
-		ath11k_mac_tx_mgmt_free(ar, buf_id);
+	struct ath11k_skb_cb *skb_cb;
+	struct sk_buff *skb;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, skb, buf_id) {
+		skb_cb = ATH11K_SKB_CB(skb);
+		if (skb_cb->vif == vif)
+			ath11k_mac_tx_mgmt_free(ar, buf_id);
+	}
 }
 
 static int ath11k_mac_mgmt_tx_wmi(struct ath11k *ar, struct ath11k_vif *arvif,
@@ -7103,8 +7105,7 @@ static void ath11k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	ath11k_peer_cleanup(ar, arvif->vdev_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath11k_mac_vif_txmgmt_idr_remove, vif);
+	ath11k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	for (i = 0; i < ab->hw_params.max_tx_ring; i++) {
 		spin_lock_bh(&ab->dp.tx_ring[i].tx_idr_lock);
-- 
2.53.0



