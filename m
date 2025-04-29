Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F4520C488;
	Tue, 29 Apr 2025 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950182; cv=none; b=Xbrw3jXjEcYK752I0CdYXt9boMXsypEHKjHDutE8Hngcn++ZUYFG4ycbxDcP/KauZjaLpDOk8GLhq96p2i4Kf1soOa6OHBl0fYBEQL5AXXHdEbFDyMzRUQh8TjezWVN9HlYLlXg6+X8vx7VQH2Ul7+vE6T/hpwH3FjVfcw1A7GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950182; c=relaxed/simple;
	bh=YgafliukxonebhwJyYKv3TdROWW9HFv1lWWG3JgBksE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMfx1r57OMQaMqF8EaBP2LVZ2itP5vIf1CrIw35oW0Ot3WvVw+skaDXQvpOwaVwNpThjbEH/BxS7jrPqSY1G2VDw1MTSL1wBYw04ZV7peOZKxvy+rn0EsvUwCoj/deVf2YdpyHuJtzlL0Gt305A6azXvpZ93Rq9eJRziRRQTGnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/LKU5R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/LKU5R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC0EC4CEE3;
	Tue, 29 Apr 2025 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950182;
	bh=YgafliukxonebhwJyYKv3TdROWW9HFv1lWWG3JgBksE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/LKU5R4u1aR/7A7FqNWdZkLCq6ut8bXJZYQw7vv5TZqWfMEkDHqSnUG3RlYeR0hT
	 8J3NZkRlqmmw9ruZQQD7dCwDzjSIpPVhZrZeLUK0BOVi+3vbHRORxpvIKnwUnVjmiC
	 b369pm2TfkFi+nN3KOy0eucEOkkeoXKbK7yFGmPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/204] auxdisplay: hd44780: Convert to platform remove callback returning void
Date: Tue, 29 Apr 2025 18:41:42 +0200
Message-ID: <20250429161100.001152719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



