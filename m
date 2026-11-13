Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585614;
	b=U9dyWa8EaR3VuUAiTwAaDgOv9qJ8hPi00pc2/WyuxTIFNUALBZTjPvGRe9WV38aN1OJb
	 JAQgAlPpN9UP9bq8TgTOpruIaCGv56VUQ2o43l9mjT/6+CrxRBTSxhNKXvOqPBAca5ntj
	 ekY5hA5pBAGK7Fb16d2e6BJH5zwl60pWLKxc8sZuXiEOj35WoDc8Psuf6Y7sSxTwigG0b
	 OasBrgJA4s5dFsR8P1sE25Wk0n557lK2D3Jy4NuARZLloVCqP/WQ5glKoZvffeKcbq4zT
	 KYcd7wN11GFjybWQagDQ8ljY+L/JmS6jz7urN/3HOgvdFo/MfTsoiPasjyMzeVhmH6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+EaQrd4jrVJ9c+Xzdl9mtp3znYcIF9eQZMtEbDSuoys=;
	b=Zd+K/CXbPjVjKyfVFTuI3nVD9UkjBivXtYQL7tuCdRkSAUa1gQT7cHj4m8OmAHDN2P+j
	 gXviC5FCosfbUYTlzBWdxufSPvyVTbJIaSFw9BZgYE5EKTz+1slDQxPCrg4pgV65mGDVk
	 roraLgTLzOrCUsrQIJLqoch88htQgMrNhHKbgE0qtyDzmfkd2jX8CL7YI18GUc2Z1hzyq
	 UYh8RmOSzMO8/9CGTUUXKP+UwP4WqPosDojgaKReXZlDSni2FoPts6NQYM5Waxv7as25N
	 5epiwrK1kpLniJimXwgPA1z/uCdYdXuCioPE1+n1wUpRrMGbrOnbpx/xgkBHWrVyzJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0IQ+BeXe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BAD6070221;
	Fri, 13 Nov 2026 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0IQ+BeXe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022E11F000C4;
	Fri, 13 Nov 2026 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585614;
	bh=+EaQrd4jrVJ9c+Xzdl9mtp3znYcIF9eQZMtEbDSuoys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0IQ+BeXeK+z0k8qXDXJdxLYnVJSYVdB8Tsa4niAtxF2nMCSHiMvTaiBO4diqDSPYD
	 Xo+G7euDu69NefTykKlqu25x7saYSK/poUe1eS7vLHym9kRkd7G09P3uDC/R9t/uoR
	 oq0/MyHH7ucpGkHXGatt0l0nuAJ8otLwcL0e2rBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Brindley <kernel@maidavale.org>,
	Denis Pauk <pauk.denis@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 185/507] hwmon: (asus_wmi_sensors) Avoid global struct mutation
Date: Fri, 13 Nov 2026 10:48:09 -0500
Message-ID: <20261113153800.784084538@linuxfoundation.org>
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

[ Upstream commit 59d586c9e47d1205563bc9b5a5d443adc3ba5bc5 ]

In the asus_wmi_sensors driver, device-managed memory allocated in
asus_wmi_configure_sensor_setup() is assigned to a global static structure,
leading to a potential use-after-free when the device is unbound.
The driver defines a single global asus_wmi_chip_info structure to register
with the hwmon core. During probe, it dynamically allocates the .info
channel array using devm_kcalloc() and assigns it directly to this global
structure. When a device is unbound, its device-managed memory is
automatically freed, leaving asus_wmi_chip_info.info as a dangling pointer.
Furthermore, if multiple WMI devices are probed sequentially, each probe
overwrites the same global pointer, forcing all registered hwmon instances
to reference the channel information of the most recently probed device.

While it is unlikely if not impossible that multiple WMI devices of the same
kind exist, modifying a global static data structure is undesirable. Remove
the static data structure and allocate it as part of struct asus_wmi_sensors
to avoid the potential problem.

Fixes: 548820e21ce1 ("hwmon: (asus_wmi_sensors) Support X370 Asus WMI.")
Cc: stable@vger.kernel.org
Cc: Ed Brindley <kernel@maidavale.org>
Cc: Denis Pauk <pauk.denis@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus_wmi_sensors.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/asus_wmi_sensors.c b/drivers/hwmon/asus_wmi_sensors.c
index c2dd7ff882f24..502996e97cf14 100644
--- a/drivers/hwmon/asus_wmi_sensors.c
+++ b/drivers/hwmon/asus_wmi_sensors.c
@@ -164,6 +164,7 @@ struct asus_wmi_wmi_info {
 
 struct asus_wmi_sensors {
 	struct asus_wmi_wmi_info wmi;
+	struct hwmon_chip_info chip_info;
 	/* lock access to internal cache */
 	struct mutex lock;
 };
@@ -496,11 +497,6 @@ static const struct hwmon_ops asus_wmi_hwmon_ops = {
 	.read_string = asus_wmi_hwmon_read_string,
 };
 
-static struct hwmon_chip_info asus_wmi_chip_info = {
-	.ops = &asus_wmi_hwmon_ops,
-	.info = NULL,
-};
-
 static int asus_wmi_configure_sensor_setup(struct device *dev,
 					   struct asus_wmi_sensors *sensor_data)
 {
@@ -508,7 +504,7 @@ static int asus_wmi_configure_sensor_setup(struct device *dev,
 	struct hwmon_channel_info *asus_wmi_hwmon_chan;
 	int nr_count[hwmon_max] = {}, nr_types = 0;
 	struct asus_wmi_sensor_info *temp_sensor;
-	const struct hwmon_chip_info *chip_info;
+	struct hwmon_chip_info *chip_info;
 	enum hwmon_sensor_types type;
 	struct device *hwdev;
 	int i, idx;
@@ -549,8 +545,9 @@ static int asus_wmi_configure_sensor_setup(struct device *dev,
 	if (!ptr_asus_wmi_ci)
 		return -ENOMEM;
 
-	asus_wmi_chip_info.info = ptr_asus_wmi_ci;
-	chip_info = &asus_wmi_chip_info;
+	chip_info = &sensor_data->chip_info;
+	chip_info->ops = &asus_wmi_hwmon_ops;
+	chip_info->info = ptr_asus_wmi_ci;
 
 	sensor_data->wmi.info_by_id = devm_kcalloc(dev, sensor_data->wmi.sensor_count,
 						   sizeof(*sensor_data->wmi.info_by_id),
-- 
2.53.0



