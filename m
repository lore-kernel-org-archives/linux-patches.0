Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213027;
	b=eRyjHZ5ZLC+U5kxl2egSnfQWdkoRRCFiYyw/pPqDcPeCJDWMBjUnDzNsQNJp9aimC9ZR
	 z8l16TH0w+xGDP2ralExDgOJnxU+sfwPIFL/8Xw3px5aol0e5C9Cjrj48V+ioNvY9B0Vj
	 2YADX3JGTgxJC3Im0JO6shNT8U7jmnIkfC0jEu84dM76LOyGyv9xSdcB6Ec2s+to8WUEL
	 LlAu21GMJY/1sKWjRXAtsfHbjht3MKIYfLGR3xN4c+l9OKBBLwv4itqRqoX5lCZaO3GqI
	 j7qQKXV9oyi8Ru4pHOcViUjjRzzORspbbp6rY6htJorJlD0yVvzlTpg/Vp8i2MloGNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3/MMwuEe2MdTPEVb3qr9jRbi15Sn1iPdMM6O6ouCFFY=;
	b=3oYFp1xotgKzDMAdE/tVSyTpXpfxiwkrjFK29twn64O6pTuESVgAVAgEywaZ8+KZZKpA
	 q3pr/HeGuvaa9UrnOZDa6FYbblqSxHhaL7r2NRBEiCZw/QqVwNoYgaqr+i1IneciR/FLF
	 sETk57m8WpfgPIzlLU8tIBHKmcixoU4Gib7Ib60OSv2RygCGwgQxozXrdPaoLYPRaR687
	 xXkf5zy1ZYNv0/RrGeh2J0hy+VTK4MOMJjqzh8Chuk8WK1MZv3VBW/SLnOfttY8+WU+1W
	 kUfYuEj3n+P3QH8b39/UHTHLbQasC/TI6jlzJ9skxkrVE6dK7jfdA0W9/M0A5165rLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKxzDlbt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6358E606A320;
	Wed, 28 Oct 2026 18:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKxzDlbt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B672F1F01829;
	Wed, 28 Oct 2026 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213027;
	bh=3/MMwuEe2MdTPEVb3qr9jRbi15Sn1iPdMM6O6ouCFFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKxzDlbtrzMWj+yD/Ro1iGvH3MPogq4RIK6QDMCZhEu2cuL2uuLXs3ZsQb5UGslM+
	 90q92Bdbs1pce6F1Tdj0PLBAPLXBfCD1tP5cGEv6H7cHXTS6yVhlK2J4DFX1ONI49v
	 aoNgVtXyPOzNEfByKLNEaVU+sdxNQG0g9sd/WJb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0361/1887] serial: imx: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:40:57 +0100
Message-ID: <20261028170507.447551518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c066f87314b7fbbf4d72d38957436a98e7b7e503 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231110152927.70601-18-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8b0b29fdcb47 ("serial: imx: serialize imx_uart_ports[] lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2534,13 +2534,11 @@ err_clk:
 	return ret;
 }
 
-static int imx_uart_remove(struct platform_device *pdev)
+static void imx_uart_remove(struct platform_device *pdev)
 {
 	struct imx_port *sport = platform_get_drvdata(pdev);
 
 	uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
-
-	return 0;
 }
 
 static void imx_uart_restore_context(struct imx_port *sport)
@@ -2709,7 +2707,7 @@ static const struct dev_pm_ops imx_uart_
 
 static struct platform_driver imx_uart_platform_driver = {
 	.probe = imx_uart_probe,
-	.remove = imx_uart_remove,
+	.remove_new = imx_uart_remove,
 
 	.driver = {
 		.name = "imx-uart",


