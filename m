Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585353;
	b=PZcp9a2XRZOgpC2mPZDsVk57xuNI8uEF3Qh/n3f849Xen1bPh5ttyj8oJCtCWBXlDIjH
	 RaCK1HsoPRZJCvCoq/suoDm+pqEBG5J0OcSsisqkqqtItXXkzDAiMZpkhxhWnSpN7uA3c
	 jikUJc88UFcOS2tuDv7wk9lkRct+nR23KnDSZXx0jao7CHyMuoA3vdbsLL9iaXrp0xQ63
	 /ICv6fzirbhnQBQ9sXbnDxp1A7kbZXMGMNwQaGPLffcCf+7R+pK2tq1Z4Js7seaB+lzjx
	 ljJp6CWExgjcc77IO6t0WbAXJy13RhH4mX2nt6liMu+AHHXbRlkhhDJ8EWGnmiIX6BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yB8GCbabODKjGPm/honWxYsQykcmEBZfFhafY/kQZ/s=;
	b=RUJk55rxHR/0fuC6ZCIGQscKFO/HXGwQ0H31K87UZMPVtZk00FByU/gJs8vzOu3YB+DA
	 Wcv4zz64Oa/c9ozKZAaTmyCRcwB3XnCTLwaaTARzHQ6ZMt4fiAqXmpfXLnIha6kE97dGA
	 /mFSoKIj5OpX/kmhZcRCfuxPYeqbRnT847AN3D+m2Pwc/XeNX43TYAjsvwvpBdGfHYh9m
	 ZbHNzTt1PVXNt9Uyt91KhAHToVvMzc9XyssYR3LihL3/seNr7HV8LsF42BOFGq3ZpLbI6
	 4WjIzlRfeZTxjsO9BGcf4WOnaEh76CuVBGTNkxWim3URr8UYewBf9Z/vj7he+2tYTfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FR1D27ZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2C606A8AA;
	Fri, 13 Nov 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FR1D27ZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6AA1F000CB;
	Fri, 13 Nov 2026 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585352;
	bh=yB8GCbabODKjGPm/honWxYsQykcmEBZfFhafY/kQZ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FR1D27ZQXx2LB7vJYI+b/aXfY78U7BZh0pW1LccDWBmY4iM0wGoPFaSKJrcFEQcYG
	 66nNUuPbPd+iny5g8maad05F0a6pAT3MKcGRVAY1sRGl+DBwuEyiQcHNMhEr8nCzsZ
	 o8rkF26PoYW/kCIF2IFkm3MZx2GHbAdSO/de22cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 033/507] wifi: rtw88: TX report with long timeout for non-PCIE devices
Date: Fri, 13 Nov 2026 10:45:37 -0500
Message-ID: <20261113153754.534157949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 7cde94dab0e74434ccc0a387d7ad373fb3becda0 ]

Many USB and SDIO devices can't report TX status within 500 ms, and
extending to 2500 ms as tested USB/SDIO devices can fix the problem [1].
To avoid adding chip ID one by one, and this change looks harmless.
Keep PCIE using short timeout, and others use long timeout.

[1] https://lore.kernel.org/linux-wireless/20260921165343.8131-1-pepe.schlehofer@gmail.com/

Cc: stable@vger.kernel.org
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Tested-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Link: https://patch.msgid.link/20260924004637.9958-1-pkshih@realtek.com
[ Adjust the removed condition. This tree has no RTL8723BS support and
  lacks commit 4d688f22ebbf ("wifi: rtw88: tx: extend the TX report purge
  timeout to RTL8723BS"), so the old check has no rtw_is_8723bs() part.
  The resulting code is the same as upstream. ]
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 9 +++++----
 drivers/net/wireless/realtek/rtw88/tx.h | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 8786bbb421c2b..701ed7c4f3f75 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -196,7 +196,7 @@ void rtw_tx_report_purge_timer(struct timer_list *t)
 void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 {
 	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
-	unsigned long timeout = RTW_TX_PROBE_TIMEOUT;
+	unsigned long timeout;
 	unsigned long flags;
 	u8 *drv_data;
 
@@ -208,9 +208,10 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 	__skb_queue_tail(&tx_report->queue, skb);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
-	    rtwdev->hci.type == RTW_HCI_TYPE_USB)
-		timeout = msecs_to_jiffies(2500);
+	if (rtwdev->hci.type == RTW_HCI_TYPE_PCIE)
+		timeout = RTW_TX_PROBE_TIMEOUT_SHORT;
+	else
+		timeout = RTW_TX_PROBE_TIMEOUT_LONG;
 
 	mod_timer(&tx_report->purge_timer, jiffies + timeout);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index d34cdeca16f19..168f48e87853d 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -7,7 +7,8 @@
 
 #define RTK_TX_MAX_AGG_NUM_MASK		0x1f
 
-#define RTW_TX_PROBE_TIMEOUT		msecs_to_jiffies(500)
+#define RTW_TX_PROBE_TIMEOUT_SHORT	msecs_to_jiffies(500)
+#define RTW_TX_PROBE_TIMEOUT_LONG	msecs_to_jiffies(2500)
 
 struct rtw_tx_desc {
 	__le32 w0;
-- 
2.53.0



