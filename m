Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D728335566;
	Thu, 28 May 2026 20:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999103; cv=none; b=N8tC5embb/LDDxE4tbCapJLjafeGA4nC4fn3c7FbQsof5KbLxjazJYO+weAJkk4PaaJpLk9hsu5sI+8SGHWQQwgmdYXyAj2D0i8L8VCknbUfXDIauc4DoAAx4ZUaApFHgc6cGLu77GjCtbcg12iCaf0V8kerBAZuqHVOYwCgXBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999103; c=relaxed/simple;
	bh=V92dPWHQuZxMsqoriJDdu6cbNW+2wP89rgjJZahK/FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dy7tpqUQxLU2DZTE1SI6s3ACBUvTqmDB6I9hYe8LAfprvl9yvU9waZoBnQFAx6bz9URwBBLKxstSSYy1LO4MIN8gNCi2dcfwmy1Hw0VzMeV84dF4uB1YHJqUX9ytelQFXIMYmVRIXFkyPnwA2Mm1HZK2ElThSRfLZVmDMsOA84I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGUncy9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGUncy9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315371F000E9;
	Thu, 28 May 2026 20:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999101;
	bh=KZoLrTvFrkaqlSrPaG76O9XnPRzjUEanUksKK3agcJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGUncy9bR6y7XVjH31lgde4Cy7mJDzicj6S8v2mNBnzFotAw6IzOnMlGNRigi3uvX
	 gCLCc+YsryGOAWdRkR02iA5vnDOiglrRtX4iIWUQKlCbqwnzIIqGUXGNhlTnTGVBEV
	 yiU+iT1OxS4WzkTkg0Zt3YLP4mElXGn51z66GYok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 392/461] platform/x86: intel-vbtn: Check ACPI_HANDLE() against NULL
Date: Thu, 28 May 2026 21:48:41 +0200
Message-ID: <20260528194658.811405408@linuxfoundation.org>
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
index 9ca87e7075822..874023c38fd15 100644
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



