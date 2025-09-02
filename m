Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0530EF9D;
	Tue,  2 Sep 2025 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819552; cv=none; b=BFN9QMI+1/AclOEiN4eHDY2VAVVUbVYj++OjsLXC5FhegAy/ZrhW7VfxFF8v0lNxvflh5AnoLmkXl4RzEFEVhwMKXfICCaviZ/E8vZJcUsd1KKRCj7YGSH1XfqdRHAubalIBvap8S/2OXbqbd1MQOu+if2X6A+XXkCphCvX0n28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819552; c=relaxed/simple;
	bh=jX4qCk8Vk1qB1Ttg5hZzqUTPA1qwYrFuQLfaXCUIduE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/1eAh/M20M2DyahwjZYpyC//YYXtRHjxa3duvvY7PxjDgkpGMgfCMDjA1LiBbP50fAFz/rFSzg/Wa010sJxAqbXkF1VhVfE8QfI+8B0Wno16cfkhjex7H9tPZl9ocUPFxHBfJMuVOzAkBvm7+sVkv4YTj4NUZnrbCidYLQZa94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sveZmQYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sveZmQYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BEAC4CEED;
	Tue,  2 Sep 2025 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819550;
	bh=jX4qCk8Vk1qB1Ttg5hZzqUTPA1qwYrFuQLfaXCUIduE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sveZmQYYERgdrLkinF04LxvQAeY1yktMfvKghGzm+PcTq/4bPfPLkGn57NnajToQE
	 oJm11FKcA2AhuLcSxl0y4/BoN1OybitRxhMpFcND9gKiexfLmEvz/066OHxK2nTqLZ
	 8XVIYcWA6TrVtM7yXqraglkwX/sJpFl7r5Ia53C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongcheng Yan <dongcheng.yan@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.16 026/142] platform/x86: int3472: add hpd pin support
Date: Tue,  2 Sep 2025 15:18:48 +0200
Message-ID: <20250902131949.145844663@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongcheng Yan <dongcheng.yan@intel.com>

commit a032fe30cf09b6723ab61a05aee057311b00f9e1 upstream.

Typically HDMI to MIPI CSI-2 bridges have a pin to signal image data is
being received. On the host side this is wired to a GPIO for polling or
interrupts. This includes the Lontium HDMI to MIPI CSI-2 bridges
lt6911uxe and lt6911uxc.

The GPIO "hpd" is used already by other HDMI to CSI-2 bridges, use it
here as well.

Signed-off-by: Dongcheng Yan <dongcheng.yan@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 20244cbafbd6 ("media: i2c: change lt6911uxe irq_gpio name to "hpd"")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/int3472/discrete.c |    6 ++++++
 include/linux/platform_data/x86/int3472.h     |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -193,6 +193,10 @@ static void int3472_get_con_id_and_polar
 		*con_id = "privacy-led";
 		*gpio_flags = GPIO_ACTIVE_HIGH;
 		break;
+	case INT3472_GPIO_TYPE_HOTPLUG_DETECT:
+		*con_id = "hpd";
+		*gpio_flags = GPIO_ACTIVE_HIGH;
+		break;
 	case INT3472_GPIO_TYPE_POWER_ENABLE:
 		*con_id = "avdd";
 		*gpio_flags = GPIO_ACTIVE_HIGH;
@@ -223,6 +227,7 @@ static void int3472_get_con_id_and_polar
  * 0x0b Power enable
  * 0x0c Clock enable
  * 0x0d Privacy LED
+ * 0x13 Hotplug detect
  *
  * There are some known platform specific quirks where that does not quite
  * hold up; for example where a pin with type 0x01 (Power down) is mapped to
@@ -292,6 +297,7 @@ static int skl_int3472_handle_gpio_resou
 	switch (type) {
 	case INT3472_GPIO_TYPE_RESET:
 	case INT3472_GPIO_TYPE_POWERDOWN:
+	case INT3472_GPIO_TYPE_HOTPLUG_DETECT:
 		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, con_id, gpio_flags);
 		if (ret)
 			err_msg = "Failed to map GPIO pin to sensor\n";
--- a/include/linux/platform_data/x86/int3472.h
+++ b/include/linux/platform_data/x86/int3472.h
@@ -27,6 +27,7 @@
 #define INT3472_GPIO_TYPE_CLK_ENABLE				0x0c
 #define INT3472_GPIO_TYPE_PRIVACY_LED				0x0d
 #define INT3472_GPIO_TYPE_HANDSHAKE				0x12
+#define INT3472_GPIO_TYPE_HOTPLUG_DETECT			0x13
 
 #define INT3472_PDEV_MAX_NAME_LEN				23
 #define INT3472_MAX_SENSOR_GPIOS				3


