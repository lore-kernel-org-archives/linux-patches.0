Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D293B9D96;
	Sat, 17 Oct 2026 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256833; cv=none; b=g9k1mJWyG08XKkjYP52IDaD3Y3WpmVbgdWV7UhyO52tVizWhqTGDseoLdvEPbxtEKcBUFufKQYwI+ecRX5zjrXsrLTzNnuWr08tRAWPkq06M9mRuLcHjPscSeHkSUba5NNjE/9QG6UwTtXkVnowu17cgBPC1qbTFfPY6qJvzeqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256833; c=relaxed/simple;
	bh=YkaGhi0ghENNPymDwe02pWTQMQa46A77Ifq/oJynUnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuGG7uChxTq3tQagfkp7vfsoyqFjuLMx/VpJ1Fqm4biOABz22PPIrCFpESkFEC/A6d0LodptR6TcJR4ziBGfKx8Cz5YjQBtysMrCghOnWHtNrs3dMlWDcdDDga/zsm+NlWqfs3OIRZfm3RIHVmdgBobg92T6/zSCqqutz0as/JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjJdHkN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjJdHkN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B280E1F000C6;
	Sat, 17 Oct 2026 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256832;
	bh=u9OmDDMUL6k47Gr7Z4PI5bDEHjuw1XHk2KCoceyMEb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjJdHkN1xCl0ER/mmQAptkWojvvNF/H/9pjT3p8KUmppEpnMt/BcLaaAjhoXZRuzA
	 bn7lr4/5ewN3CfAr7Bdb0KCu5+OlqEmvDsdYRZzFcRD92r9/7BraWHff3URQH+NtM6
	 aTI4+CUquRN14sVlO0DMbCrZhngKgOKC5nQUSIuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0366/1674] serial: imx: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:43:58 +0200
Message-ID: <20261017160440.515790283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2502,13 +2502,11 @@ err_clk:
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
@@ -2677,7 +2675,7 @@ static const struct dev_pm_ops imx_uart_
 
 static struct platform_driver imx_uart_platform_driver = {
 	.probe = imx_uart_probe,
-	.remove = imx_uart_remove,
+	.remove_new = imx_uart_remove,
 
 	.driver = {
 		.name = "imx-uart",


