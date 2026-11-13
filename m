Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590625;
	b=IU34R13y7l7dHbzXYI2ndxmyOU3KN5XirxCZY0SpRaufKYfGjbNwbnFs7FWrjKxwv5ao
	 fZDotsjY26yvMmaWfcM061SzRF7OfGghBTV/FxksuRvMDSx5XyFg8ZJ+aTMws5EE7xSCn
	 dwPa7noPOrTVOE9n1GmyqanruiYfKumaEZRzvpRv4g9/r2w4txCw+p+7F4goCVCdrysXz
	 MoHWxlaKDvdRy3SegviB1VpW6ja/RD8xDP1yw2Ir7lvI2raDbLYeqXQ53KLv1Rj9pW38V
	 f0zB6KZL4uhuC8U0OWmhHVvqwMEJvwpsla+UaB9c1idtI3EvyZba0/9rw6mTuVrpExQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLpydCmRYkWbPw5rOZ6eUFsi2LUwK0GEMFxbhgQX2JQ=;
	b=fLZfz5m66JJbkK+nLzqwL2ZA5m1SGtj5ncRapUoCBkU5gPAMIKR+wsE/zoEqwx7OqjLO
	 9lrxj1kc1JRZ9bKFLtnTOAURAEV6IgxE3OQKvLBkkoXJMxFvtVGtNGjznzEuDSbkngLR+
	 84cwcDXKkV7uYxYs18n1ui//dDcqFIenTWwruBtlu/gsGVOBmFTFc2gMsUhbhorplGDq3
	 dFbJHUTTmH/4Eq1gF1GuO1SyFfI2ECv97ZnLWROLQBXwvaTQwvbGElIdQBOcCMDH5XmfT
	 0oIACEQLK+SbXy5tWoF3tP6WJtJEmoXPeFMvh1xhZne75znnKfvyqbnPS8q9/SE5/AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqYpyXtN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87986075E1C;
	Fri, 13 Nov 2026 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqYpyXtN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A41F000C4;
	Fri, 13 Nov 2026 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590624;
	bh=kLpydCmRYkWbPw5rOZ6eUFsi2LUwK0GEMFxbhgQX2JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqYpyXtNUDT7kvvYqW1HWilCDW2+q+GPrq5y6TD5JGVF7STOMpAkIziDWgiUpvzjc
	 JX6NJuyDZ5M/OA6UwL07zNI9yQoMrCndDqZ3g+Ul8bFsDAFEV33xRSwoXREISDFc3I
	 ldagxgnPNdSSZZ4Gcnnv3LOVmRLUZ2YPinfhDXc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 547/686] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Fri, 13 Nov 2026 10:51:20 -0500
Message-ID: <20261113153840.086229762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit c710c7c2e0380d7c0eeb33b686262edcaef7cb07 ]

In AP mode every broadcast and multicast data frame is routed to
TX_DESC_QSEL_HIGH, the after-DTIM queue, whether or not anybody is
asleep. The firmware drains that queue at beacon pace, a dozen or so
frames per second measured on RTL8822BU, while one associated client's
mDNS/SSDP chatter alone exceeds that. The excess accumulates inside
the chip until the shared TX page pool is exhausted (measured: 14 of
1803 pages left). From that point every host-sourced frame queues
behind the backlog: authentication responses reach the air seconds
after the client has given up, so no station can associate anymore,
and the beacon reserved-page download fails the BCN_VALID poll
("error beacon valid") because it needs pages from the same pool. The
AP keeps beaconing, so the failure looks like a silent RX stall and
only a reboot recovers.

mac80211 already decides when after-DTIM delivery is needed: it sets
IEEE80211_TX_CTL_SEND_AFTER_DTIM on bmc frames only while at least one
station is actually dozing. Honor that instead of routing
unconditionally: flagged frames keep going through the high queue with
the MORE_DATA and HGQMD handling introduced by commit 076f786a0ae1
("wifi: rtw88: Fix AP mode incorrect DTIM behavior"), everything else
leaves at line rate through the AC queues. This partially reverts the
usb.c hunk of that commit, whose unconditional routing is what lets
the backlog build up.

On a bench AP (USB2, 20 MHz, WPA2, hostapd, a Windows client driven
through disconnect/reconnect cycles): reconnects fail 0/5 on RTL8822BU
and 0/3 on RTL8821CU before this change, and pass 10/10 and 5/5 with
it, with the page pool staying healthy and no beacon errors logged.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260814053426.2473247-1-mehmet.fide@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index c7f723c084338..355c607202381 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -560,6 +560,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 	u8 qsel;
 
@@ -567,7 +568,8 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 		qsel = TX_DESC_QSEL_MGMT;
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
-		qsel = TX_DESC_QSEL_HIGH;
+		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ?
+		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
 	else
-- 
2.53.0



