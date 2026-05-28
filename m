Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314892FD7C3;
	Thu, 28 May 2026 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000191; cv=none; b=jRV8kMeVVIR2DXV0XD1TdEKKGauTUQUTIs82SlzYz+CHCzxMCLRW9uwXnPBDZY5RQ0WW2X06O1GDiuxyZ4A0+0PbAm3Wdhm3/eHWMdmGivzfpDhpKmOkwhto53iQutFQ3gyoV6TCzM06yzLLy/Hlhc7D+NWi7shz9m7xYb6uJLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000191; c=relaxed/simple;
	bh=JcoOI2/IeGM6ie588ts4WT9c3FcEhRS0ekgh7wAnS+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZI0DUXkms7JdlGIlo5Vr57VZCb7zbsSEOyU92Oh71btmT5urnrD3zoLNLNlLq2dHePJM2A2KNB9CUOQv+gyY+P3HKgfwRLJMTKPDIWjt9fZugFKoCsAShIPT6KG6S64g+jD2/OBW8pBgU9yizeQFN2EmudVEMBVQEHHE7wR2Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aX1RSxLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aX1RSxLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD391F000E9;
	Thu, 28 May 2026 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000190;
	bh=v67fqkO0P38CIaPlbOweYrt3qI7JY1UVRtFNdkUSrIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aX1RSxLROCdw7laoggN4PQhVFlqg7QVncnmrZNLTOQybU7U8PYtyTstPTTUDS5pOE
	 sXXvTe8KABoSkbN0SobqLS03X0oosPDic5+jelNiuaC7lUqcfykdXQgOGUa2GfDFN3
	 RMwkk5t0dtq9/oOvHdMdYiZBVouzgNEaPTd7vlNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/377] platform/x86: intel-vbtn: Check ACPI_HANDLE() against NULL
Date: Thu, 28 May 2026 21:49:32 +0200
Message-ID: <20260528194648.083208225@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 232cd12e3c9fa..03b5bf461a866 100644
--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
@@ -275,12 +275,16 @@ static bool intel_vbtn_has_switches(acpi_handle handle, bool dual_accel)
 
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



