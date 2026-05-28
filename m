Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6627632ABC0;
	Thu, 28 May 2026 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999072; cv=none; b=olKzCksDGFLZ1OjbcwMYH8bt5ewDTktZKOHpm5xPv6Cp6CTtcI7y1g3rgW5Bx4/ai6XrAviD+qvAopbR59MREHuEVXkyobnfHVZXJDYNTd883kj3nf5BUtdiPIB3Fl2AmOWH3TIZvQ6jJlyqstyEpfoX/7Xf6kxS0xDgzmZg+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999072; c=relaxed/simple;
	bh=glnJy5qG8ATBCHHszGK5pN3wUxT7Uq+RhCbJHZO15eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zysw70PuGBQJvuCQr787zC3pFk+/l+bLeLnqZfQ7nRTmvlJH4yee1F4+lPTn2yUpIUM30dofLNxKq4Vhanp0lEvEM4uH+uly/jFnfwzpIP3DY9kH5vSD9THjJAjcIdKdAkxEaYGpyRrUbYe16csaYEeW/13NhOVgcrVgJeazzNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Njw0SLDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Njw0SLDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889A31F000E9;
	Thu, 28 May 2026 20:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999071;
	bh=tPKPoXaGwo5lfbfs3CBnviK9XZ+m6rJ5AOZjiadR13I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Njw0SLDGk0OFkATLZWm3fpU4qiXyn1PpINLkmBEe0LNpxkN2q8jFa12rD05Cv+l5T
	 +r5wfkwiSjD/4RFZZawtd06TIfPLU1xVP6YFze7XB98V+Vbkdt+ud20G36cpbyWee0
	 PiNCeALqq0gu64zBP5RNhDf/b71md8ecorQ+21Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 391/461] platform/x86: intel_sar: Check ACPI_HANDLE() against NULL
Date: Thu, 28 May 2026 21:48:40 +0200
Message-ID: <20260528194658.779875420@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int1092/intel_sar.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/int1092/intel_sar.c b/drivers/platform/x86/intel/int1092/intel_sar.c
index 88822023a1490..849f7b415c1e5 100644
--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -245,15 +245,20 @@ static void sar_get_data(int reg, struct wwan_sar_context *context)
 static int sar_probe(struct platform_device *device)
 {
 	struct wwan_sar_context *context;
+	acpi_handle handle;
 	int reg;
 	int result;
 
+	handle = ACPI_HANDLE(&device->dev);
+	if (!handle)
+		return -ENODEV;
+
 	context = kzalloc_obj(*context);
 	if (!context)
 		return -ENOMEM;
 
 	context->sar_device = device;
-	context->handle = ACPI_HANDLE(&device->dev);
+	context->handle = handle;
 	dev_set_drvdata(&device->dev, context);
 
 	result = guid_parse(SAR_DSM_UUID, &context->guid);
-- 
2.53.0



