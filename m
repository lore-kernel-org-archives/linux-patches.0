Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ED917A30A;
	Thu, 28 May 2026 20:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001527; cv=none; b=NKlIEJE11WT9Fe/09XTp1VGSliFESvbR+WHi574XvivwsTIklL2h3q7B8og4BDGWvPyk9+R5upklOYJl9Lntm2VKj3JE67yfcJ3W7EAmOGxscVB9fnMXNPNA/N0FsIjsX3OOjcY3wAv4AHvQFyM7eymAcrgDCgqJ62dhpUqHka4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001527; c=relaxed/simple;
	bh=O3TPn3v8zK9DdB4cTcT1vNd2kvGTvQhQPiNY1QRaAK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDGgg+oqaoL5Ovv7YrsGNJwbLNg6cO4hxEcPrm8BWqv85kOExqBphxFCmP4dYjpL64d7wXKNmpiGY4HnGLAmD+CvPtzsPleGw/VW30O8DEm9PB+5GYguqBtWi12QhRru2UPgHcclkiZKR7W9UPtMWCHX0by9SdrhwWT9+DRfdxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GeVkwv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GeVkwv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78F31F000E9;
	Thu, 28 May 2026 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001526;
	bh=FupH4q/Yno59iz82IQ1OiLQ18BmAQ/D0cjqdeP9AOJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GeVkwv6GJ8bKahlQB2O7dVwkrD2Ovak73FyH3VfH3XvrhB+cfu9U2ISIE9y29gYu
	 vrNJhOinoNGJ9wcv9EyshnV5FM+OSVRleVVgCcVGCYe5T+U2kGOtp6FyWxfHHi+rDt
	 JopBxUUi6pcZtzwc0GKEH8EYQJWCiRb0mmAwVBkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/186] platform/x86: intel-hid: Check ACPI_HANDLE() against NULL
Date: Thu, 28 May 2026 21:50:40 +0200
Message-ID: <20260528194933.281420307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5c69e090ae5dd93d910f70db0796357080707d26 ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_HANDLE() check against NULL to the
platform/x86 intel-hid driver.

Fixes: ecc83e52b28c ("intel-hid: new hid event driver for hotkeys")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/1971512.tdWV9SEqCh@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 79390e9e888a7..346fbad34e24a 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -657,12 +657,16 @@ static bool button_array_present(struct platform_device *device)
 
 static int intel_hid_probe(struct platform_device *device)
 {
-	acpi_handle handle = ACPI_HANDLE(&device->dev);
 	unsigned long long mode, dummy;
 	struct intel_hid_priv *priv;
+	acpi_handle handle;
 	acpi_status status;
 	int err;
 
+	handle = ACPI_HANDLE(&device->dev);
+	if (!handle)
+		return -ENODEV;
+
 	intel_hid_init_dsm(handle);
 
 	if (!intel_hid_evaluate_method(handle, INTEL_HID_DSM_HDMM_FN, &mode)) {
-- 
2.53.0



