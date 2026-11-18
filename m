Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059603;
	b=QI2mTcAq0GoZw4R+qcjSRAWG8KNOi4DqislKMK+w7xooIBKy61IilCJONBocsclKCHL9
	 6val9oXMOJpjqhqk1AL0t+VyYL2wDDt67SAhdqNP7ZZr1Neq61Wg7G8WFG7ebNDm0gk2U
	 GgJqc4rl65vYClPvi0OO9wrSRmHkorgFRZGJDfkNnEB9LUz7uks5RQTwjRDVE/2uulDdS
	 jvSp6R8/XPTqLUHoJBDT5fxI0f5UIYmOF3+99pu7wK0CXqGnK3qJnof3bBa+h8LyDZ/8v
	 Km6D84xGQ6hdI4WWWO0WRdKTGD9en6XoNcNeQ4G8zPedgrtCcSSpMOLuAC8YWx2Xd7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ww+4k1zKEbGGgD4P/YzH/5p1KWMfa3yUTvEoKaWXPvY=;
	b=muE8faT7ws2QBqcTfusRd8kV7nscBhY3cK1YIXnWNyerlwLruJbW8Ti+FUMHP/mMOYOT
	 X3HDz/N85pVf8pqUm2ABIYU8R03IzVPmTrMsKlGwnBVgLVkF2Bctzy8+kP10UeTjE2yDl
	 mTXD/8e3qtq/DfsxG8N83l+HAGs/1ceOZPIYag1ZdWyVUIYSZtchiL9h3xQo5GKVQfwxp
	 hJQJV1Pdd1/mQNPkZOe8J2xqFCT23qmP6oVc/OkfhXaZ05chASvUS3DWapSV5tFG734WV
	 J6Eh/k4/nJnSNKcMaR+jD2MVy4FH63+2lGCkodx2OHWx4D9UrT7T4nfIWB2yTE91l4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvlp6lOa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C6460A261B;
	Thu, 19 Nov 2026 03:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvlp6lOa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630621F000C6;
	Thu, 19 Nov 2026 03:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059602;
	bh=ww+4k1zKEbGGgD4P/YzH/5p1KWMfa3yUTvEoKaWXPvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvlp6lOaDHuV4EPaPjBpkakaj44eiUWwZhHDzMV3DmqPjjmW99k5E2eBfNbbJ8ni7
	 0lolarRh6TRi2vig0gjTdCkwz1RrWtF3r0GVB+aOeUGGbVYu6qa/YxByrIciA/g7bZ
	 kDUB5u4HlG6S4rm+pcyiyX4vsGt2wUz8bP9VUs6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0901/1848] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Wed, 18 Nov 2026 15:48:59 +0100
Message-ID: <20261118145954.491313860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 1c41d09dcd07ee9648e20aa8238e404c2e6a12fb ]

MCR register has the same address as XON1 register.
IER register has the same address as DLH register.

Which register is accessed depends on bits configuration in some
other registers.

To prevent potential access errors, declare MCR and IER as volatile
registers.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20261006192540.234402-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adjusted context to match the existing switch using reg >> SC16IS7XX_REG_SHIFT ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index e177df2c4ea22..1934fce0fa732 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -467,7 +467,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg >> SC16IS7XX_REG_SHIFT) {
 	case SC16IS7XX_RHR_REG:
+	case SC16IS7XX_IER_REG: /* Shared address space with DLH */
 	case SC16IS7XX_IIR_REG:
+	case SC16IS7XX_MCR_REG: /* Shared address space with XON1 */
 	case SC16IS7XX_LSR_REG:
 	case SC16IS7XX_MSR_REG:
 	case SC16IS7XX_TXLVL_REG:
-- 
2.53.0



