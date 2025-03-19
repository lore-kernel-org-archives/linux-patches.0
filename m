Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BD71DFD98;
	Wed, 19 Mar 2025 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394889; cv=none; b=hLNSQDBElqyWS92KWdgDZl6FkNPFkk4rZjXlaYsaB5AXKDw6G5w//4XzyTIlomNh2IyaPXiT7Rj8CXkRJznFk4q+QYvyxqrN3XC+3DQS7LCi33I9DHZxLNzYtFOyib3hejl27nDiCHy3K+FdmH37kjUEJmhvPMh2ghO3lAY8HKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394889; c=relaxed/simple;
	bh=o3+cTxsmpmc7lNZlXM+chykFY8lPupPce7A1hKjs+PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/VqQOzEDYQBDtWK8shcKE87fPHzenxu1V1bj8Xuk7rcBEGn758i4HAQ8Ud6AicTBjNvWSEjJO7YsMDW5xZQRqhZY8xoI0CNyd4mElhhR4qg5wRdC510/tpsoBBtJSpI8BFTXe38NrsOIw2f7t2XMnOc6tjLwBvXiK4lMCyjxwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnUzmn9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnUzmn9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46050C4CEE4;
	Wed, 19 Mar 2025 14:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394889;
	bh=o3+cTxsmpmc7lNZlXM+chykFY8lPupPce7A1hKjs+PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnUzmn9HjHJzqJ5tmluazgL0LliwDbJgvaiQ8uGCOtZSaZFGpMTmqEl+FWm6rXhA6
	 IAA95pNxLi3Uu59SADI02mc2KieR9IPCL6qkO8jBm1Tg+fSQ9bpdzDWP1mc1kIJCMA
	 BtqiT5uE+8rppAKMx+qqpPlO4GG7RZGiafIDXvv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 092/241] platform/x86: int3472: Use correct type for "polarity", call it gpio_flags
Date: Wed, 19 Mar 2025 07:29:22 -0700
Message-ID: <20250319143030.000474702@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit fc22b06fbd2afefa1eddff69a6fd30c539cef577 ]

Struct gpiod_lookup flags field's type is unsigned long. Thus use unsigned
long for values to be assigned to that field. Similarly, also call the
field gpio_flags which it really is.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250211072841.7713-2-sakari.ailus@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 39 ++++++++++---------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 09fff213b0911..8205993d3b5c4 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -55,7 +55,7 @@ static void skl_int3472_log_sensor_module_name(struct int3472_discrete_device *i
 
 static int skl_int3472_fill_gpiod_lookup(struct gpiod_lookup *table_entry,
 					 struct acpi_resource_gpio *agpio,
-					 const char *func, u32 polarity)
+					 const char *func, unsigned long gpio_flags)
 {
 	char *path = agpio->resource_source.string_ptr;
 	struct acpi_device *adev;
@@ -70,14 +70,14 @@ static int skl_int3472_fill_gpiod_lookup(struct gpiod_lookup *table_entry,
 	if (!adev)
 		return -ENODEV;
 
-	*table_entry = GPIO_LOOKUP(acpi_dev_name(adev), agpio->pin_table[0], func, polarity);
+	*table_entry = GPIO_LOOKUP(acpi_dev_name(adev), agpio->pin_table[0], func, gpio_flags);
 
 	return 0;
 }
 
 static int skl_int3472_map_gpio_to_sensor(struct int3472_discrete_device *int3472,
 					  struct acpi_resource_gpio *agpio,
-					  const char *func, u32 polarity)
+					  const char *func, unsigned long gpio_flags)
 {
 	int ret;
 
@@ -87,7 +87,7 @@ static int skl_int3472_map_gpio_to_sensor(struct int3472_discrete_device *int347
 	}
 
 	ret = skl_int3472_fill_gpiod_lookup(&int3472->gpios.table[int3472->n_sensor_gpios],
-					    agpio, func, polarity);
+					    agpio, func, gpio_flags);
 	if (ret)
 		return ret;
 
@@ -100,7 +100,7 @@ static int skl_int3472_map_gpio_to_sensor(struct int3472_discrete_device *int347
 static struct gpio_desc *
 skl_int3472_gpiod_get_from_temp_lookup(struct int3472_discrete_device *int3472,
 				       struct acpi_resource_gpio *agpio,
-				       const char *func, u32 polarity)
+				       const char *func, unsigned long gpio_flags)
 {
 	struct gpio_desc *desc;
 	int ret;
@@ -111,7 +111,7 @@ skl_int3472_gpiod_get_from_temp_lookup(struct int3472_discrete_device *int3472,
 		return ERR_PTR(-ENOMEM);
 
 	lookup->dev_id = dev_name(int3472->dev);
-	ret = skl_int3472_fill_gpiod_lookup(&lookup->table[0], agpio, func, polarity);
+	ret = skl_int3472_fill_gpiod_lookup(&lookup->table[0], agpio, func, gpio_flags);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -122,32 +122,33 @@ skl_int3472_gpiod_get_from_temp_lookup(struct int3472_discrete_device *int3472,
 	return desc;
 }
 
-static void int3472_get_func_and_polarity(u8 type, const char **func, u32 *polarity)
+static void int3472_get_func_and_polarity(u8 type, const char **func,
+					  unsigned long *gpio_flags)
 {
 	switch (type) {
 	case INT3472_GPIO_TYPE_RESET:
 		*func = "reset";
-		*polarity = GPIO_ACTIVE_LOW;
+		*gpio_flags = GPIO_ACTIVE_LOW;
 		break;
 	case INT3472_GPIO_TYPE_POWERDOWN:
 		*func = "powerdown";
-		*polarity = GPIO_ACTIVE_LOW;
+		*gpio_flags = GPIO_ACTIVE_LOW;
 		break;
 	case INT3472_GPIO_TYPE_CLK_ENABLE:
 		*func = "clk-enable";
-		*polarity = GPIO_ACTIVE_HIGH;
+		*gpio_flags = GPIO_ACTIVE_HIGH;
 		break;
 	case INT3472_GPIO_TYPE_PRIVACY_LED:
 		*func = "privacy-led";
-		*polarity = GPIO_ACTIVE_HIGH;
+		*gpio_flags = GPIO_ACTIVE_HIGH;
 		break;
 	case INT3472_GPIO_TYPE_POWER_ENABLE:
 		*func = "power-enable";
-		*polarity = GPIO_ACTIVE_HIGH;
+		*gpio_flags = GPIO_ACTIVE_HIGH;
 		break;
 	default:
 		*func = "unknown";
-		*polarity = GPIO_ACTIVE_HIGH;
+		*gpio_flags = GPIO_ACTIVE_HIGH;
 		break;
 	}
 }
@@ -194,7 +195,7 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	struct gpio_desc *gpio;
 	const char *err_msg;
 	const char *func;
-	u32 polarity;
+	unsigned long gpio_flags;
 	int ret;
 
 	if (!acpi_gpio_get_io_resource(ares, &agpio))
@@ -217,7 +218,7 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 
 	type = FIELD_GET(INT3472_GPIO_DSM_TYPE, obj->integer.value);
 
-	int3472_get_func_and_polarity(type, &func, &polarity);
+	int3472_get_func_and_polarity(type, &func, &gpio_flags);
 
 	pin = FIELD_GET(INT3472_GPIO_DSM_PIN, obj->integer.value);
 	if (pin != agpio->pin_table[0])
@@ -227,16 +228,16 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 
 	active_value = FIELD_GET(INT3472_GPIO_DSM_SENSOR_ON_VAL, obj->integer.value);
 	if (!active_value)
-		polarity ^= GPIO_ACTIVE_LOW;
+		gpio_flags ^= GPIO_ACTIVE_LOW;
 
 	dev_dbg(int3472->dev, "%s %s pin %d active-%s\n", func,
 		agpio->resource_source.string_ptr, agpio->pin_table[0],
-		str_high_low(polarity == GPIO_ACTIVE_HIGH));
+		str_high_low(gpio_flags == GPIO_ACTIVE_HIGH));
 
 	switch (type) {
 	case INT3472_GPIO_TYPE_RESET:
 	case INT3472_GPIO_TYPE_POWERDOWN:
-		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, func, polarity);
+		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, func, gpio_flags);
 		if (ret)
 			err_msg = "Failed to map GPIO pin to sensor\n";
 
@@ -244,7 +245,7 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	case INT3472_GPIO_TYPE_CLK_ENABLE:
 	case INT3472_GPIO_TYPE_PRIVACY_LED:
 	case INT3472_GPIO_TYPE_POWER_ENABLE:
-		gpio = skl_int3472_gpiod_get_from_temp_lookup(int3472, agpio, func, polarity);
+		gpio = skl_int3472_gpiod_get_from_temp_lookup(int3472, agpio, func, gpio_flags);
 		if (IS_ERR(gpio)) {
 			ret = PTR_ERR(gpio);
 			err_msg = "Failed to get GPIO\n";
-- 
2.39.5



