Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031516;
	b=lIydBrgoWP7AFKiGtCpn2atRj+8IEKirIfsVaObbkd6nCbNjttRgkDhsJN8YBJO1AuuA
	 ofWeOFNGUYMC+HQoz40VjU1mYEBMYU1VWZTiC1FDu1q9UCSD9Cav/iDEhybqiqD2zX2/9
	 okumMgmfwvVFvnM3LJOFIWqe4c7/BqDMIGZEb3Ml4/qadloToJSRoAHIydOv4YbP6Fdz6
	 gYANlrVEYKaQYw8MD7f9Li2nTbmFBMkuZZ6F6ygcjbQ3SD1yuBCyiaQ4Nk376YeeyHl5T
	 ojue+ylaMda3rzV+FWDyLreieJDl0IOFPkj1CLBs+USWp4E9N5YeHvV34p02w3GVB6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9B4GLfvWXMTyZohALw39atpI8Q/qrJ7NxfzviegkJZA=;
	b=aJO//nWKSzeF4zXw7M0ZGDmjWCx3/L1AaPlK4eyCI5GVAnwTmhKn5aB2m9chcCMhoOnh
	 4h/hPDIbfmwaNvqvq20SzUPpRGijPjFThEx2wRLBpQZ/IM/465UZD/DOrvD9Qjl8gU84p
	 iGmVqPyqs0VTkds3uGMQz+Zc4yEXCYviiw1A4qL7FTmoWkvJGyygP+0ONwsgq0iXFCIoX
	 wkIdzZP8ZmNBTXp87JvstPbknGkZllFn9ZuCyZkN4ScVK0HmOI+d9moltO5JzJa4vRiX1
	 CnQ14z8st/LI5hNWhzEeJPbRNd82X2iFAnZDCvt3yqnL/h6vZqKzvrIPuzZWi9NgaIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNYUTk1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D73060A2601;
	Wed, 18 Nov 2026 19:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNYUTk1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521441F000C4;
	Wed, 18 Nov 2026 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031515;
	bh=9B4GLfvWXMTyZohALw39atpI8Q/qrJ7NxfzviegkJZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNYUTk1REVXWFuPcENAW1BuzA1hEYEeHPuv15FQofbvbtv3os1uTlKA/KpNVla9yB
	 jzgKhvbB+QfXjURUAaMYOr/CS2p4aFCFYfrpF4h/KbLg696LLZX5bczlXpHKnMVvvt
	 nEcXOhR3o7YRs+gq65OHvpSyqtpifEEpC9xHm/0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1086/1756] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150053.424555983@linuxfoundation.org>
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

[ Upstream commit 3e7f5d362b2b3a21b3adb4b860aad14b69a896ad ]

The pending management TX cleanup walks txmgmt_idr with idr_for_each(),
and its callback removes the current entry. This can invalidate the
radix-tree iterator retained by idr_for_each().

Use idr_for_each_entry() so every iteration starts with a fresh lookup.
Continue to remove each entry under txmgmt_idr_lock before freeing its skb,
preventing concurrent TX completion from finding a stale skb pointer.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-3-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c |  3 +--
 drivers/net/wireless/ath/ath11k/mac.c  | 12 ++++++------
 drivers/net/wireless/ath/ath11k/mac.h  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index bdadde90df9d2..11744dd3c71d4 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2122,8 +2122,7 @@ void ath11k_core_pre_reconfigure_recovery(struct ath11k_base *ab)
 		complete(&ar->thermal.wmi_sync);
 
 		wake_up(&ar->dp.tx_empty_waitq);
-		idr_for_each(&ar->txmgmt_idr,
-			     ath11k_mac_tx_mgmt_pending_free, ar);
+		ath11k_mac_tx_mgmt_pending_free(ar);
 		idr_destroy(&ar->txmgmt_idr);
 		wake_up(&ar->txmgmt_empty_waitq);
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d0c6f9f3f763..706fab4b54262 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6026,13 +6026,13 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
 	ath11k_mgmt_over_wmi_tx_drop(ar, msdu);
 }
 
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
 {
-	struct ath11k *ar = ctx;
-
-	ath11k_mac_tx_mgmt_free(ar, buf_id);
+	struct sk_buff *msdu;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, msdu, buf_id)
+		ath11k_mac_tx_mgmt_free(ar, buf_id);
 }
 
 static int ath11k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
@@ -10277,7 +10277,7 @@ static void __ath11k_mac_unregister(struct ath11k *ar)
 
 	ieee80211_unregister_hw(ar->hw);
 
-	idr_for_each(&ar->txmgmt_idr, ath11k_mac_tx_mgmt_pending_free, ar);
+	ath11k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 5e61eea1bb037..6dc769489c5c4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -162,7 +162,7 @@ struct ath11k *ath11k_mac_get_ar_by_pdev_id(struct ath11k_base *ab, u32 pdev_id)
 
 void ath11k_mac_drain_tx(struct ath11k *ar);
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar);
 u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
 enum nl80211_he_gi ath11k_mac_he_gi_to_nl80211_he_gi(u8 sgi);
 enum nl80211_he_ru_alloc ath11k_mac_phy_he_ru_to_nl80211_he_ru_alloc(u16 ru_phy);
-- 
2.53.0



