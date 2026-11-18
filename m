Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026269;
	b=Uysu+J+HVrzZAAO+1gNXA9kwgCAdTHLyfBc0/qD3yRC/wD6Tpt/Z1Qw/wo3NJGZBQUzb
	 qFhj68VWTRf5aeoo+1zs7QvHtdtlXZFULiw8NIofKO8y3J4+3UuSayYKdnlamLZFgOzVZ
	 iQk/dK/Jg8l3BNVibmgmTfJcOChTZX2m74+IJweo/b+mnMotRrO1m6Ge7fykEQ9VBlN4r
	 2Lxd1CpjwCof2l3lIsehhQ/vzjURrdp053L96WwkvVtgC35GMg/L0hwl0+1UQX8VqobYs
	 w5ZN4Tl9e/GjPzbqcYkWg1GI2SBYD3IorPLGMIlYvUTSDxx8wruI97cr87bjLbozsYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BrnY41pGIMLYnJHRQNpnkfegHVjqIxVsg/XLNpca3jY=;
	b=YDC409KaGT3RTS4+lrJBLC39FvK3ARB0Lfrn4gqDl6Qtvjx0eLilrpjlHqQaGwZ3OSBv
	 SGTmbmW/+21gZi6BgSk4CN9v7y7t9sdq7s1eQyQwSLyxqu31C37atw6FQ5Q8r+YegtLbc
	 larlqRaNennh0eukx0Gg2uRGaRsMjsD3XgijXViHmviy2y4rcsSJZowTLlS4qRhBJ9s+D
	 rKufOE5FXaHQVNoDUAQQM3IsnFqAdHSQZbV7ymS9H7xm0rDswiI30HO/yX+wCT3TLn1g4
	 WbBQNS00tDyQU0gXc7JXbwVX59r3cGHRF/EoeSIlhBrB52Ue8W80uLM8+LS3+AfW5IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnmoTRUw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE88606A32A;
	Wed, 18 Nov 2026 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnmoTRUw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8D31F000C4;
	Wed, 18 Nov 2026 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026268;
	bh=BrnY41pGIMLYnJHRQNpnkfegHVjqIxVsg/XLNpca3jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnmoTRUwzjWpZaF2l3TrkAuc485zM0vCweqc4VIUFIoExge7eUNmQxfkb6zK6JKZ0
	 k5zTbnrqZfkkXz5VVht5r7eNGPvmO27hP7A2xrU3u1mDBx+YfmrFsK0JK/5AFlNOC5
	 r4ehTrRRLDccEQWHDb+fgrDb1bM50jWhuzSP80Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1373/2151] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150212.034544327@linuxfoundation.org>
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
index 38ac5b820a2ce..620cb9ab3ec09 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2417,8 +2417,7 @@ void ath11k_core_pre_reconfigure_recovery(struct ath11k_base *ab)
 		complete(&ar->thermal.wmi_sync);
 
 		wake_up(&ar->dp.tx_empty_waitq);
-		idr_for_each(&ar->txmgmt_idr,
-			     ath11k_mac_tx_mgmt_pending_free, ar);
+		ath11k_mac_tx_mgmt_pending_free(ar);
 		idr_destroy(&ar->txmgmt_idr);
 		wake_up(&ar->txmgmt_empty_waitq);
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 60ffecd52280e..6f620265bf924 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6032,13 +6032,13 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
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
@@ -10244,7 +10244,7 @@ static void __ath11k_mac_unregister(struct ath11k *ar)
 
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



