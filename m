Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F13A1DFD98;
	Wed, 19 Mar 2025 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394890; cv=none; b=Hj97TCOGRr1RWtkrYmy9l01FcekSLVAJgDAEyR+lE3fIbPOnQadQCyk+6gy6G1ead/UBWAVdlg86A8jP2iC+HehpKw4ViC9O0t8FxXcGew6gfRBw/u6n3Z9sCuqVUZpOC18uWM8kZJDfJuEruVF1BgNFR78NKBC+hVwEYUMAvJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394890; c=relaxed/simple;
	bh=1m3f64YOrQfbLDjUmwhrloQZSB7GwFR0TA14FWE8k5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTisldCHQCHRtjWOF4oK2Q5x4b5HT7iDCd8ZBV36sC2efxLedtDC9dzgW57OiMV6CkwHci62h9/XNS620JEyGxLmPpR+oGFkeU0yxp7j9l03n8o8Z0DaMjHsGL725UIWN69dC0srK03hETyI/ApUl3cQ2BQpB5IuXiVOO+Rco3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UerjZtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UerjZtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E801AC4CEE4;
	Wed, 19 Mar 2025 14:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394890;
	bh=1m3f64YOrQfbLDjUmwhrloQZSB7GwFR0TA14FWE8k5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1UerjZtzcwUW8p7tMZVzLV9sM6kyLErM+eE788lkpZeSsCK21RC9tvv2CRzjpOYqs
	 8Wna2SSvggfObQ7QwZUBvpnptt7BSV9bMB1ZKAVfsY6bCtUs+G/moDn64I71uS2yqw
	 TStRFssbGPR2hMKm6TRYIzpny6ICXHybp4mnNW5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 093/241] platform/x86: int3472: Call "reset" GPIO "enable" for INT347E
Date: Wed, 19 Mar 2025 07:29:23 -0700
Message-ID: <20250319143030.025347338@linuxfoundation.org>
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

[ Upstream commit 569617dbbd06286fb73f3f1c2ac91e51d863c7de ]

The DT bindings for ov7251 specify "enable" GPIO (xshutdown in
documentation) but the int3472 indiscriminately provides this as a "reset"
GPIO to sensor drivers. Take this into account by assigning it as "enable"
with active high polarity for INT347E devices, i.e. ov7251. "reset" with
active low polarity remains the default GPIO name for other devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250211072841.7713-3-sakari.ailus@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 52 +++++++++++++++++--
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 8205993d3b5c4..a80c981caa340 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -2,6 +2,7 @@
 /* Author: Dan Scally <djrscally@gmail.com> */
 
 #include <linux/acpi.h>
+#include <linux/array_size.h>
 #include <linux/bitfield.h>
 #include <linux/device.h>
 #include <linux/gpio/consumer.h>
@@ -122,10 +123,53 @@ skl_int3472_gpiod_get_from_temp_lookup(struct int3472_discrete_device *int3472,
 	return desc;
 }
 
-static void int3472_get_func_and_polarity(u8 type, const char **func,
-					  unsigned long *gpio_flags)
+/**
+ * struct int3472_gpio_map - Map GPIOs to whatever is expected by the
+ * sensor driver (as in DT bindings)
+ * @hid: The ACPI HID of the device without the instance number e.g. INT347E
+ * @type_from: The GPIO type from ACPI ?SDT
+ * @type_to: The assigned GPIO type, typically same as @type_from
+ * @func: The function, e.g. "enable"
+ * @polarity_low: GPIO_ACTIVE_LOW true if the @polarity_low is true,
+ * GPIO_ACTIVE_HIGH otherwise
+ */
+struct int3472_gpio_map {
+	const char *hid;
+	u8 type_from;
+	u8 type_to;
+	bool polarity_low;
+	const char *func;
+};
+
+static const struct int3472_gpio_map int3472_gpio_map[] = {
+	{ "INT347E", INT3472_GPIO_TYPE_RESET, INT3472_GPIO_TYPE_RESET, false, "enable" },
+};
+
+static void int3472_get_func_and_polarity(struct acpi_device *adev, u8 *type,
+					  const char **func, unsigned long *gpio_flags)
 {
-	switch (type) {
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(int3472_gpio_map); i++) {
+		/*
+		 * Map the firmware-provided GPIO to whatever a driver expects
+		 * (as in DT bindings). First check if the type matches with the
+		 * GPIO map, then further check that the device _HID matches.
+		 */
+		if (*type != int3472_gpio_map[i].type_from)
+			continue;
+
+		if (!acpi_dev_hid_uid_match(adev, int3472_gpio_map[i].hid, NULL))
+			continue;
+
+		*type = int3472_gpio_map[i].type_to;
+		*gpio_flags = int3472_gpio_map[i].polarity_low ?
+			      GPIO_ACTIVE_LOW : GPIO_ACTIVE_HIGH;
+		*func = int3472_gpio_map[i].func;
+		return;
+	}
+
+	switch (*type) {
 	case INT3472_GPIO_TYPE_RESET:
 		*func = "reset";
 		*gpio_flags = GPIO_ACTIVE_LOW;
@@ -218,7 +262,7 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 
 	type = FIELD_GET(INT3472_GPIO_DSM_TYPE, obj->integer.value);
 
-	int3472_get_func_and_polarity(type, &func, &gpio_flags);
+	int3472_get_func_and_polarity(int3472->sensor, &type, &func, &gpio_flags);
 
 	pin = FIELD_GET(INT3472_GPIO_DSM_PIN, obj->integer.value);
 	if (pin != agpio->pin_table[0])
-- 
2.39.5



