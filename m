Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7001BDDB1;
	Thu, 13 Jun 2024 11:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278654; cv=none; b=n4wuQo/wJn9+X4rDz9GNwLbMNOdOo5z3AXh8ez1+KoTIUZT1jBlZ+fqiIoktIMaPPi0Vq+B5LOmhgK9rfPrlLoZnjw7vOGZwePaWWYaSVWT/h4CgGxI7V7H5lF1uddztUxYKOFRicMlchFcdSJpnw7qdT8xe2lsGYovkwZGCvgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278654; c=relaxed/simple;
	bh=V3LDj/5aJYUc/pVPcoX+GKjSLU3yMQ8SkgsMLXSZJFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCMJkweEvAIvVhFy9Go6e12qwWBx2bOI5cZOR9bZHobE/GISz1pdF1VvwGzjPHEpz6rkIwU4zc4vwK6YFwlRtdln6z0GgK2HLHqTR0/ADSmtRZJKqh84pLQz4DG0MEei+DhA12ALhwB4NMk3soNKHbvbCZfV2Izs09GxdOF6ssU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mS/YoD12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mS/YoD12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980DFC32786;
	Thu, 13 Jun 2024 11:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278654;
	bh=V3LDj/5aJYUc/pVPcoX+GKjSLU3yMQ8SkgsMLXSZJFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mS/YoD12iS8SB2Mj0vENZJXgTGSWV9H3Xl8yy4r9iENMjHnhhheMXtwGtr6AUHtq8
	 gEhoGDjgkKzUWWTx+Qpg10p9hqO419wEd5Xj0Pml1pYoqGY6kucx3ezvLkffouaK+Q
	 x/CGpxdqP2Kgw0pC3y3Lwh3gO7Xs7xHevHVyiGtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/213] power: supply: cros_usbpd: provide ID table for avoiding fallback match
Date: Thu, 13 Jun 2024 13:31:13 +0200
Message-ID: <20240613113228.966061503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 0f8678c34cbfdc63569a9b0ede1fe235ec6ec693 ]

Instead of using fallback driver name match, provide ID table[1] for the
primary match.

[1]: https://elixir.bootlin.com/linux/v6.8/source/drivers/base/platform.c#L1353

Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20240401030052.2887845-4-tzungbi@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cros_usbpd-charger.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/cros_usbpd-charger.c b/drivers/power/supply/cros_usbpd-charger.c
index 74b5914abbf7e..123a5572fe5b1 100644
--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2014 - 2018 Google, Inc
  */
 
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/mfd/cros_ec.h>
 #include <linux/mfd/cros_ec_commands.h>
@@ -530,16 +531,22 @@ static int cros_usbpd_charger_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(cros_usbpd_charger_pm_ops, NULL,
 			 cros_usbpd_charger_resume);
 
+static const struct platform_device_id cros_usbpd_charger_id[] = {
+	{ DRV_NAME, 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, cros_usbpd_charger_id);
+
 static struct platform_driver cros_usbpd_charger_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.pm = &cros_usbpd_charger_pm_ops,
 	},
-	.probe = cros_usbpd_charger_probe
+	.probe = cros_usbpd_charger_probe,
+	.id_table = cros_usbpd_charger_id,
 };
 
 module_platform_driver(cros_usbpd_charger_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ChromeOS EC USBPD charger");
-MODULE_ALIAS("platform:" DRV_NAME);
-- 
2.43.0



