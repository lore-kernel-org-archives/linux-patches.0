Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591405;
	b=ZHhFaYPDWjoN5DxUEAv3/W89HCNJDM0d96kfvmbjXHfMYrELo3Nn9BbJ04Nkzamu8JoB
	 N3MGT+4bd1Y3DXO/aCs69eXvZAIOIcFWlosa874kqthRCjOeFMLxLCKsBgmGWxkI14QKF
	 Wgj3+R3ZiqiJ2FIfrbUP85AhAztmP+p/8xI1nj0HK1OOBjfV+7YId+PvtTHKYYAQNY+/4
	 t/Z4/ZrjsAWt1q788tCgBpVH9LCgqk6+LT0BehW1asiqIaojncUdV7rv8LI3Ob+eoGvFh
	 cCs2zHLljqOtZ5BUMbPIT06I1B+g4sLr2yFRB49uzANIzRGe2SZnMSwLJf/DZ8mzMyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u8dNhVPEdWjZ7bH3hYp7ikvyZsJVY3VPYksZjNVOmOk=;
	b=A46MbIs+2H2s8MhuHvoyduNhRvHQ3A/340U5AHAW3gRqoxILqJ3fZYfxycpYrU+IhdjU
	 FUWZxBYRSsQuOb+B4gvDkIHsbRBsY4DdaqowIIiKJH/nsbd2dSUpA9qSbji5gvd6M0S+7
	 OXfKxUnaZ6dA/frrLDBQTf355frjFX+BWX8Bw9KewxIwblMxNRYn6YaYltA14/n9yOudB
	 szdJMellNN13sHZoquzlCrUoDd6KkFmJhySsnj0PwdGbGTlm8Y2vhvOI9Txyz3iQCHQ+a
	 uy8IEDnpMMzaUm/jEMf6uRAmC3LCIffORiz0CimK05o6s8bawIPNvanBruxJ+zerlaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsaFAG9K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D516079D60;
	Fri, 13 Nov 2026 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsaFAG9K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CC41F000C4;
	Fri, 13 Nov 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591405;
	bh=u8dNhVPEdWjZ7bH3hYp7ikvyZsJVY3VPYksZjNVOmOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsaFAG9KsjmWbCF00j6+2e0ZQyMqvfx/eoRgt1abeYdw3t1jEw+Cru3/Q0APRAU7F
	 ibgX9emyUuTmHJ1zwWi4zwT+rSMfkpb1SWNNf9nLi4yPm/ZC7AbkGCBhWnLvFVJjWe
	 5JYw3zdkMN56ffJ45cdbvV0TbnJTpjwuYosoqFWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 501/670] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Fri, 13 Nov 2026 10:51:05 -0500
Message-ID: <20261113153828.936164472@linuxfoundation.org>
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
index b3e1e9a0fda69..006ad50ff24f8 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -558,6 +558,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 	u8 qsel;
 
@@ -565,7 +566,8 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
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



