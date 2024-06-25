Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9476FBEF;
	Tue, 25 Jun 2024 09:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308179; cv=none; b=kwdcwrgheZTApVbsu+9eCF0zdkF7Hf8x9iCybpRf8pwsVju4lL5zYh92GepyMjTOJTwngArCtrsqXvIkjX9FQUZK6Hm1CFUyZp8DLqhY3LM/3ATqX6GkftRinbv2FEOikiFNBdPvgNKMSBNCZFkceUu/7n1IUSaIKdPvN5Cb+7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308179; c=relaxed/simple;
	bh=20WTo5NXyrptTMCTUC1KSCyIEoXJox1HP/GDyh40fHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5p9CHX+cXa2eYSL6T4EZzi0WCCkTijTCcqzZFKLm5E0I/ftlP/dFhHXLHkPTaKL0tolKVXOfZybBYznOodqrCNLtd5Dtc31kEVnigD3RJayfpaRaroR1fFLTE/VFzPDeK66fJPOU2nxuufWWV5sdhUK7gLpUQN9/eHxdP1aYvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCckTt6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCckTt6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269B1C32781;
	Tue, 25 Jun 2024 09:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308179;
	bh=20WTo5NXyrptTMCTUC1KSCyIEoXJox1HP/GDyh40fHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCckTt6yMpu/qHt+oo6cKybuZ6JQ24NKbyBupF4mQwlanCf5iaUoitcxoDqQ0l3E3
	 9Loz46HEiCzGpkiZr38vKgmar+fx/Jpotq1v4Cc9IMpkUGsxwt3EvIS7v3PxHdWhqz
	 +Zk3a5E89Y44MGqUcyC+OVe/hjKMv38XrjtxD/9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 009/250] platform/chrome: cros_usbpd_logger: provide ID table for avoiding fallback match
Date: Tue, 25 Jun 2024 11:29:27 +0200
Message-ID: <20240625085548.401021013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit e0e59c5335a0a038058a080474c34fe04debff33 ]

Instead of using fallback driver name match, provide ID table[1] for the
primary match.

[1]: https://elixir.bootlin.com/linux/v6.8/source/drivers/base/platform.c#L1353

Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20240329075630.2069474-7-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_usbpd_logger.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_usbpd_logger.c b/drivers/platform/chrome/cros_usbpd_logger.c
index f618757f8b321..930c2f47269f6 100644
--- a/drivers/platform/chrome/cros_usbpd_logger.c
+++ b/drivers/platform/chrome/cros_usbpd_logger.c
@@ -7,6 +7,7 @@
 
 #include <linux/ktime.h>
 #include <linux/math64.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_data/cros_ec_commands.h>
 #include <linux/platform_data/cros_ec_proto.h>
@@ -249,6 +250,12 @@ static int __maybe_unused cros_usbpd_logger_suspend(struct device *dev)
 static SIMPLE_DEV_PM_OPS(cros_usbpd_logger_pm_ops, cros_usbpd_logger_suspend,
 			 cros_usbpd_logger_resume);
 
+static const struct platform_device_id cros_usbpd_logger_id[] = {
+	{ DRV_NAME, 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, cros_usbpd_logger_id);
+
 static struct platform_driver cros_usbpd_logger_driver = {
 	.driver = {
 		.name = DRV_NAME,
@@ -256,10 +263,10 @@ static struct platform_driver cros_usbpd_logger_driver = {
 	},
 	.probe = cros_usbpd_logger_probe,
 	.remove_new = cros_usbpd_logger_remove,
+	.id_table = cros_usbpd_logger_id,
 };
 
 module_platform_driver(cros_usbpd_logger_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Logging driver for ChromeOS EC USBPD Charger.");
-MODULE_ALIAS("platform:" DRV_NAME);
-- 
2.43.0



