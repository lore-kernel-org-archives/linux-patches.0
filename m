Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019657;
	b=leSKIzcXo++W0diqhKtF0zI22m9OeYvGkluHX7U9j+69FPm2MZt5FO2ayRi7zXCXErU1
	 zRC4ARaWoXQuv+ANlXi2uUzWurust+csVI37J9RoYQ1OWrO4h/GSoaBJ+bIFXnrtuY58W
	 VLE95Elm86lIejY0v1BK3i0NaRq4/MmxjuS/xcL4PJL47DwFuHkigFcO4JUoyVKLaNGw4
	 B66WxqP67GWPxkxrbNYDFvYZxEf6by6oxaf6xcx1c0EpZSFt7Oh4/kQPQajA4X43gOdWt
	 +NXgGDsCFezov++jt+ksfQUApVPwR8vv5dh8jZ44za1w9iRKgsqZmdwuvt8cak0bZ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UELyQEVnDMxuoo3iG3OP6krz1gu69RNRpc6lJQc7c4=;
	b=pP2PeDj/oAiSF4Htvh+adTGRwH//fnyib43cR0Qt0kxYFOb1EOcby9CClRwrEOq/yKIP
	 /RTa/AwbOSK80sKJElplCMIejijaT5XsygvGpIxk5qNLM6HePDbsAjxzz+876IDXgUDLH
	 CLKiOql8wV0o3MD3R/fVQYa4AeOToxnXC2fJ6ZeaLssdLrKQAuGL5rlk5T4/yOXPWW/u+
	 Upy037V2A1EpnlQ2Z0uh+fORFx+t/fOXNUIybEFa1hlwh+OB3uPoml0JJQy4CcE4mHaAP
	 inJ5FjHb5YIsUHxbSQbXVUn7GGLicHf8nrVLHsONLniN3cKogSMNb4xRaH+auHhKXdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siYTXx7L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FC1606A32C;
	Wed, 18 Nov 2026 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siYTXx7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3E01F000C5;
	Wed, 18 Nov 2026 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019657;
	bh=4UELyQEVnDMxuoo3iG3OP6krz1gu69RNRpc6lJQc7c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siYTXx7LKeoxtO12TOQ7/5Iw7HUMWsQqT9cyE8gyuTjX2vrkWpmrSqjEjxSHUxDbO
	 poCbu5Af5DKbBW+krJ1wY+zUk/s4bIuSBZYIZldQrbuukEy74EAuMPVQL8xc3Xs1NV
	 zWjSsN5Nu1iSLsBBVJFraJj8Vb/6UWW8ig9eouUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1675/2651] wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
Date: Wed, 18 Nov 2026 15:48:35 +0100
Message-ID: <20261118150347.997032179@linuxfoundation.org>
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
index 1ee32c7dc4943..1a237adaa37d1 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6176,16 +6176,18 @@ void ath11k_mac_tx_mgmt_pending_free(struct ath11k *ar)
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
@@ -7417,8 +7419,7 @@ static void ath11k_mac_op_remove_interface(struct ieee80211_hw *hw,
 
 	ath11k_peer_cleanup(ar, arvif->vdev_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath11k_mac_vif_txmgmt_idr_remove, vif);
+	ath11k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
 		spin_lock_bh(&ab->dp.tx_ring[i].tx_idr_lock);
-- 
2.53.0



