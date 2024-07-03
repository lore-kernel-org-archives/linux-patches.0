Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7562317B40C;
	Wed,  3 Jul 2024 10:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003821; cv=none; b=g4eq758mKTGrEf26el+0Or9230FzCvPOHcLkwxBysDeNgwXS+4Pj/9wMhYvL3dk7oLHJgUXoeRD+p1217CxuT9Soq/FXvIrqD5Y2ZZ4ssXk+uSFZebeVkWBjp8cQJ+wJq0++nYMXGsMdidn5BxVzdjObyF2IgBsLQFtcEbKfFeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003821; c=relaxed/simple;
	bh=uaDHIXqz4FyPOzIrRL1gvDBGx+Vt/tlQeqjGzYdomiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAo1PtnLHifW43rbAynp+zJPkQOQ1jEYatOtPqFmu5ZU/B8F6HykgEf9t724V3SroHumnB6RUPoB4/+ouswFOqj+uuvY8cocF0OrZIPpZDaL/7pIEz0jIv70vKJn1ovzFjb9Hmed6cL1ki3WN/Rp3n4Q0KueCvj3dA2vW3hYLmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqhmJjPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqhmJjPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F74C2BD10;
	Wed,  3 Jul 2024 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003821;
	bh=uaDHIXqz4FyPOzIrRL1gvDBGx+Vt/tlQeqjGzYdomiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqhmJjPDVL2NqmRT/OLvlDgQfTeTbQk0gv5UnCpccsTidfyAW8+b7v9RJAx1xdgdw
	 rO5a6E+skDjKchwo90d2e/pSAXylU4pUq1BgJkGk/XMORPHbmmo1MNBXAQoxCIil5c
	 ZEvfs5EQw/W0jtvagIUvY8jAnDh3CxEmSC0dunK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/189] serial: sc16is7xx: replace hardcoded divisor value with BIT() macro
Date: Wed,  3 Jul 2024 12:38:13 +0200
Message-ID: <20240703102842.720510876@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 892e27cddb0ff..fad8d1f744466 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -496,7 +496,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	u8 prescaler = 0;
 	unsigned long clk = port->uartclk, div = clk / 16 / baud;
 
-	if (div > 0xffff) {
+	if (div >= BIT(16)) {
 		prescaler = SC16IS7XX_MCR_CLKSEL_BIT;
 		div /= 4;
 	}
-- 
2.43.0



