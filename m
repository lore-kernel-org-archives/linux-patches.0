Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C9117BB06;
	Wed,  3 Jul 2024 10:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003347; cv=none; b=Ux4dVX8LDuu535RBpQ46mi204lt89BNpXAl/ZANbVnJp2Ze5rcyXtJT3gRRZv8RS8Wy9dWninvCq4kfQaN75eYp4WC9hap635EdyGk+pyYzofHDvtNtXYM+RdYCODqfYBU/CgPoFbWnazS+7UYYbX8VeGpHvx5AIQinsd7+3y3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003347; c=relaxed/simple;
	bh=t1368XCGfD8T/I/Jjmoc0I0ALjV5Tm99iEPgnQHoqLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHbbMwcUyk+/Wftutih5+OuJLbLukem6z5/MGEucPyvymSbR9h9mKsyHPkb0T0hP4w+x0+nwqj4TKDYYtK2U4vCtu4tIiHVFfqrneB+/dHIbPDnNi7DuzdnSO/hzzLcwn4xE/ZMciosNZWDYyoYy7m36oLtsSKVUHwqZPG+umMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR1ncHIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR1ncHIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E49C2BD10;
	Wed,  3 Jul 2024 10:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003346;
	bh=t1368XCGfD8T/I/Jjmoc0I0ALjV5Tm99iEPgnQHoqLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR1ncHIscEwmRFSj7hFECwnxJQ2Dbf7Ku5nftqJt/VLkkQp+Fcw5wD49BqjHAmpSB
	 T50OGOoyrMFLJbAOLkoWT8zvTQyGp9WrEp1764jTcpo55kZ3ZApHatz51VBalNpFZU
	 8EmHa2AEZezJ/zkvitRPTE2ihTtNj3guZqngU90M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/139] serial: sc16is7xx: replace hardcoded divisor value with BIT() macro
Date: Wed,  3 Jul 2024 12:38:36 +0200
Message-ID: <20240703102831.166761528@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 800cb94e4b912..a1331225cdc21 100644
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



