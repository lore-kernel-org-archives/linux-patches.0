Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F83D8138;
	Wed, 20 May 2026 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295357; cv=none; b=J3v0alWMPnGrcefAy83xNs3FMnZSfH+M9EnHNu2pGT9GnUy0GPxKBgxb0fdoTdNnSd0fwBdD+38NSgDMKs4FUEquI6py0+AbMvzy4m0KuDz5oQtH35ct9r5CaGzp5NFD83mV/xjzAMQCK35B2L0/TwklyOb8tb810Z/QDeKEmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295357; c=relaxed/simple;
	bh=HUu1BniarOmVnoquqi0k0tvuq0weD/KdKtKZcFD4Ung=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xxv3BbQjXB6yTzJe49mTP25RlRHDi0/te+DipgTfMf+VtJpoosP/KolTA/obs/Dn/1G66wSVdvjn9YsqWJuGgGdkVbGvm9O7GYicIWXwbdQaywBZHH5xPlpMNCHpdIjtXteTnJ5cRHA/1QQTlL1pvQY68fCV0crrd+Sk693OB1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjOT+KTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjOT+KTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD5F1F000E9;
	Wed, 20 May 2026 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295356;
	bh=SvBoTLinesxSRd3b2z6ONPalBwM55IAjQaUdykyABTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjOT+KTNlf+tUrnQ22VFy0Jpn0dgehotiJO6qUfR6pfYRBboTn4M/PmK0pXdgdL3a
	 6TXJxPwqDqT/+M3j9bGom0dEXmTvZvOndU4Kg+DgFu2YYyVelrCliFiTUb4AGyXqlA
	 18Fkqs3OxxLYETpBiPP1eW4e5+DRa+25HlIKUGUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0347/1146] hwmon: (aspeed-g6-pwm-tach): remove redundant driver remove callback
Date: Wed, 20 May 2026 18:09:57 +0200
Message-ID: <20260520162156.053625675@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 44e1ecba205d7..4f6e6d440dd40 100644
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
@@ -537,7 +530,6 @@ MODULE_DEVICE_TABLE(of, aspeed_pwm_tach_match);
 
 static struct platform_driver aspeed_pwm_tach_driver = {
 	.probe = aspeed_pwm_tach_probe,
-	.remove = aspeed_pwm_tach_remove,
 	.driver	= {
 		.name = "aspeed-g6-pwm-tach",
 		.of_match_table = aspeed_pwm_tach_match,
-- 
2.53.0



