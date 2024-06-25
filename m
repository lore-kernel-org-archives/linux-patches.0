Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189AC148315;
	Tue, 25 Jun 2024 09:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308108; cv=none; b=OiGiJnTnno/dg+MWs6aoHPlwZaAI+fY58qW7DVVWflPAWjR/++5CGoLurpFQlj/R7FPWo8nJai2hWtDdyXpTtCjD6/RwGFkkdcjc0xjeS1/ZNmyr32LV6F9c1ESX+DjoiXXnNfLnXoFZKJnTHaEAupA9BbdkzymXevbH7SxMzVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308108; c=relaxed/simple;
	bh=y6tUm1ekviqpSpAXcRKeWWl7Ao/DAI4nQ7shrM8ukUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuxKz3E/9rv97lxq8uC08w7nb3+vCsZMi5cdjK6eDOJeRNguTc7Z07jr8w5pdhrQw0PZTz0eRQRFe2r/cgDEi65iyWSjrR/hZUOFVqLGH0n7RwAKM0QB5BWHokrpjxcoUNlCANQlLn4TiOlWL59HCNv4keXaLEdLxqtmNqPeN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGkbKMhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGkbKMhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7BEC32781;
	Tue, 25 Jun 2024 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308107;
	bh=y6tUm1ekviqpSpAXcRKeWWl7Ao/DAI4nQ7shrM8ukUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGkbKMhHJTvJEXxYh1LV4j8eBARXYQj8SFMaC+4E3p4ViP8TMeNV0X0VvlKIBhNZ+
	 vXavfnzrmZHkHwP22Rt22S7xdxfSaRMNFqphIwOiM4pg15d9erZtfsHjsjDhYv1WOT
	 U59AQi7Ga5FKB5sqSVoHXdrzbGz3FfMQgwAjWNAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 010/250] platform/chrome: cros_usbpd_notify: provide ID table for avoiding fallback match
Date: Tue, 25 Jun 2024 11:29:28 +0200
Message-ID: <20240625085548.439357606@linuxfoundation.org>
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

[ Upstream commit 8ad3b9652ed6a115c56214a0eab06952818b3ddf ]

Instead of using fallback driver name match, provide ID table[1] for the
primary match.

[1]: https://elixir.bootlin.com/linux/v6.8/source/drivers/base/platform.c#L1353

Reviewed-by: Benson Leung <bleung@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20240329075630.2069474-8-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_usbpd_notify.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_usbpd_notify.c b/drivers/platform/chrome/cros_usbpd_notify.c
index aacad022f21df..c83f81d86483c 100644
--- a/drivers/platform/chrome/cros_usbpd_notify.c
+++ b/drivers/platform/chrome/cros_usbpd_notify.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_data/cros_ec_proto.h>
 #include <linux/platform_data/cros_usbpd_notify.h>
@@ -218,12 +219,19 @@ static void cros_usbpd_notify_remove_plat(struct platform_device *pdev)
 					   &pdnotify->nb);
 }
 
+static const struct platform_device_id cros_usbpd_notify_id[] = {
+	{ DRV_NAME, 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, cros_usbpd_notify_id);
+
 static struct platform_driver cros_usbpd_notify_plat_driver = {
 	.driver = {
 		.name = DRV_NAME,
 	},
 	.probe = cros_usbpd_notify_probe_plat,
 	.remove_new = cros_usbpd_notify_remove_plat,
+	.id_table = cros_usbpd_notify_id,
 };
 
 static int __init cros_usbpd_notify_init(void)
@@ -258,4 +266,3 @@ module_exit(cros_usbpd_notify_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ChromeOS power delivery notifier device");
 MODULE_AUTHOR("Jon Flatley <jflat@chromium.org>");
-MODULE_ALIAS("platform:" DRV_NAME);
-- 
2.43.0



