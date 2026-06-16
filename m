Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2671A47A0B0;
	Tue, 16 Jun 2026 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632285; cv=none; b=DJzXdFoBhk5Nubmp54AOm2zB9nYx9YgMFcO/V81QdDirZ6WtWAToF4VqbVXJHwRNt5poLntDyZCPLNVwJEFGDx1H20Xl748emlSLloGhfNuQEbCFMNQ3DMfm3oJ5uE+ik2sp0mlJgzA5TOfw2izReIi2McfEn0/oTacJTxJ1FA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632285; c=relaxed/simple;
	bh=hd8ZcIGJbE1oySxHcqe1vAFi1k+gi+I7grFX7JFHZKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VbosJz2xkr3xKPh2qgkrdN3BsfCixeKMq2/OHJyhSBcQgi2eG0tQyD3jOIxHCfndaGC9O/4JZBhNL6l/XUMXRY0A9biWa3SB+eBwtsPgA7rL2X2oac2JIXGweOutZC+kFuoPW1bmaC+5IqyWlHIHl/jHppX+s6HHdp3uCvLgag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPQJSI9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPQJSI9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16BA1F000E9;
	Tue, 16 Jun 2026 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632284;
	bh=jrK4hWwowHvy01t1Q7zPiE0Ckb3rSrbwqsCBjfZJiB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPQJSI9quyBYf5uvWjihSySPtIRTB+jkuMJIPssWf29fBX5yo+QpTrthpJaItTeN4
	 QkzAZ3vxIHpx8utqHP4zCpv9V6ScA3U/jGe7LzbnOWhj7zcUODA9AkYQrUg/Av//NQ
	 Pv2uCmzliQtCdNo7zzl7drxU3qYdvxCOor124m1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 382/522] spi: sun4i: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:28:49 +0530
Message-ID: <20260616145143.647843214@linuxfoundation.org>
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

[ Upstream commit b7b949458ac391963e56ae354b73fee63016dcee ]

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
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20230303172041.2103336-75-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 42108a2f03e0 ("spi: sun4i: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun4i.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -519,11 +519,9 @@ err_free_master:
 	return ret;
 }
 
-static int sun4i_spi_remove(struct platform_device *pdev)
+static void sun4i_spi_remove(struct platform_device *pdev)
 {
 	pm_runtime_force_suspend(&pdev->dev);
-
-	return 0;
 }
 
 static const struct of_device_id sun4i_spi_match[] = {
@@ -539,7 +537,7 @@ static const struct dev_pm_ops sun4i_spi
 
 static struct platform_driver sun4i_spi_driver = {
 	.probe	= sun4i_spi_probe,
-	.remove	= sun4i_spi_remove,
+	.remove_new = sun4i_spi_remove,
 	.driver	= {
 		.name		= "sun4i-spi",
 		.of_match_table	= sun4i_spi_match,


