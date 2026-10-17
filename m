Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0B39F18A;
	Sat, 17 Oct 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259621; cv=none; b=lK4azqXJPdLXhoG3hrJF3Nsrg+Iyw+vM7RLNthl/AR1BLjpgy0vrv5VbOd2UqtjlhQMouF/a4t2K2gBk5WXtKPRttc+l03g0QsqW4HSyaq3hI1N9jcPgBr6LJ9t3pKq0G4NunKgXoe+jAXiuKzpvCYETtXYRxJbLl7pRQNyLsis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259621; c=relaxed/simple;
	bh=dnvC27sjiqK6NP26AjAK3MgU4ww70bV4b26agWiAd+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DtQ2ntE98dY3aID/kJRQEwrZZdiLp3oRIfcPxfs4WPUdoWB1LNcVVZq6MxbrpaSarfBfCpJedykR2/P+Y6B+nZjHLZZ7wtIL0CgDBOVpCD6hKT96889DGot/vm39OIjfWMYG+chcZZrX0hMxmSNwGSVkDVDAnABxIOokTs6HK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWMU1MOV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWMU1MOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664C21F000C4;
	Sat, 17 Oct 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259619;
	bh=xSroLpY/GvpnF09ru5iKc/cR2+Sb7kh2NeGxuaCU5xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWMU1MOVI9UgIHNfB2bpqn+IhN7kBl9AlsEeCdzx+lOofK/wT2im5d4xJTo6yS6EV
	 n32HXfFoHd12v1NQ7W0eUGKrAt1NaCiUCVdvnhAzOx3Bp5TxX0rUHb4ZlHKE5UNl52
	 kBUUoaQfNljF5hY5y2CiKb5JWZKfOCzqwMdH43Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1272/1674] power: supply: lp8788-charger: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:59:04 +0200
Message-ID: <20261017160503.792792363@linuxfoundation.org>
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

[ Upstream commit 7810ba3c5110ce66652ec6bd2abb92da5d726c3b ]

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
Link: https://lore.kernel.org/r/20230918133700.1254499-17-u.kleine-koenig@pengutronix.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 831c29a12d56 ("power: supply: lp8788-charger: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index 755b6a4379b85..2c81be82a41a4 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -714,20 +714,18 @@ static int lp8788_charger_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_charger_remove(struct platform_device *pdev)
+static void lp8788_charger_remove(struct platform_device *pdev)
 {
 	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
 
 	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
 	lp8788_psy_unregister(pchg);
-
-	return 0;
 }
 
 static struct platform_driver lp8788_charger_driver = {
 	.probe = lp8788_charger_probe,
-	.remove = lp8788_charger_remove,
+	.remove_new = lp8788_charger_remove,
 	.driver = {
 		.name = LP8788_DEV_CHARGER,
 	},
-- 
2.53.0



