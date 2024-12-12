Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F002153DF;
	Thu, 12 Dec 2024 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017655; cv=none; b=J3ORiZBlKm8ooAHCZeNZ2424tOfYKOSGRG9TpBZHNgtW4YeqHVPuOeX2ZqLiLyq6Bp36Jj1KGiLuAwIxtEiRqzg93tc9v6oELswevcrampIWGG5tC0TMLRWJ7kG9aE9un7A1F44W7kl3q9kF4iWPHZbp7H1qRNIytkvbto9xqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017655; c=relaxed/simple;
	bh=ZxffZ5XhvQjuqB610Ar/DgLm2UzhhbOLHm7PjFJJwqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zcbi8riWnf735s+QoB8lQsqEa/8w/73UZIJdNlm/IVUZbs5uhgTltWrYuDCramu73QsSKEI46oz6ZoyV39ivM/8I4jkvKDtM8wzp+0TxKYPvdX1P983fQclgDcgz+8F7W2CTjcAu3y+9m+sXe8BdyH/+Fs5ZDju2GS6tfgAkynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPU+cIEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPU+cIEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F096C4CECE;
	Thu, 12 Dec 2024 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017654;
	bh=ZxffZ5XhvQjuqB610Ar/DgLm2UzhhbOLHm7PjFJJwqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPU+cIEVMUsUGf7M2aZVcCGT2rmmd27WuQXrUbQpuWrQgAkNkzdcF+PXcyQAGMa0E
	 VZzBoJ9qazyV50Oc6Xw0NWcrlq3zcFvXIFzAYzN7ivvuPRczCNB3FyWeakZbvlHw/7
	 HZFwxXvQ5M9S9GZbeFUt0RBQQ3QFZY2Z52xgXb/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/356] soc/fsl: cpm: qmc: Convert to platform remove callback returning void
Date: Thu, 12 Dec 2024 15:56:33 +0100
Message-ID: <20241212144247.553431899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 14914a115e807aa2f8025e451133627a64120ac3 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Acked-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20230925095532.1984344-7-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: cb3daa51db81 ("soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qmc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 8dc73cc1a83b1..2312152a44b3e 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -1414,7 +1414,7 @@ static int qmc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int qmc_remove(struct platform_device *pdev)
+static void qmc_remove(struct platform_device *pdev)
 {
 	struct qmc *qmc = platform_get_drvdata(pdev);
 
@@ -1426,8 +1426,6 @@ static int qmc_remove(struct platform_device *pdev)
 
 	/* Disconnect the serial from TSA */
 	tsa_serial_disconnect(qmc->tsa_serial);
-
-	return 0;
 }
 
 static const struct of_device_id qmc_id_table[] = {
@@ -1442,7 +1440,7 @@ static struct platform_driver qmc_driver = {
 		.of_match_table = of_match_ptr(qmc_id_table),
 	},
 	.probe = qmc_probe,
-	.remove = qmc_remove,
+	.remove_new = qmc_remove,
 };
 module_platform_driver(qmc_driver);
 
-- 
2.43.0



