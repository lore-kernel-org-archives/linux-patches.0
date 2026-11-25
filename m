Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622783;
	b=yafC14z/pI9+7uSQoqsKzyRDhNO6PBVfiHAVn6byVIBQAzOOLjOEbMe2R+2QfgORY20M
	 PWehB0G1+eTQpUO+wuN6mkooCKKkWGJWr89edUO/lPvUVsRaZx31tU91mrb0lKM6Ep73L
	 syBNbQSTXuoP2DMcCl9tx2W18P+2BW4YMpeu89tRRzyjVUd/1XARGe7D3ZD2pP+59ai3M
	 nHtJbzQgJxhei5YeFFgR5tecZ0PA++WMRev4GvJy43SsIRKCO6UvCp+eLtKq3497bvZzE
	 wCDCihWUPLBWwlksxZiDIbjw9aQHrYpjhdQQwh2ixMq8MZIK9w8OXRF6PmbkBBY++Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0YVdEyP+hkH62w83WFjXPGAioZnole+FZAqKYYuDdU=;
	b=3Jwur9a36K2XXBfC7kKp1quwuBTUh+2Np8N//2MPvz8mTl8D15cW92tCbTKg4OTUEIvl
	 pu0VpxSM7AB4YA0iBnziF8KTG/MWCRokGnvI5R/rRS8r5J+H7HgEoCrs1mvKoiQL80LGh
	 tyH/iP2iWHogeuSyGqavyzC2uVB5dpEk26ISxav9CIuygb5sZjkOONu6ttKo9en3jOVEI
	 a2Hjy3d3ZH4Btmf15Jqd8bQsoSx9+7rTcLVQ2y2a15mBhAbvaGnBzMCRNsQvQgu7mEu/w
	 T8wwQbbZfR1qUx7b7//krbkZXUAC4AbTO1ekkOZ1jaLIswyaqBNXBgo90b/I9R8EaZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lvc4ze90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F847606A31E;
	Wed, 25 Nov 2026 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lvc4ze90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CC51F000C6;
	Wed, 25 Nov 2026 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622783;
	bh=f0YVdEyP+hkH62w83WFjXPGAioZnole+FZAqKYYuDdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lvc4ze90LgCXq+Rs/3D8Buav6VOnqP2g0gnNfe45T4FBYM2nbHwtqPrl2So95wWzo
	 iXJGKNdKjLV+Z1JFqc1dSC8JmrIFxPshZ5k8lVd1N3UPvFP9/NSnL4+RjelAavG6mr
	 hPpxTWjrGDmGseZhLpKciXg43nBNI6vy58OKo+Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 591/990] wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 25 Nov 2026 15:32:38 +0100
Message-ID: <20261125143835.935071752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit 94c7b50351fd30e1dfe1b4051197a1445d8547e1 ]

The pending management TX cleanup walks txmgmt_idr with idr_for_each(),
and its callback removes the current entry. This can invalidate the
radix-tree iterator retained by idr_for_each().

Use idr_for_each_entry() so every iteration starts with a fresh lookup.
Continue to remove each entry under txmgmt_idr_lock before freeing its skb,
preventing concurrent TX completion from finding a stale skb pointer.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-5-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: adjusted context lines in core.c, mac.c and mac.h to match the older tree; the functional change is identical to upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c |  3 +--
 drivers/net/wireless/ath/ath12k/mac.c  | 12 ++++++------
 drivers/net/wireless/ath/ath12k/mac.h  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index dc969b2516ea0..8a11ff7fb58fc 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1468,8 +1468,7 @@ static void ath12k_core_pre_reconfigure_recovery(struct ath12k_base *ab)
 			complete_all(&ar->regd_update_completed);
 
 			wake_up(&ar->dp.tx_empty_waitq);
-			idr_for_each(&ar->txmgmt_idr,
-				     ath12k_mac_tx_mgmt_pending_free, ar);
+			ath12k_mac_tx_mgmt_pending_free(ar);
 			idr_destroy(&ar->txmgmt_idr);
 			wake_up(&ar->txmgmt_empty_waitq);
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index b9c943b219546..13a7d60c50c7c 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8476,13 +8476,13 @@ static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
 	ath12k_mgmt_over_wmi_tx_drop(ar, msdu);
 }
 
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar)
 {
-	struct ath12k *ar = ctx;
-
-	ath12k_mac_tx_mgmt_free(ar, buf_id);
+	struct sk_buff *msdu;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, msdu, buf_id)
+		ath12k_mac_tx_mgmt_free(ar, buf_id);
 }
 
 static void ath12k_mac_vif_txmgmt_cleanup(struct ath12k *ar,
@@ -13977,7 +13977,7 @@ static struct wiphy_iftype_ext_capab ath12k_iftypes_ext_capa[] = {
 
 static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
 {
-	idr_for_each(&ar->txmgmt_idr, ath12k_mac_tx_mgmt_pending_free, ar);
+	ath12k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index 1f689e367c8a1..0d75fae5c7bf7 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -172,7 +172,7 @@ struct ath12k *ath12k_mac_get_ar_by_pdev_id(struct ath12k_base *ab, u32 pdev_id)
 
 void ath12k_mac_drain_tx(struct ath12k *ar);
 void ath12k_mac_peer_cleanup_all(struct ath12k *ar);
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar);
 enum rate_info_bw ath12k_mac_bw_to_mac80211_bw(enum ath12k_supported_bw bw);
 enum ath12k_supported_bw ath12k_mac_mac80211_bw_to_ath12k_bw(enum rate_info_bw bw);
 enum hal_encrypt_type ath12k_dp_tx_get_encrypt_type(u32 cipher);
-- 
2.53.0



