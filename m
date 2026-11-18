Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061481;
	b=T7tx6p4sETeN7ACl7KyYQEUwEbZbi+KsDjalBENnMShEJQKFueMKLRZ8A4IiODf1GYQ1
	 XTY5gSLrDjf/GaUDRwr8qlcFd577gcZu1/hgi3V9eaXSP9AsWWZzMWLBHknR4crWqeutG
	 rKuWj585ErV1+OEGaXqGtyUipTw8l30IZ+3ZvqLFpRbMfBelnwcCq8fq523lAFr2tdqxs
	 HHJT5bRSdiSTwMkVLdXxA7ancEXfmzIFcSbRzXEp6iuNEEhvZ/+/DNTuJg+61KWXh5t0c
	 Y/hu6ddMVDmIOe9+aAArL1irRfv5nHF0kw5fmUT8xX3f7Fy7UE6cbC5vPY/wanB+f4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dl7iqTzHzufu+4/wyxeA5SZx//TW39gxKuPAKSA9vrU=;
	b=s9tvds9FoclFwxx77Bdkl7a4nZn3U+QOtOCRqc4X2rOi51WaFNYoFsm65t7Ntn2W4lht
	 NsyBZXbmKOfUwco9qBbCuctplRnh/WApbuPnxTvopniF2AViU3ahohhVAP8HU8JHd/gZg
	 WvBEDkTrMfz3PqPQ1ZnZNSCGBY9nAF1eYAHQDWXBYwFZ8njiTCJAJc97xyYNYbW2/4Gtd
	 bOIDf8oKdANvlFvvsdzHcAt44QqL1dcaecND6aZbtSVSk16HgGekfVkltyGOzCF8q07fP
	 9zOZve334hlUgCnKNoiWuVkl7oiBlQnT/6Ih8opx0vEzGKcYPYH37CVda9uieR2rBHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcQdwR8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D44606A32A;
	Thu, 19 Nov 2026 04:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcQdwR8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80EC1F000C4;
	Thu, 19 Nov 2026 04:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061481;
	bh=Dl7iqTzHzufu+4/wyxeA5SZx//TW39gxKuPAKSA9vrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcQdwR8zk5eucM4FEJDfY6I1ax8BvGrtAs9ibIJMoExDq/96uDI+KrN/HW+30oFCU
	 vtD0uCUGa4boe2CVlC00JcxiO0yNrGo4qWsr/gfrdVSQUrs9HS5ipcWan6LPiuNiIS
	 j2wMOh9EVrmR/iv3RZnh7HSF3M7I2GGTLqagh5Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1569/1848] wifi: ath10k: avoid IDR mutation during TX cleanup
Date: Wed, 18 Nov 2026 16:00:07 +0100
Message-ID: <20261118150025.248671305@linuxfoundation.org>
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
index 5f67da47036cf..cedb15d5626f0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -504,9 +504,8 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 	return ret;
 }
 
-static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
+static void ath10k_htt_tx_clean_up_pending(int msdu_id, struct ath10k *ar)
 {
-	struct ath10k *ar = ctx;
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {0};
 
@@ -516,8 +515,6 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 
 	ath10k_txrx_tx_unref(htt, &tx_done);
-
-	return 0;
 }
 
 void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
@@ -534,8 +531,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 
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



