Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6FA2BEC43;
	Sat, 12 Sep 2026 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212594; cv=none; b=YQAipX5vtFnCjcrHZYZn5/fshHs5L5+1H7WlyewoVlPS0MkQwES8XYdVyTdOPlwNll6JFB4XaF0+RcbyLvYnbgJ/Ukk2aiX0T1YAEmqsPHCtdoXWNWjt74C9LBLQe4lrSJhmPccMEF2mdLSzegeJi91gT88aEkWk3rvb+bh/ca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212594; c=relaxed/simple;
	bh=hp1bKZcs/PVHO06FVUoepwpbSFYrNnooOmboOmCSwXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyTh84RcLTwxFtcVRGzkjE9yiGgA3rpmNdB4ImbLQFI3NZAO8k3XKYoexsmnSZPLR00/Qy6lZuzppcrKogYDE25/gnvZJooUO7/iIoesJ1xWQeM3da5g92IBDub45X0a6PtYqSseOijoVckQf/ulTT7+zzzhmoQTH9iK5gF189g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T97dfJok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T97dfJok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9A21F000FF;
	Sat, 12 Sep 2026 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212593;
	bh=kzZVGjubndx9pbrYVLK4vvTvLUJsxlqPFteF/kT2QYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T97dfJokhaIElfHT67v2X9Hrw17zRRm+8Q59/a0fUWlENMx1V4oCfaVAZStsx+Ux+
	 SAd8Pq3cjZbD/DzEf2Q2YDtngPUGpEKxJ1Ms+J70pxldSSJFUrfM3NDpOMp8KmEDKY
	 ZU0GcMaoY7tfiKextVR7LCy31vvQj/rRyoG6eIEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1466/1518] platform/x86: lg-laptop: Check ACPI_COMPANION() against NULL
Date: Sat, 12 Sep 2026 09:00:35 +0200
Message-ID: <20260912065656.718388330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



