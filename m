Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026266;
	b=p4WjWJepwxe4siVOziRzcUa3qm6eqg6/0Eaq29e2C6LuNcKuTD1pQAIGUDffT3Vn72gA
	 AbfWqljoXpPKC2Xg5YjwOcj2DVxgM5n0wroRwJBR0hgy1xneIdKxHweTgejKllygPdI8E
	 k5xKIBF6dy8vnWjkCzPRxlHjaUyXqbTWv7Drglda/7NXpKh8nmpaL7zClBGGTFdDTCgJ9
	 DYE6CTvOXTuWLFBaUclZr+3fJk7+g2drjGjrCnHx6sc+S2hIAO8htUFFxw6xBPxiJ7LWx
	 i/txnEpjj727t7BYTS+rrqX6guP0+z0xFrJio0IWzBRtJemnLpj7+qYWL3wE3N35ymA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0H+9Q1cO80Qz7f66dT1dAKhLUcsfo6GHNAqapTt/1I=;
	b=sbmcQh7cikdYuKvBtD89rd2Ep3U4gmblbzYCRF2Lu6jaLgsR1baYQ5n9LBx35Jbo7rAY
	 qkan4pzMtBk52PQNei9sE60tBOphBSV71WW4VnxWUh7yD+GscT1fOA5S6ubQRLXEuxsI2
	 W8A/G63zc5HU1A0xsx7/GSegKSk/5p72O0fLqGorXyB3reDriiZJIMpRd8E4OL/wBv/Fo
	 0fJGuaRgLNqSEUGCBtz+jLUrxB8aAeQWALzrPMosnHE8RDFIv4y7DkNdMwAjJii3OrvVr
	 Tmrd09O/0KksAeklK1tAxF1/lQzEy3Nr1jKvfovfWGSDa4z0hhl1C6zluMKDSQBpB5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pEaQRYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6D3606A330;
	Wed, 18 Nov 2026 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pEaQRYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C131F000C4;
	Wed, 18 Nov 2026 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026265;
	bh=r0H+9Q1cO80Qz7f66dT1dAKhLUcsfo6GHNAqapTt/1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pEaQRYH4/yj+4NPdgY1jlSUk6zITttqX93hve+Jv+oDZAMyfm/zcy20QFcftpA6+
	 Ief+JITVQt3ZQLA5L3Yjnf9VZW3XSScdZFdBSWvkiLd0jUuvLM4iSg8Ptv8lR+KZ+0
	 kM48KWJ3dQBfKsSR4BeicC/oHtcHndXNaSjilE74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1372/2151] wifi: ath10k: avoid IDR mutation during TX cleanup
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150211.997439427@linuxfoundation.org>
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

[ Upstream commit 1c1a208e65a08191901cfded3bbccc4a54e4a75c ]

ath10k_htt_flush_tx_queue() walks pending_tx with idr_for_each().
Its callback calls ath10k_txrx_tx_unref(), which removes the current
entry from pending_tx through ath10k_htt_tx_free_msdu_id().

idr_for_each() keeps radix-tree iterator state across the callback.
Removing the current entry can therefore invalidate that state and
make the remaining walk unsafe.

Use idr_for_each_entry(), which starts a fresh lookup after each
callback.  The current entry can then be removed safely, while the
following idr_destroy() continues to release the IDR itself.

Fixes: 89d6d83565e9 ("ath10k: use idr api for msdu_ids")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261003092104.520135-2-yaojiale02@163.com
[changed ath10k_htt_tx_clean_up_pending() signature]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d6f1d85ba8713..b9a153ff82b28 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -506,9 +506,8 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 	return ret;
 }
 
-static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
+static void ath10k_htt_tx_clean_up_pending(int msdu_id, struct ath10k *ar)
 {
-	struct ath10k *ar = ctx;
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {};
 
@@ -518,8 +517,6 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 
 	ath10k_txrx_tx_unref(htt, &tx_done);
-
-	return 0;
 }
 
 void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
@@ -536,8 +533,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 
 static void ath10k_htt_flush_tx_queue(struct ath10k_htt *htt)
 {
+	struct sk_buff *msdu;
+	int msdu_id;
+
 	ath10k_htc_stop_hl(htt->ar);
-	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
+
+	idr_for_each_entry(&htt->pending_tx, msdu, msdu_id)
+		ath10k_htt_tx_clean_up_pending(msdu_id, htt->ar);
 }
 
 void ath10k_htt_tx_stop(struct ath10k_htt *htt)
-- 
2.53.0



