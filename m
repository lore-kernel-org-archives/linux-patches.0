Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC5C4779B3;
	Tue, 16 Jun 2026 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632610; cv=none; b=hbwGEi/WCnFGGvV9lQXB0wuIJj2VEGRq9Sf//EzJPvJWbosEEfru/l75XXXsCy9+K034syI8bUbvsvmKpCR/9lptN51Zq5BAMhmoGjzR7+f1ewxzaC+/nUq4UDzkyb29wNd0GsloA9SSTlzUsCJGohrnDLFZyGwvmT0P2YEOHdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632610; c=relaxed/simple;
	bh=8pdUYk6OigIirkk0s41VcE7mWxwoOL5qDrOtJar6ux4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3qXezrlasB/GRtP0H40ygjGD7tq5yDdbWgHg7MPBdJxqHEijhw8tYExMxbq1+Qux5ui+MdVIF4JYTwy7mFUAZLBGmbG451J3VZgGeyiMlNDk/S93QjplXwxrBy5H4k3ffwm/8czNxnc7/t4dKflFMZXfXt1KTusRGTN1DEFIHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rELG1w8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rELG1w8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDB91F000E9;
	Tue, 16 Jun 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632609;
	bh=ND0ApNcj/qjAkx9Pb7sk9hFqNzMrlXggrWISareCScg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rELG1w8r4wbvySffClcoyxpGV2jEgZKMI3PHl6owFKpO1cKplmy7GK8WMqaVjE9V
	 Rpxg16WR6RelbHQMSYRq9YfUT++03xDjU5ifLcP0yvBYZxE4eSxGYMqowfUu8zHmwJ
	 LseIf7KBoPf14XE+Vt4A01nWHD6S0357jWRdchHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 411/522] spi: topcliff-pch: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:29:18 +0530
Message-ID: <20260616145145.283893955@linuxfoundation.org>
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

[ Upstream commit b082694f18bdff807b42a3bccc62c3a524168f23 ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-83-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5d6f477d6fc0 ("spi: topcliff-pch: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-topcliff-pch.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1396,7 +1396,7 @@ err_pci_iomap:
 	return ret;
 }
 
-static int pch_spi_pd_remove(struct platform_device *plat_dev)
+static void pch_spi_pd_remove(struct platform_device *plat_dev)
 {
 	struct pch_spi_board_data *board_dat = dev_get_platdata(&plat_dev->dev);
 	struct pch_spi_data *data = platform_get_drvdata(plat_dev);
@@ -1434,8 +1434,6 @@ static int pch_spi_pd_remove(struct plat
 
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
 	spi_unregister_master(data->master);
-
-	return 0;
 }
 #ifdef CONFIG_PM
 static int pch_spi_pd_suspend(struct platform_device *pd_dev,
@@ -1516,7 +1514,7 @@ static struct platform_driver pch_spi_pd
 		.name = "pch-spi",
 	},
 	.probe = pch_spi_pd_probe,
-	.remove = pch_spi_pd_remove,
+	.remove_new = pch_spi_pd_remove,
 	.suspend = pch_spi_pd_suspend,
 	.resume = pch_spi_pd_resume
 };


