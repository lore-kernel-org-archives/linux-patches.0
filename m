Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019652;
	b=sCB/bX7rZrHC9N4KF3PjM7EBjOrA9KdNTjxj4qCYOpDyw9aXtpj53YfPjyU/zQfzUYWt
	 Q+0UJqByFP8Ep6tZfJWIEE/Zgr8KSoHgNS174VV4uivqsVbITNFl4OpgCalBbxLt1bFe5
	 AYd5OUNHwx9LpoPwkLu8LEW0ZnagaLY2cYfl7Bl3OUQPaCnR3L93ZgjZIQouv8p5kW1im
	 4BVE+c6MxmW4fhRJBx0LYYqhTYDXh12fEyWPMz3ApqCX3OUuWEmimnlqSH/ph2w40E1bx
	 HNsbrReYbhc4HPtPDbsGzi3jLPW954cX3JO4N14Jw6fjGxCOThwheWY9LUhye8vCOaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ufO+WfqCUfqDVq/xZ2Byfd3L8yj3MiNN6tiYJ5SH05g=;
	b=EssumuEn+bGKpK6O4V7BlYpDWCjQeLovxARGcWAx4E4Gbjn+y+I9u/ejfiYus9sJPUku
	 +bIQhf7ux2uU38FbsPI28Q5IOU2khdeg+H6h9kpcFMzyqot/CjKb/bAn0/xj2MSqnAz03
	 92CZJfk4/gSfM+jp/lYQnESspeek6I/g0r1UVyW850nkQ5e7YU/qGCijxO0xYtgpVLKoo
	 eIY/RqooolpGgvmaIG4ul7x2mtzndrO4FLc29P2+QmbhvIGS4oIFIgHHyXF1u2pRKnser
	 tALaOSMJFUGKCZBp1BwXXHNJQTw5kXHLn2lCudHNmJmazK8My2qmnCHl0YS+DV+Gt3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlDGpaBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C32606A33E;
	Wed, 18 Nov 2026 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlDGpaBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFEB1F000C4;
	Wed, 18 Nov 2026 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019652;
	bh=ufO+WfqCUfqDVq/xZ2Byfd3L8yj3MiNN6tiYJ5SH05g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlDGpaBfgQuRcQNejdxYSbpGTLMk0+ZNjCo6NXOHjqGriMfYvxTdW9IUHUqyKiq+t
	 XnISTbEVC6upYMVRHIS1PXI+xUgx9BDu/lFoi328rwFsiZhlcUDnJPN8cnTKLc70bA
	 IqeFaBGudErenxuPbMYXExlalwVtyJ5pEGAWPRcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1673/2651] wifi: ath10k: avoid IDR mutation during TX cleanup
Date: Wed, 18 Nov 2026 15:48:33 +0100
Message-ID: <20261118150347.927892314@linuxfoundation.org>
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
index e46f579d745d3..efaea150025b9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -505,9 +505,8 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 	return ret;
 }
 
-static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
+static void ath10k_htt_tx_clean_up_pending(int msdu_id, struct ath10k *ar)
 {
-	struct ath10k *ar = ctx;
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {};
 
@@ -517,8 +516,6 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 
 	ath10k_txrx_tx_unref(htt, &tx_done);
-
-	return 0;
 }
 
 void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
@@ -535,8 +532,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 
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



