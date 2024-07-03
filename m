Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD71957E4;
	Wed,  3 Jul 2024 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004404; cv=none; b=Oh8+7zJv/icLmV/RVFOPS8SfNZcTe75piAUMS5/GO5721C2M2UAtHvSoW+4C/KfJlhNXXbxcqtTwy2p0+OhSQtF62BM1XDw4MHIecbCML2+H9+Xi/CgNtrNhwYRrKlfuLVDGBzCQJtoc+SmXgHHf8Zkl7ZpywvbTlkvKqeqp3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004404; c=relaxed/simple;
	bh=TuItk1MdMaFg6X0EO4tEIdkXHiAtlacJyPIS7t8Li5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erdUVk9244/+Z9JXIpIqv3Gn3M2mJNrIcKY4h8LaKMhHpIqxFHyuUI/sqPlrCWzP4SOZfdYY9uKvvqhGt3WP+6Vzovy2p7MD+UBUyPYMkWZ+KRJelcxP/Dtsf/ZSohGACCUMMWBOzehcEcLjLK6QyDAuZ1CTxJbaJNBMFwntNpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJaNh7MC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJaNh7MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A64C4AF0B;
	Wed,  3 Jul 2024 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004403;
	bh=TuItk1MdMaFg6X0EO4tEIdkXHiAtlacJyPIS7t8Li5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJaNh7MCEQv7n7AWa9HTmqG4Mdk7e4P3lX9Y9RScshQtKdlRWiCGHDxAz5AI92Qo/
	 FkMgU/SPsRvQA0L5fNUYiQYkMQbxVEvCgiHwqmgOs30oj04hxmey6Zx9bkfL+I/5Lq
	 DAQqV3bRdSoxnk1kbqr0RV3JgRe9qBACjxSt4Me4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/290] serial: sc16is7xx: replace hardcoded divisor value with BIT() macro
Date: Wed,  3 Jul 2024 12:36:52 +0200
Message-ID: <20240703102905.372660875@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d751f8ce5cf6d..88b84d43c2d62 100644
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



