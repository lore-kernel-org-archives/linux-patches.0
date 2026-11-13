Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590863;
	b=nbWPy86egaTc9HjdzBsc2Lgz2Q9Drak5NOvkRhNslIxvtVJlnUL/MtNdBRlnVpaMqY9x
	 Y2xIfCEDKjVyqi+KsmkE+F9plPmd57oFsQxkIgPxMffXGIceHoD/GEYxx8Hqef0hXI1w5
	 hwsLsjqfXpd5I5fxt7ScHrzXADsVCczU/QwqDWuV/vNssQS6QvVbefBL/gVkzzCGUGdDb
	 PpjxenNjgXeA/OXnHbL7NifV6dp3hFq9D8TQN6Kh+nRXRsdRoyCjsfpTFfmZiq+6Xn0ll
	 GrnKbe1l80LnslzNRz58tap7xihT4hRnUWYApg4sJXpp6meMvsYLsVfxGMZNZmIhrEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SfiDbF4y8IK5X7VABisSdscsIBfnoyla8N4R4Da3Ees=;
	b=woCJMDF8yI1wdNYuAyNgnjpHbqR8Kejp11gxNW7SMR7o0vPUZ0L/dNLKtqHzAbyWtDnr
	 1hCiomjeVlvAjzr0m73Dg6PHCkwplyBbZGBAJdZXuhIpweep2Pa/PC9uvKVtPiQq8ls00
	 U1UM0IRfTYVSyybfHui2yqmRaQKsG18Fj8vSjjO6eyRU7AOF8m6dmm8iIErPN08fcIodL
	 H0/zhL5MR0WxD2BTXoxDVxoA9y0soN4Nw5BBh3ttFICfhOzAvl/y7JQ+atCm0fGfRBeJ1
	 guJvzBzXSkgz4dY6F8fFpURnd1synzftw+bnUseriRKP0vGOUqJvxBujdikgIuMzgNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTArixIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6FD606D84A;
	Fri, 13 Nov 2026 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iTArixIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDB51F000C4;
	Fri, 13 Nov 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590862;
	bh=SfiDbF4y8IK5X7VABisSdscsIBfnoyla8N4R4Da3Ees=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTArixIZvBZ7o0I/YN746ydQQRKuqb3l/zZMMwkr1c7ezCEaN6d9LI+M0NTG0KUJw
	 Fll9L1COi7AD0PbJaHprlR5/NWu5G3z7ktIrT1UgBsr9HM0aO0mSd0oCp4F9nJZRxi
	 9q6TGs6js/pQL/pajdbJYB0PVXGZI50w78Z2oryY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/670] wifi: rtw88: TX report with long timeout for non-PCIE devices
Date: Fri, 13 Nov 2026 10:43:46 -0500
Message-ID: <20261113153813.613937668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 0c8817bf46c74..959ae66776aa4 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -191,7 +191,7 @@ void rtw_tx_report_purge_timer(struct timer_list *t)
 void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 {
 	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
-	unsigned long timeout = RTW_TX_PROBE_TIMEOUT;
+	unsigned long timeout;
 	unsigned long flags;
 	u8 *drv_data;
 
@@ -203,9 +203,10 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
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
index 3d544fd7f60f5..f361713ece9f0 100644
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



