Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211163;
	b=DqRLck4AWFPiXU87NkzVfKdFzw5MCaN8U51f5/kPymGg7ur8Sirvb6HNZKtox/JPwIYN
	 JWd1nrrL5cQIT4fPYdFrQHbD7nTif3xTrW9FJ5Pzkuwa/UQy0/4mLQUz7qtFMa9Ixj3wx
	 IkrWk/olAX4VNl9NI/uSUTBtpwDy5Kpx14C+aFSRyJEVWWOTKBGJ995oRQo1s3PLgE5Ye
	 TPs3Z2GbzHk6xn/nBcLscjc+G4TIUtFQ03aKXzdeCF9d9J0VIvu28HTgDwWqguidu52bA
	 G+KcmmqzS8BbtxF85w2G6GZUjsaSRn2mX6/DrukJy6/k0e8i1KVuEvwYisRAn/JzBEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=P+QN5HG1wyKOMNOnKVAfDJvYLfZYVpgceu3SUneyJJM=;
	b=vR6c7WxkQXTfL5WdMdsnMsKbyY24KQ6NQbi+IItLsDn9hGQv8BH0lxXgRf1qytoUK7w1
	 c8F8wppwL0Z6OChjYkjQJQ47aYHXiKcmWIP0IKZoiLR7KvjknuYz8d7C+lIOocuHYrhkV
	 EV0WlBmucCfCt1i4DuTX3DPpcejVV8s2nICQxIp8DuwKrrycorsqeMvNivqp1uIz5ajmj
	 7pvF+2awJTxqrQs60+xVXZeIt2paOSsMyvcdCEU0vgh7CeurEvMNO0xzpPvim6DtQkXjt
	 xi1BDgRVYPiALTpy/yxuC3b5XJXel07hFmc2CWZlXxKx46TGRPZ4h7hTvDQDyW9Qv6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ygMt/LOE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5131860A6F62;
	Wed, 28 Oct 2026 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ygMt/LOE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9420F1F031E5;
	Wed, 28 Oct 2026 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211163;
	bh=P+QN5HG1wyKOMNOnKVAfDJvYLfZYVpgceu3SUneyJJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygMt/LOEdXKNQgqAobq81Drk6pZInxnYKTeX5Qw2l/pHI9lUg09N5uzoiwSfLWubz
	 nMKJcHE9pII8gw5a4d4RBpBn69UbaqB3+UKCcf/r33DtLa5TZ5jURIni6No4tT59Pw
	 9VcxFb+H9ORxiukOjLN40fBpu8xgs4mBHXSyKPAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/571] usb: gadget: at91_udc: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:57:09 +0100
Message-ID: <20261028170014.692849939@linuxfoundation.org>
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

[ Upstream commit cbd1b152519a581bfe14fb6b14ea6e57cca426c1 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

In the error path emit an error message replacing the (less useful)
message by the core. Apart from the improved error message there is no
change in behaviour.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231120215830.71071-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c27d13ce4bab ("usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/at91_udc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1942,7 +1942,7 @@ err_unprepare_fclk:
 	return retval;
 }
 
-static int at91udc_remove(struct platform_device *pdev)
+static void at91udc_remove(struct platform_device *pdev)
 {
 	struct at91_udc *udc = platform_get_drvdata(pdev);
 	unsigned long	flags;
@@ -1950,8 +1950,11 @@ static int at91udc_remove(struct platfor
 	DBG("remove\n");
 
 	usb_del_gadget_udc(&udc->gadget);
-	if (udc->driver)
-		return -EBUSY;
+	if (udc->driver) {
+		dev_err(&pdev->dev,
+			"Driver still in use but removing anyhow\n");
+		return;
+	}
 
 	spin_lock_irqsave(&udc->lock, flags);
 	pullup(udc, 0);
@@ -1961,8 +1964,6 @@ static int at91udc_remove(struct platfor
 	remove_debug_file(udc);
 	clk_unprepare(udc->fclk);
 	clk_unprepare(udc->iclk);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -2018,7 +2019,7 @@ static int at91udc_resume(struct platfor
 #endif
 
 static struct platform_driver at91_udc_driver = {
-	.remove		= at91udc_remove,
+	.remove_new	= at91udc_remove,
 	.shutdown	= at91udc_shutdown,
 	.suspend	= at91udc_suspend,
 	.resume		= at91udc_resume,


