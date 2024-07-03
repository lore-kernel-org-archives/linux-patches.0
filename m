Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD20173334;
	Wed,  3 Jul 2024 11:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005370; cv=none; b=QjA/79B7TJD6QJYkMVheizSDEqSbMqXoWaqKaxvF7cEqszUhUZJFV6q+NySbYvHGslBDR+t/s2HLmdB2S9xB2EBBGn3EkSMYBVDr6aTycLb4Clp8d9N4dbAvdtDi5HUmyffnimODPvImsTcfg9ELy6KyFLIhIjrS2bHrDmhyQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005370; c=relaxed/simple;
	bh=3tEQwD1OddDjwQB0bhIQwfdGQrUCMUHpNkQ93JOMCaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6wPHV6ORGYbt/se3umDTd8SuP/9gB0g4QNvXmcccEbFwMTJh7eP0tq1ORczm1uvhefJUKLemuxKF/xkMzS+ukP81bmT4AfFSFQ3hNqxwOi7wiNtXybIcb3eL0iDnaf4ZcZXkUp69WvgeTSipX9livTZS1IYdkh2zHJ7cZMhQQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qh4CBFPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qh4CBFPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4F2C2BD10;
	Wed,  3 Jul 2024 11:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005370;
	bh=3tEQwD1OddDjwQB0bhIQwfdGQrUCMUHpNkQ93JOMCaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh4CBFPX9/m6freAtdb1D8Wkrhmn/LGj40vNEcfsvx4u2S34MJ7OWi6O/SeMmVQ2D
	 Jol+5nq3XXZENCb/pbexYypIcJMWg/dwd038/EkMqYAcmY1ikCcr3h9PrXsWTl2mIv
	 3oGsUNquHR9Wkm6LveI9yCDHCWa2oMghIb1QBDCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Yangtao Li <frank.li@vivo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/356] mmc: davinci_mmc: Convert to platform remove callback returning void
Date: Wed,  3 Jul 2024 12:36:35 +0200
Message-ID: <20240703102915.327981424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit bc1711e8332da03648d8fe1950189237e66313af ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Link: https://lore.kernel.org/r/20230727070051.17778-7-frank.li@vivo.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 55c421b36448 ("mmc: davinci: Don't strip remove function when driver is builtin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/davinci_mmc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 80de660027d89..36c45867eb643 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1347,7 +1347,7 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
+static void __exit davinci_mmcsd_remove(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
@@ -1356,8 +1356,6 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
 	davinci_release_dma_channels(host);
 	clk_disable_unprepare(host->clk);
 	mmc_free_host(host->mmc);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1404,7 +1402,7 @@ static struct platform_driver davinci_mmcsd_driver = {
 		.of_match_table = davinci_mmc_dt_ids,
 	},
 	.probe		= davinci_mmcsd_probe,
-	.remove		= __exit_p(davinci_mmcsd_remove),
+	.remove_new	= __exit_p(davinci_mmcsd_remove),
 	.id_table	= davinci_mmc_devtype,
 };
 
-- 
2.43.0



