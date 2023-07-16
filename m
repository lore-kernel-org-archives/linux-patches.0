Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335F8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D527C433C8;
	Sun, 16 Jul 2023 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540907;
	bh=kUTzVbt6v1+/7/8zkBSuQt7LSFTI7XSJrX6zI3myGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fuVeP9t13/oCECR4SNAJ4BCuDu1KNW7fWDePxG+3UscAt7Mr0C9v/8sMwfrgD7Nu
	 S0wk7jwrFbWarAZ4P3samKFLASG4xwOD2BHuULGKY0m1Y5sjeB0OkTBRm5jgpjwaL0
	 TvC64ZbSLsGpkfj0o49exLQ5nT46wsuoMe7s65Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Yann Gautier <yann.gautier@foss.st.com>
Subject: [PATCH 6.1 531/591] mmc: mmci: Set PROBE_PREFER_ASYNCHRONOUS
Date: Sun, 16 Jul 2023 21:51:10 +0200
Message-ID: <20230716194937.607602546@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 3108eb2e8aa7e955a9dd3a4c1bf19a7898961822 upstream.

All mmc host drivers should have the asynchronous probe option enabled, but
it seems like we failed to set it for mmci, so let's do that now.

Fixes: 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.4")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Yann Gautier <yann.gautier@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230612143730.210390-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -2456,6 +2456,7 @@ static struct amba_driver mmci_driver =
 	.drv		= {
 		.name	= DRIVER_NAME,
 		.pm	= &mmci_dev_pm_ops,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.probe		= mmci_probe,
 	.remove		= mmci_remove,


