Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1AA30ACF6;
	Sat, 12 Sep 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226081; cv=none; b=HfCTVx3oJIpSEKq6+oJ90w/O29Thgyvu5QSyxnFGPUkhXlcbB823FmWBof2kzczZML6lTB0Y3a3Iv+jhYKE5+SDZZNCr6EnLSNSxvNBhW3jCIYYr6pJ5qDr7bL88agrcqIHQka8c/e2qtkedLZhWkNuZu83u192hUAuTMqW3jXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226081; c=relaxed/simple;
	bh=n7vyV7Zkz9m4fwKQqBX0mTEbGlYNavjUiSpzD7oQ0Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJ7RYeOnauwGcCZyI+59/JICMPyigQ21qAN7aqMUZ6jZMv6K+FhOrcUC9bufQDViZrRUcgYuTD2IQtWiBnkZielC3ICUr9Xs+C4bv//iBJdfWdkvJe24tOby8SK5Pk93CcsYNYCCgl+Pusm9FS0BV+FtbSIC/piuHkehrsuzft0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2t60RrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2t60RrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CD71F000FF;
	Sat, 12 Sep 2026 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226080;
	bh=f9beFiziT+JUPom7R1lYOaLz9ypbmGGh+LToMb0eG8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2t60RrImxWwmDFJjGc5p4mfzR4D+/BTM+rZEwyEynE5SBFMSWFICw/Sd/mgJJ2HS
	 XFmmyi0e/n800j/hwouklaUIk57EUmmB0NTWmxMdsnGJ+Eh2XJhd4/RBM0JamfjSPx
	 GEQFYkNnPjYzacxC4hKR3jxGzH+EGxafJOCY+BOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1330/1424] net: ipa: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 09:02:42 +0200
Message-ID: <20260912065637.042545092@linuxfoundation.org>
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

[ Upstream commit a92dbb9cdf0465d56c7e0fc5d674e6834f7c6a79 ]

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

Link: https://lore.kernel.org/r/20231117095922.876489-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/c43193b9a002e88da36b111bb44ce2973ecde722.1701713943.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6b9eaa61ff2d ("net: ipa: balance runtime PM reference on remove error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f5924142021d2..196755bf60f87 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -936,7 +936,7 @@ static int ipa_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ipa_remove(struct platform_device *pdev)
+static void ipa_remove(struct platform_device *pdev)
 {
 	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
 	struct ipa_power *power = ipa->power;
@@ -959,8 +959,16 @@ static int ipa_remove(struct platform_device *pdev)
 			usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
 			ret = ipa_modem_stop(ipa);
 		}
-		if (ret)
-			return ret;
+		if (ret) {
+			/*
+			 * Not cleaning up here properly might also yield a
+			 * crash later on. As the device is still unregistered
+			 * in this case, this might even yield a crash later on.
+			 */
+			dev_err(dev, "Failed to stop modem (%pe), leaking resources\n",
+				ERR_PTR(ret));
+			return;
+		}
 
 		ipa_teardown(ipa);
 	}
@@ -978,17 +986,6 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_power_exit(power);
 
 	dev_info(dev, "IPA driver removed");
-
-	return 0;
-}
-
-static void ipa_shutdown(struct platform_device *pdev)
-{
-	int ret;
-
-	ret = ipa_remove(pdev);
-	if (ret)
-		dev_err(&pdev->dev, "shutdown: remove returned %d\n", ret);
 }
 
 static const struct attribute_group *ipa_attribute_groups[] = {
@@ -1001,8 +998,8 @@ static const struct attribute_group *ipa_attribute_groups[] = {
 
 static struct platform_driver ipa_driver = {
 	.probe		= ipa_probe,
-	.remove		= ipa_remove,
-	.shutdown	= ipa_shutdown,
+	.remove_new	= ipa_remove,
+	.shutdown	= ipa_remove,
 	.driver	= {
 		.name		= "ipa",
 		.pm		= &ipa_pm_ops,
-- 
2.53.0



