Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A7F19752C;
	Wed,  2 Oct 2024 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879894; cv=none; b=WCgZc6/sVkSPRE5we3pWRMXj7nsl/JdYINu8TpdmapDuMjSFdWRS3L3YxxpS0hYyPJfYlDLAqO+M0nkgCikZ3TocvhgB1KVmHY3O/8XZOQPMIZc39JEd7nc2JEGzT+v1J1pzHyd6BqGWyj5akZtGthwNU6wDhxJR5q7v/PbjEWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879894; c=relaxed/simple;
	bh=lKZD6dgPxS/HMRM7bpqZjg7b0lTbPVzH2ijsThvfY3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBfTixLp8lUFC13bCA/58SAJLlI1opzntrZhx8bcbCshfq6dROwijeynIchxB7LPMybXmPaDiQm6LSxy7u/9xFLEY8XfXd00KIz3K9ThSqLdwbOak3lHkZmeOcQbQ8SbvlhOc6qpXX4R0Z+/1q12Oy2bYLy6TjU55XaKI08op+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRQDBluP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRQDBluP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD360C4CEC2;
	Wed,  2 Oct 2024 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879894;
	bh=lKZD6dgPxS/HMRM7bpqZjg7b0lTbPVzH2ijsThvfY3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRQDBluPoohUG8ewHZh0MDO/7iHKkRsVibKKVq9LSp0HSLeyLJm3Nip1l+UmBUPaq
	 2OqngtDh0oWdryROX2ZSkPqUdOT6T+9GIehV4Gy0Hp6fK9ULTsz89505l+tugVOrRG
	 9fWGvXzrjjyTOdBiKNCFpYCblVOxD+er9tkw/kP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/538] pinctrl: ti: ti-iodelay: Convert to platform remove callback returning void
Date: Wed,  2 Oct 2024 14:58:34 +0200
Message-ID: <20241002125803.111497427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 93650550dff9d1a3b88c553f8adb81dc89778977 ]

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
Link: https://lore.kernel.org/r/20231009083856.222030-21-u.kleine-koenig@pengutronix.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a9f2b249adee ("pinctrl: ti: ti-iodelay: Fix some error handling paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index 5370bbdf2e1a1..81ae6737928a5 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -900,23 +900,19 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 /**
  * ti_iodelay_remove() - standard remove
  * @pdev: platform device
- *
- * Return: 0 if all went fine, else appropriate error value.
  */
-static int ti_iodelay_remove(struct platform_device *pdev)
+static void ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
 	ti_iodelay_pinconf_deinit_dev(iod);
 
 	/* Expect other allocations to be freed by devm */
-
-	return 0;
 }
 
 static struct platform_driver ti_iodelay_driver = {
 	.probe = ti_iodelay_probe,
-	.remove = ti_iodelay_remove,
+	.remove_new = ti_iodelay_remove,
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = ti_iodelay_of_match,
-- 
2.43.0



