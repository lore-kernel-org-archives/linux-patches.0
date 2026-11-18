Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038364;
	b=s68KKKWXJRIIbupxe9+xs0RfVtN7C9QrYTeK2RJZtKga7HwozEzygYZ3xOFrCjP5Nhng
	 J2Pn1r4vhnWuDnK/L0tHDZZaEYJQxXqPP23yMwcVhRcOsWssQ8idC1iHWftxNMif16YNt
	 Bbm5gCoLcFIXrvR8cbMGuCKp3Vnvj0gL8FZYYMmVxfDNzXecZC3Y5WI3+8KErGEQsLy5/
	 OpzUjQ5Qz10BxLHxSfkndhmtQEXhLl40v8kAU3fQivZRPKwDqD08cWvs16iCeJBs/Xvgq
	 txaI90w5DhPGF6y6kGs5UJBGajVKdwLRRDgXHWu5jRmysLRX1996k7kCI9oJWTLGMNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TLWDTZPZBiLaPsfy79oWL0AgjvHTXawHjL/5i4J6pJ0=;
	b=NkXhwEFAIksuqRRpZ9zRl4Vfk+unbbzBnPH+lgUlTUkoKh5zOyy42o5eGBE4Ze8Tvilw
	 mqgrG0PW+fDmnWm2z5/mJp8RkhMnHe6NIDUpGaDXzDEcyE7MOpZG0rolWSnc1Z0X2dF7/
	 1cyXsyHzhH/LIU30iWOzrIoUuT341LA91e2pCoJNvRS1Ztj8ui5e4V+jaz0Qr8cRGXXu4
	 OpKY7ccsoCt1Apc+jNZkZaJYwn1XlRcUbnW92FHL36Lprgs2QGl2ZtsfaCENxWDa15mq3
	 98NlGmYCrHDpiQkpxKBfRH5WPvJM6uGlpkaEXcZP4nhbvQwlGL1TCKixDvaUeZPBFBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ME2qs5kN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4632A606A325;
	Wed, 18 Nov 2026 21:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ME2qs5kN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9441D1F000CE;
	Wed, 18 Nov 2026 21:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038364;
	bh=TLWDTZPZBiLaPsfy79oWL0AgjvHTXawHjL/5i4J6pJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ME2qs5kN0durMcCM2GlswvB64/brj+dASt0nbvbh1L6Wyj80upGNlXjRlFpMVXd/V
	 pga7i38q198cMJNsGoQ8p8ZRKSw17VtmtyDq9f8GYLqZqqTK4uGTXNTGrrrx680BHp
	 XihHVsknJfNhlmKwHjjOBixT6TzFyTqo09gj8ry4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1718/3318] serial: sc16is7xx: declare SPR/TLR/XOFF2 register as volatile
Date: Wed, 18 Nov 2026 15:39:00 +0100
Message-ID: <20261118150413.407528142@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 983f91e5f13149ade6dbd9568053ecd0ab5e9265 ]

SPR shares the same address space as TLR and XOFF2. If SPR or TLR were to
be used eventually, this could lead to incorrect read value from the cache.

Prevent this potential bug by declaring SPR/TLR/XOFF2 as volatile.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-8-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c41d09dcd07 ("serial: sc16is7xx: declare MCR and IER as volatile registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index b208181de2455..fbe8128b5e681 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -536,6 +536,7 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 	case SC16IS7XX_IIR_REG:
 	case SC16IS7XX_LSR_REG:
 	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
 	case SC16IS7XX_IOSTATE_REG:
-- 
2.53.0



