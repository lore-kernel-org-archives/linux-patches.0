Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022617;
	b=LbLF8/zpqMqmsxUlm/o8lT0WDYShsYw4LGI0bVyo/L6p9CKkvzgsM8hN2gCJZYcnk1E5
	 vjAdAFi7SUOitiWWxov6zC+XYwQkyaY6eH+VjL0X1CJX1aA4yv9oQcTuAbhpj/CQACh3g
	 /cKPRAcLxEwLTXtgoZNQ7bq+1gW91m4zqMwCM0iBpneYcnMiaj21wzE8k35pNx4drO81J
	 Q5dUqwiKZ35duF27aqAGJuTRtFm/UUv4DrRA6KtH3Nm/nQFgHoox8YwCRlGmQ8lvDR1MN
	 kER6vzyCuoUc95XB+BzNcM8u+YUs/nj/n7KqKPv2wAGyjPfYRx32zL2J4Zvbk8pxd7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gdj/WDWCew3wa0JwlMOWSBp4oiYlCDwbFpQCL803+Hk=;
	b=xHS2ezrgH1tuRZvVWQgBdALB1BSQzHKicmEEAeRcwYPX3KltBiAIOL/BVTabZSkGohJU
	 AxBFKxjC51F1ABLHlPz0HoSrijLlvBfQKRppUxtolXTCpU6HcsSFPx8Ybp0ryWpYsPwf3
	 Zndo0irjGf+8OpkwyUBUQqMRFR1VcCoA8Jb9bwX/SDeM2IKd72VB/SThcX0hiQHQSaHSx
	 B1JKfAp8H9vSRzwnYnBA04cW3baowhuIrP5EQwuGvS55lj9fk5/f1q+DQ3IvYcrQvgAV2
	 X88CI5G29WhsLMAjvX88stzcuJA/oAQ4szA1/SOskpaFCswOEOKzwN69l3XSwqOseaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Agv94LXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EEF606A325;
	Wed, 18 Nov 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Agv94LXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D970D1F000C4;
	Wed, 18 Nov 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022617;
	bh=gdj/WDWCew3wa0JwlMOWSBp4oiYlCDwbFpQCL803+Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Agv94LXgXRBIHv1/rgCZVwIs1nGlVzIaRNWA8QIBHMbq1YkHDlWDDdzPONgQdZ8WL
	 ZuBUALd6RCGAHCHMSUL2FpWfcru4SmBd0lafWn19OMDL6v5j0qD0Nz6YaTiBKbT0+Q
	 FvmiAH55TrVN0II8J7eeKGntFCk3JSkFzNsxSheE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0050/2151] can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL devices
Date: Wed, 18 Nov 2026 15:29:45 +0100
Message-ID: <20261118150123.554713463@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol@kernel.org>

[ Upstream commit 0fce44e29fce4b07642491b098afb41bd571e4f2 ]

Sending a PF_PACKET bypasses the CAN framework logic and can directly
reach a CAN driver's xmit() function. The PF_PACKET framework only
checks that skb->len does not exceed the net_device MTU.

For a CAN device that is not CAN XL capable, anything above CANFD_MTU
(72 bytes) is therefore dropped before it reaches the driver. However,
CAN XL frames are variable length. can_is_canxl_skb() accepts lengths in
the range CANXL_HDR_SIZE + CANXL_MIN_DLEN up to CANXL_MTU, i.e. 13 to
2060 bytes.

As a result, an ETH_P_CANXL skb with a length between 13 and 72 bytes
can pass both the MTU and the can_dropped_invalid_skb() checks.

A driver that does not support CAN XL will interpret canxl_frame->flags
as a length because of the overlap with can_frame->len. And because
CANXL_XLF is set, the resulting length is between 128 and 255. For
drivers that do not check can_frame->len before copying can_frame->data,
as most drivers do, this results in a buffer overflow of up to 247
bytes.

Drop ETH_P_CANXL skbs if the device does not have the CAN_CAP_XL
capability. Keep can_is_canxl_skb() for the validation of CAN XL skbs.

Closes: https://sashiko.dev/#/patchset/20260731-master-v5-0-5b27029dee20@qq.com?part=1
Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260731-drop_canxl_frames-v1-1-7387b70353b3@kernel.org
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ sashal: Replaced can_cap_enabled(dev, CAN_CAP_XL) with can_is_canxl_dev_mtu(dev->mtu) because the capability API is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 6fb1f9b2a9e20..b643995fc5369 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -354,7 +354,7 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		break;
 
 	case ETH_P_CANXL:
-		if (!can_is_canxl_skb(skb))
+		if (!can_is_canxl_dev_mtu(dev->mtu) || !can_is_canxl_skb(skb))
 			goto inval_skb;
 		break;
 
-- 
2.53.0



