Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B431B96D;
	Thu, 18 Jan 2024 10:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575279; cv=none; b=FlMBuEJ7JJs4t2CdY2X/RcXzO7iMdx/dnVAgG1+pLksofBn7ZiSCgiAGcFeyml9lenHF7YbuFuY6B7nr4bNkGZWX6zpsM35KP1CNqpdrAjULVn0tw5ksz5q55+N6XRJ7NVBmht7NkLj2l2rFVztRdAb5tgr7oocbqFv3wyIEm/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575279; c=relaxed/simple;
	bh=bBiNKpZPFcKXgZd9/aFaGUTeoZyAUCP/av4AyKZ0tcU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=ozLvPoG06EfV68D7i1E5rlGpt8rJ98R7XuwR+2wxJGe3iaz1dBQCN7vE7atQ53s6Gk2dpqkeoAXpePV2YwZcLQpyk5B473VhGX/ZizanDqdI7XTm1j6u6b9QuLfKxO6ffes0Xcjy2C6R8u2l9ydmZpil/q62XQOEc4Wblf4aS20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3iuKSHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3iuKSHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD4AC433C7;
	Thu, 18 Jan 2024 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575279;
	bh=bBiNKpZPFcKXgZd9/aFaGUTeoZyAUCP/av4AyKZ0tcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3iuKSHhU5iBoCHD80V4fft4PX30nXQ9Z0xhBvvWv3bAfh4IXK4v8RsLwyu+5RXs0
	 OU9cI1Ohf12Wi6fylQ6p1nU0lMJzPUaO3hhj4Dzoa66L5YK6qchOkLNmUZWEyA0/5X
	 hLzTgoZF/LI7ssa0OsoeGx+jYdPynA6KtxjSJw/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnold Gozum <arngozum@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/150] platform/x86: intel-vbtn: Fix missing tablet-mode-switch events
Date: Thu, 18 Jan 2024 11:48:18 +0100
Message-ID: <20240118104323.507705745@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6fa1735ad7a4..210b0a81b7ec 100644
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
@@ -352,7 +357,13 @@ static void intel_vbtn_pm_complete(struct device *dev)
 
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



