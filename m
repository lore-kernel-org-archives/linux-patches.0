Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613793A48E4;
	Sat, 17 Oct 2026 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256936; cv=none; b=O4Iz5NWpmDh6o6GurYqqtv/xKiLa1mo1ok3GQgRQwj4i4Rk4NhhOVBAn7UjbdJHQaeobnba5wcSZLS7j4CBrWgBWFmjYyHs0E3Madq9/vISyHU9p5cV+PJ8GVUFxERv/aGfolWJ9UwHJ21sA9DqSVceP0TXByQ78+3db6wgVX8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256936; c=relaxed/simple;
	bh=iOGkiapyPZnYRpmWxOCbbqGDbItSRnL14SFEzN9pGJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvjDIKO7LJWj+zAoqC4ZLaDzLqzw4c3W1xeBsbqwWAYn24Rzjsh8LAF1XojB5ZDTFAZOzs7io/FX74PXNQIAsFVq1lDnxID3rieadLniBby41oG/Y15y7ZzvsPLAriuAzKIeBZDfILAKk8CdV0KA51/s3Qx2d24hZI4mHngfOqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afHSBGId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afHSBGId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF5F1F000C4;
	Sat, 17 Oct 2026 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256935;
	bh=HAc0XHGOBtzz+y8ApKRU/5G+mRH67ET0D01idd4YSQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afHSBGIdX04TcgP0mG84jf3BFXSxJ6rAM7hoUbSLTcaY4qFWyk+KJMuEzCiQSA01b
	 ZrPd2wlWz3JVP0d9Vwx2J2vlQ+gH0WCneB2jlQRhyHNq66J+fFqk82vSQMa+i+Nk04
	 /W0rUd04Wf0+X4/13kQLaP3IGroWA80yf2EQUMH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0400/1674] serial: ma35d1: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:44:32 +0200
Message-ID: <20261017160441.387138332@linuxfoundation.org>
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

[ Upstream commit cec346ec4649bb9d741a52da1632db4e6fd13947 ]

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
Link: https://lore.kernel.org/r/20231110152927.70601-22-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 98401cf912fe ("serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ma35d1_serial.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/ma35d1_serial.c b/drivers/tty/serial/ma35d1_serial.c
index 6e5458b085541..f6f832ba7204d 100644
--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -760,14 +760,13 @@ static int ma35d1serial_probe(struct platform_device *pdev)
 /*
  * Remove serial ports registered against a platform device.
  */
-static int ma35d1serial_remove(struct platform_device *dev)
+static void ma35d1serial_remove(struct platform_device *dev)
 {
 	struct uart_port *port = platform_get_drvdata(dev);
 	struct uart_ma35d1_port *up = to_ma35d1_uart_port(port);
 
 	uart_remove_one_port(&ma35d1serial_reg, port);
 	clk_disable_unprepare(up->clk);
-	return 0;
 }
 
 static int ma35d1serial_suspend(struct platform_device *dev, pm_message_t state)
@@ -800,7 +799,7 @@ static int ma35d1serial_resume(struct platform_device *dev)
 
 static struct platform_driver ma35d1serial_driver = {
 	.probe      = ma35d1serial_probe,
-	.remove     = ma35d1serial_remove,
+	.remove_new = ma35d1serial_remove,
 	.suspend    = ma35d1serial_suspend,
 	.resume     = ma35d1serial_resume,
 	.driver     = {
-- 
2.53.0



