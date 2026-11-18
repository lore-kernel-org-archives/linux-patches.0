Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026412;
	b=BffsV8DTslTETuGFl71TQoztvbI+I9S9Zovw8nG9Z1eCm6TFiV+h3TyD38Vzy0h5Ib3e
	 1dUupFhNNUZ5JM8gSYEJ2J+B2zlzrtjXzw4+e87D52Ev0e+UVuLPiI6/WxbdB4iNFouij
	 iO9zVvgdOl0tMwAX/T+jFbWrMY/hsQ8hyeFyP9ppFxkMg8jUxqHyVqFyDYU9E76z7tahX
	 qIDQj1gpVJfaIrECX82OjzPsVAq0bv7KzAhxLJrwXLWhUdAJH6oOJx0KIDRnQPPezuXV1
	 OYcyRXjU/dhG6YbpwpQboCjOEkzZye+M0Ej/RmB7WLtvb1H5f5sD56bdWYO9f97Yd7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hIpvTEjT9sDRbKiDntHNZvE75jI0/4XLUd/0XDEJdsE=;
	b=gM59iE+3ho3ZlpOeQc3hquSUrT3QHV01frX5jCixo5267DHLhxRSwS/YzeTBHiVlEHTi
	 dJGuMi9aGDwzXRmgyQDzaR+521WnR49tNAGsnGlgsHaP1/6LIP+PCcFIvFMXGOQkqjZSw
	 m49k484U+iOpW/AfN8dURj7Uv+UzD9dXObnq9cHRuqk7bbyme5CaMKyI1+96Perm56VvU
	 ye5BK3P7sXsuHZm6yObZ7CktE/qvblrPVr9JvnhOqlsOFKb7MNllSGo7huOVKLEHV1c54
	 CzBMYtNgth2iKXA21UWB3iVPQza4smBm2ZTR8XT9va6eOV26W+yVLHHEvzG2JdjIzLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLtIzJB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE2606A325;
	Wed, 18 Nov 2026 18:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLtIzJB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F621F000C4;
	Wed, 18 Nov 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026412;
	bh=hIpvTEjT9sDRbKiDntHNZvE75jI0/4XLUd/0XDEJdsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLtIzJB2bk8HsWqmClyF2SSraElakSojefy0648BvuRR87pOdecITw8ooENxEBa1A
	 3L7EA81DUojPWLCON2v3MtDAL90h/KLzUI9Ce04Mopucfhuq8Dz+DC1si5j4bgnHQO
	 N0wGwnUtwl0NYW2yqKj00f02dFpy2YAXYdlCFFPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1375/2151] wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:51:50 +0100
Message-ID: <20261118150212.102898717@linuxfoundation.org>
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

[ Upstream commit 4aa45334eb23d40bf31c43405daea9b73469f2a6 ]

ath12k_mac_vdev_delete() walks txmgmt_idr with idr_for_each(), and its
callback removes each entry belonging to the interface. Removing the
current entry can invalidate the radix-tree iterator retained by
idr_for_each().

Move the walk into a helper that uses idr_for_each_entry(). It performs a
fresh lookup for every iteration, so each matching entry can be removed
through the locked removal helper without retaining iterator state across
the removal.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-6-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 7f7eddfa97719..e10a3366cd845 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8316,16 +8316,18 @@ int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
 	return 0;
 }
 
-static int ath12k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
+static void ath12k_mac_vif_txmgmt_cleanup(struct ath12k *ar,
+					  struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = ctx;
-	struct ath12k_skb_cb *skb_cb = ATH12K_SKB_CB(skb);
-	struct ath12k *ar = skb_cb->ar;
-
-	if (skb_cb->vif == vif)
-		ath12k_mac_tx_mgmt_free(ar, buf_id);
+	struct ath12k_skb_cb *skb_cb;
+	struct sk_buff *skb;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, skb, buf_id) {
+		skb_cb = ATH12K_SKB_CB(skb);
+		if (skb_cb->vif == vif)
+			ath12k_mac_tx_mgmt_free(ar, buf_id);
+	}
 }
 
 static int ath12k_mac_mgmt_tx_wmi(struct ath12k *ar, struct ath12k_link_vif *arvif,
@@ -10198,8 +10200,7 @@ static int ath12k_mac_vdev_delete(struct ath12k *ar, struct ath12k_link_vif *arv
 	ath12k_peer_cleanup(ar, arvif->vdev_id);
 	ath12k_ahvif_put_link_cache(ahvif, arvif->link_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath12k_mac_vif_txmgmt_idr_remove, vif);
+	ath12k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	ath12k_mac_vif_unref(&ab->dp, vif);
 	ath12k_dp_tx_put_bank_profile(&ab->dp, arvif->bank_id);
-- 
2.53.0



