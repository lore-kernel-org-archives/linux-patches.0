Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585556;
	b=FQEZ0o9XzGlbA79afDY/j6f1huR26KL4i2um1rgjx5RcurqD0vbZh9qZkuUbMK6ou11f
	 ZOCrMVzcqgEH5KA79qkPBrSjpBhudb1hNbjf2YEi5oQepQzKHCrLdeoJNpu+44ag4S89H
	 3+hTklXTvRW3Sl/+s+Qn93PnEym9n/u1MxDaavRUFL7d6N5mszbaox4nZTi3D8/iYOacC
	 kLJ/zcpdu/twotofDw5GVzeYyTQF4tT8jbDExB+PdQ/5cIKv8W84ZdD0nZNXrbg7zujBZ
	 2wlHxmDtlGg2Ly2Nyk/Wg1HS2XoSDTWf5EAztnKAHWTuiickcdrjPg+1xoGB7r56WNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WZLmTozchpCXVR7UNT7UldEHt96CohhPteoaJGB2CjQ=;
	b=eAQu9nuwjehEumoTKRDJ7OB+aS8Vk2M+YleJdhm4XLtv8oBh5rSKN8im85xVW9GzN0mS
	 RpJ8m71iaO45GbfQINvMKbi6FaLVlxpVQ7BuowIkhscvHZeJMwDMkJlbyIR0KGaxA8qyr
	 rgJiSxI1O4aJ4rcbb2R9nCRvvz8NV9OAW0rW/oHCmHEQOiNa1jJLqH6vTdUrIUu808kYD
	 VSy/Ie02xMtr63zIad6dlDPyhN4EyBI0wtshC1dW+lQckWn9z/hGzcoFRbWJojEx63RBL
	 hbkABZpgdQ/3cPVDRQ98PVsS6QwXV/0SHbFpDAE9UIR3NlkAwWy0qaeyn8tkotFOuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXGKXP6s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EDA606BA86;
	Fri, 13 Nov 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXGKXP6s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723071F000C6;
	Fri, 13 Nov 2026 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585556;
	bh=WZLmTozchpCXVR7UNT7UldEHt96CohhPteoaJGB2CjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXGKXP6sb99G7EBhhBsoCbAAbofCAfA7kuzruGqpKBBFDLqD3fV49BECwjGm7JiIw
	 d+ypddEvaYkY9oiYOs9cqS1i8T96Fmqq/TVCb7NDliVz3cz2gYsuIdxxUEIVVV8XJj
	 c7GE06v/fohFVOut0kTdnvg1cjvfJysDTWAmKSsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 186/507] hwmon: (hp-wmi-sensors) Avoid global struct mutation
Date: Fri, 13 Nov 2026 10:48:10 -0500
Message-ID: <20261113153800.824745947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit dc992efeace99e479aec7a8f0c49a9493c729606 ]

In the HP WMI sensors driver, make_chip_info() assigns a device-managed
memory allocation to a static global structure, resulting in a
use-after-free when the device unbinds.
During hp_wmi_sensors_probe(), make_chip_info() dynamically allocates a
hwmon_channel_info array using devm_kcalloc() and assigns it to the
static global hp_wmi_chip_info.info pointer.

If multiple instances probe sequentially or concurrently, the shared
global pointer is overwritten by each new device. When any device unbinds,
its devm-managed memory is automatically freed, leaving the global
hp_wmi_chip_info struct and any other active device instances with a
dangling pointer. Subsequent accesses by the hwmon core (such as thermal
zone reads) will dereference this freed memory, causing a use-after-free.

While this is not supposed to happen in the real world (there should only
be one instance of the driver in any system), modifying global structures
is undesirable and should be avoided whenever possible. Allocate struct
hwmon_chip_info as part of struct hp_wmi_sensors instead and initialize it
in make_chip_info() to avoid mutating the global structure.

Fixes: 23902f98f8d4 ("hwmon: add HP WMI Sensors driver")
Cc: stable@vger.kernel.org
Cc: James Seo <james@equiv.tech>
Acked-by: James Seo <james@equiv.tech
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hp-wmi-sensors.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/hp-wmi-sensors.c b/drivers/hwmon/hp-wmi-sensors.c
index cfa0d6ad0fb3f..dd1fa48314a54 100644
--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -390,6 +390,7 @@ struct hp_wmi_info {
  */
 struct hp_wmi_sensors {
 	struct wmi_device *wdev;
+	struct hwmon_chip_info chip_info;
 	struct hp_wmi_info **info_map[hwmon_max];
 	u8 channel_count[hwmon_max];
 	bool has_intrusion;
@@ -1531,11 +1532,6 @@ static const struct hwmon_ops hp_wmi_hwmon_ops = {
 	.write	     = hp_wmi_hwmon_write,
 };
 
-static struct hwmon_chip_info hp_wmi_chip_info = {
-	.ops         = &hp_wmi_hwmon_ops,
-	.info        = NULL,
-};
-
 static struct hp_wmi_info *match_fan_event(struct hp_wmi_sensors *state,
 					   const char *event_description)
 {
@@ -1962,7 +1958,8 @@ static int make_chip_info(struct hp_wmi_sensors *state, bool has_events)
 	if (!ptr_channel_info)
 		return -ENOMEM;
 
-	hp_wmi_chip_info.info = ptr_channel_info;
+	state->chip_info.ops = &hp_wmi_hwmon_ops;
+	state->chip_info.info = ptr_channel_info;
 
 	for (type = hwmon_chip; type < hwmon_max; type++) {
 		count = channel_count[type];
@@ -2053,7 +2050,7 @@ static int hp_wmi_sensors_init(struct hp_wmi_sensors *state)
 		return err;
 
 	hwdev = devm_hwmon_device_register_with_info(dev, "hp_wmi_sensors",
-						     state, &hp_wmi_chip_info,
+						     state, &state->chip_info,
 						     NULL);
 	return PTR_ERR_OR_ZERO(hwdev);
 }
-- 
2.53.0



