Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887CA47DD63;
	Sat, 12 Sep 2026 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219387; cv=none; b=e+jqmw5/HV9iXsFqYZFfIRkBTSiIefRgH9/V8UGONJlH+LqMO4L3utCBJxGT0CHolVn2143jecfYfkm+4bA7T5IZEqpsJjHSjYVnfPFFYiXgB1/+AZW1A0OnTlsk7+siPEl+/V/5jTCIxFxLvlnscEq8o1tU9yLbCyF6W8gFcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219387; c=relaxed/simple;
	bh=EfFDSuuYFMHsM4YpfvQ2qQF5zT4xN2zgmlvV1+ASEaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLBRprTDQqKXZZJGPS9m0395q/IUQJXfcEE9fK+1uBID1Ih4K0aw0V6eI5/Yi7i8HFSioF7VtyJqoVodFARnKmFQAY4WSxF6mr4YLKdZgyInKyv90QT8jntn4inVNoIMDK9t1NT4hknnQkhRpRtdChDUC7eFP2IQImRtEBmXcV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5+5PADH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5+5PADH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A86D1F000FF;
	Sat, 12 Sep 2026 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219386;
	bh=be4ufaYX8rrcB6x8yRg3MZnu6LbZ6T4vlbRV9eR3NcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5+5PADHdIPj491ZN8TlpgVRrBDtkbPwOOes+rWq8HAy7MGFeUtt7dgk0Ar7GUsBv
	 uHkqT1fMiYG4caGYrNEDjxBNml3+/6J9uoe42oDXECISGYNnMSsJpmx3Za6QiV2feH
	 itaXwMMK3EydSt5I5axq1562VfOuDuUTAcTwHHLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1338/1376] platform/x86: lg-laptop: Check ACPI_COMPANION() against NULL
Date: Sat, 12 Sep 2026 09:02:44 +0200
Message-ID: <20260912065637.351525001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7e169326c2263ebc4878baae536c956fa3118eff ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
platform/x86 lg-laptop driver.

Fixes: 2d9cb20610f7 ("platform/x86: lg-laptop: Convert ACPI driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/3706551.iIbC2pHGDl@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 0a5c8f0471823..f4e43e09cbe4e 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -755,12 +755,11 @@ static void lg_laptop_remove_address_space_handler(void *data)
 
 static int acpi_probe(struct platform_device *pdev)
 {
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 	struct platform_device_info pdev_info = {
-		.fwnode = acpi_fwnode_handle(device),
 		.name = PLATFORM_NAME,
 		.id = PLATFORM_DEVID_NONE,
 	};
+	struct acpi_device *device;
 	acpi_status status;
 	int ret;
 	const char *product;
@@ -769,6 +768,12 @@ static int acpi_probe(struct platform_device *pdev)
 	if (pf_device)
 		return 0;
 
+	device = ACPI_COMPANION(&pdev->dev);
+	if (!device)
+		return -ENODEV;
+
+	pdev_info.fwnode = acpi_fwnode_handle(device),
+
 	status = acpi_install_address_space_handler(device->handle, LG_ADDRESS_SPACE_ID,
 						    &lg_laptop_address_space_handler,
 						    NULL, &pdev->dev);
-- 
2.53.0



