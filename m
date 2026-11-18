Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038367;
	b=uQoJlKrCUYphuKQc+ix/pjbfTme5cnW4w1ldfQFDaRy0TD2dgTaNQXzPgT0JFy7MC2cI
	 y4drCOh0FtWtPruKPz7IJ9r7dqI/jnaePCIF/QZGfUwQlTR4MkmAs0NBsQAe4qqglRowL
	 xqSLKDFhH+93f8RcvzAzvGiq7a3pe/3+97DMCcxoi0hkvd/Hzh/UbcjkWkl3w6ohT5uI4
	 I9mLsRtpH+8tgmnbXOUqPUbwXf9zvFtxnie5D4UsgrYwbeb5SGSDCcoakvUMMeRcgqvzT
	 b6pHv/E+1RXjdPcSaks9Ix7gfygcQ1+ZtEPZzFem7WLO/yUM2QQyjnHau9/f8Vxq0hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fvYz5vRZGb26FzkenSPz4wi0lsEOzV7UsP0dqbyFurc=;
	b=zZc5vJY0Nf2e0si2p/v83mgOWSiMn8Y+Z4MfHH+psXHvWMgFP6ko7oqZMtjuFkM99yEw
	 59bz3xI9fUC490BiHo1dztykv0XOM8lagOSIvYVm3NhL6HRCSPZQp4UbHbM+9bSnBohUa
	 /i5SM9HJhaj8y+Dz900/RlutAAiMiEIZHgqZWxF1v+UFJRwBZ+1VatI8JC6vS/eR7c0Tr
	 9dlPGfQZC47CdEAJ6r3HKjWCmDuNVOf+5DyGIu9xeoPMvWaoQye+/0h7NKsUp29EjUigN
	 OfYJ2tJeLgHifWMmW6jE868LMejYitRQ8BU08oQ4RKlodaa6+F0iR7ZMkcB0JH05xmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiFPql84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF39606A31C;
	Wed, 18 Nov 2026 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiFPql84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F56E1F000C4;
	Wed, 18 Nov 2026 21:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038367;
	bh=fvYz5vRZGb26FzkenSPz4wi0lsEOzV7UsP0dqbyFurc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiFPql84/sdAs6S4Y0XEU0hUii247EqiWYB3nnh41y3hw61fBXcYqWS3ieh0iiDtl
	 SeMTYOihJZqLdu5bcKxZBqWUKVMniZaWYb8aLzC+Lt0wQx1wvdDASumIsa02lYNi/C
	 Kiokt6x5vEuFo7/qBIzV4f2xX0gztfewiMy5l+iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1719/3318] serial: sc16is7xx: add comments for lock requirements
Date: Wed, 18 Nov 2026 15:39:01 +0100
Message-ID: <20261118150413.436575668@linuxfoundation.org>
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

[ Upstream commit 42405cb77fd35b5acc0e5a11d74eef68c2afa484 ]

Indicate why lock needs to be asserted when accessing
MSR register, as this is not immediately obvious when looking at this
register in the device datasheet.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-15-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c41d09dcd07 ("serial: sc16is7xx: declare MCR and IER as volatile registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index fbe8128b5e681..3a11bd9230555 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -532,10 +532,10 @@ static const struct sc16is7xx_devtype sc16is762_devtype = {
 static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case SC16IS7XX_RHR_REG:
-	case SC16IS7XX_IIR_REG:
-	case SC16IS7XX_LSR_REG:
-	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_RHR_REG: /* Shared address space with THR & DLL */
+	case SC16IS7XX_IIR_REG: /* Shared address space with FCR & EFR */
+	case SC16IS7XX_LSR_REG: /* Shared address space with XON2 */
+	case SC16IS7XX_MSR_REG: /* Shared address space with TCR & XOFF1 */
 	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
@@ -780,6 +780,7 @@ static void sc16is7xx_update_mlines(struct sc16is7xx_one *one)
 	unsigned long flags;
 	unsigned int status, changed;
 
+	/* Lock required as MSR address is shared with TCR and XOFF1. */
 	lockdep_assert_held_once(&one->lock);
 
 	status = sc16is7xx_get_hwmctrl(port);
-- 
2.53.0



