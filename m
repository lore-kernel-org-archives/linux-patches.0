Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D3F846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35E5C433D2;
	Fri, 10 Mar 2023 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458624;
	bh=Jt1/z6jTpPmPUy5JNtwJfcFWYr6kRp/vUNBouuelTM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGW/GPBXDTXpLq6+3s8ZPc9MuPlZWpJYuAiGZwdZ+NdYV6khL0hz8NGefZ7cI8o+e
	 9bpfGClUIx1odwbwK5JvhS0nSO1HduduDnEnHPDXVFyiqTr94ZYM0YecGzScNu3unx
	 nreKKHOGEVzDWkweFmCbM3l1Z4N5UmAlPoge2PwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wan Jiabing <wanjiabing@vivo.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/357] ath9k: hif_usb: simplify if-if to if-else
Date: Fri, 10 Mar 2023 14:35:47 +0100
Message-Id: <20230310133736.524911707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 2950833f10cfa601813262e1d9c8473f9415681b ]

Use if and else instead of if(A) and if (!A).

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220424094441.104937-1-wanjiabing@vivo.com
Stable-dep-of: 0af54343a762 ("wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8a18a33b5b59f..15c8b512a1d9f 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -368,10 +368,9 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
-	}
-
-	if (!ret)
+	} else {
 		TX_STAT_INC(buf_queued);
+	}
 
 	return ret;
 }
-- 
2.39.2



