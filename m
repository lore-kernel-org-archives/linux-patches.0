Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037614;
	b=llWV4dWIV1PP1q0VbRgvYjJUPSLsIkLB1DIwvdVbAcSv1ntVIeX/gGJ+KrZWssrrgYKO
	 oEcSMYvEGN1YMlVZL1Nl++moGocCWzqE+dyvOoFGzMC2YgONLviFhmtN3QT3g+6Y+5jvi
	 ntPjdRWpVjP8QoyAROdUnS9fVNbiLdF6Qe4j75aFrnfrnyecXz/MocDkITZI1DaiAZYmW
	 lfclvffCRtvwN8XsqbZuZILxaNaLOlnaxpEdbqVfY6NF2rfNlIxAWgvQwVDhuF8M1rs8J
	 IxeTAP0tSnSA3vKel9/ClJa1eo+UFRBXg+T2ptUA8XEh96UzgWaYFz2ECCntcrDZgrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rpNUdOSjrlfH+WxtVDHzLxV/5S6KTtxG1SRuABMbxc=;
	b=lFa/zeF/hH3a4Gkej2owmXdercsO/b4Vq/ClXY5s8he26kFQ8GFZjd0ub4+iDf+GgqTs
	 h4ElkurtNkLX54HegT7GcpvbH8BPrGKXzpJYwxxR41MXyI1jlXnPx/5KIsRyH3XzEArcX
	 Z7MqCpdrSky+iZ3sTBA/+hPo68My3daZvr0W/9FGFFPEzW8qzcxJvFLzWstto70b9SBoq
	 28vd+9pvqV6cSzJfqu4j6vUsnEJZS3xnVi+fh5WrjlZCSZ0P5TI16IChWRxu5dyTtD8Ez
	 DOFENVtHnRu9fbS+jahl2sHcWv/Rk1jnjpnoQ7J51hz9T2yz1ONnmeU0mom/4C2vsig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrOVQ2Iz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B0A606A31C;
	Wed, 18 Nov 2026 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrOVQ2Iz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D11F000C4;
	Wed, 18 Nov 2026 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037614;
	bh=6rpNUdOSjrlfH+WxtVDHzLxV/5S6KTtxG1SRuABMbxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrOVQ2Izj/TZcpEuvVAeZDqnovQnuMvW32WEszyS6Dz/tx1TuBmREgqD8ztr9qXFm
	 TIQWhYqEtL4LuotCZXLq6T9kCzAQtMQ8wOZ+reEun3g3FV5X0WBZhag8WPUWX4jrl6
	 wMRbh2j5+IE4CtVIKF1CxCDghdrAL5qgRzwJ23s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1458/3318] hwmon: (hp-wmi-sensors) Avoid global struct mutation
Date: Wed, 18 Nov 2026 15:34:40 +0100
Message-ID: <20261118150404.632851029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 587ae8896d1da..8f2f7d648c99e 100644
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
@@ -1517,11 +1518,6 @@ static const struct hwmon_ops hp_wmi_hwmon_ops = {
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
@@ -1958,7 +1954,8 @@ static int make_chip_info(struct hp_wmi_sensors *state, bool has_events)
 	if (!ptr_channel_info)
 		return -ENOMEM;
 
-	hp_wmi_chip_info.info = ptr_channel_info;
+	state->chip_info.ops = &hp_wmi_hwmon_ops;
+	state->chip_info.info = ptr_channel_info;
 
 	for (type = hwmon_chip; type < hwmon_max; type++) {
 		count = channel_count[type];
@@ -2049,7 +2046,7 @@ static int hp_wmi_sensors_init(struct hp_wmi_sensors *state)
 		return err;
 
 	hwdev = devm_hwmon_device_register_with_info(dev, "hp_wmi_sensors",
-						     state, &hp_wmi_chip_info,
+						     state, &state->chip_info,
 						     NULL);
 	return PTR_ERR_OR_ZERO(hwdev);
 }
-- 
2.53.0



