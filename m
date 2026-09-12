Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15433B27EA;
	Sat, 12 Sep 2026 18:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239502; cv=none; b=nP87KgJ2BgITjWQUzXiWOtNVPtestMCCUp64TsJIVUWDr3YG/8nVe65UKoDKMxt45zesqL/gQKzPgWeptBeCugskL5zmY0nPkDswZmvu+Y5obYBRqqFbXC6w3J0ZuvjNcbW2tdxv0VDGvBzNXPtLMW6VpHps/JCRcECQFn0RBaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239502; c=relaxed/simple;
	bh=NJLfE3tGP4xp5SqD0vPIg+FCqp0ZadDWqgHyn0+i06A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=asgUkHeyF7UKY237uWIfN32bUjMAKYW7f61vbcw8v9dX+willQM+A00r7d5Lkac5uLV4nIrXHhngJdB4nszP2DGeGJYqI1eIwDvRIS0t5mHFbW8YKVBVS9NvwwszDtJ5OwwmepJS2+IVdgZ2PHXDGvPt13tegH/jHKNFKlSP3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cmu78mnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cmu78mnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624461F000FF;
	Sat, 12 Sep 2026 18:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239501;
	bh=rg5B9h4+MZdAy0/wQ84oWlti3czqj0B6qL3cUm3/EM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cmu78mnVFaEK6gPT8p0GRQmonLl9egRPbYDLpQHtTdE80Ep8cz497/JA9zg/dN0Fs
	 aH2FWZt+PNv1UhjMnEF1ZVijQHm0vpjhuTfeb9WwI/aXGdvdg6eAWJjyJKyV/F8pTj
	 nxXlPqx863LWyenNIfQ55MhTipBXs+prlzOcRAl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 635/935] power: supply: sc2731_charger: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 09:01:05 +0200
Message-ID: <20260912065541.403673764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



