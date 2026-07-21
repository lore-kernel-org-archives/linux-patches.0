Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C9C434E2C;
	Tue, 21 Jul 2026 20:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664261; cv=none; b=h+idLcGS+oSdIoSQGt5Cwu2g6QXB0kiQ1o+2nSudyNH3YB2KlUyJ86852zpPpQm+IsxcXPCFzi9gRnhFYcy5xUCMWDyWcetg7QWZ7oZ5tnspY8myUDBTRl4lzn8/HaSkG3UWvqB0bvJcJMHH80lcJZsc6VcoMngmvUDSaWaDciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664261; c=relaxed/simple;
	bh=eAe0VnRovFSoEOgRtbghumDJTZJ/jJqmx5YUWH2Ce4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSc21iBESzkp0FGS58I2Dr7Qbrwck2NYeItkDPQbOYunX56AwDMIzIQ7Y5FCNltD5L5HyCVF0lufPtT2v0Bvl08ZvQ7ISEFOxPljgPM1K3L1m3EAghb3BflZ6IlJ3mM49IZ3siMxh+TNsji6dhbw9S4OaolBHwwZnmyj79V7J5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SyMaq49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SyMaq49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8541F000E9;
	Tue, 21 Jul 2026 20:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664260;
	bh=Zr4fRuAGq8iObImuqQhv9Et/BbMisOdL5rUdNoTscQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SyMaq495PbmIkx6+2kU3dDerix1SIKvlpZw2cKBDMQw1Qv1qTLKwkM1jbw0+UUCE
	 oFxkv4Lb6o/oXTWzjDJgUHFwXpZuCox1+/vvvvhYEULAh71viEMKi44qA7VQd1ATGo
	 ahcdtDacrVIaK5z4G+T1LT6U/2pm7hItqrW7ge/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1133/1276] ACPI: driver: Check ACPI_COMPANION() against NULL during probe
Date: Tue, 21 Jul 2026 17:26:16 +0200
Message-ID: <20260721152511.350203165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit e4865a56d013e86e46ea6acea15bb6eae01898ff ]

Since every platform driver can be forced to match a device that doesn't
match its list of device IDs because of device_match_driver_override(),
platform drivers that rely on the existence of a device's ACPI companion
object should verify its presence.

Accordingly, add requisite ACPI_COMPANION() or ACPI_HANDLE() checks
against NULL to 13 platform drivers handling core ACPI devices.

Also change the value returned by the ACPI thermal zone driver when
the device's ACPI companion is not present to -ENODEV for consistency
with the other drivers.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/4516068.ejJDZkT8p0@rafael.j.wysocki
Cc: 7.0+ <stable@vger.kernel.org> # 7.0+
Stable-dep-of: 18a00ed0e718 ("ACPI: NFIT: core: Fix possible deadlock and missing notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ac.c            |    6 +++++-
 drivers/acpi/acpi_pad.c      |    6 +++++-
 drivers/acpi/acpi_tad.c      |    6 +++++-
 drivers/acpi/pfr_telemetry.c |    6 +++++-
 drivers/acpi/pfr_update.c    |    6 +++++-
 drivers/acpi/thermal.c       |    2 +-
 6 files changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -203,11 +203,15 @@ static const struct dmi_system_id ac_dmi
 
 static int acpi_ac_probe(struct platform_device *pdev)
 {
-	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 	struct power_supply_config psy_cfg = {};
+	struct acpi_device *adev;
 	struct acpi_ac *ac;
 	int result;
 
+	adev = ACPI_COMPANION(&pdev->dev);
+	if (!adev)
+		return -ENODEV;
+
 	ac = kzalloc(sizeof(struct acpi_ac), GFP_KERNEL);
 	if (!ac)
 		return -ENOMEM;
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -427,9 +427,13 @@ static void acpi_pad_notify(acpi_handle
 
 static int acpi_pad_probe(struct platform_device *pdev)
 {
-	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+	struct acpi_device *adev;
 	acpi_status status;
 
+	adev = ACPI_COMPANION(&pdev->dev);
+	if (!adev)
+		return -ENODEV;
+
 	strscpy(acpi_device_name(adev), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
 	strscpy(acpi_device_class(adev), ACPI_PROCESSOR_AGGREGATOR_CLASS);
 
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -588,12 +588,16 @@ static void acpi_tad_remove(struct platf
 static int acpi_tad_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_tad_driver_data *dd;
+	acpi_handle handle;
 	acpi_status status;
 	unsigned long long caps;
 	int ret;
 
+	handle = ACPI_HANDLE(dev);
+	if (!handle)
+		return -ENODEV;
+
 	ret = acpi_install_cmos_rtc_space_handler(handle);
 	if (ret < 0) {
 		dev_info(dev, "Unable to install space handler\n");
--- a/drivers/acpi/pfr_telemetry.c
+++ b/drivers/acpi/pfr_telemetry.c
@@ -363,10 +363,14 @@ static void pfrt_log_put_idx(void *data)
 
 static int acpi_pfrt_log_probe(struct platform_device *pdev)
 {
-	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
 	struct pfrt_log_device *pfrt_log_dev;
+	acpi_handle handle;
 	int ret;
 
+	handle = ACPI_HANDLE(&pdev->dev);
+	if (!handle)
+		return -ENODEV;
+
 	if (!acpi_has_method(handle, "_DSM")) {
 		dev_dbg(&pdev->dev, "Missing _DSM\n");
 		return -ENODEV;
--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -505,10 +505,14 @@ static void pfru_put_idx(void *data)
 
 static int acpi_pfru_probe(struct platform_device *pdev)
 {
-	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
 	struct pfru_device *pfru_dev;
+	acpi_handle handle;
 	int ret;
 
+	handle = ACPI_HANDLE(&pdev->dev);
+	if (!handle)
+		return -ENODEV;
+
 	if (!acpi_has_method(handle, "_DSM")) {
 		dev_dbg(&pdev->dev, "Missing _DSM\n");
 		return -ENODEV;
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -789,7 +789,7 @@ static int acpi_thermal_add(struct acpi_
 	int i;
 
 	if (!device)
-		return -EINVAL;
+		return -ENODEV;
 
 	tz = kzalloc(sizeof(struct acpi_thermal), GFP_KERNEL);
 	if (!tz)


