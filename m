Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C542D3F8704;
	Wed, 20 May 2026 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300473; cv=none; b=iXGrLoxsda68fsSW/vAwnn2Igp0FuDNjOEn0Q22vXHCIDggSB82UfSOxVSF4vY2jJbjzCsS0njiJuX3KCuj1QTSiI7iBf5B6OIzscyA902rEWV3vU4YM2OiwUWRxlgr4zI3/Cm8oIdbuH0vX1fYgyIW7mNxd3RujsxN+CJY2PmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300473; c=relaxed/simple;
	bh=qj1NCBANSyYgJxWXTQjo2+Vc7VWdTWOoReH6PdnV00g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asIYpKT17v12MXUlUBMLaD8GRP91adnpotitYtFEhNo/1rOOHX8FF87k1XZQ7AYZwPS+C0cCcZbKIG+FLZpIfzbxhXSFy/WcM5K5Bko3OmNzdr5uR6CC61qtcoKIwMlEh+q1hDFTYXFDiXNN3yjXrqgWiigV9klQ8HlGX5FjcWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyZJc8qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyZJc8qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386581F000E9;
	Wed, 20 May 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300472;
	bh=BFMCsERZbPbdoaHR5UCMpMtuAIYMxqcAtEzHRUiUwNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyZJc8qwe1QEhF2VB6l2W3P0vnAqLxRFaS2uqxYMjaQcxwHpDmaCJBoKJOW2brn9T
	 Gr28Vys179+H0UvqHMhPrBL2XxX/DDIeQMp1ojA1EGRM0+1VhyJrCPXWHpty2ECjDt
	 fHY/nbl2keaMDciwRtXffLmrHzyiEVKHq3Oj7/pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/666] hwmon: (aspeed-g6-pwm-tach): remove redundant driver remove callback
Date: Wed, 20 May 2026 18:16:39 +0200
Message-ID: <20260520162115.276778344@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



