Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074BA477982;
	Tue, 16 Jun 2026 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632268; cv=none; b=DV0IFgvAlf50Wwccjal3RlVjOc8FppWVvn6XG/fdVo4NnG9uBG58G+w8RnwxsInNthzSzr7m2HUaeTGW2tShWOlkU7Ys7qyzhkRGxO8b2Ra/n1RcB53X74rY59/JCXVbX0vfNx6857OwvXYvwaajfhTJa1Z6OEA2yooQqh+S/a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632268; c=relaxed/simple;
	bh=MijkSv/GnBovznPZIv0kAngVeZ+kBPKKVUCmyD5Jy+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcmGxDmK4Qn4Z2OW/qttsHZSO+EzIWiX3G2MtOGLJgFlHZn5dvrwrTUYP5eTo9Oam9QprfTl5oP6und8c9qUp5gdb6JqIfal593g8FY+WvovxZI3C/Qp6H18QlRwmSyCfao8lCq4fkuwDv881FMLXfD4WsbMxjzpd9y7Ks6FQAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxHPOxur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxHPOxur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE86B1F000E9;
	Tue, 16 Jun 2026 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632266;
	bh=hzDWUc1rNJr2QOQEIAv4cTReOlUq9nIWAW5SvpvW3uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxHPOxur5i4hAUQhbiQ6r/Qv61K+6C7eMMnGZ7Xn6QfS3qxZQpTCo/VGOefKBB4Nj
	 49F54oMY8txldlsqYUy2OkmvHyU52ZS10GT+pJUaGtfvBAHDosjcrHPKG0NdMX48oA
	 HgO+OElN5mIXt7NO4nifAZp8VOoKpF9KFGuBgTV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 379/522] spi: synquacer: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:28:46 +0530
Message-ID: <20260616145143.508515729@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 1972cdc47df737f5b90ac2132080004f5e413e91 ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-78-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 75d849c3452e ("spi: syncuacer: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-synquacer.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -735,7 +735,7 @@ put_spi:
 	return ret;
 }
 
-static int synquacer_spi_remove(struct platform_device *pdev)
+static void synquacer_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct synquacer_spi *sspi = spi_master_get_devdata(master);
@@ -743,8 +743,6 @@ static int synquacer_spi_remove(struct p
 	pm_runtime_disable(sspi->dev);
 
 	clk_disable_unprepare(sspi->clk);
-
-	return 0;
 }
 
 static int __maybe_unused synquacer_spi_suspend(struct device *dev)
@@ -820,7 +818,7 @@ static struct platform_driver synquacer_
 		.acpi_match_table = ACPI_PTR(synquacer_hsspi_acpi_ids),
 	},
 	.probe = synquacer_spi_probe,
-	.remove = synquacer_spi_remove,
+	.remove_new = synquacer_spi_remove,
 };
 module_platform_driver(synquacer_spi_driver);
 


