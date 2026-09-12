Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C153A255F;
	Sat, 12 Sep 2026 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240447; cv=none; b=uQ5br+fNelLbc5lNCcMetEaErx5M6p/EBPw0F16uI1viKoblP+GI+nX3FWpQ3vouJJ7amITW+PlX9peBh7bWL+l1LHHu3xy7HRHaOKG7YI72nbaP84VIRlHHrk9Fuh77+ZnTyOriHhfptInif5nBjrKQyocWV3dgGlARkGJRD5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240447; c=relaxed/simple;
	bh=+q6TOpIEReJyZ7tapVlPlJTLvGsq62ffT78T9Nmh2yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jzHtuOJEGzSIj+v71OWyHTKZ51WbDcEL8OfK6mpPD/VwETXTz1cUukSF8gMfx6phgeZ6aqcOtVZz/ceTE4fNAcrnGUGQmVfFretVPuSj2+cfuSPMBNujDM73uPoPbEh2rKOphIZw+n/COEM6UDSVqVk5eonShXMqoO91s3ebQzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6dP7A4D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6dP7A4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813191F000FF;
	Sat, 12 Sep 2026 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240445;
	bh=PoJC3bOZFbFVlqCbbhI7gX0uksqXMNyYw+uadXgFnH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6dP7A4D+ULXQGg4jhzbZe2XKi8OTP1j/WIQ7s5a/Cf/0anmS0ivAiCzHvPR14kyi
	 KJdxmfmyF6q9z/6rjE8Fb7nU4Vi+7+hE9OhDWGFsIBwxlzwsfOy60BUEcJZg8QDW+p
	 pkkef7RsK8Z8MweLgoV0kikHZM+8zhFFJ7Fg6sQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 871/935] net: ipa: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 09:05:01 +0200
Message-ID: <20260912065546.795232420@linuxfoundation.org>
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
index 272c1b449f7fb..8a5dd0b595601 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -795,7 +795,7 @@ static int ipa_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ipa_remove(struct platform_device *pdev)
+static void ipa_remove(struct platform_device *pdev)
 {
 	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
 	struct ipa_power *power = ipa->power;
@@ -818,8 +818,16 @@ static int ipa_remove(struct platform_device *pdev)
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
@@ -837,17 +845,6 @@ static int ipa_remove(struct platform_device *pdev)
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
@@ -859,8 +856,8 @@ static const struct attribute_group *ipa_attribute_groups[] = {
 
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



