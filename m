Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016184;
	b=zEMD2vGkcfiFrCkcBiG4ZvC2qv+1r5m7Yat+i0+VyFG0OUySF5XPO9+t0z243/nBQQxk
	 EdfTuHtoPrHp/Dpe7AyWNf4/m3CmvLcE3Ab78lh+MmPu+VVJL0tMLSOOutRCMwWMfwTeb
	 tQmNAi5ixogxwIRXE5No0ikaOC7EBaNS8nFdAg72pOD8oC5C8nzWYzQE+3fsDV1zos729
	 8d9b/A77awMJUiIjx4js6ihrRwfu6dVoOnCaEvPGDh0ZE2o2ZiVhydqMe/ElCGcs3bzJt
	 AloFfE+dMtev6ioXc0aIbWQ8HknfdPXRiv+8qm9QURxj/JQ9VWdcHLpb09hlzlYRrLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hDMijC5g44TnG49eBZ9INOUM5RFBAtlQU+ZodI4TB/k=;
	b=Xt+RUCd7FLnM3ih9c/CJiGj/JKhLC+L2w9sRF9i1lLAEXUtzr8SHKVYoA09cYQxJE3Ui
	 U/HxVhYeP6Wt99j95j8lVDwLadqqUBdoUof74EpST4DS2xBn8PzbVIy4kad9knhAFEuiq
	 f4cg8TssGCCjTDlWy2PpLT/9Q3xUm44ddG2Xzo+DbYcefu9cIF5bNRh07sEi5Kw1xYzTp
	 O9cww9cnfP+i3u0Gqyafb0P1eAEZkzcuhoB80QVqypL7RYimIbyihkFg9lSBCaqmhYH1L
	 uqf0vziVUnAPwkgE4kfp76DokP+0gcNdAjqyhH/3QaOTVN1NI2XRUOAHOdgAdfwsnzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqS4+lp5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3081A606A31C;
	Wed, 18 Nov 2026 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqS4+lp5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8376F1F000C4;
	Wed, 18 Nov 2026 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016184;
	bh=hDMijC5g44TnG49eBZ9INOUM5RFBAtlQU+ZodI4TB/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqS4+lp5SEpecSJVuQ3UjeIuewvkwj1rENWyts2zfE9q/aF70KP2e3Dv1dlH+iEJe
	 P/SfwWt34dodNdpoIRdxK6DnUjnbzLZBSXX0+SGYFhaOhtU7IklSnXoo4tG8WkKhgW
	 OcSiLHiRYMvoOQ6Lwhd8pvvX3tysHMsk/9mn3UcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0440/2651] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:28:00 +0100
Message-ID: <20261118150303.663153939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 4d6fd9f6e9ada..6cfe390411c1d 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1825,6 +1825,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
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
@@ -1834,12 +1840,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
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



