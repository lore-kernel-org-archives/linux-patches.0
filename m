Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041408;
	b=M7JZjOAf5uc7ngIQYk/LVjp5sebUXtl1i3J9GbXljnL4JYctx6PznahjzY9qWgwJRiXb
	 BSWaV+KJY2XNj0ggzcdBzJCifioMqBaAhOzVp1tHDd64dUR6QDfG+GSMxrzPpQfHElhEH
	 4bjJsbbCw1QFh2yXdcD5hxlbeFojFQZ0U1IJD6coRWiltrrksEvjCRttkkv3fmXiGiS56
	 VKAE2cJaK3jxHrpQCIYy23NlmqgrhebX3IOiyR8mZbW4A8Zoofapr9o36qS/kIOEJyHuQ
	 /gc9rIow2e5ek3HPn9E+95u/GKhRIFDm532L5q/gYth7gbUSaN8RxILGRxFPbqFguRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfCWpo8OTmWUhOynslCwxhc6uUS+DZn1MKQbaiuhRfs=;
	b=pqc70haJfFFiRixoujcDiQ8kQHyamFMmgZ9XnOFo0AkLuLvMs/x3jBAeNiR/6cyV5D0Y
	 okm1DbYQ0LCUgnNwu5ony6yedojSeghMvkojy1aaItwAKAD/Dhj+h3XeqCjojvfjcG/Ev
	 g4UCC7uOQxJD7cLO904rWL30lE/G2rizGDk+y/imyO3YvVge+fxMVNs2OZ16MlLVwHC9p
	 9uma66umPSufyFbsswHugDUdPP70J0Nh7DHMGczciICVaJ4zyBAXKUSCo/gdmSlwantms
	 bYiK3QXHU/IsaaCzUUG3vHHcWpkO8F+phk1lWJHSKbQHkuyWDiBq+KK8U4+vE0QQWVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OBS83eZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D70E606A320;
	Wed, 18 Nov 2026 22:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBS83eZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728001F000C4;
	Wed, 18 Nov 2026 22:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041408;
	bh=nfCWpo8OTmWUhOynslCwxhc6uUS+DZn1MKQbaiuhRfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBS83eZ/eXI2vZgpkD/hnC6WibCMXqWTCUKdHErOBtLjXL1WylTXKDXB8Xj51qUGN
	 ST8oZVe8y4j1+7RlnsTAG8quXYlwEbimS7EIuO3FAe7TLUmZ9ioOU266Tevak0/VDO
	 t+NdNLsAjd9iXc2PZ3qN/2yTDnKZ1VbAn26aLY1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2762/3318] wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:56:24 +0100
Message-ID: <20261118150443.585768308@linuxfoundation.org>
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
index 010413bfdb141..2c29aa63dfb07 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4773,16 +4773,18 @@ int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
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
 
 static int ath12k_mac_mgmt_tx_wmi(struct ath12k *ar, struct ath12k_vif *arvif,
@@ -5635,8 +5637,7 @@ static void ath12k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	ath12k_peer_cleanup(ar, arvif->vdev_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath12k_mac_vif_txmgmt_idr_remove, vif);
+	ath12k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	ath12k_mac_vif_unref(&ab->dp, vif);
 	ath12k_dp_tx_put_bank_profile(&ab->dp, arvif->bank_id);
-- 
2.53.0



