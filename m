Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211157;
	b=tLHC/SkUKqrel79IYPIQlh89afXLxy3cWQW0WsPfcdb+vSyQterZp6JKmutwKZNSUSFG
	 jewLGW2awGEVsblOnsREd3nVoRn8qxrDnj7zGdJ7or1X8RAKY0YjxHXN6QkbwFf96wyG7
	 lBmCS5cQBpWx8A5e29hMHowqLUfrWulWye2MAG7iJorzQ2d59/2uzD/w4rhOvcdf4tR1r
	 vTsTipyhA8e+ltJ4z/Pm7VmWgitdUi8da/eGdFK/4lOoroWE6AIildlPDNgZ9iQ5d3fPy
	 YY7PoVizCjOh76kwMujR5IudzboY8c2yn+Zj8VWG1/A+u/FWlfRUfnObb6XFoxudCKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/9Vr2iDTkfF2MJKm88D3pTXdbhfFTQQ0ngtv2h+3XV8=;
	b=TRlc22pYDRt1x6e2A4nl53ONhs2Tr+N7bPKOBwYYneVcT+gyzXwUSFLqVk4lWenfqLmA
	 xla8zJhZGimmEk4bxBkqWtoQJzyN24bfb1hMmiysnLjh/mdTiVlzMtEjSwDOckE3BaxWr
	 sNapZx72yFYUzPgc8cyQRsIv7siNPLDx53F/Io2Fvuyb2PgjnIzo1HiidT61kQicMV6ZE
	 ff1utfqCUtr/SOJycyWICiu8YXp3iK+9cCfRUHr+Q2XNedbethqLnqLSeCRqM6kZkzpK7
	 bJVGD7ofAPde3GzO59pgvG5VKAcm+VoMEHu76ifVGpMxRvqoVEJHN98OAWjwPxMQZyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMX7oJGI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F9660A2605;
	Wed, 28 Oct 2026 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMX7oJGI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D7D1F01829;
	Wed, 28 Oct 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211157;
	bh=/9Vr2iDTkfF2MJKm88D3pTXdbhfFTQQ0ngtv2h+3XV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMX7oJGIaUntommiTNJbbwa+dEpIvC14AyyPkM7GSDthdC8+PhfgZTUh9nQJKsdMa
	 TCvWtl3axIrSigkGSnmWEMz9X4sfzwt9rZo9vIDJqj6lzJr+d/FDo8EO1LJ594kDLL
	 I0gQOmsjVqu3+1/whAXivaujGm2d8vqsardfElno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/571] serial: imx: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:57:07 +0100
Message-ID: <20261028170014.646227014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/tty/serial/imx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2484,11 +2484,11 @@ err_clk:
 	return ret;
 }
 
-static int imx_uart_remove(struct platform_device *pdev)
+static void imx_uart_remove(struct platform_device *pdev)
 {
 	struct imx_port *sport = platform_get_drvdata(pdev);
 
-	return uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
+	uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
 }
 
 static void imx_uart_restore_context(struct imx_port *sport)
@@ -2655,7 +2655,7 @@ static const struct dev_pm_ops imx_uart_
 
 static struct platform_driver imx_uart_platform_driver = {
 	.probe = imx_uart_probe,
-	.remove = imx_uart_remove,
+	.remove_new = imx_uart_remove,
 
 	.driver = {
 		.name = "imx-uart",


