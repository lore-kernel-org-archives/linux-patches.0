Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D93196D90;
	Thu,  6 Jun 2024 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683666; cv=none; b=Sua99W9otht5Do7BoUDV6BYdm/UeE+8GBsTrN5N+vXLaCWl+16FclizK2CUxfjd2wu3K7O2FZ2p/fDigV05ndfTiFP37IQFi3Kzli97o//cQnoyDMXOTeYWUbmT3srAKQTq6IuvPvuNSJQrBY9RXVBaOszXP9pJ/MyFdLY7JwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683666; c=relaxed/simple;
	bh=4wlpuHcgZAX6Dk8oma2Nc0O8b/gdiX1ednA2ptRipz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjvFQWY92jUnmF6TnVSwsQlDelLgSUvvpE7tO1phtChMEwMOi84Rf2A8fvO1E2hJ8Er2BuawC659STaqtvjzqN2XvVVYeGaZd6MGJhb8TI+JKTm/r0/KH7hQ7VomlRDvK6YT0T2+5/uQ1NN0hHUMXOqBHBxQfeAdZAYS2y+bAo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/H884JZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/H884JZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D1AC2BD10;
	Thu,  6 Jun 2024 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683666;
	bh=4wlpuHcgZAX6Dk8oma2Nc0O8b/gdiX1ednA2ptRipz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/H884JZDEkJrpX1HkhGy3FR1JOF85zNRyOgAlJUaEkg+nz3nJhL6nIBoJTvcz0qL
	 6wBYo4hbhT7OP8LJs3eMsazDRxCx7ZjeDYFK4kIqQtyyfaR8EtrITPhY18pf/Pjg/C
	 OMVCGgQUs+x2Rea+4WvlTK3RbPil+VWguHgi2Nvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 551/744] serial: sc16is7xx: replace hardcoded divisor value with BIT() macro
Date: Thu,  6 Jun 2024 16:03:43 +0200
Message-ID: <20240606131750.131177062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 2e57cefc4477659527f7adab1f87cdbf60ef1ae6 ]

To better show why the limit is what it is, since we have only 16 bits for
the divisor.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-13-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8492bd91aa05 ("serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 89eea1b8070fb..26ab1f042f5b8 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -489,7 +489,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	u8 prescaler = 0;
 	unsigned long clk = port->uartclk, div = clk / 16 / baud;
 
-	if (div > 0xffff) {
+	if (div >= BIT(16)) {
 		prescaler = SC16IS7XX_MCR_CLKSEL_BIT;
 		div /= 4;
 	}
-- 
2.43.0



