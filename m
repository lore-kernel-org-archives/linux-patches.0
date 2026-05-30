Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6D6137750;
	Sat, 30 May 2026 18:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167210; cv=none; b=cD1pxmuI1ystaQiv8kjWtdhVKQAB71fiRWrquePU6GJK3n5nXD1eHc0QVGAaYqnLwpR1DOASkWyGlasdGdKaKbi2R4LK5r1Q2jgeWO3besbMfHAaNAnuZ5Ss9dTSMbC1TCBuuP3wHdnYBSWlH+G5ny1hxmxPjz3uCFgCF/2jPUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167210; c=relaxed/simple;
	bh=vBKVhwFlABte6FLFM3Qhg2304sSg79OIUd5v1PuzHxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU8tuGZ/lxlsQw7may1bPeiuKqMgvFF/aBmUxoKXMTtsX56zl7nY+F2wFduPf08ryvxab7/XcqtjIkopM5mAPVgj62CsvyyzpmWz52fLNFYoc677cjZOFnrFiS1qWr/8bsJmlzQlH2YWy7aOad55KYoCJ4IJVFaKH0S4TUkdNCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqqlzBZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqqlzBZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6238D1F00893;
	Sat, 30 May 2026 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167209;
	bh=TnfwlmYYeMvahLRrXE4LfFDO9063pU9k07h8VNvvcxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqqlzBZ/Gz8XscbU+lZ6HF0E0rn1Te/SWeB5bi3G9r+nnpwe8RrPXmO1wh0QBbXdx
	 tpezk6Nxf929DaZU8PNZy7m2sRFUXMaL8ffdcgkB3teKT+RPxX3ow8Q4XMH+OlmHuU
	 xA7C8qHk2TFNKnwLLSlxiNozXRofUSts2Oy3XlEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 583/589] platform/x86: intel-hid: Check ACPI_HANDLE() against NULL
Date: Sat, 30 May 2026 18:07:44 +0200
Message-ID: <20260530160239.917579689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/intel-hid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 12d695adf3f74..f52367363d530 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -471,12 +471,16 @@ static bool button_array_present(struct platform_device *device)
 
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



