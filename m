Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041394;
	b=fVWiWF8kwrvNNSTJm1/mJyrEWDUmy2AoRPIsONj6ne7eft+cPm+X9PvzY9j/N9Tm+xOw
	 9sdSS/dj0fnkkwLbEycsnHdUi6Y0YrwmerzEfKdSbIreX9sjAX5EzStprLybgDIXSg6FK
	 2qwfKe9DLgNjuZLgd8W5tlEAXliWMCNs5wUiRpScp15wVlVkap24jK6hRw8chlYpVr10H
	 AjLj8V1WLZvI4Lux77m8EU4nFlt2vHwo7B74WuWX89cY0+YKcSv0la5kt5LZJ2nxnjjB2
	 F401AHwSSGQrefgVb2E+qNawF9JfR20afX6W74CtNTEXtP2IMu/OTSvOxkr0bOveEYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFHs1ttSZPEnGUjgpOvhkJuD/QlExflbT3z42LsSIug=;
	b=JnFp0PxUAMpBc7llEz33cuWg5ZbcNyL1BUD2CQEZXu0koYHNBMRS2g5fQ5tFVAziE9t8
	 VgfhkXvc1cxFjaxu64XkyEQk4LwhgKRKnlRXQlizvlPvazfoAOD3IOR0fJfiwi2pDqoSe
	 t+Z4LL+nWJslDYfG4WlQgSIUml5VDcz2GZkK8yRnybHeT9W1xx0xf7rrVIVu0GquSWhzT
	 77R53TnjDL14f0MpTwayv+Esg4DfiE9axCdqL0Utt4/GTCz16PsmojZNHyGH3LywVUw2g
	 d5vBA/0sHsLFlW/v0xmbmI95oUDEnAMnu8tr+YtUFezI7DXnot7M8R3djFSnBxG+c7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5tVPf0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A06606A32A;
	Wed, 18 Nov 2026 22:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5tVPf0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694551F000CA;
	Wed, 18 Nov 2026 22:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041393;
	bh=uFHs1ttSZPEnGUjgpOvhkJuD/QlExflbT3z42LsSIug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5tVPf0mIDt+h4KRsLsYTml8SB8TlfTBzW7Nan4NvIx5Xqdzm+/AG7O7IxT7tHZHg
	 KycYS0eZzqPVNkOY7V6NW0PGw7kQUnaOAO026H0u20Vkd9crnvXMXkocKfaWRI4zdn
	 79wfZaJtDt4zxldAMfuwY82SJE/h3FgKkDESqb5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2761/3318] wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:56:23 +0100
Message-ID: <20261118150443.556684602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5b0be210f98ba..2661d2bc8f259 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5855,16 +5855,18 @@ void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
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
@@ -6889,8 +6891,7 @@ static void ath11k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	ath11k_peer_cleanup(ar, arvif->vdev_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath11k_mac_vif_txmgmt_idr_remove, vif);
+	ath11k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	for (i = 0; i < ab->hw_params.max_tx_ring; i++) {
 		spin_lock_bh(&ab->dp.tx_ring[i].tx_idr_lock);
-- 
2.53.0



