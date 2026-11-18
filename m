Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031521;
	b=b36gyh+nggmSCiqPZQSaoikSZY8/KRiBRgBwQhIifXZnhVzDXd1sxSApqK0C20KcZdNU
	 X+o5pE+N7RQIRUeMXCYuSPcWGXLjUtir46fFiV7hjZevGWAFBFjOGf8eoJXKkgADQwM8n
	 df/lhz13vu3liyVUgvQJWYO+T4nc2QHm9kyItpRoa9cW3AESUIM7oSoGPqY8jaWVOIV1e
	 /BKoDzGsASnUQEDbUn8A8H09YO6DgZRlV9L0GexQUFz4vzBu+GhO+0zscEZzv2oasvYc/
	 TJAbSVYXD/sKaAz8qw/E9uiZjCvD9975eaDdbuR08yN2VjEg2JMdHOfUuCo8aBwIZiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=biCKF9JVCu8jYrrfd7RtdYgssIWhr5rTPSRqbYwzATI=;
	b=iFdsWnVhB/gKDj8BniBgt4Wo5OwVVHFPjuNK/4ba8Ki1TSaJcKVYidws/m9Na8tqY/Tk
	 0UY/WZqi/tL2jbdO3JzphyaZdbtEqXRklHipPWjbwdahDgkfGeHRuyFFP3LSN2lwbRvOD
	 6GR1z4JawkpcTLSIx8km4kQn1PC7j/RKHGbLFOmQVFI9QmxwySNMYVd/xsmAt1k0++7Mr
	 spDBLGed8y9wq8WnGa5aty8Yp9zGNFmxiBKm9ZPse/tD54shx9aH/bs3spwteVQVzyth3
	 x7EMdoNrVE7+g+P3F63WQzSZUzXfHUUqLBIfQ2LECHYuVP+EOoeMqjGo+73NoVjWrPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDrSBVCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8DD606A32C;
	Wed, 18 Nov 2026 19:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDrSBVCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E170D1F000C4;
	Wed, 18 Nov 2026 19:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031521;
	bh=biCKF9JVCu8jYrrfd7RtdYgssIWhr5rTPSRqbYwzATI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDrSBVClDQ7T5DsGmgtSkvka6qRD6u3e2YLXgY8IFq5vcx12TJjyZmdvw5o3LMcup
	 dyyw/uOcj8HD1ufZT8Bbx09tKrC8SPdFp/d0W6VlPXMzyMOeHPR5BMwmX58vspJgJy
	 hyuRFFsTQGaQGZGPvgxKL2iuCa2USOHY44qUdh78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1087/1756] wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:53:34 +0100
Message-ID: <20261118150053.462499391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 706fab4b54262..1d0c9c599b4be 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6035,16 +6035,18 @@ void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
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
@@ -7100,8 +7102,7 @@ static void ath11k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	ath11k_peer_cleanup(ar, arvif->vdev_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath11k_mac_vif_txmgmt_idr_remove, vif);
+	ath11k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	for (i = 0; i < ab->hw_params.max_tx_ring; i++) {
 		spin_lock_bh(&ab->dp.tx_ring[i].tx_idr_lock);
-- 
2.53.0



