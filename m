Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BC2129A86;
	Tue, 23 Jan 2024 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971017; cv=none; b=fyCt7YDuRaNWcoCuj8aUDuZ6L9W3UsLx5F813pcqaYRpeER5cy7xxATco+07blOc8PYnQ0r64j8VxXciBMoycjCAw9/hd1X/Y3qXs85M2Wv56uz2acHNqGIZf1Mo9x7Up3qqIHcACuAdCBCaA0oT5NgxEFD69XM8Hj+zwPbyXFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971017; c=relaxed/simple;
	bh=B4edW0mMkmzZuv7rGHrU5EEPvx1bo1UrgqDj1rhgF0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQHrDxdRPx6lfwsHL/q/Dtf0aGTMbVCmqiKuctxB81On5YI4rCFZZ6US/D1DkiAxJiKkXzWAPmTPSqAtya/IoqnbQiu/3SXndLpfoxJjrwUsXmH+H/1HJYph0owEdlFjFD631NzsEoPQcIkfllOQjAnSjnhlxrvXubU/eH5AonU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdsZUKPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdsZUKPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2109BC433C7;
	Tue, 23 Jan 2024 00:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971017;
	bh=B4edW0mMkmzZuv7rGHrU5EEPvx1bo1UrgqDj1rhgF0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdsZUKPo6QYNPIW+hvTJN6PM43DRJMByhkmT4pHPKdZTcdJlv2KeGBNjk76ohPxJX
	 muF38JX2bR9XN45bsxJYxyCFjfEUwU8gpK/CNzEQHpoi4/ge5cERwS729I4u1hoPJT
	 2iFPWar3FNALqGdPiypI3To7Sp+6uzE1vCJzf15Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/417] drm/bridge: tpd12s015: Drop buggy __exit annotation for remove function
Date: Mon, 22 Jan 2024 15:55:31 -0800
Message-ID: <20240122235757.491382217@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

[ Upstream commit ce3e112e7ae854249d8755906acc5f27e1542114 ]

With tpd12s015_remove() marked with __exit this function is discarded
when the driver is compiled as a built-in. The result is that when the
driver unbinds there is no cleanup done which results in resource
leakage or worse.

Fixes: cff5e6f7e83f ("drm/bridge: Add driver for the TI TPD12S015 HDMI level shifter")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231102165640.3307820-19-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-tpd12s015.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-tpd12s015.c b/drivers/gpu/drm/bridge/ti-tpd12s015.c
index e0e015243a60..b588fea12502 100644
--- a/drivers/gpu/drm/bridge/ti-tpd12s015.c
+++ b/drivers/gpu/drm/bridge/ti-tpd12s015.c
@@ -179,7 +179,7 @@ static int tpd12s015_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit tpd12s015_remove(struct platform_device *pdev)
+static int tpd12s015_remove(struct platform_device *pdev)
 {
 	struct tpd12s015_device *tpd = platform_get_drvdata(pdev);
 
@@ -197,7 +197,7 @@ MODULE_DEVICE_TABLE(of, tpd12s015_of_match);
 
 static struct platform_driver tpd12s015_driver = {
 	.probe	= tpd12s015_probe,
-	.remove	= __exit_p(tpd12s015_remove),
+	.remove = tpd12s015_remove,
 	.driver	= {
 		.name	= "tpd12s015",
 		.of_match_table = tpd12s015_of_match,
-- 
2.43.0



