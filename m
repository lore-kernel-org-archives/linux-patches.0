Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A37F17FD;
	Thu, 13 Jun 2024 12:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282354; cv=none; b=tjYXST6fAvRjAoz2ifJcYN6WFOfK3mITgBiPD9SG6wB6GecMbst31nomcPmjKJLUyddVStpR4DJLVVrHn9hhI+z2i9hmVaregWGxQeFsdREJAX8sexPaDR8GIygSs4O05WLoWRguMgoFJmsrGpAtvPpwHGao8cu0WV69dgpc79k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282354; c=relaxed/simple;
	bh=tNzXh/z5qCFe7RxmEOyTTtJ3seoYF0Tb+y7g0MMEMNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Om5/9Sd+FKZuf6nb1BAfNMcaVWRMxQq8POXXYSL7g4uI90waczmOLkuwl0xs+MB7H2KXbqP6gUje9FnrBfe4XMuZJXF4OKXEGO3bO0Qtravkppngh3mjbao+Q4Qb/zHp8Thh11sG1ZYO/Hh7aDGXvIWVbssZTjO4P6Ua5W0YvDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twMkQHPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twMkQHPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3778C2BBFC;
	Thu, 13 Jun 2024 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282354;
	bh=tNzXh/z5qCFe7RxmEOyTTtJ3seoYF0Tb+y7g0MMEMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twMkQHPYl0qAKsTEbtDN6cEWVw5YkDk6gM6Cg5AGRC/l7pAJvmEQZtjuq0cm19KzU
	 di12Xkk7wNHuYR+cHsQ5q9ipI9xiEvRi8IU+oa7HQhNkjfbizb0r2zkZ+rOnRjrqee
	 vnOB+sd2dKn3uC6Y8mMZnbonoo2tbyB65NZTY8uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/402] Input: ioc3kbd - convert to platform remove callback returning void
Date: Thu, 13 Jun 2024 13:33:24 +0200
Message-ID: <20240613113311.782295277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 150e792dee9ca8416f3d375e48f2f4d7f701fc6b ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230920125829.1478827-37-u.kleine-koenig@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: d40e9edcf3eb ("Input: ioc3kbd - add device table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/ioc3kbd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/ioc3kbd.c b/drivers/input/serio/ioc3kbd.c
index d51bfe912db5b..50552dc7b4f5e 100644
--- a/drivers/input/serio/ioc3kbd.c
+++ b/drivers/input/serio/ioc3kbd.c
@@ -190,7 +190,7 @@ static int ioc3kbd_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ioc3kbd_remove(struct platform_device *pdev)
+static void ioc3kbd_remove(struct platform_device *pdev)
 {
 	struct ioc3kbd_data *d = platform_get_drvdata(pdev);
 
@@ -198,13 +198,11 @@ static int ioc3kbd_remove(struct platform_device *pdev)
 
 	serio_unregister_port(d->kbd);
 	serio_unregister_port(d->aux);
-
-	return 0;
 }
 
 static struct platform_driver ioc3kbd_driver = {
 	.probe          = ioc3kbd_probe,
-	.remove         = ioc3kbd_remove,
+	.remove_new     = ioc3kbd_remove,
 	.driver = {
 		.name = "ioc3-kbd",
 	},
-- 
2.43.0



