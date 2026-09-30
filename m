Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5285A51C044;
	Wed, 30 Sep 2026 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789756; cv=none; b=hfkpAau8Pi7Qu0nbjn0LY0H/TeKuf9VdDuHrX2hTSQA/xcaeZnHi1qyRF1YixiIoqty2e5O7X6bfDJEywdjdJUvl/YqxREkhyfLEBVGfCJkppDQVx7MnCOW81i9ftmMjBQgHNyCmCN2BeV2aEfK7PcZz05UjdJ1bluMGhZXT2n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789756; c=relaxed/simple;
	bh=rOGhWwUPPJRtl4dYhsUdU0NRKLtaNPEEnUkCBsWFfSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5O1cWTLdEmxuq4DLJoVanLh2lM/BzAQ/ur0W3OP2ygExNCRM8n/soeKOCqv3UOC8p2KTgKi3njJLhxhdx2Wmjqi2TzYvCusvAcod6lyCSYi3mtvjKY1gDKq+Zzohv385hh002pDBWslvjTHLjF3Sk4BJY4zbPGEjpfZjv4GlTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WV+CurkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WV+CurkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625211F0089A;
	Wed, 30 Sep 2026 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789754;
	bh=JSOl3CYbRPt5mD8LeeIT3kqoJRlSn7BtBfiaDsYk2Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WV+CurkIMu5tFBvbxkY/CfGbhAr3R1sTI0/Qggq3iGpKn8/647P2/HEUYYbPPk28W
	 NwF5hnv9yniQyBnCvrE6TI+irjet75kyYuSyQ/0lxK28H0GIQZbz94/GqOVvGqtUYK
	 tuKhnMDz8u1rk43gUyFJ7s5EqOEIXXDvXK8zOhEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 587/877] platform/x86: intel_sar: Check ACPI_HANDLE() against NULL
Date: Wed, 30 Sep 2026 17:24:58 +0200
Message-ID: <20260930152427.317002931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


