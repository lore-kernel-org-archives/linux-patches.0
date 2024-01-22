Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BBC149006;
	Tue, 23 Jan 2024 01:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972088; cv=none; b=q+5i+pPNnzoEqo/0oDh8Q8C8gpm/RRxd5HiWABzl68gLRU+nNmEKBIA8fF/8VY1CwuTzRa5TLupLamlL2P9WqWR8v9NtHVmX4jZwGJRGJqTwaeObjZK5qB/Gw4QDyAfmM4+SU2j3CwLLSGCVZyDqpmoToVw2lW9VurLJSNk+Frc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972088; c=relaxed/simple;
	bh=rqWKkAnvHnqqaDpmO4LlmWUMcSgh7Li0hD3vzwc3/nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9yDVE+nFDUUWXlh88JFZ0qoD5N4NirUDY8q3DLGxF3UwleEkFkf37zyQysv1ygJnmFbxKGxod/P8hPpVlTKvPQknx9EeHF+zzCVTTq7gndu1rVZK9fVkxJ2jtbD816ENIbm3aCtJHMZSH2Z+k1YBFifI40Tvg8i7n4waRAwgjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY4LpqR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY4LpqR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259FEC43390;
	Tue, 23 Jan 2024 01:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972088;
	bh=rqWKkAnvHnqqaDpmO4LlmWUMcSgh7Li0hD3vzwc3/nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vY4LpqR9mPIYq03s4ZKDmv2dVTW4flEBeu4ttmgp9xm0To00Xc2W6jbZdLE6uh8Ok
	 8KND5xt/9WTroyTtmZCQ/ewFZqPcQK0oMGcSsxHcxjIWtD3Qc3xxwtPyan7Hazr33M
	 eKRmUzGn02LStMYVaY/W7JnsnGbxNHLnDr3JrxBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnold Gozum <arngozum@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/374] platform/x86: intel-vbtn: Fix missing tablet-mode-switch events
Date: Mon, 22 Jan 2024 15:54:45 -0800
Message-ID: <20240122235745.653161666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 14c200b7ca46b9a9f4af9e81d258a58274320b6f ]

2 issues have been reported on the Dell Inspiron 7352:

1. Sometimes the tablet-mode-switch stops reporting tablet-mode
   change events.

   Add a "VBDL" call to notify_handler() to work around this.

2. Sometimes the tablet-mode is incorrect after suspend/resume

   Add a detect_tablet_mode() to resume() to fix this.

Reported-by: Arnold Gozum <arngozum@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/87271a74-c831-4eec-b7a4-1371d0e42471@gmail.com/
Tested-by: Arnold Gozum <arngozum@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20231204150601.46976-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vbtn.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/vbtn.c b/drivers/platform/x86/intel/vbtn.c
index 15f013af9e62..f5e020840d94 100644
--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
@@ -73,10 +73,10 @@ struct intel_vbtn_priv {
 	bool wakeup_mode;
 };
 
-static void detect_tablet_mode(struct platform_device *device)
+static void detect_tablet_mode(struct device *dev)
 {
-	struct intel_vbtn_priv *priv = dev_get_drvdata(&device->dev);
-	acpi_handle handle = ACPI_HANDLE(&device->dev);
+	struct intel_vbtn_priv *priv = dev_get_drvdata(dev);
+	acpi_handle handle = ACPI_HANDLE(dev);
 	unsigned long long vgbs;
 	acpi_status status;
 	int m;
@@ -89,6 +89,8 @@ static void detect_tablet_mode(struct platform_device *device)
 	input_report_switch(priv->switches_dev, SW_TABLET_MODE, m);
 	m = (vgbs & VGBS_DOCK_MODE_FLAG) ? 1 : 0;
 	input_report_switch(priv->switches_dev, SW_DOCK, m);
+
+	input_sync(priv->switches_dev);
 }
 
 /*
@@ -134,7 +136,7 @@ static int intel_vbtn_input_setup(struct platform_device *device)
 	priv->switches_dev->id.bustype = BUS_HOST;
 
 	if (priv->has_switches) {
-		detect_tablet_mode(device);
+		detect_tablet_mode(&device->dev);
 
 		ret = input_register_device(priv->switches_dev);
 		if (ret)
@@ -198,6 +200,9 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	autorelease = val && (!ke_rel || ke_rel->type == KE_IGNORE);
 
 	sparse_keymap_report_event(input_dev, event, val, autorelease);
+
+	/* Some devices need this to report further events */
+	acpi_evaluate_object(handle, "VBDL", NULL, NULL);
 }
 
 /*
@@ -358,7 +363,13 @@ static void intel_vbtn_pm_complete(struct device *dev)
 
 static int intel_vbtn_pm_resume(struct device *dev)
 {
+	struct intel_vbtn_priv *priv = dev_get_drvdata(dev);
+
 	intel_vbtn_pm_complete(dev);
+
+	if (priv->has_switches)
+		detect_tablet_mode(dev);
+
 	return 0;
 }
 
-- 
2.43.0



