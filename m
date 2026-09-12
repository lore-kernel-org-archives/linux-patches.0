Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F63381EB5;
	Sat, 12 Sep 2026 07:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199201; cv=none; b=WuRtl1HqLlX+vfKILLefilDA0C0z1hRCXqFe3dXO+o6oTB5p13mecqV8xKyasJrfpI9dMH0o3Cabmi7FE/w6zYP0Loj688A+964ZG9sE8/6BkmQOsrqdcg5KzwQaXRPnE6Unf4Qy22I02sNWFwN2XKXRqz29LyGQ3IJgDwGJeho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199201; c=relaxed/simple;
	bh=6zKC2xuLOrW9sHQnbudsOy0jPKJ9XTjNQAH1o58LQUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyuAch+VM17KDGyHQm5WewCHVLuzxOpMcX55nEZxWjhJjolXq0mjmH/pOKa7kEhBATQAaTB9N1aY/3MRHY0VXaJ5Hoag4/aklagCwIWGQnajNafmL7lcPDB4Xeb7jZRoUb5fR57gSxCKX/IYTLxLLVpMT/frQ2N3zMkHszHbHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLYm8//O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLYm8//O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CF31F000FF;
	Sat, 12 Sep 2026 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199199;
	bh=Xu9sk3EMw+cCjlurlqw5u60kLsGbhOEqlOBibgtecwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLYm8//Ocem/9y4WRSc9lC4YKzNzl9ZGIsFIorO9P5FcevxDZgJyrBGeyfny6+ebT
	 irB2BNQusD5JIfhKYUVwTAB9IuehOFtlFqDYX6AJTpUqTC/eET/gk1mek97tx0MdoV
	 0TQqL13ynA8GRgzg5FPqH+ANl2dfdSw3Vh+4hb9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0535/1815] iio: dac: ad5686: missing NULL check on match data
Date: Sat, 12 Sep 2026 08:38:05 +0200
Message-ID: <20260912065701.438589264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

[ Upstream commit 572a008526359cdac2fa935dad75e9d50a79792f ]

Verify that chip_info pointer is not NULL. If a user binds the driver
using driver_override via sysfs with a device name not present in the
id_table or of_match_table, match data will be NULL.

Fixes: 0eb1728461a1 ("iio: dac: ad5686: drop enum id")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260710113149.53EC51F000E9@smtp.kernel.org/
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5686-spi.c | 9 +++++++--
 drivers/iio/dac/ad5696-i2c.c | 9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/dac/ad5686-spi.c b/drivers/iio/dac/ad5686-spi.c
index 8abfaf8f0c469..859874ab861c5 100644
--- a/drivers/iio/dac/ad5686-spi.c
+++ b/drivers/iio/dac/ad5686-spi.c
@@ -98,8 +98,13 @@ static const struct ad5686_bus_ops ad5686_spi_ops = {
 
 static int ad5686_spi_probe(struct spi_device *spi)
 {
-	return ad5686_probe(&spi->dev, spi_get_device_match_data(spi),
-			    spi->modalias, &ad5686_spi_ops);
+	const struct ad5686_chip_info *info;
+
+	info = spi_get_device_match_data(spi);
+	if (!info)
+		return -ENODATA;
+
+	return ad5686_probe(&spi->dev, info, spi->modalias, &ad5686_spi_ops);
 }
 
 static const struct spi_device_id ad5686_spi_id[] = {
diff --git a/drivers/iio/dac/ad5696-i2c.c b/drivers/iio/dac/ad5696-i2c.c
index d49946adbde3a..d5934405d5552 100644
--- a/drivers/iio/dac/ad5696-i2c.c
+++ b/drivers/iio/dac/ad5696-i2c.c
@@ -68,8 +68,13 @@ static const struct ad5686_bus_ops ad5686_i2c_ops = {
 
 static int ad5686_i2c_probe(struct i2c_client *i2c)
 {
-	return ad5686_probe(&i2c->dev, i2c_get_match_data(i2c),
-			    i2c->name, &ad5686_i2c_ops);
+	const struct ad5686_chip_info *info;
+
+	info = i2c_get_match_data(i2c);
+	if (!info)
+		return -ENODATA;
+
+	return ad5686_probe(&i2c->dev, info, i2c->name, &ad5686_i2c_ops);
 }
 
 static const struct i2c_device_id ad5686_i2c_id[] = {
-- 
2.53.0



