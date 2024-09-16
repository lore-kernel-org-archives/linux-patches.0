Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D9154C04;
	Mon, 16 Sep 2024 12:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488099; cv=none; b=HuUT+Kvtsr6KVRUxX2dEc4ankE9Fwasv2IFb4CAKhgX9WZ27PuUaV+E2YoRpr9QgcUZc/5QEf+VurFcrx3TylRQ8GGqNwic5+ovmh64FV2vewkieov4sl6EUPD6LIc9gcixisoZ57yYchlIIX06uyPtZTY6D7kj8OZZ/CWEh1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488099; c=relaxed/simple;
	bh=OYEMRUei5le+ZOlaMmEMPP7nsled3pCLxezaVLhiqj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBKckN1V7AxJQq/HqjyL1alIg0pQa74Dbg4QH12icHmvJSW4gqZ0i9axqi2WL0nQ7/BI7KNvt11OmWkAVQ9M1FTcL/I76l61X+zA6fPyQurA/T1hWZk9+/LRGcIVrHmF+IKKdkVn6R97oVPIvc0EHBD4jhoR6vPJO88U67j/6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afn5Xx5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afn5Xx5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B9C4CEC4;
	Mon, 16 Sep 2024 12:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488099;
	bh=OYEMRUei5le+ZOlaMmEMPP7nsled3pCLxezaVLhiqj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afn5Xx5PqQLDTOrE46C+dY4x9N0qxfCSXUX90K0ewZEdTpY98wdirzXXdDx/u+kKv
	 VYjnZfj4gQekADtAzD3J5LkOjQ1XwpFd0UM9FtCqw8a3kMN3bC6g6+jVHcxYLcK8dm
	 d4vmz/wpK+/WcjD/7sISV2CPSAMyBmcMzswZ5lZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/63] spi: geni-qcom: Convert to platform remove callback returning void
Date: Mon, 16 Sep 2024 13:44:37 +0200
Message-ID: <20240916114223.096602472@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

[ Upstream commit d0b52f6539e008a0d42bf673486bd21b7d2dc191 ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-30-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 89e362c883c6 ("spi: geni-qcom: Undo runtime PM changes at driver exit time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 7b76dcd11e2b..ac5a581d1e5e 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -1003,7 +1003,7 @@ static int spi_geni_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int spi_geni_remove(struct platform_device *pdev)
+static void spi_geni_remove(struct platform_device *pdev)
 {
 	struct spi_master *spi = platform_get_drvdata(pdev);
 	struct spi_geni_master *mas = spi_master_get_devdata(spi);
@@ -1015,7 +1015,6 @@ static int spi_geni_remove(struct platform_device *pdev)
 
 	free_irq(mas->irq, spi);
 	pm_runtime_disable(&pdev->dev);
-	return 0;
 }
 
 static int __maybe_unused spi_geni_runtime_suspend(struct device *dev)
@@ -1097,7 +1096,7 @@ MODULE_DEVICE_TABLE(of, spi_geni_dt_match);
 
 static struct platform_driver spi_geni_driver = {
 	.probe  = spi_geni_probe,
-	.remove = spi_geni_remove,
+	.remove_new = spi_geni_remove,
 	.driver = {
 		.name = "geni_spi",
 		.pm = &spi_geni_pm_ops,
-- 
2.43.0



