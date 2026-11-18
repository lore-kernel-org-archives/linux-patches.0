Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019660;
	b=c+qtAXucZ6e3IqwlczCfWHMK54b7EsGNl0bhPpjmhXa2yxSPE8V0yfX2YyYAezmshokx
	 7RRzomj/+dY4M4He+jzBh18GnWNoRzlLq2trEUA+3YW69xya9JcQ1He36UirZjYApmCDI
	 46h2M9KILSKSJQEvGTf29KLAF14YPwapEr3tZUzBM/jPx0uhUKzfTUD0aQVrNxLc7qjgt
	 4CcV/Ncgd+PQB5N7IPfj4n3uAdu22/ENHu70njRVrCn1fw2BIE90G/DTNCbsZfvK3TfL0
	 /VKbE3qABzve+sBWhdnpDEIUNPo5RRsQA9hBX439VPqB30YJNqY5Io3rCnihG/1AbIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTAIhhWFoGhUVV36e13K+Zi4JPetUWXEuRzs60i48F4=;
	b=IH8N0Zk6aP4WSiGMhILUfj3ZwXQ+SuXJRN57id5FBfOybf2mNJPfhfRckMPB+WhSBRTP
	 LNErhdKF4inXUdudujEaXtDB6yCVWSM2vwW2cjI9/wHYM7oMHsGq3DWKQuSU6ug2cu0Wy
	 O9FwcyM2PXLNSKmoVWqGSZ3DpFCPzlgVoU5lfSM2q7nSaH4nfogXSdKD8OctqzKxlT5kS
	 11prPommTmCrSx8O8mTFZlQguW6VuHS684Vbune/vq8Jka83cGspysXKPsSKk52OZXULx
	 zj8T8np+JbzmA2f9L/4X6ljcRjiuaeNbcSbJh+zvzr/D7kyep5Hs+d/dDSL3bWCh5ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sf9WEMht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0B1606A32C;
	Wed, 18 Nov 2026 16:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sf9WEMht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E611F000C5;
	Wed, 18 Nov 2026 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019660;
	bh=YTAIhhWFoGhUVV36e13K+Zi4JPetUWXEuRzs60i48F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sf9WEMhtZGMRzmndS7sr8GiKYp43HN0YxGXplUUhpDy2oL77E12RaOUBo8yXRAjn5
	 SCFopG7y8yQNyU0zCzxeGijoLV8aVqofLs2RMzIGGIMMfFqTN5PH950cwhy+XlLsf4
	 R0iUsJjk2f/FNxFpBhl5TTPGzTwyLOdrqQ+4nU/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1676/2651] wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:48:36 +0100
Message-ID: <20261118150348.032525567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c |  3 +--
 drivers/net/wireless/ath/ath12k/mac.c  | 12 ++++++------
 drivers/net/wireless/ath/ath12k/mac.h  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index b25202effb002..c6af10e54c3f7 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1516,8 +1516,7 @@ static void ath12k_core_pre_reconfigure_recovery(struct ath12k_base *ab)
 			complete_all(&ar->thermal.wmi_sync);
 
 			wake_up(&ar->dp.tx_empty_waitq);
-			idr_for_each(&ar->txmgmt_idr,
-				     ath12k_mac_tx_mgmt_pending_free, ar);
+			ath12k_mac_tx_mgmt_pending_free(ar);
 			idr_destroy(&ar->txmgmt_idr);
 			wake_up(&ar->txmgmt_empty_waitq);
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 815be25b33c4a..3e4039612fb5a 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9194,13 +9194,13 @@ static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
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
 
 static int ath12k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
@@ -14735,7 +14735,7 @@ static struct wiphy_iftype_ext_capab ath12k_iftypes_ext_capa[] = {
 
 static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
 {
-	idr_for_each(&ar->txmgmt_idr, ath12k_mac_tx_mgmt_pending_free, ar);
+	ath12k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index aba98afd4365c..ae44ebfd9bd98 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -173,7 +173,7 @@ struct ath12k *ath12k_mac_get_ar_by_pdev_id(struct ath12k_base *ab, u32 pdev_id)
 void ath12k_mac_drain_tx(struct ath12k *ar);
 void ath12k_mac_peer_cleanup_all(struct ath12k *ar);
 void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah);
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar);
 enum rate_info_bw ath12k_mac_bw_to_mac80211_bw(enum ath12k_supported_bw bw);
 enum ath12k_supported_bw ath12k_mac_mac80211_bw_to_ath12k_bw(enum rate_info_bw bw);
 enum hal_encrypt_type ath12k_dp_tx_get_encrypt_type(u32 cipher);
-- 
2.53.0



