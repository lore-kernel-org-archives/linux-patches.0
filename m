Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038863;
	b=e4j2Ygq84phs60X4VyNI67sGDmOv0+D7lm59UQgG5aPuwXG2IGgdaKIlJgfW3psFGMdP
	 dVIJyahm3PJWvaZw2nQd0gRy4Sli4nZ35R6o4qCd/91U4QriDlRXrQHhW/QeJp8Ipy2Ye
	 eRwiohiHrk6u3Nv8erQcNzqd5eonIOPX475CKjN6hYWRw6i/up3OsB3O0B+KHjT715XKK
	 v8VzeLt0Cp3ix3K1ltmd51q3OFJhv4Dtybo3TacZWdsh5AeMzWYk6gv79QeScdp8PAqKe
	 twTma+cLCv85OcSZ+2E0cfkQGrnMINNRd6iDvUOVzmiglUI+2I1bHlsaFT7xLTrlCpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LzYUh62Qj6zWqf35aJdd7BJR/odabu1Dp+tlJysI9Zg=;
	b=jFPp/mDO/Sh7FKv+X3AwSolLh2MAnuIGTwxetQrIJNxnAptYPpVxL6uhPeasBXEveGBr
	 SEvWTo2bfRTLmPuVbszgeZHZXFTeE6dne6kRL0aGpt1JP2u9C4qQ/wIr2Olbt/r2gJNmy
	 n0DBGudmJYQB7wn1BnHS7Z0JK5NX7+CZdXDI7xGoqFH/M5nChTXBNlNJboIapMqZuYFMf
	 6uXKc0zR64KzGMwFN0uoFvBbVMceubx2SsKTGbGNlsDn0skx+Ccb31hrBmxsjIrGXLpdA
	 LPcai+z4YSXzT3Frfgi35iQ6ZtUcqb39pYSQjqWnl2x0qQpahmcIE1OtbvqOjC/6MBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvZ+mtL1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B6606A31C;
	Wed, 18 Nov 2026 21:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvZ+mtL1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146961F000C4;
	Wed, 18 Nov 2026 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038862;
	bh=LzYUh62Qj6zWqf35aJdd7BJR/odabu1Dp+tlJysI9Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvZ+mtL1l6IGz4MJ0RVFefYZtehy8ea/XUIffY5TsiV/6LmHslbYYZh69vYnkbDP1
	 +2TWTZhfctLOI2bPefYkpFNwrOAdO9CFSonmK7Z3hRsgJ6j9BwKTBRBFwus4AgYLZ/
	 iUCx4t4GqzkVQGbHJb2BRH9otgjMUlWlW8x9m7wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1894/3318] can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL devices
Date: Wed, 18 Nov 2026 15:41:56 +0100
Message-ID: <20261118150418.829228228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced unavailable can_cap_enabled(dev, CAN_CAP_XL) with can_is_canxl_dev_mtu(dev->mtu). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 6fb1f9b2a9e20..4f5eec05db220 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -354,7 +354,8 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		break;
 
 	case ETH_P_CANXL:
-		if (!can_is_canxl_skb(skb))
+		if (!can_is_canxl_dev_mtu(dev->mtu) ||
+		    !can_is_canxl_skb(skb))
 			goto inval_skb;
 		break;
 
-- 
2.53.0



