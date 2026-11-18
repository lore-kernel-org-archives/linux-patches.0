Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019666;
	b=DNjQ05GcWJo+n5X/yCT8Gmc3w+AJ5npIX8UZF32nqpQ1C42p0zmGLHilrhxcXNa+KLCU
	 Tt3MjNjeE9Uyr1dojDp7jikeubtMAb540SpL4va+T5zyDxHjdpLC2TucArZZxO5iyVHyr
	 m8YouGpeneCn9qNjHZamfLh0QE9SiVZJkJfTqjGXDJamswhH8LWW2AyFvP32v4lb/C6H4
	 1fFobSEzgvs8bZP1/pSohZCddei8zLXhHhrb2azGTNvMy9Dpf+q318sFAKW054Lo/lx3w
	 bZBdWf8qEomfRZ1YHBB0kMmCBp5NVXhP/KqB3unbiTY+D0uaympZOOU04SupEElVWOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dOwBA4Yl0lqVdHsgljNg2Dil+FUEckFHX7r8mikNr/A=;
	b=z4eOQJUgBtjzFrvvTV/S3YONNn5Vrt9k3ITqMf0UG0T+QBCd7gg8sODmhyt8WkDqJKAk
	 COIJZCsoai0FTyaUBnNBsBXxesLNAV0HaaPcUk2KvxizEB8R5JtmCYTarPtHfBWyqPji8
	 Pd0v5FsZFQEi68oh3rfm++yOgT6BmugwwhhiyF9l+1RMoQ67zXOuasAcdyGDdXhEgxkDR
	 ovl4zjtgSyyxBE6QrBk9NWPr27jwIJErThPB7u0ez6SMRSE0ZJtqCiR7DKMCnX0ugqXtY
	 iN/jBXchy596dtMvDoRgg45y3M1ntyg5CXEIrDMH8FxrKujj4t3D1uBgc3oBUGPHhsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4Y6kUqc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526FB60A2600;
	Wed, 18 Nov 2026 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4Y6kUqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A407B1F000C5;
	Wed, 18 Nov 2026 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019666;
	bh=dOwBA4Yl0lqVdHsgljNg2Dil+FUEckFHX7r8mikNr/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4Y6kUqcznixAEXMx19jc/8WCCxw7EowYavDo6jFc8YGU+GUoIDcvpzSeJmt2QYKI
	 9u4sPMpHEzbZoIP9/6Z64Fno6C2VvMXa+GwnzLgMw/E646pS03lLUCYMdGNUUvNUBt
	 ST1EqniFGI6B8Uzvr4+oI5ckg/d7rDfZcUFyMxRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1677/2651] wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:48:37 +0100
Message-ID: <20261118150348.062793319@linuxfoundation.org>
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
index 3e4039612fb5a..56578321e88c6 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9203,16 +9203,18 @@ void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar)
 		ath12k_mac_tx_mgmt_free(ar, buf_id);
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
@@ -10977,8 +10979,7 @@ static int ath12k_mac_vdev_delete(struct ath12k *ar, struct ath12k_link_vif *arv
 	ath12k_peer_cleanup(ar, arvif->vdev_id);
 	ath12k_ahvif_put_link_cache(ahvif, arvif->link_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath12k_mac_vif_txmgmt_idr_remove, vif);
+	ath12k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	ath12k_mac_vif_unref(ath12k_ab_to_dp(ab), vif);
 
-- 
2.53.0



