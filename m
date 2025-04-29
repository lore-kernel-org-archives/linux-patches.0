Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D300221D92;
	Tue, 29 Apr 2025 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949706; cv=none; b=OSV28T75zXB/aG2MYtHaRZ8mdnZ7Ld89wH/XJxffuI+ClTdbi0ICWZzSQ215PN+g1phP2zPYE9C9HWpZbsTHpAMKhclLSmla5CRTzXiJvgd8RfXBEUduOcPC7HTtbx3JEqsE2NjYUSqKCq2bG7xO9uS20UmS2AY8D21GwUIwdsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949706; c=relaxed/simple;
	bh=0HuXTdtDnNFYO+jQFw9AGhAhtYo44bHbbifhRdqWcsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCmfJ1IQ5EggiMy8gwmW7XRE5b/PFpUdmdy3yM0QTRToeuyZD+Egook9okqUhtOX6tnwqPXS5uUkc4lfD/7l7MY2mp9/uD2CUxFKfQN0dgSotr/ejh4yL6B/1494iRpz6a866EK2tdNyMMiQVr01p5oYIhQt4mG+Mn/n4B5F1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R062et2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R062et2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B0AC4CEE3;
	Tue, 29 Apr 2025 18:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949706;
	bh=0HuXTdtDnNFYO+jQFw9AGhAhtYo44bHbbifhRdqWcsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R062et2PmeCOczVS1FMXu0PknWUkxxCd1DP8r4vG+0Gq3OvCF9h9esCGBag7aeno
	 ODD4lR1PLc9h+8lZ11y23Uds+eLHgqYvifi0/qLNnQiAwAN/oLD6K9wNb3/hk3Cnbq
	 ulIKeil3qBGd3VudFQsvgJzDyUgF0t6FCqPDNNhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/167] auxdisplay: hd44780: Convert to platform remove callback returning void
Date: Tue, 29 Apr 2025 18:41:56 +0200
Message-ID: <20250429161052.088280452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9ea02f7cc39d484d16e8a14f3713fefcd33407c0 ]

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
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 9b98a7d2e5f4 ("auxdisplay: hd44780: Fix an API misuse in hd44780.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/hd44780.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index d56a5d508ccd7..7ac0b1b1d5482 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -319,7 +319,7 @@ static int hd44780_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int hd44780_remove(struct platform_device *pdev)
+static void hd44780_remove(struct platform_device *pdev)
 {
 	struct charlcd *lcd = platform_get_drvdata(pdev);
 	struct hd44780_common *hdc = lcd->drvdata;
@@ -329,7 +329,6 @@ static int hd44780_remove(struct platform_device *pdev)
 	kfree(lcd->drvdata);
 
 	kfree(lcd);
-	return 0;
 }
 
 static const struct of_device_id hd44780_of_match[] = {
@@ -340,7 +339,7 @@ MODULE_DEVICE_TABLE(of, hd44780_of_match);
 
 static struct platform_driver hd44780_driver = {
 	.probe = hd44780_probe,
-	.remove = hd44780_remove,
+	.remove_new = hd44780_remove,
 	.driver		= {
 		.name	= "hd44780",
 		.of_match_table = hd44780_of_match,
-- 
2.39.5



