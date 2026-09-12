Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22729415B7B;
	Sat, 12 Sep 2026 09:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205508; cv=none; b=Hfd82ovm1h+zmjSsxRP7sVoGzVtrzSmzUgmPvrJp6AfGwyoIjhLRbhbx965PYL4YCJYqH/Devp71O20EMidFeMg70CakGS6pk9LJuFYh6GqB1u6jTs61qP8hgkPwebFS48amceweEQpqACyxvK0RmSCuUXhiNcGuClUItm65LpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205508; c=relaxed/simple;
	bh=ViNi0K25XsNqWR17hI4xg2Zq29EGB4zP+L9UOSvreG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rixXIfjshGGJ2/dYquGura3O0pSeuoL6YtWlVt+qruPHBM0p3mxnrXdb2SmiPbZqdgoGUhcP9XjBGQxSYO9qMHuu5wV4FM0oSW9z79GpAoVMH58vv0AJC+rAdTjw1+4J/rUHLaUdIW3WWboQ9GU12y1RB0gDIaIlwE6GG3rgxkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2SYBBks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2SYBBks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289CE1F000FF;
	Sat, 12 Sep 2026 09:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205507;
	bh=WwzeFj08ATo+LmnIIznS4HzRpcjrjYYkCg09Kw8Ko8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2SYBBks7Ak983WxMuQhZS+CsJANSDpr8u0BsaEVWrsvipyyB/3Swv82PUmEFv6NU
	 bVlDW16ZfjsDF0OhRad2B5bP+VQ03fTNqqf2i7xyQhUnFEKxfQ6dBjqda4ZeRWZT6i
	 fccy0fSmciXsHIrsavz/RN4d/q2gyrJI48wPonmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0017/1518] platform/x86: intel_sar: Check ACPI_HANDLE() against NULL
Date: Sat, 12 Sep 2026 08:36:26 +0200
Message-ID: <20260912065623.808210819@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 2765f16c12af7c2533763e46b8113b727354012d ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_HANDLE() check against NULL to the
platform/x86 intel_sar driver.

Fixes: dcfbd31ef4bc ("platform/x86: BIOS SAR driver for Intel M.2 Modem")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/14023870.uLZWGnKmhe@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

For this stable dependency, also convert the existing allocations in
parse_package() and sar_probe() to kmalloc_objs() and kzalloc_obj().
Both helpers are already available in this tree and retain the same
allocation sizes and GFP_KERNEL flags. This makes intel_sar.c match
the parent of 30c906cff490 ("platform/x86: int1092: Fix potential
memory leak in sar_probe()"), allowing that target to apply unchanged.
No new functions or allocation helpers are introduced.

Stable-dep-of: 30c906cff490 ("platform/x86: int1092: Fix potential memory leak in sar_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/int1092/intel_sar.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -91,8 +91,8 @@ static acpi_status parse_package(struct
 	    item->package.count <= data->total_dev_mode)
 		return AE_ERROR;
 
-	data->device_mode_info = kmalloc_array(data->total_dev_mode,
-					       sizeof(struct wwan_device_mode_info), GFP_KERNEL);
+	data->device_mode_info = kmalloc_objs(struct wwan_device_mode_info,
+					      data->total_dev_mode);
 	if (!data->device_mode_info)
 		return AE_ERROR;
 
@@ -245,15 +245,20 @@ static void sar_get_data(int reg, struct
 static int sar_probe(struct platform_device *device)
 {
 	struct wwan_sar_context *context;
+	acpi_handle handle;
 	int reg;
 	int result;
 
-	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	handle = ACPI_HANDLE(&device->dev);
+	if (!handle)
+		return -ENODEV;
+
+	context = kzalloc_obj(*context);
 	if (!context)
 		return -ENOMEM;
 
 	context->sar_device = device;
-	context->handle = ACPI_HANDLE(&device->dev);
+	context->handle = handle;
 	dev_set_drvdata(&device->dev, context);
 
 	result = guid_parse(SAR_DSM_UUID, &context->guid);


