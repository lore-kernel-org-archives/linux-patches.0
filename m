Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F2E17A30A;
	Thu, 28 May 2026 20:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001530; cv=none; b=rejrFznaYba2VrsM/3l8CMhjNyoGOQ0X0I0eXSiyUBPiIUUou9JeihcwrEJ2y869DyewxDcQSiC91Wftc+FdzkUjdDb2VJWxZCpASm1dctxDduoOzD68NSHZHM84NpG03FtYEfsvj7htqltFm+Vt+CbChehlrV6UNxdFNA8KMn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001530; c=relaxed/simple;
	bh=9GRJtl56+o8cptBXQGgAC2phsq6x9lH1E5Ls14pZg0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESSLEbtAunUH13sdGsUWFipa/eCYbROfbkCQs3eA5x6+15utQ095SIuXBdUMMw9hk28qCiKBWxxLJdLi8LqvNWeQ0m+lPRodr6zYV+3dT91AUWOJps6azMZFNnYP8uvado+vjn9heyByUd5qsq0A+D/tcbkB5a3oQy14AF9bRqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNNfHV6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNNfHV6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826661F000E9;
	Thu, 28 May 2026 20:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001529;
	bh=VaXXspI5X2UcKWtvxzVr5Cfxzx7UEwPFDqKVI7SBBCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNNfHV6uDtJ4fT7cStj2QBsVc1S7z8tdZ6D+v1euXHwWZ6NXJgCFJR/AaImmHgTkz
	 C2tdkYRSIyBN9qD28aA0NeaG7IRiKxwTGLP++esoY0dIp2aotE5ZinhRKqZXOK5VmR
	 ZBVmJQoo2dscSXSMvVD8YpANbyw1cr60cr47gtyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/186] platform/x86: intel-vbtn: Check ACPI_HANDLE() against NULL
Date: Thu, 28 May 2026 21:50:41 +0200
Message-ID: <20260528194933.308389869@linuxfoundation.org>
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
index 5d13452bb947a..0e0c4022e61a6 100644
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



