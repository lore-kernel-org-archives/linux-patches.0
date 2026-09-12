Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D4623BD06;
	Sat, 12 Sep 2026 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224474; cv=none; b=M2OE9eqQbC1bVSw+ZBiR8pu4ztwwQVk/HZYxrw2+yITDH5OL1kp2rusd3fRMXY+Ahaee8ArMOZramYxkt+wQwjuAtoGeplh7Vhp4TZzAuvgqU+6RmkDeKLPiHcOUfsXnJWWbDF0W2ImKgf3X/R5oTkLuOdw5Dt2OuTqIdnrgUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224474; c=relaxed/simple;
	bh=KbpP4fL9VYb6mPRcUBTF3PcMoXtAaMErbbk0HGZw5Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWlpCAF6oYalhL8RJtk9W3TbYr6TWg5cRUSfoKjvAuquAVZJArrpYCreyEPRflcgEBhOlZSFWEJpI2ZTsEWdXxIVoIFcTwbC528h/CWjERtLRVkKkmZS67QHF8mb6nk8+bFc/2ojNma4f9bSTVoTLWvCzpk3pCAyKCIVH0DFarw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHmdbJUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHmdbJUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153971F000FF;
	Sat, 12 Sep 2026 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224473;
	bh=GSVhdtGCghVDF9MB6g0DCbaqpurmAwrjkMHYQY5PyZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHmdbJUNKscojwnp3/TsecB7onASiy1DWbrmmqA/KtZ/xXekcRvUNV7U3i7gCCUhB
	 tPsR18yi6ONMqUFeuQ0YT/9I9sXJlQpabyX5aQ7+jwAw2QIpvGMZ6uwiAJ3zAgARtb
	 jGsm0qhDNz/0AMUIp6NpzoNtOfJ0YmW+c+kCLjHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0956/1424] power: supply: sc2731_charger: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 08:56:28 +0200
Message-ID: <20260912065628.724784529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 9ac17cf7a1260..b3d8b1ca97da7 100644
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



