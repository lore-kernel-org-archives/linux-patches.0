Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029539;
	b=oiWbBZQFlKwAr63LFS8b1YTnTCO02BbVEXJERIuVVMiSL8dzwoOK6iGqJGmkcvZdtdi4
	 NyWjkVxPIp+eYtTz271k3vc8uFTzPvxhddrvcHHpXDbVrqy2bxhm0slBkuQnt98qqVE6Z
	 8VFeWuXEBpVOcTJGxHPTI0FXjlCU5SVvalMqL4lNiYltU8SC7q8XCcS2s6cs3IW4nzYMG
	 CFVSpiM8qfVSjWjnSLUc2mvwz/EwBUsTKs0MrROJwu5CNvSE+4OVvSvz1Otvl18oXPmpF
	 Y03ZE+ehBEpup8PjuIeFVb+8Skkx2oO1KWt3ep2pZ1lU7Pzwew0QSF8N+9tTL3skFlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oaw8VN7k2GwZkok/Rk3tbIFgPltGgAfG4RtYQsWfQA4=;
	b=XX5/LeLTxZObFjhPT6pMz8TFjOFS4s8IkDtQxInxEF99cQdMPYaQ5o+uS5C6VVkQ4Djt
	 gCb7v3EC6c2gMeLMcaZsk+E9gXcKyQ2NKtUFO9G00omm3iz/P/MdUz6CjwbefxrScwOkE
	 WQKKV8/nk3dv9fDeemLgpucwHTXvHC+9RKllM/SBbuNv42iAnNoCSPAV9foY+qiZ0kEaM
	 63L59DciHVlKP6IYJ5q5LZQ007WikkJX4CIfyrmoaqjDLDW24jYHKrXqUUSK7frP9jPSb
	 DKTAmJ9rXHIe6OSjWYrgaV2ejL0x/dF8R1ReqOzkwdDAhuM9QMLIyh1TDdA/cNBoPdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmNEQ11T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3EE606A325;
	Wed, 18 Nov 2026 19:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmNEQ11T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195A11F000C4;
	Wed, 18 Nov 2026 19:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029539;
	bh=oaw8VN7k2GwZkok/Rk3tbIFgPltGgAfG4RtYQsWfQA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmNEQ11TN68ZpkTngzY0z0uGysfVjIF6BdQDjsa8D/DduMNhK3iRRVBfEHjOtRi22
	 rS8yOsGMEl55Z9/NlXdMHyk5sl7DNWw90DyKO9UTPLPnCtf7M3jaVPCNsX/0A1ywEp
	 YQS+IaFL588XOK67dpV2qIIC8LZxnULL+Gr7ip7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0387/1756] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:41:54 +0100
Message-ID: <20261118150024.021303938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 496f3b585bca2..a476b7397d23f 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1828,6 +1828,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
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
@@ -1837,12 +1843,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
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



