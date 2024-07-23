Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843F313D896;
	Tue, 23 Jul 2024 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759632; cv=none; b=DkHAYBlebu67qIz64l6JUJQpTjea0dXfT/6Bf11zAqg8KQ8KLorwZbDcseQ0JeUsDq2fP48MhFhpvdDzcbKPcTXSzr9lLmOSe2JSZM9F+CxYfDMdpim6kiWUFctBNbPaAwrmfYvBcKZvPQrcmWQbqyrDnCMwAavE/0/uWjoxJiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759632; c=relaxed/simple;
	bh=9S8gtc/ORiHW/GgrDuiHlNoNccelNSobC9bAqRkuEYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQQkiIGj9Zro4UrX92Mbd+HI10EGq/oWS5BJ+zaQDveun8ZGuPuS/DqIgeeao0QCn68uW+C0KMlUVZCBwoEp5NbPuxx0i8t0Kstj8un2LR9jrd2FW3G6FADajKzxMR031ZaZ/uvMMeR+zFHr4QB71hRXyJIOkp68/4dph3zLDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcmhVU06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcmhVU06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F2AC4AF0A;
	Tue, 23 Jul 2024 18:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759632;
	bh=9S8gtc/ORiHW/GgrDuiHlNoNccelNSobC9bAqRkuEYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcmhVU0624SjzS/ohZv/RBcIkNSFRdfdzIn1Dfh93aKy2Mv1xXVuCIdmM5oEjt6S/
	 sAEHYaPMufxkSK34sX7VYpkqQHDD2IFs/fwvbuZh3QoeXIW714awA2VrEZK+8B5Zcm
	 eY2p8LUiMp2rarElR9lYOhLRYs0ATmEIlwedY8HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/129] Input: ads7846 - use spi_device_id table
Date: Tue, 23 Jul 2024 20:23:44 +0200
Message-ID: <20240723180407.719509275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index faea40dd66d01..a66375700a630 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1114,6 +1114,16 @@ static const struct of_device_id ads7846_dt_ids[] = {
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
@@ -1392,10 +1402,10 @@ static struct spi_driver ads7846_driver = {
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



