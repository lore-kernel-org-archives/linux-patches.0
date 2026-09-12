Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD5D39022B;
	Sat, 12 Sep 2026 19:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242837; cv=none; b=eDGDX8Od1sWKoCA1zEmS4WrtHlF8HDhIpKQxpg6f0qhh3TPaMxxtm8mXm+j3EsL5ZvGi5kSGl5Z8y2zcGKpTNRx0jC5RMUkEbFeePhE/+6bPqQPomh92ZGGBtD0ICQZgXc0ohXJ7Y7KwETLWlBCfFjDypn8KcL16t4BspEZxd/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242837; c=relaxed/simple;
	bh=JzoN2EgXh8QeaInCd2r8cEKv7guGf++8FIARlWh9sBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZF8HegSaVjGZYAyZvQHiI12+pIpe2+j7ESeOyP+Jm4vVv1l/cP+Mduc1Ji3o72tuhByD0TYQj0dh6QusIU+ARQgumA/d+oDKftt9qNOe0va0MttEa8yxmeacexDrvi2mV7IbIdH+fcirsz3wjGa2ukDYfLaMVLBjdNjDPPkLoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQ6ZDztG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQ6ZDztG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA6B1F000FF;
	Sat, 12 Sep 2026 19:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242836;
	bh=9jCSBRYdQhlBmUXiu0U3C+4Nh2eks7XvejY0fgD+v6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQ6ZDztGd7+It9SoHkCkrYIrfHxQl7WZS6BDvCPhqW6HoGVq4lU/MTF2CstplwL7W
	 ayIHe10t4gkMRFz+HytOkIsQdmQD+HGXe3nDAOeZtAfliiexxVgMyHQJ3JzBBiQOwa
	 8IdiS0DEClZRZecVyuwTDCErK+00M/H0H1mTAUzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 544/798] power: supply: sc2731_charger: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 09:02:52 +0200
Message-ID: <20260912065529.596450264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0569d4cfa800ba303647dbf8170d1e89bdee3ed9 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230918133700.1254499-25-u.kleine-koenig@pengutronix.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: dfc859bb8d33 ("power: supply: sc2731_charger: cancel work on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc2731_charger.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/sc2731_charger.c b/drivers/power/supply/sc2731_charger.c
index 288b79836c139..07aba733c447a 100644
--- a/drivers/power/supply/sc2731_charger.c
+++ b/drivers/power/supply/sc2731_charger.c
@@ -511,13 +511,11 @@ static int sc2731_charger_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int sc2731_charger_remove(struct platform_device *pdev)
+static void sc2731_charger_remove(struct platform_device *pdev)
 {
 	struct sc2731_charger_info *info = platform_get_drvdata(pdev);
 
 	usb_unregister_notifier(info->usb_phy, &info->usb_notify);
-
-	return 0;
 }
 
 static const struct of_device_id sc2731_charger_of_match[] = {
@@ -532,7 +530,7 @@ static struct platform_driver sc2731_charger_driver = {
 		.of_match_table = sc2731_charger_of_match,
 	},
 	.probe = sc2731_charger_probe,
-	.remove = sc2731_charger_remove,
+	.remove_new = sc2731_charger_remove,
 };
 
 module_platform_driver(sc2731_charger_driver);
-- 
2.53.0



