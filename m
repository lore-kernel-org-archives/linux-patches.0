Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02FB1D0BBC;
	Wed,  2 Oct 2024 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880143; cv=none; b=aTwNl8nwXXwkO/bJjAHYx+mn0+8vC/IViHq6XZNaOGZQcqZnELMegwuFzmHg8zUDlhhYBDU5EFg4OcK9Y2uLXr5Hh72rBUhbuYnW4/9xWh/q4zjJAvFTWoHcWLxJ9aEr4crAVSrM2vjC1OPTLRfw7mcK1Ze/TOPd0t4yQFidyeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880143; c=relaxed/simple;
	bh=YtbwWg4E9AYeaLf5e6rHGYcASo/3Yll+B1GYuWLzj8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7Rc/DJQwshmAplwSUVmS+m8mfXp7SqZey5TtNXwy+l39H0d/WD/0EHzAFiqdb4+AAKgbwyMxRYxdfNXxh+oHBxbHTkBxKEoONZpNE8c1Oy1Qr0iTrbjAanlbRK3osnJfcCsWaot8vh26IkIq2Xeywi6NhOiW/5Vj4bVZgMC9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GH3sowOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GH3sowOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D35C4CECD;
	Wed,  2 Oct 2024 14:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880143;
	bh=YtbwWg4E9AYeaLf5e6rHGYcASo/3Yll+B1GYuWLzj8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH3sowOlGrzVIBmNz7+GC0kLlvlPqiAsOPkpbOvxSZGv3k4IXOg6pSaDBsqWUoyfs
	 XiQJdOjdEw/l1PSDZgUez+wq4qaEvSyFZhPi/tiThKAHgvzwKwe6ncLDWh/feewToP
	 Yvw0UbdyveJGa6Fhs4h3cF09CcDZYeTvVz09TqdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 358/538] iio: magnetometer: ak8975: Convert enum->pointer for data in the match tables
Date: Wed,  2 Oct 2024 14:59:57 +0200
Message-ID: <20241002125806.558478478@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index eb706d0bf70bc..104798549de11 100644
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
@@ -883,10 +883,7 @@ static int ak8975_probe(struct i2c_client *client)
 	struct iio_dev *indio_dev;
 	struct gpio_desc *eoc_gpiod;
 	struct gpio_desc *reset_gpiod;
-	const void *match;
-	unsigned int i;
 	int err;
-	enum asahi_compass_chipset chipset;
 	const char *name = NULL;
 
 	/*
@@ -928,27 +925,15 @@ static int ak8975_probe(struct i2c_client *client)
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



