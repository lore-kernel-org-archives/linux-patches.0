Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038063;
	b=oAuRR3+7VCi+1lJ9f7/UFJAA9BKEQfZZ6zfMn/5bRpg+Nw0SZmMiYlmxc5z8/5ajqfX1
	 59bSnXr3EULksXSaNn4zhy65GeENoWtmz4IEJq6/S1ZAJyudHaPEBurGkXkVv2r3nhGJY
	 R3adLeK0tKgpg0dHkj3iRmUj0QjvymDN8jAblgilGIxL+7baNySSHGSbmpDEDNtr4EJ+Z
	 jMkAR879Zz6BYxcM5ShgBtU+mSJ1ldHbGgN78Lpc4Af3kd5/5uqRSfjLJxN3/Wj4gh0d2
	 UGfgDErhdy0Hrg4DuoyqMKt1DEr7h+gJMsePUBh+0kwKOOmZnos5qDRSUlqyrrq+BuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NDokLJQpmxu6Ifn/sNwecgSC3wXNOBqDq1yq0hoilBY=;
	b=zuvLY27RiS0zWYn5xIHrrmTsFzt7CQq3r4+g0EWjm3sp0jx68jer90bpIxeCrNn1IF/R
	 5dgO8OIo6LSsW/PLbd6iVMF2jm3KXBjEzKnJzJcfFG+fWN15e2/8TZ9tDqvGVxeqoFpIu
	 05By4Zq08qn/CnIkRWpWWV7cP61LFr1KNdsk9Q5LJKREo7RmiQpJ23hfL0ZlbPolwOrzx
	 5SikszGhBeOxOuKVlutTlhpCoFVMO3P/TsoBfAY6bU3djCMGF9AFksQgYr9JCJAN38XED
	 CreG2IM2qxPUhlDxhky5sQWcGuezNLkOcx+YlOye41St52i6dARwLuUNfEMH+MCohxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf0TxTwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908FB606A32A;
	Wed, 18 Nov 2026 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf0TxTwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF281F000C4;
	Wed, 18 Nov 2026 21:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038063;
	bh=NDokLJQpmxu6Ifn/sNwecgSC3wXNOBqDq1yq0hoilBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf0TxTwG2WVdj6FkbSsMrlbEqooQJGokd3C1tBqLgzah5kwMVt33VnEdDqEFluakl
	 aaoar2uCOfrLhgjAdrd9nK+xbE/Z/aVXITbxPogkvvjKCYmVJ/uwcudZQsSAx19HM4
	 Br3F/R9UtAS6k8uBNPOFhKmIWfjDVfDiWi5WniLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1614/3318] arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:37:16 +0100
Message-ID: <20261118150409.609241358@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 8ef8a0e38d1377c6d51c06f95c64d87641b2c717 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-11-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
[ sashal: adapted to the older shared device-tree layout, where AM625 SK and AM62 LP SK share the pinmux block ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
index 8d608c7ee2b12..1483c361807eb 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -169,7 +169,7 @@ AM62X_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24/H19) GPMC0_CSn3.I2C2_SDA */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (Y3/V3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (AB1/Y1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1/Y1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (AA2/V2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT, 0) /* (AA1/V1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT, 0) /* (AA3/W2) MMC0_DAT2 */
-- 
2.53.0



