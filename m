Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206261FE7;
	Wed,  3 Jul 2024 11:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005358; cv=none; b=oCYrnbqH9NyOBN6EdZBi1Nns0O48Tz6J22h5jDOzf+2F/ztwbUeDWyqFK2yx3Rf5K4rGWuaRRql8n96oJjabwUyj7Jk9Pf6JtG0r3q76d1aQannoq6EdJOycriCArDSiUnFMNP0S01CknSDDm+M8Ngvi5dn6Tw5KiY+zLKB2ds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005358; c=relaxed/simple;
	bh=fcmXZcNdVo9MqC+qNg1HgdLwnLJGVRmf6Quh/2WWvdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trMqungfj12uSI8Ua6hcCoCof6fyUcWyZ2zlVJEM0OsMAOusF9jmSw6aV9Cp7M/fkFO2XHw4Xxrpd39R0fth+leBlWomc2tTveqcjMhI2nZX+8u9Gw2zC8/+/j0GuI639yAKskKBvjwTU+ipYN/fogw1vkFKFq6FMvwiHifCxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bEwGpa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bEwGpa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04E1C2BD10;
	Wed,  3 Jul 2024 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005358;
	bh=fcmXZcNdVo9MqC+qNg1HgdLwnLJGVRmf6Quh/2WWvdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bEwGpa5+tSV7dNxqfSF4flwds4Ggb106FfEecWwid/R8beHvs3zalVPVZwC8LSv8
	 B8iOqzwti59KvE26aDRe/ORKS0iBsbvGmE1wRRsFEAwaKXKkWTkrHbNnjKi5TfHiME
	 KnYVQAuT2i7rhv47sLfvzOiNvZETIkEmW2NaY/c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/356] serial: sc16is7xx: replace hardcoded divisor value with BIT() macro
Date: Wed,  3 Jul 2024 12:36:31 +0200
Message-ID: <20240703102915.177084071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35f8675db1d89..25e625c2ee74b 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -497,7 +497,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	u8 prescaler = 0;
 	unsigned long clk = port->uartclk, div = clk / 16 / baud;
 
-	if (div > 0xffff) {
+	if (div >= BIT(16)) {
 		prescaler = SC16IS7XX_MCR_CLKSEL_BIT;
 		div /= 4;
 	}
-- 
2.43.0



