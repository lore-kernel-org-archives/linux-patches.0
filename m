Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037611;
	b=dP06ZIYPbGAGWq+X98zqzK/VgNb9mOpWNhPJiFG+WddYVxDv8iVmn6L8h+a8H6/fkRMk
	 k8iKvadbT6vsfrEyxtM+Xgb14y972e2oS5xb4DRXg4xbtPn/s4Whh2T2Hb0Ibj1EgY7x/
	 pD/p52YJhVwhFTFs4FoJ+k0DxHf15DiVh1NClpkHffyf0nhDh9rKQa5QtU3JpA/4Tvbvb
	 KovGa0mB6KTun6080D6DIAAfH6fd/0NRgWypys8lkDczjUppERIKp65cUGiFLMighn/Qc
	 LdW87KCSHRcnzpPKpBMKKzaao4r32nZDoF18IecNxJ9PF3V1oOgAgaphHcOTPwlDJzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JcSo/svSMkuHKmFofc8p0FsY3Q2XUCVAzTwD3YwMrtU=;
	b=1byc/zGGXoLNWLqx0w266aM3UsiUjISn75Q5pyDzvMc2HbG940XUR/+oqWvI2HMmo+NT
	 FF791GUw00CEIp1PX8doREZjSwhwwUZ2tA3bxpp6mm+yBQh3zrBmq+p5FYRauau9iYwb8
	 BkbgKnqZXQcQojBBbmAW2hcfKl4/m6U+ZFDdU6ayeu4h0ES+rcmLHgpyaduq3Suhoak70
	 70WkY7QPLCzlkzcHpHQo113ADCXPY7msXhHDM6Ag7ljNon0dQB+b/B8zbvTuHYzMnFYcE
	 /shZBE3+Q1HUSZce4ovADH4Wj012uHLsFz+YkhPQNxa55O1YXiQhD+duwrHyhzl3K3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbrJ05NL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7F606A320;
	Wed, 18 Nov 2026 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbrJ05NL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89EE1F000C4;
	Wed, 18 Nov 2026 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037611;
	bh=JcSo/svSMkuHKmFofc8p0FsY3Q2XUCVAzTwD3YwMrtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbrJ05NLwqqaJQw98dWzPVcgB85+ZYValTVTZkWtICaDTBbX+Ci0jwQBGZ5dLKjDA
	 SImy+8IMlNHr4Ctzp2zaJAEfd/Lko+9XcxKJipWPxtUjsbyv7UvaE3mUb7S03YrNlh
	 kCrLFEtuXtxS0zkVZhbNlVvkcy9bYrJXwoQ/SVWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Brindley <kernel@maidavale.org>,
	Denis Pauk <pauk.denis@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1457/3318] hwmon: (asus_wmi_sensors) Avoid global struct mutation
Date: Wed, 18 Nov 2026 15:34:39 +0100
Message-ID: <20261118150404.602812368@linuxfoundation.org>
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
index 6e8a908171f0a..aa8af891bf9af 100644
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



