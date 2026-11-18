Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046320;
	b=23mR35AyQxb59hUxFjS+4Ojz3OSJFMV+MR/H3k+F6ln+8uvuLVPnxnNK5LzpU8HGFmpt
	 qgeMQMI7aK0Ol458PO4ZhAfufwrpHNYodkgA3WAHdXfeFZQlqyGGw3MCreAZwTgG8hp3h
	 exa5xDgJsFcI0DGOthwKM5fLzpN8N8ug0YFyTuVy5Z6ZPr5esIoit5Xh8LGTykF3SQ+NB
	 uOlk3COaiSPh5L7jfs+brIHQMP1uWA7B+wejlpS/v7sxF1T2X7SjryMVoBzXYkjXgsUPG
	 FAEuPbcy+7vsDAd6FwolcJR3cLUUpQrZwbAXMfEiZbLx78LH1QhiS/gXs97L/R4Cclg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nhBdlNYTIeWkaWjrBrnm4BaWkFIzFRguPm/4ZTC/Kk=;
	b=epT1AbrcaP65ALhQ3fe5V4apwN5t8K1fLt/7LlbsHjNN6Fe8k41PVfyY7qxhiPnb57WD
	 38tGm3snKUUn7Q9Bx7KoFceUqTcD7wOd4NMbLCRKTAWvVSlvv4vIvhLkXdCZaEZOw9mi/
	 5zUaXLQg7DDHScLDpMn04FkgqwSDLXdo5H9fwSQnx++L6GMppCLVFovFRNK74wcy1V1Q7
	 GObFzPsO7/4+hFUCHkW0YvZ1xAzCr/hhNpRLzoX3On/4l2RVL7lJAUkmfvNAqmN3TA650
	 rDqTiEWFMN59EHW71D5UDgA6Ns9mbGWmeFaclQ9MddqZhejRYT4LTs6uWBO7tW40zvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVVOcJ50;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17831606A31C;
	Wed, 18 Nov 2026 23:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVVOcJ50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC1F1F000C4;
	Wed, 18 Nov 2026 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046319;
	bh=5nhBdlNYTIeWkaWjrBrnm4BaWkFIzFRguPm/4ZTC/Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVVOcJ50RirjqljZ3Ku9m+XoCc8OMoG76+z83JWwuZAcuzNAcidMrKkoWW0jdtvwU
	 50fSSyLnKPubTqo30bJCfTby0fMq7m7hvoih7k6Rzq/JYYNmjZYRWfw953x39paJig
	 OIg9DNY9hn2GwRc17DykgFctG638i/hrdbtLfNWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Brindley <kernel@maidavale.org>,
	Denis Pauk <pauk.denis@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1238/2857] hwmon: (asus_wmi_sensors) Avoid global struct mutation
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118150246.124365799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



