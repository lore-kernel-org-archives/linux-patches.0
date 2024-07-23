Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AF91586F5;
	Tue, 23 Jul 2024 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760184; cv=none; b=sqZmarSTr/MnCBko6k4dTbn2varaax88QLSvUIOr3sDZ+OZDc3lwCvBceiD3UgHtf/zz9Sew+UvIbBrh6iYlN0Q51cwMbCimx0NHqxE2aZFWdXilmuKc0ayFsa7oNvbFRf9BDREt53H25xk62rt6vJtW5m5TfWKpR8ZNyymD/gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760184; c=relaxed/simple;
	bh=FKPYFm7xEaa6lZu0snh9Bw0PaifgWe3WE0mIlVlL8q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh+neNY1WuGyQcnbvb1+3ti2K0jKRmuq4+iMI267mu1tSXH0+tSmeiIRCdo8gtefOq0gXSO3kSjpTv0N9uKGBAiERpfZxUUyP1dDJSa402BHrKozaj2/YFLvhHu5PuUIOoD7yZ+K6BDQV2APmxR9941zZuhva2uOO0Lj09LTCFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB5fY6M8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB5fY6M8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D67C4AF09;
	Tue, 23 Jul 2024 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760184;
	bh=FKPYFm7xEaa6lZu0snh9Bw0PaifgWe3WE0mIlVlL8q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IB5fY6M8E/3J09CJ3JtIguqU+MVAXw7gVHb7nbPfKf4aVUAISRPXV0cAf3jJC4HKJ
	 OnIBaaenbrRnTO8dvSUjhK3NeJd+HZNjVbsy/C5NI8BZY9tmrCUoRtuqyDvkO1n2K5
	 MYm/YUXNzDrMNkONJUb5KcCbXCMsZlpGajEOpxh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 103/163] Input: ads7846 - use spi_device_id table
Date: Tue, 23 Jul 2024 20:23:52 +0200
Message-ID: <20240723180147.456081600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 7c7b1be19b228b450c2945ec379d7fc6bfef9852 ]

As the driver supports more devices over time the single MODULE_ALIAS
is complete and raises several warnings:
SPI driver ads7846 has no spi_device_id for ti,tsc2046
SPI driver ads7846 has no spi_device_id for ti,ads7843
SPI driver ads7846 has no spi_device_id for ti,ads7845
SPI driver ads7846 has no spi_device_id for ti,ads7873

Fix this by adding a spi_device_id table and removing the manual
MODULE_ALIAS.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240619122703.2081476-1-alexander.stein@ew.tq-group.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index d2bbb436a77df..4d13db13b9e57 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1111,6 +1111,16 @@ static const struct of_device_id ads7846_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, ads7846_dt_ids);
 
+static const struct spi_device_id ads7846_spi_ids[] = {
+	{ "tsc2046", 7846 },
+	{ "ads7843", 7843 },
+	{ "ads7845", 7845 },
+	{ "ads7846", 7846 },
+	{ "ads7873", 7873 },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ads7846_spi_ids);
+
 static const struct ads7846_platform_data *ads7846_get_props(struct device *dev)
 {
 	struct ads7846_platform_data *pdata;
@@ -1386,10 +1396,10 @@ static struct spi_driver ads7846_driver = {
 	},
 	.probe		= ads7846_probe,
 	.remove		= ads7846_remove,
+	.id_table	= ads7846_spi_ids,
 };
 
 module_spi_driver(ads7846_driver);
 
 MODULE_DESCRIPTION("ADS7846 TouchScreen Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("spi:ads7846");
-- 
2.43.0



