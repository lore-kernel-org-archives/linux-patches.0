Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625361;
	b=dQhK/wDoInQav9wrvB4X3Gmat/iWNXZ6je9yX3Hh1EEQq2TjF/idompGBkvCvL72xhOO
	 eH+KRZP/19ruvtcxoxpy75Cul8vNP6t79uWkLg7gRHW7HN6duhYgBXjW+dbxsmEQuqQkU
	 eWwx1e2kcMJwcH551TNWlrgOPK5BeHAaM1t8Sd9+4quEsv2lcRjyftgzweykUWO4X1+O4
	 Hbf5mAmNxmmc84k0hSj6xPJJJ6vtl7i7grk5MPzaxAt9iIQ9x9dl1jjDSXCPivu0ZPkqO
	 1NT4xrjavR2aQyagSqMONxpFrD/+S0V4G0cCs+6cFAT6pEkswjFrO9zCgQXQ3jWWx8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIx2T6rgTv9n1GkCAw48e0w5LE8wWq1T1L74dV2/juI=;
	b=q3ogdZ470htsCurL4angxkQk4QMBQ3qIN2M0WkmBw+jUcfDtM350TOinVtzVsG34VWzC
	 tovN79/UWJwzc4K7c/cEA9L9o5H8H/ZftJ4xI12R4ZB+8NKkTd6SQIaDxnaJu8VmszvfV
	 9ZHFJF4BoZkLpueOO4Gr8PqmjAR285Q08gxe2ej0Bg5i/xDdaT9GPPW46heu4oLEQiWST
	 J3YalsSRlWe389pu8yhvxfBUAY0v0/Fqk43BPTF7FyYPf+T0uXyGzCGWKWLtaXKkiICGl
	 PNZgZ9yyp3EyNFdmCk5mifKQRyKSCgbs8vOo4ky4ECclv3DkA6KtmbX6xBwt+EXSciA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnMxba31;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F9F606A31E;
	Wed, 25 Nov 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnMxba31
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DE01F000C6;
	Wed, 25 Nov 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625360;
	bh=sIx2T6rgTv9n1GkCAw48e0w5LE8wWq1T1L74dV2/juI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnMxba31XMY2icNnX+Fm1syNR/l5shhtOY0lFEFyP/eS6rm36fp0U5Zu7vmocgr2n
	 ebiG8Q85j0Dg7gZ/Y2CWPxtAk09yttsjOuph0RuGJXhQclIrtBl5a+x+negNaxOcPN
	 hEtYpfUJo5qzUUxB+ymidefcIfHV41hEZa7oVKys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/816] wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
Date: Wed, 25 Nov 2026 15:33:59 +0100
Message-ID: <20261125143900.556832665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Adjusted context lines in core.c and mac.h for older surrounding code (different neighbouring calls, a missing helper); the changed lines match upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c |  3 +--
 drivers/net/wireless/ath/ath12k/mac.c  | 12 ++++++------
 drivers/net/wireless/ath/ath12k/mac.h  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index c3c76e2680629..af4e9c77f5209 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1064,8 +1064,7 @@ static void ath12k_core_pre_reconfigure_recovery(struct ath12k_base *ab)
 			complete(&ar->bss_survey_done);
 
 			wake_up(&ar->dp.tx_empty_waitq);
-			idr_for_each(&ar->txmgmt_idr,
-				     ath12k_mac_tx_mgmt_pending_free, ar);
+			ath12k_mac_tx_mgmt_pending_free(ar);
 			idr_destroy(&ar->txmgmt_idr);
 			wake_up(&ar->txmgmt_empty_waitq);
 		}
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 9f10eb7de3df2..6f2df6d2b68d4 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5699,13 +5699,13 @@ static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
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
@@ -8999,7 +8999,7 @@ static const struct wiphy_iftype_ext_capab ath12k_iftypes_ext_capa[] = {
 
 static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
 {
-	idr_for_each(&ar->txmgmt_idr, ath12k_mac_tx_mgmt_pending_free, ar);
+	ath12k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index 5efbb6822628f..2c0a3b199669b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -73,7 +73,7 @@ struct ath12k *ath12k_mac_get_ar_by_pdev_id(struct ath12k_base *ab, u32 pdev_id)
 
 void ath12k_mac_drain_tx(struct ath12k *ar);
 void ath12k_mac_peer_cleanup_all(struct ath12k *ar);
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar);
 enum rate_info_bw ath12k_mac_bw_to_mac80211_bw(enum ath12k_supported_bw bw);
 enum ath12k_supported_bw ath12k_mac_mac80211_bw_to_ath12k_bw(enum rate_info_bw bw);
 enum hal_encrypt_type ath12k_dp_tx_get_encrypt_type(u32 cipher);
-- 
2.53.0



