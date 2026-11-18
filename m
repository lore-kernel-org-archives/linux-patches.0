Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028566;
	b=k8TZQ8Rea2KiOvldDWGIaQBalHEx8c5Pnfpm2U+234n5i6lV6hq9k6iQls4K7JeLuw9e
	 el12YO/s0ROECcGPKLgtE1aqXQy+PRBvHhlCDeb+gTTonmfn9e53GROMdgfAuIgPTwNXq
	 ojGFlr3ur7eVo5TrQwSanIMHcgtKe1rwOTb/TNAe3Px7LjoV76zRYZtkECfJQmxpPzyAh
	 evPnZsdmURIvw8Yz/H9p+JIUAutxwFpnLKwPWhX/zhnbCKFZYRb0tW8OPwxGVbbWLDW6h
	 cqZRIpMiR7Rla/9pPmvhR5xixGn67g/A8ipRmEfLWDWX7XqQukKd8Tb5qY+FbeSQGRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hX23Tv+pcPsfFs2pNc3V8LbudHgAiYmS60SFPSVMnk4=;
	b=EtYRvn1iB27rN6JIwwixL9xO4U+XjWynf/k/38QMlXqTnRidDn7Ymg0gj1ich13fhX87
	 R23l7/WlJGCKaYw/laHRlW79nXY2BarZ1OSkQ8nmSAnO4E9MwKdVFeWc+5PNfSUJSm4fH
	 oUQQfOG1GW06PLWj+KQOHMDPoTi15JEh7RbuFiTmTLdNuKJrv2OXZewQLeZdWPQLPIhRz
	 HpGK/cjmlFXU0qQa6aA86btZu0iVmDRpUEFkJAzs//5arTE5V5PsuHpGmH3kwcyDsu1EI
	 HTFdKjzHNKH8mVHGh1we+uwU9/xKMvM+ES1WK1rpeWMGAQ7wFMJYtpAY7f6CoraDe5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZbm95Y2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC4606A320;
	Wed, 18 Nov 2026 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZbm95Y2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2346D1F000C4;
	Wed, 18 Nov 2026 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028566;
	bh=hX23Tv+pcPsfFs2pNc3V8LbudHgAiYmS60SFPSVMnk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZbm95Y25v0NKQdcTelO6eX2ATVzrJcQP50JVDhdh0wtJD+9yU1GHWGfOZnLfOeqK
	 BXNLKqBldnxFW7FJl5F1yqjchwVlPWrsWkPU/spn7iaaI55YVekxIlMMeagUtkIHZx
	 OpQlg4dFrz2OwSYZeOjyd26YmXYUEf1PE8GluaKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0041/1756] can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL devices
Date: Wed, 18 Nov 2026 15:36:08 +0100
Message-ID: <20261118150009.528242637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



