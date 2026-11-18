Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039706;
	b=mbPXVSYsw+ihbRKz8E0w4+n/sVt1bpyXbjw4nFYv0iXHjs28GDdDIckatiwjPE9SJEN9
	 TJTdlvyK5vZuf7xFkKTNU/adIv8A5RqXvBhBND0mzx0Axaz8lsfTflEv57PSYPjSOYBo5
	 IRBPjA7BOGBNbwPQBdgsyZpuF/T8USI+bDb2lg+j8a6zBrFwXk9b4PVh6cIG12fzeta6u
	 mPyzyV5+3M2Kbi0pugdhstdbP/2Qdvf3D1mWqGQPfBPJyZ0/23BXvjdkjmYquLplalNTN
	 n+8AxYLxb5q+GfrP2yBd2NiXwp1Ou+6tVsadh4TivEVf5/0qJ7EABZ/Eyla7VOd9g0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zMwzdIGDL0QaByPh+OAY/w/1BRYSSHo16K8BwzQ6oL4=;
	b=R2XZJDjErdUHf/H6VM0t7+1b3hHyEzF6ZKWgAHAbQJSHZd3FW8sCT9hHjAdtQ+2oeUCi
	 hPxLCTRY7xvhUgX43lgJbpoVbFCvj24N+QwWxsklrgMkv9wzhfPNRB5TuFPAjUaGi2N6r
	 iRKOWyRim6q+7W6JKEWmCcFp5gxd8BTztqAnaYrtKcI+RPKR57iIAKH54tu9bJiXvFqMT
	 tVsT1nUB1MSP9xL0EUaZA+U8r2SBVFknz7Ka4wtQ1RCPf/twPa40f3nB0Nwkcw+BkNImY
	 ZCHOluAA6V7gKRD6gimXg/w8DRm9+7Wh8p5VjISBK2Om4yPrvrvYRohCEih/pkFO1jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+XhfaVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A89606A320;
	Wed, 18 Nov 2026 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+XhfaVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E68F1F000C4;
	Wed, 18 Nov 2026 22:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039706;
	bh=zMwzdIGDL0QaByPh+OAY/w/1BRYSSHo16K8BwzQ6oL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+XhfaVrrxJL+PwFwake2kti6aoFP7tNUtpMRgC7wWGFheZKIVBB8RW8qrECoVntN
	 L3WrV6UvEVj1JawFJLT81BXrT2XiD8FxVB/pwm6PwLKMKMijyyaDHiotFuJbhOrCVG
	 II4EK0bGR/uhHZagFl7lBkjCmxuLVscmrMTBrsp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2197/3318] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:46:59 +0100
Message-ID: <20261118150427.849793789@linuxfoundation.org>
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
index 841db33e94756..72588e65be053 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1834,6 +1834,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
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
@@ -1843,12 +1849,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
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



