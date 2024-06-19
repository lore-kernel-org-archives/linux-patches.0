Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A1D14A0A7;
	Wed, 19 Jun 2024 13:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803675; cv=none; b=exoiL+3a3NaHR/2eHte9qDwFc153YkvYMYK8kQA6ZVZLzdu4m9V3wfdkNV6SFeVDaE/itjNVVYEya+rA01rYEX5YPmCI/NDhDIP0KezEBFGaVExw59ENqCe+N9AKRxPJxhwlGcAl2zCb9zDEU+Ly2rDhm8RI7McIpdXlrGszUew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803675; c=relaxed/simple;
	bh=gSAqZYLQg4/6WKXzZ0ziO3Ijvn46zIfb8n72W530UKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvGHQlUK/rCrceiQbz3JhNMh3sehsm4tiGz02jJFq/4CXUSlWgBtZ4uYW8iSE4n6bEIihJbG0CpmbbIKM/OVx57yQAYzTcgtHHvVm0Pf+ovjlY2J9vZHCugcuYi/lD/Q+B5Hp1KAcOh9wmQKfs9k8Ti0BJd3M6CISwL4WqjnQR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqT71RbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqT71RbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A563C4AF1A;
	Wed, 19 Jun 2024 13:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803675;
	bh=gSAqZYLQg4/6WKXzZ0ziO3Ijvn46zIfb8n72W530UKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqT71RbNmICM1yfiRWcgjA80cL+xmEMvSnB5TsLMQwT+sA5edWC+FYVM06S1CcCPU
	 PSaV2XAXqkM9QgGh8TxOG1mZxuxZwWEqX5733p79qD2IrZ0ZLWW9UAFUV04sLJdzvF
	 xSTmP+DAj0Prtm64uiL4/U5C20VrN+mPjB678IOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/217] serial: sc16is7xx: replace hardcoded divisor value with BIT() macro
Date: Wed, 19 Jun 2024 14:55:07 +0200
Message-ID: <20240619125559.155789905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6eedebf67765..08da7cc221d0e 100644
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



