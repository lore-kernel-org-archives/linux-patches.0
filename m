Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061489;
	b=nzlKs59rJ+b8kmvT8JlTbltJzYuszpd2KggjZLvSMiNNKY0aVPKTID0d/dhEyCZbcm8D
	 IgkD40u+sqd7PSWwIfH08a3JjNE+InOQd+fOZACkcpJ8ykYKzppYZvDL6cIfOfKNAuzjx
	 PK+rhnR4fGoQyRKXy9HEiIt2/dt5m6li4Syy8nAOke021SzoUeWkdn+snJ0HvR+wvWk4q
	 5OEMB7+RGh0iOzcbNVG8V6sWNHTN64csHTI5ymFP1YgnnewV2uF7PgjLlExQGh0JiWPu4
	 EaxybDtsVYDlxYH/UP7iTZJaZF4reyGyPywlTLf+t6a2gNx4Fm449fxTUMUhb/kzijw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ei/J9Y0U/1CZOAcGzsCr2GB9JPMrIY7II2sUTxmLTFA=;
	b=jyEYeaqyLhkKCEDVKVq698yRzjI8WUNaV0cG80VRFzhZjuUhC5PQW/eTau8kqjuoy1BL
	 kKWwuhwje0Og/EV7H+ZhTTG/LdlP8HIkoxDvEAbQ4NzYXflS0SHMnHy24DISn4oBRD+9e
	 o8xh0N2hrpU+LRi1MPTbXOY9j347VLJuzi60Q54Zl8L8nuZebTFDqs1WfLOVjkDCxkIL5
	 8TcEPZj4vqz0arcUtwD/SI+XT5WC2y3xBCYhoDPiUbwp4T0f1JyElrBygl5QInCoBCJUg
	 hfDkw16KguyhIk6q1VDIHJ9XcgXxtSlN8ZO9WnVgCuALR/iiXexuK5V3z5KF3JG7r5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDnctuLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC543606A33E;
	Thu, 19 Nov 2026 04:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDnctuLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341F31F000C4;
	Thu, 19 Nov 2026 04:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061489;
	bh=Ei/J9Y0U/1CZOAcGzsCr2GB9JPMrIY7II2sUTxmLTFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDnctuLVhDH7iqLh+VH6kiWrDHr5q9u1hC9PrbfzJ4sYDpaIPSv1TMe6LDe/s3V+x
	 Phkth5D7O8qbOrYAR334OSZIxcSdPrRg0sitgqfD0YOQv9/OinyfAG8bIaM63dZecK
	 n1kR/Hg2ckbg1Mzdo9rkmyAo3d7EGQIgtrPqmEis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1571/1848] wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 16:00:09 +0100
Message-ID: <20261118150025.322899483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bd1a9b15e0ac8..a2a33dceae82c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3928,16 +3928,18 @@ void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
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
@@ -4716,8 +4718,7 @@ static void ath11k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	ath11k_peer_cleanup(ar, arvif->vdev_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath11k_mac_vif_txmgmt_idr_remove, vif);
+	ath11k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	for (i = 0; i < DP_TCL_NUM_RING_MAX; i++) {
 		spin_lock_bh(&ab->dp.tx_ring[i].tx_idr_lock);
-- 
2.53.0



