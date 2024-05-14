Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64558135415;
	Tue, 14 May 2024 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686191; cv=none; b=GGtm59LNSg+pIhNlo5Q13AU6Ktp1RaaCitqS6uxZmiCMt/IXguPlHNnqTrl7oW6RDsD5lQN4b1pYuTQud20IpocZ2EzXix+iGKy1Pz0LzJVnhAG9uTyADvkBTLRJaMh4I9FOP9XHlbAcExfQYM/yxZWoV1ofQT0aCPIdGTJSKh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686191; c=relaxed/simple;
	bh=ICYHCMADpUKrAzUw4HTB14OjqvUq7rcYtwoxD605mP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRIPUCzn0AejqCVNyYl+zqfcsv+KuwWzgaAl743ym7YKlmOpr0pSpDZUR5hKk6rpPGbd/97JvUpwQ5OyyG4ZvoLpVtVsHtBe5pjzBCWGwmD424vmGv6SWZmUvuLznexHu2N4DY0wa51Zl4MwG0Qc7k2k7Jm36a0xdeKAkfmpKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As4dOmcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As4dOmcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6CBC2BD10;
	Tue, 14 May 2024 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686191;
	bh=ICYHCMADpUKrAzUw4HTB14OjqvUq7rcYtwoxD605mP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As4dOmcA+Jp/WV3DszZwc2cb1yLanUA7sjkDmZ7ksAhFSpMMceCVsS/jRlfoOVu9m
	 9sTCMC0YiwiSFYlcGWdVGyxsMysAdjezvMv1Z2imlwbbOAe6wnx60z9zwLumBe67B/
	 aY3lY5x4X15TX5V1BMMhPVwrO9xYww0bUg7AEdeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/236] spi: axi-spi-engine: Convert to platform remove callback returning void
Date: Tue, 14 May 2024 12:16:47 +0200
Message-ID: <20240514101022.055196428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

[ Upstream commit fc87abbef23413943457459e2c473ce607b4dd24 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230303172041.2103336-9-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0064db9ce4aa ("spi: axi-spi-engine: fix version format string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index 80c3e38f5c1b5..c5a3a31891642 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -554,7 +554,7 @@ static int spi_engine_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int spi_engine_remove(struct platform_device *pdev)
+static void spi_engine_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
 	struct spi_engine *spi_engine = spi_master_get_devdata(master);
@@ -572,8 +572,6 @@ static int spi_engine_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(spi_engine->ref_clk);
 	clk_disable_unprepare(spi_engine->clk);
-
-	return 0;
 }
 
 static const struct of_device_id spi_engine_match_table[] = {
@@ -584,7 +582,7 @@ MODULE_DEVICE_TABLE(of, spi_engine_match_table);
 
 static struct platform_driver spi_engine_driver = {
 	.probe = spi_engine_probe,
-	.remove = spi_engine_remove,
+	.remove_new = spi_engine_remove,
 	.driver = {
 		.name = "spi-engine",
 		.of_match_table = spi_engine_match_table,
-- 
2.43.0



