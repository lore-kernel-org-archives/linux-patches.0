Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050491DFD80;
	Wed, 19 Feb 2025 09:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956829; cv=none; b=PIXKwuSUBtk1zeOy9bIFXAfUTvLN1bK1cOiDGbHc4mU0x80ygXx3ys+I47ruYX5mKRDIN5uwG9uVxPKZ9n5YYTatfCpPs8XBAt6PcctiYTmI8J59jpm0SbZm5+HKfKiBK1+K0O1XXEC/hrbQFSgSzHJxx9NscIxLxeDa/CopfAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956829; c=relaxed/simple;
	bh=KkcNBTYk/HLQalkUvldKJ4r0bicjS/Cw+oAvLSPg9jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Chegx/BJznyh2cG5PwR0cE7BGhAK4XZQCxcTgj9WiEJR1mkOBJegzwZuX5jOyVqjGAsOaI0xmrnNjX1jCGRs/I1xZWo4BbkBhD5AEP2HMQtfLixZmOla8I/WpwTbFB6jXh/r8x8kGA6Xtd/1//WJmbSG3yQkiVC+uY9JLfMX3RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdRc29ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdRc29ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E924C4CED1;
	Wed, 19 Feb 2025 09:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956828;
	bh=KkcNBTYk/HLQalkUvldKJ4r0bicjS/Cw+oAvLSPg9jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdRc29vedcmm6hyAoH9384FNOSxFuquHXn0tIkxBJW8wqXD4HGplUHwtZyZBr3BXT
	 16Q9+zeuPJz97uV4k+ajTZBCtleqKDRyP3bAL2O3jncZnDdWGyaPLh1XDLDCtqGuem
	 FfyzIPIVCe0ZlIwdsFTvRsHMvbDWEJ2sGulNps1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 313/578] usb: chipidea/ci_hdrc_imx: Convert to platform remove callback returning void
Date: Wed, 19 Feb 2025 09:25:17 +0100
Message-ID: <20250219082705.329051406@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit ad593ed671feb49e93a77653886c042f68b6cdfd ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart from
emitting a warning) and this typically results in resource leaks. To improve
here there is a quest to make the remove callback return void. In the first
step of this quest all drivers are converted to .remove_new() which already
returns void. Eventually after all drivers are converted, .remove_new() is
renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230517230239.187727-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 74adad500346 ("usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 984087bbf3e2b..362dcb2374bb7 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -507,7 +507,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ci_hdrc_imx_remove(struct platform_device *pdev)
+static void ci_hdrc_imx_remove(struct platform_device *pdev)
 {
 	struct ci_hdrc_imx_data *data = platform_get_drvdata(pdev);
 
@@ -527,8 +527,6 @@ static int ci_hdrc_imx_remove(struct platform_device *pdev)
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
-
-	return 0;
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)
@@ -674,7 +672,7 @@ static const struct dev_pm_ops ci_hdrc_imx_pm_ops = {
 };
 static struct platform_driver ci_hdrc_imx_driver = {
 	.probe = ci_hdrc_imx_probe,
-	.remove = ci_hdrc_imx_remove,
+	.remove_new = ci_hdrc_imx_remove,
 	.shutdown = ci_hdrc_imx_shutdown,
 	.driver = {
 		.name = "imx_usb",
-- 
2.39.5



