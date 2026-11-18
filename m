Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056071;
	b=iGXYZq3RXTSnUSF3LkWTP1v4BtzcysAhdbx+6l3G43o+lkNtrpm21R5ePF62qmlJuK7i
	 Uqx9D5PJjbIkdaW+f4btrc8k0z4ep0ETQuS/s6Axqf/NtHKIwkmIxLw+VYKhiyHmT+FpR
	 vO35PhsGrHtzSbXq0gknb1Eej6QEGpgYnRT60fqElbEWDa5RU5TgiYsmqk1fijb9xK+a8
	 KikGIAV02N8pvOZEQBbV0pkq1wczqDrLumQDt0T/5QKGEd/7DFLeAKYS6TNJHM6PcWChG
	 zQBzTr9Ha97J3HnfMJArl40NiIvco6RJZt0baCjQqYi9xzDr8Pz55rhTN/uea/NeaqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtbWzSpwto6Ug4kgBt8G+NW8yaY4EbS14YiJWhw0DQo=;
	b=npO/hpt1QdgVY1dEHJgnlAbKF45vvkhAULgOne3t7xQDUeaRrovw2kJGTgJJG0SnKUkF
	 glyUCeY1SKyca72vszYo+9OVFYNdFKEelLU7RL0ThMTk/LYvJClPOg1lLiP2lBGDcCMOL
	 pjJtfc5zhgaNqAHqVZkXhcM66gciViYo7iivrDxDrYStXvjDrQPw9mm6nlJlKnCcYUnUG
	 H1GVsb/96Bc7e3+LED93lhT0ORpBkDDR+BKgCaKaqxFbquzCgXBQfMQtq5fBYRO8NDtBu
	 i1q2SCN6BBPrRVrvghA9BDMjwHzwb90O6KgC8PZEj3JsFq2Ie4ZbDA7e/+hz9is7jBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxlNmYnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED0F606A31C;
	Thu, 19 Nov 2026 02:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxlNmYnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7C61F000C4;
	Thu, 19 Nov 2026 02:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056071;
	bh=NtbWzSpwto6Ug4kgBt8G+NW8yaY4EbS14YiJWhw0DQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxlNmYnwSgEzaIB/WhSEgO8N+sKZdTABrOnVSvWebIy8LbnXl1I6bDyhZk7ErIu8u
	 nHjK8aBJY/9W7nBc0Ad/OlLCYXdxRJqMUOcuywWuLE/lmrCLJlpWsMz1YzMjbBg+Mi
	 HSxvMlP1McNmcSt/0u4XbE9SoC0J+sMBK/d18VE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1855/2214] wifi: ath10k: avoid IDR mutation during TX cleanup
Date: Wed, 18 Nov 2026 15:58:51 +0100
Message-ID: <20261118150125.570315454@linuxfoundation.org>
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
index b793eac2cfac8..7fedc31ddecd2 100644
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



