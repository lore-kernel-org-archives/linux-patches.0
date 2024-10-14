Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641D81ADFE4;
	Mon, 14 Oct 2024 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918196; cv=none; b=YAk3OzuYnMlrlRotJm7F5CZLKTkLokBQuzAH6ReLm8RDFiOqgylQoTRzmi8Cv77/PBhw3Blj5uerKvVo8DLWj3pQu2UPO9yj2hFKcv+mEioQZVrhRK/2ca7fa9ip/jf/9JhbEAPKK8mt1DuS+O4TDQF8jr6UuyjBWiieIFBFGfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918196; c=relaxed/simple;
	bh=tC7kegarhe6w1GZ3qik5D9lrZxXQIkh0hhWFlOY8dGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pf8D/lVqzfkZMehKXIa6uV7rWEbsqQHOWzEHGurCtaHk6y+cF4NmXqQ8mhDAeYBYKj8YJTliGm2UUmdS6rWPIX12Zvow8WyYydEwShtNnk3sA4tJm9VlLW5z7RkxS6w/3QOz3qfho+rfGyy9iUl11FO88GPoVcrLA7U9vFPm6Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb4I+5Q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb4I+5Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9320C4CEC3;
	Mon, 14 Oct 2024 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918196;
	bh=tC7kegarhe6w1GZ3qik5D9lrZxXQIkh0hhWFlOY8dGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb4I+5Q5WqBTvZhpwTsy7qi2iEnGvz7TpFfL9kql89WrxTfdLXXffnWZGNGpS4fhW
	 j6PAWfa3gm2yzbRYruAKEZDf2bMV9OD3xbtxWMoJl4D8VHJcxcsOuBIh+FP0gvwfRr
	 yl+FrrJ8InOEm/+TE/eApnHw9ROfE4zQb1x0vaQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 251/798] iio: magnetometer: ak8975: Convert enum->pointer for data in the match tables
Date: Mon, 14 Oct 2024 16:13:25 +0200
Message-ID: <20241014141227.797283024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 4f9ea93afde190a0f906ee624fc9a45cf784551b ]

Convert enum->pointer for data in the match tables to simplify the probe()
by replacing device_get_match_data() and i2c_client_get_device_id by
i2c_get_match_data() as we have similar I2C, ACPI and DT matching table.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230818075600.24277-2-biju.das.jz@bp.renesas.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: da6e3160df23 ("iio: magnetometer: ak8975: drop incorrect AK09116 compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/ak8975.c | 75 +++++++++++++------------------
 1 file changed, 30 insertions(+), 45 deletions(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index caf03a2a98a5d..8762e0f085b80 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -813,13 +813,13 @@ static const struct iio_info ak8975_info = {
 };
 
 static const struct acpi_device_id ak_acpi_match[] = {
-	{"AK8975", AK8975},
-	{"AK8963", AK8963},
-	{"INVN6500", AK8963},
-	{"AK009911", AK09911},
-	{"AK09911", AK09911},
-	{"AKM9911", AK09911},
-	{"AK09912", AK09912},
+	{"AK8975", (kernel_ulong_t)&ak_def_array[AK8975] },
+	{"AK8963", (kernel_ulong_t)&ak_def_array[AK8963] },
+	{"INVN6500", (kernel_ulong_t)&ak_def_array[AK8963] },
+	{"AK009911", (kernel_ulong_t)&ak_def_array[AK09911] },
+	{"AK09911", (kernel_ulong_t)&ak_def_array[AK09911] },
+	{"AKM9911", (kernel_ulong_t)&ak_def_array[AK09911] },
+	{"AK09912", (kernel_ulong_t)&ak_def_array[AK09912] },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, ak_acpi_match);
@@ -883,10 +883,7 @@ static int ak8975_probe(struct i2c_client *client,
 	struct iio_dev *indio_dev;
 	struct gpio_desc *eoc_gpiod;
 	struct gpio_desc *reset_gpiod;
-	const void *match;
-	unsigned int i;
 	int err;
-	enum asahi_compass_chipset chipset;
 	const char *name = NULL;
 
 	/*
@@ -928,27 +925,15 @@ static int ak8975_probe(struct i2c_client *client,
 		return err;
 
 	/* id will be NULL when enumerated via ACPI */
-	match = device_get_match_data(&client->dev);
-	if (match) {
-		chipset = (uintptr_t)match;
-		name = dev_name(&client->dev);
-	} else if (id) {
-		chipset = (enum asahi_compass_chipset)(id->driver_data);
-		name = id->name;
-	} else
-		return -ENOSYS;
-
-	for (i = 0; i < ARRAY_SIZE(ak_def_array); i++)
-		if (ak_def_array[i].type == chipset)
-			break;
-
-	if (i == ARRAY_SIZE(ak_def_array)) {
-		dev_err(&client->dev, "AKM device type unsupported: %d\n",
-			chipset);
+	data->def = i2c_get_match_data(client);
+	if (!data->def)
 		return -ENODEV;
-	}
 
-	data->def = &ak_def_array[i];
+	/* If enumerated via firmware node, fix the ABI */
+	if (dev_fwnode(&client->dev))
+		name = dev_name(&client->dev);
+	else
+		name = id->name;
 
 	/* Fetch the regulators */
 	data->vdd = devm_regulator_get(&client->dev, "vdd");
@@ -1077,28 +1062,28 @@ static DEFINE_RUNTIME_DEV_PM_OPS(ak8975_dev_pm_ops, ak8975_runtime_suspend,
 				 ak8975_runtime_resume, NULL);
 
 static const struct i2c_device_id ak8975_id[] = {
-	{"ak8975", AK8975},
-	{"ak8963", AK8963},
-	{"AK8963", AK8963},
-	{"ak09911", AK09911},
-	{"ak09912", AK09912},
-	{"ak09916", AK09916},
+	{"ak8975", (kernel_ulong_t)&ak_def_array[AK8975] },
+	{"ak8963", (kernel_ulong_t)&ak_def_array[AK8963] },
+	{"AK8963", (kernel_ulong_t)&ak_def_array[AK8963] },
+	{"ak09911", (kernel_ulong_t)&ak_def_array[AK09911] },
+	{"ak09912", (kernel_ulong_t)&ak_def_array[AK09912] },
+	{"ak09916", (kernel_ulong_t)&ak_def_array[AK09916] },
 	{}
 };
 
 MODULE_DEVICE_TABLE(i2c, ak8975_id);
 
 static const struct of_device_id ak8975_of_match[] = {
-	{ .compatible = "asahi-kasei,ak8975", },
-	{ .compatible = "ak8975", },
-	{ .compatible = "asahi-kasei,ak8963", },
-	{ .compatible = "ak8963", },
-	{ .compatible = "asahi-kasei,ak09911", },
-	{ .compatible = "ak09911", },
-	{ .compatible = "asahi-kasei,ak09912", },
-	{ .compatible = "ak09912", },
-	{ .compatible = "asahi-kasei,ak09916", },
-	{ .compatible = "ak09916", },
+	{ .compatible = "asahi-kasei,ak8975", .data = &ak_def_array[AK8975] },
+	{ .compatible = "ak8975", .data = &ak_def_array[AK8975] },
+	{ .compatible = "asahi-kasei,ak8963", .data = &ak_def_array[AK8963] },
+	{ .compatible = "ak8963", .data = &ak_def_array[AK8963] },
+	{ .compatible = "asahi-kasei,ak09911", .data = &ak_def_array[AK09911] },
+	{ .compatible = "ak09911", .data = &ak_def_array[AK09911] },
+	{ .compatible = "asahi-kasei,ak09912", .data = &ak_def_array[AK09912] },
+	{ .compatible = "ak09912", .data = &ak_def_array[AK09912] },
+	{ .compatible = "asahi-kasei,ak09916", .data = &ak_def_array[AK09916] },
+	{ .compatible = "ak09916", .data = &ak_def_array[AK09916] },
 	{}
 };
 MODULE_DEVICE_TABLE(of, ak8975_of_match);
-- 
2.43.0



