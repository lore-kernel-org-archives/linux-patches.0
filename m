Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB794779B1;
	Tue, 16 Jun 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632329; cv=none; b=s/oWZodUpaBo9/qRN5Xh7LXiYW+yZydXiEMTbnsfotfH5ypTDWI8/pysmty5dkmJbbxu9tE9IDsNUoWM5MhVGoai8uDRbIBZQ+cWsRo0WgudieWdU6fIPvWbHCklpboxMBtrCWiOk8b8yTkKqplEJMcHRXU3my3W8Liwjvcc2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632329; c=relaxed/simple;
	bh=esDB6p56L/baquA6EfvPdK7nZEo7gvf/3OEfHXCD9bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehvYxkvr7HaHanR2dh1zMrNrRH6EgeT6nCiAQoiTiDGxoyJX1qo6yvD54uDfiu8AwNNjOO93NIsDBjUG/DxtTwB1O3ExG3/6o5Lg+4lYz0d5zTTMKogphfkgBLnRYjR5jJZhchdt09tw4GdueYDeBMxYFL5Pj2jJUzfFWbmXURc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTjs5aEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTjs5aEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F5D1F00A3A;
	Tue, 16 Jun 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632325;
	bh=quLLk3Efft6+0rCwGHROI/eBN/pTxXbS2ZMOVw+TfVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTjs5aEr8yrZnZ27qWOMZZc8ivy0IlbhcGkNRUolvDGY3FPv9jAcH0ch3sVWeeuG1
	 zm/xXAgjGiay0zSdxICG3blK2OyqfttNJ69ckgaL7XAK06HC0xDWvEP0BeB/A3/zSq
	 R9The40MXbLWyKNPJwQ54puFbiFsJOUbMffRySSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 389/522] spi: zynq-qspi: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:28:56 +0530
Message-ID: <20260616145144.001679316@linuxfoundation.org>
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

[ Upstream commit ae9084b6458d34ebf3e377d0407ebe513e41ac71 ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-87-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c9c012706c9f ("spi: zynq-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynq-qspi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -750,7 +750,7 @@ remove_master:
  *
  * Return:	0 on success and error value on failure
  */
-static int zynq_qspi_remove(struct platform_device *pdev)
+static void zynq_qspi_remove(struct platform_device *pdev)
 {
 	struct zynq_qspi *xqspi = platform_get_drvdata(pdev);
 
@@ -758,8 +758,6 @@ static int zynq_qspi_remove(struct platf
 
 	clk_disable_unprepare(xqspi->refclk);
 	clk_disable_unprepare(xqspi->pclk);
-
-	return 0;
 }
 
 static const struct of_device_id zynq_qspi_of_match[] = {
@@ -774,7 +772,7 @@ MODULE_DEVICE_TABLE(of, zynq_qspi_of_mat
  */
 static struct platform_driver zynq_qspi_driver = {
 	.probe = zynq_qspi_probe,
-	.remove = zynq_qspi_remove,
+	.remove_new = zynq_qspi_remove,
 	.driver = {
 		.name = "zynq-qspi",
 		.of_match_table = zynq_qspi_of_match,


