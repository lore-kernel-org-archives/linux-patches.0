Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061487;
	b=NNc1KhPZcty7ChKMxxBwQR2SWmzVvDDbt8nleYINbNm5apilufPibUeOW6WWHzbMlEoN
	 lMfkTFBypAFm/c+NYv5H34MiHIenkgZmxllq+OXDVCnqJUf37gbunVC7pgpEVDiulqR5Z
	 jT2lvcFZjsn61Mvz5DWAOGtEi1I0zVEeZEYFPcb7Z827NKzNKvZxr6QnoRpMc8vKqOuLV
	 re+wVW00CuWJvUSqhUWVqjtD2fn0GwEEx+6Pfg5faSo9nJRTvGXrb8oMP8xpGdkWMFaeu
	 SpS7+7FhkEvsvkPMu6kygoP1dehA56c43+/9qslayH88vlFu/2uxhPguKCXFWUoQhCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2tDi3hEPsls//1cBN8ltUaQWr2Wp7omvSfStSmESp0=;
	b=zAp1PWOBbxT8HBRkshT6acQVYJ//xqEVjeD0G28gZ6/ALDOevIeMLfoAquAsxrBfb8mU
	 XQftMMrohqwbeV76su+MCxU6p+d5iQLbHakyI3InwQjvyH0AkKBiCCLsSDnWRQBgCdpx7
	 7e3Mb20Srdg5p5pzl3byecehh0IJk3uwmuceuR0bL2WxXtSROvJTa3SlvKxKkoOG7KZSy
	 PuBd6ynRkIbyCvZx+SdbHD4a3cvHWD7zfNsIzaanaPEkW4X4+yLrskcHhe9sR2S1Z08pI
	 9AibF/mpZcFcfHoAO/utLN2Ov7T2pWcaFm+NDRE50za3WvAp9Jk7KwKoRBI6cF5Uyxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztYFAOnF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFF260A2605;
	Thu, 19 Nov 2026 04:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztYFAOnF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864BE1F000C4;
	Thu, 19 Nov 2026 04:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061487;
	bh=s2tDi3hEPsls//1cBN8ltUaQWr2Wp7omvSfStSmESp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztYFAOnF/q37yNCUpIjfNZkR1/b1MLZD4bq3nuzkxwldAUvghhjblYzS1eso3dP/U
	 +lp4LHGnSIe+I3Z8JYZHBCfZfB6vz1vLVXYdPXYwrYn8LSiH3+N/YZc3zzOx/zFqdE
	 waAaFiGenIXkFHH7CDIftClOlGkjWgaymeHcqMf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1570/1848] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 18 Nov 2026 16:00:08 +0100
Message-ID: <20261118150025.287373801@linuxfoundation.org>
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
index 67c78ad2243b9..24fc7e6808c05 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -784,8 +784,7 @@ static void ath11k_core_restart(struct work_struct *work)
 		complete(&ar->thermal.wmi_sync);
 
 		wake_up(&ar->dp.tx_empty_waitq);
-		idr_for_each(&ar->txmgmt_idr,
-			     ath11k_mac_tx_mgmt_pending_free, ar);
+		ath11k_mac_tx_mgmt_pending_free(ar);
 		idr_destroy(&ar->txmgmt_idr);
 	}
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f09b926df9033..bd1a9b15e0ac8 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3919,13 +3919,13 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
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
@@ -6198,7 +6198,7 @@ static void __ath11k_mac_unregister(struct ath11k *ar)
 
 	ieee80211_unregister_hw(ar->hw);
 
-	idr_for_each(&ar->txmgmt_idr, ath11k_mac_tx_mgmt_pending_free, ar);
+	ath11k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 0607479774a94..e3156ea1a1a43 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -142,7 +142,7 @@ struct ath11k *ath11k_mac_get_ar_vdev_stop_status(struct ath11k_base *ab,
 
 void ath11k_mac_drain_tx(struct ath11k *ar);
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
-int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar);
 u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
 enum ath11k_supported_bw ath11k_mac_mac80211_bw_to_ath11k_bw(enum rate_info_bw bw);
 enum hal_encrypt_type ath11k_dp_tx_get_encrypt_type(u32 cipher);
-- 
2.53.0



