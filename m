Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C52E7379;
	Sat, 30 May 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162561; cv=none; b=ANyt1A5L6fEapp75rA64d2N4Le+g4CQHNJ3/HK3RA8HWyHZzOogCuMvRBp2L78qH3O5xwqGue3d5kGtMqQ+TI6XDoc3wwkZRO0JxBEvrWnP00IFzkn9tSk0LKe5rNeFs6WDuUU5q95VJ7MnI/CN1jyjR0VaomrV4BpMIvDRP/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162561; c=relaxed/simple;
	bh=m6v+MJDrM2RIqGx9wFmLPTUdixdn8VT/Lh7XTcme8iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dENwnD7obR2kLUczLRlVJgJzYEOsVxp1egQr3Igu7zK+rfEa3feZ7UT76l4oH1qFkZB0/oy8ruXQ6b0l/6i3Wa+bRfGxnpW5nFliIgxSbwwt6EDlAUmjyngT3K9BiVdbYhD8dwu2DIvF8bL4o4kPMK7NKeEnjsKuwC5uURmbhgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKQl0Lr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKQl0Lr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F9C1F00893;
	Sat, 30 May 2026 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162560;
	bh=wSRQAvjbTqZtnv27B1OykwDfHUZmM2UP93ZgUJ9rpOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKQl0Lr2siwbb65AbQp6Sg8KvAE+P9x5BiJp1pNh0wjZn0maAalHSO3E7/+uxP/kT
	 05bsWSoTDpSC8MBQZviWAGdLMUTraMmxKRyEdWQUHiPqS7bCFR3bzHQhK2+N74hdMt
	 fGdhVOw46MN0ojJeWuSjNu0QlSZFY0Xxn1paCyis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 959/969] platform/x86: intel-vbtn: Check ACPI_HANDLE() against NULL
Date: Sat, 30 May 2026 18:08:03 +0200
Message-ID: <20260530160327.251531469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit a9f305c5a355efeb240d406d378491d9eec02d07 ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_HANDLE() check against NULL to the
platform/x86 intel-vbtn driver.

Fixes: 26173179fae1 ("platform/x86: intel-vbtn: Eval VBDL after registering our notifier")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/3426431.aeNJFYEL58@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vbtn.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/vbtn.c b/drivers/platform/x86/intel/vbtn.c
index 224139006a433..1b590bbbd8f8f 100644
--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
@@ -272,12 +272,16 @@ static bool intel_vbtn_has_switches(acpi_handle handle, bool dual_accel)
 
 static int intel_vbtn_probe(struct platform_device *device)
 {
-	acpi_handle handle = ACPI_HANDLE(&device->dev);
 	bool dual_accel, has_buttons, has_switches;
 	struct intel_vbtn_priv *priv;
+	acpi_handle handle;
 	acpi_status status;
 	int err;
 
+	handle = ACPI_HANDLE(&device->dev);
+	if (!handle)
+		return -ENODEV;
+
 	dual_accel = dual_accel_detect();
 	has_buttons = acpi_has_method(handle, "VBDL");
 	has_switches = intel_vbtn_has_switches(handle, dual_accel);
-- 
2.53.0



