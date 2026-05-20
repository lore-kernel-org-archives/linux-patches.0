Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EFB3D75A0;
	Wed, 20 May 2026 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298177; cv=none; b=QKysfysxoykzzdrFLCMGSlzosBvGGm5Q8IQk9avDgG1SvYKRPdreQbfNVR+f4v4x8Qhs6037RMnJU8ScQFzQHkir9huBY4Sl/1btR9EcsW5eYl+HqQjcJBontsnPln/A0yO+xpfC+g7t1wZDdjNSxdO5VwyC5uaO7sSPmRD4Yoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298177; c=relaxed/simple;
	bh=2xSgTPo9ctisTDAdLJneuz/A2KZyV6J86lcPiPCOsLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJnVDjIgrAl17X0IfN7LD8PGLZCngENAoohL2KnP6R+k6uAAtA2fXmtqwzwL64OeL5QR7rVcdz1PAkvyTWe4AG88DaG75mT6BFQATmmd/CxHk0woSPWsYAZ73gl7xWq/lv7ogc8Hegbzkj+tJ5k+XGRlvNI8CicdCKo+nyQ8nk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txyG7kKn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txyG7kKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D331F000E9;
	Wed, 20 May 2026 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298175;
	bh=AGbskkCguKAPKdVDPf5AhlCmswn1dXy2DsLI9G1Y+6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txyG7kKnNRehb2qyt8udmUwdal7Ui/mma65bHP9gQd+9cJleJFSW690exILSx40lE
	 87ErFduPZwkwJ9Fw9FlisLKTWdi+esosNjXoDsXy8AQD7UvbftaRfqLQFJZabz4k1n
	 dMYSlkuxP8dn60DDwY2/aGAGRjG333QszXqu1fkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/957] hwmon: (aspeed-g6-pwm-tach): remove redundant driver remove callback
Date: Wed, 20 May 2026 18:12:32 +0200
Message-ID: <20260520162140.377143139@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 46fef8583daa1bf78fda7eaa523c64d4440322ac ]

Drops the remove callback as it only asserts reset and the probe already
registers a devres action (devm_add_action_or_reset()) to call
aspeed_pwm_tach_reset_assert().

Fixes: 7e1449cd15d1 ("hwmon: (aspeed-g6-pwm-tacho): Support for ASPEED g6 PWM/Fan tach")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20260309-pwm_fixes-v2-1-ca9768e70470@aspeedtech.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-g6-pwm-tach.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/hwmon/aspeed-g6-pwm-tach.c b/drivers/hwmon/aspeed-g6-pwm-tach.c
index 4174b129d1fce..d1f7f43974824 100644
--- a/drivers/hwmon/aspeed-g6-pwm-tach.c
+++ b/drivers/hwmon/aspeed-g6-pwm-tach.c
@@ -517,13 +517,6 @@ static int aspeed_pwm_tach_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void aspeed_pwm_tach_remove(struct platform_device *pdev)
-{
-	struct aspeed_pwm_tach_data *priv = platform_get_drvdata(pdev);
-
-	reset_control_assert(priv->reset);
-}
-
 static const struct of_device_id aspeed_pwm_tach_match[] = {
 	{
 		.compatible = "aspeed,ast2600-pwm-tach",
@@ -534,7 +527,6 @@ MODULE_DEVICE_TABLE(of, aspeed_pwm_tach_match);
 
 static struct platform_driver aspeed_pwm_tach_driver = {
 	.probe = aspeed_pwm_tach_probe,
-	.remove = aspeed_pwm_tach_remove,
 	.driver	= {
 		.name = "aspeed-g6-pwm-tach",
 		.of_match_table = aspeed_pwm_tach_match,
-- 
2.53.0



