Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023595;
	b=JLVG3MAxuvMzVdx0NJegnkYZmvLp9cS7Yq4azby+47/+W2aNsh7Q7Z1COlf2V6+3ajcS
	 2ntZ8WJISZaAXs8NNHkOJIQuanLUgniqD2eJUTbv+9yhyPAOIlaBWYSRLNEpjEJKW7afx
	 fwwsXhbb6VEJmmZ9UkBcfedkGnvfQP+vFVcSzfi3FKtwlLvXFB8l8miPJ1gyyvFgnzc0v
	 /dhf8E69skGt07DVRkauCYKGGGw1ZucJIHgA6VlLT1nylu/mXydx5xPr3QEl2YJtSeRYY
	 noqQpMCfHFjXIViGrfLbp8iuLkn9hADmPlsHa0jbRk22oNZSKGzCsZ76OUR4pkYWqdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FadU00Q78autfYAhq+fNJbOUosLAWvE78zlOy0xwIhE=;
	b=EAQHe5NGFFNvbxp7ZmuGuVJZL6ODqsSf9hmLsrI5F/Fs1LcvYm2JVsFr4K6Pk/Gq0Enn
	 bTVzzCsxHlWe8WfUkxfPPCa+58O6JzSmC9rgvCP3JkjmGqw890TfzTMHOqdJDHWw1/bgm
	 6stuBILyveHDR2GT4oKzdyUlEEBb7vGIhxR0tqZJqGYRPYWMeTLheSnKOsYMQa7rKi9J6
	 VeGbScsxzx/btnIyQfxkivQO8r5+BS7Gs/MK3GS1wPuejxQwYAmT17yuPTD1ZhVeiK2jx
	 Uph5RsYKDR6z1es70wK6t6+J7deiGHJbrPHkGe+AIlirMNYZG4i5+FucHsvPhQkgZsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YV6cuDkh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E51606A32A;
	Wed, 18 Nov 2026 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YV6cuDkh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934CA1F000C4;
	Wed, 18 Nov 2026 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023595;
	bh=FadU00Q78autfYAhq+fNJbOUosLAWvE78zlOy0xwIhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YV6cuDkhQdEEoXPAt+cz752akfhlX0xezIV0w4gxFbhzc3pqLIKhx9uDSwoJ3BhhW
	 Bn/cZJ+zdNDcJsmzYu+w5H8+FJ5SQ0MU9pFr2VkAsh+hbflw/WC9Zk1mv6vr9o8c00
	 kdvgJ9Hpsn2VA2M3JsMJkEEV/AfGLr2SE93v8fMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0423/2151] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118150137.465410481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 46577d36611953d1b99e86493289cfc824116ad2 ]

In acpi_video_dev_unregister_backlight(), the sysfs interface of the
cooling class device may access the brightness object under the
backlight device's ACPI companion, so that object cannot be freed
before unregistering the cooling class device.

Adjust the code to take that into account.

Fixes: 67b662e189f4 ("ACPI / video: seperate backlight control and event interface")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Fixed the Fixes: tag ]
Link: https://patch.msgid.link/3429468.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index be8e7e18abcab..1d56b42aef669 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1841,6 +1841,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
 static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device)
 {
+	if (device->cooling_dev) {
+		sysfs_remove_link(&device->dev->dev.kobj, "thermal_cooling");
+		sysfs_remove_link(&device->cooling_dev->device.kobj, "device");
+		thermal_cooling_device_unregister(device->cooling_dev);
+		device->cooling_dev = NULL;
+	}
 	if (device->backlight) {
 		backlight_device_unregister(device->backlight);
 		device->backlight = NULL;
@@ -1850,12 +1856,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
 		kfree(device->brightness);
 		device->brightness = NULL;
 	}
-	if (device->cooling_dev) {
-		sysfs_remove_link(&device->dev->dev.kobj, "thermal_cooling");
-		sysfs_remove_link(&device->cooling_dev->device.kobj, "device");
-		thermal_cooling_device_unregister(device->cooling_dev);
-		device->cooling_dev = NULL;
-	}
 }
 
 static int acpi_video_bus_unregister_backlight(struct acpi_video_bus *video)
-- 
2.53.0



