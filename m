Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EDB1BA860;
	Thu,  6 Jun 2024 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683472; cv=none; b=AADFfhF2zdf189eTln3dyIuPgthKAu4N72l029luVq8zODAlLu8f4isCQgdWO7bNODN+RUpIxvwPBaCgULdqYBuU8uy9nMWc0nA7LSNP6b987XwcgSvIatL7DN9YfeMDunJg/2aeLAiYMywf2YKIjnPsTfyL1BXd+/nnaHssGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683472; c=relaxed/simple;
	bh=Ci+pKSfK7v6MTD8zAG3VMz237mp/0BaMmfBl/sggkDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OE69aQG/ItU0jXa4WvrybYlwEbr1aEpT6uuDfepMfhBishun2KRTcyZ3dg7+1Vl++B4QUz1rfhb6OYAGE/u7dHtbVZaHTZVqWkWrY1zFZGiP0Aq80UuvHwz6SBBU54jgio4hZ3TnOgWf5gMqnx0ZpYjD2rmnqW3SY8OrkQeMu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLv3ZOVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLv3ZOVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D3FC2BD10;
	Thu,  6 Jun 2024 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683472;
	bh=Ci+pKSfK7v6MTD8zAG3VMz237mp/0BaMmfBl/sggkDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLv3ZOVFAlbR3IBu4AHU1fzI74Mt8R4Ch4hUoMkhRlYlBQLBYukOXaWa6FDpqEyyV
	 7km+A2wXZ/AewC1kke6L5O7R6dUsU/HOzzFaPDiJB5hv9TX1/xrp/YD6eHh3+5k9tN
	 2yrYmx4331esDO13Xr+1R9E8wg/BY8eMcXgTed8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 359/473] Input: ioc3kbd - convert to platform remove callback returning void
Date: Thu,  6 Jun 2024 16:04:48 +0200
Message-ID: <20240606131711.781974379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



