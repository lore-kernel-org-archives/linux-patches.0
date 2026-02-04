Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE2D2D5926;
	Wed,  4 Feb 2026 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217930; cv=none; b=Iprg0DAFxYJ/9EzMWxmxXnrwUvvVX/xRV1lURdEAuRQjhmzrBwIaUiBrmwHyaHYj0s//jNcMh6TOlJDgPZGUVwUsFr2Ciwzt71+nYoCsPyQAUtnRShoqT68ID1KbGgoAU5oJtV93UXUi/7KHZp3NkcVMONDBLrVjPxhC+0oqq3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217930; c=relaxed/simple;
	bh=sJF0iGo1Hjwgt3SH4mGLIUzR71OquTRRgkx3amdA0U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQFOj7MJYsOBL/Ff6btmfxw4OBGqgPIVkPBjqst4lBw5PpkPZN3t+hEga4iczXm2yaZdKqrBzUgd9l0Q7sgBH5fKdNoSPkKck8vBCa1ILwPKGlkEn/EfU3jtr1z1rB8Rf4sZ27pYP4sv8b1mmrQ9OgCSD9XYi3X6xwuo/ifsE9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5e8bymi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5e8bymi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FEDC4CEF7;
	Wed,  4 Feb 2026 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217929;
	bh=sJF0iGo1Hjwgt3SH4mGLIUzR71OquTRRgkx3amdA0U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5e8bymi80ANTsS4gPqyf5kDnwOpqZ2tjvWhn0Na3UHrEpe9uyM7iIk572rf35jAu
	 VbYzv3PLhpvYVdkDtpr+tZeFHgfC0HZB1aMYgNO4pxpXd672gKba/bggZ8RNsTwkrX
	 22qYLo3fKsBSf0x1gR/MRvB5uS0j1itVosDCoSsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/280] spi: sprd-adi: Convert to platform remove callback returning void
Date: Wed,  4 Feb 2026 15:38:22 +0100
Message-ID: <20260204143914.242134646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

[ Upstream commit f7f785f125d03360d3766d96d04cf08b8472ce8f ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-71-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 383d4f5cffcc ("spi: spi-sprd-adi: Fix double free in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 1edbf44c05a72..3b158124d79f7 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -608,13 +608,12 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int sprd_adi_remove(struct platform_device *pdev)
+static void sprd_adi_remove(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct sprd_adi *sadi = spi_controller_get_devdata(ctlr);
 
 	unregister_restart_handler(&sadi->restart_handler);
-	return 0;
 }
 
 static struct sprd_adi_data sc9860_data = {
@@ -660,7 +659,7 @@ static struct platform_driver sprd_adi_driver = {
 		.of_match_table = sprd_adi_of_match,
 	},
 	.probe = sprd_adi_probe,
-	.remove = sprd_adi_remove,
+	.remove_new = sprd_adi_remove,
 };
 module_platform_driver(sprd_adi_driver);
 
-- 
2.51.0



