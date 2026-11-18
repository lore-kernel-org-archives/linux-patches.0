Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056210;
	b=281TnqAlYDVFsRO13NU4tAAfhZPajGlKi2RUHzukXkyudDV77b2/6l+AOzTWwEys4Qf4
	 vexksSE78gTmcFnMCmk/DhSCWirAzMD6OtPKCagr/Sjix4teFf4aRnfsAhr9ClOXKNa8a
	 cTFqNZsFq3yDhzJBJQRXUo+IA98uIC+gp0IKWExpsQfTGcUS8DIz6QXVZFt58oFn7vsV1
	 eXGqA1/eG5SQxER34xotcS/z6WMqswYrS6TulTcBnZTBkxVPEx7nJ4zpeJrXp+d0KzsC6
	 vOskqCjxalTqVhUkC0yxUffkRmA/XaeNs9z4H6dRrISlMpRUc3P6rosxaBHRrBswCFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jt/Ot7mZyzA/JpUGBSQ73Ddzch/nl5pX0BihBJlttt4=;
	b=pil/l0dv27ntHum5C2rXhAnqwSswrniz620AnYIQ2krj3cKM8BtVIl4stwCRzwjY+ard
	 TqyV+qJKRRUXaRM+G032p32/D0UO2Qu+oIVKUkBJ8jiFSgldbEmF2kUIZ/wtWEwPeR0MM
	 y3/zdPjkYmfngGVLam0iGylDYvtI9aVPchV1jVjIUEOyZifn+g/ey+tiInvb5UViyqvP5
	 p2UUXzqWooGHf/PUMI87vXOoIBIl71jyoze2jzbDk5MXMO30XYD+pzWgIUIeJrL4DnVCJ
	 M8MPCA0wYFOziz6Vuhu4O0+LKTmCqL3A/7vBw6SNyImVzwx7NUqGiOpt5DcfvYka7jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKsjrdkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B1C606A31C;
	Thu, 19 Nov 2026 02:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKsjrdkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838F51F000C4;
	Thu, 19 Nov 2026 02:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056210;
	bh=jt/Ot7mZyzA/JpUGBSQ73Ddzch/nl5pX0BihBJlttt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKsjrdkG37nZNwuVzYzLiMCu6kVcaXI3F9t5n7nsBSeSYUmBJaKfFhoFL+Sf4xB7c
	 CQ3sIlkpfv5iBr4IPqbOi1C+0Es+/hkBBN61L0DBvfT5IQkso8vvsrpfW0aHxwl8Nj
	 EGpSkvJESq3zJrOOSM7trdKVQ+d4E4NLVQBelEio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1856/2214] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:58:52 +0100
Message-ID: <20261118150125.605737760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 01e2528fc9ca5..52d768fd5bda5 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1017,8 +1017,7 @@ static void ath11k_core_restart(struct work_struct *work)
 		complete(&ar->thermal.wmi_sync);
 
 		wake_up(&ar->dp.tx_empty_waitq);
-		idr_for_each(&ar->txmgmt_idr,
-			     ath11k_mac_tx_mgmt_pending_free, ar);
+		ath11k_mac_tx_mgmt_pending_free(ar);
 		idr_destroy(&ar->txmgmt_idr);
 	}
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index a13252fd16b86..9c4e5c31410bd 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4177,13 +4177,13 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
 	ieee80211_free_txskb(ar->hw, msdu);
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
@@ -6462,7 +6462,7 @@ static void __ath11k_mac_unregister(struct ath11k *ar)
 
 	ieee80211_unregister_hw(ar->hw);
 
-	idr_for_each(&ar->txmgmt_idr, ath11k_mac_tx_mgmt_pending_free, ar);
+	ath11k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 4bc59bdaf2443..032605bc42bce 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -146,7 +146,7 @@ struct ath11k *ath11k_mac_get_ar_by_pdev_id(struct ath11k_base *ab, u32 pdev_id)
 
 void ath11k_mac_drain_tx(struct ath11k *ar);
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar);
 u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
 enum ath11k_supported_bw ath11k_mac_mac80211_bw_to_ath11k_bw(enum rate_info_bw bw);
 enum hal_encrypt_type ath11k_dp_tx_get_encrypt_type(u32 cipher);
-- 
2.53.0



