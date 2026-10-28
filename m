Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215801;
	b=qAKdGNOngbiHMmAspk+za/nLp/ahunyxieA5WqcW+jYBVM1DPR4QS5rCEpGDZtLgvRuc
	 N9o3Xhr18+31Erb1GyurtnfxGUZvvxfV6iFkeoz0ZCrKzQ/LAI3TG2Qm0KgB0wtU2NAcN
	 Z5VbJErSgqNOIxXIhUNRIqH3izuJMUVl1WwphjFlju1gtit7/TAbsntHbrN7gyHMHZL1U
	 gf61BM9AcvUn01gOEYFmHaGprRtE3V1fDZx3KYIchJlvCXDurPVlOTh7IyDPHpXPd9bP6
	 3uwO18EoGPi7KP4YGLDLdE5GQab4+k612UYwVRRNN3ivcdw4DIH4e96297VHcG0O9fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TuVynu98zdXcfaRtpks9i1vSL21BdtYNfOQUorPKLN8=;
	b=e8yBrkSMk1dqiIqu7Rx5ka+gHSlveFVd+hY9+xrzsc0Zr/PgnRcEFypnPenIU7pbv12W
	 sspYLMFNfhyvjhCCv3xb1doL+2NlyMlWHGbVhdzHniB2x7h+VakxtWvbDmFaHorCbpytL
	 DtbrlQCGpyDrGyLQQYJ51j+Kvqdt/9ozfGy/ZtLA8aB7qOkHqVOhdO9nXVfl4vtjCZ9Jc
	 ldDpobA0ProPSTdXnC+sDVQPX/lEVe3pQPPfnKzq5ObUKfd3Aip/fUiDEqIdnMCd/PDiS
	 yfAYqqfUnPSZIqripTHvNrVxwZm+gNlbBhY+cHMG62aKuXSw/VWps9W+dMIYKcMW/9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIrpoCth;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E57606A320;
	Wed, 28 Oct 2026 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fIrpoCth
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69211F01825;
	Wed, 28 Oct 2026 19:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215800;
	bh=TuVynu98zdXcfaRtpks9i1vSL21BdtYNfOQUorPKLN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIrpoCthsJja4vxWqvFxrAQMYtOhmryogWxp2MLpNsfm4wqkx8i+ROMqkxe6kS5Ew
	 QYF4dYDfxopwyFd3M5oh4/dgxh9vVMGZz3ASlR9vFtUuoSV/Zb2+zLITJLNe5oYqvO
	 AviShnG0hY0FZlSIlOTBgVm4W2Vz/Pdwfy0zsFxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1337/1887] s390/appldata: remove power management callbacks
Date: Wed, 28 Oct 2026 17:57:13 +0100
Message-ID: <20261028170529.861043870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 78c045c08a393285e615260c50cedf9cea5a7fa1 ]

Support for power managemant has been removed from s390 since quite
some time. Therefore remove unused power managemant code from the
appldata device driver.

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: 7f40b346462f ("s390/dasd: Fix undersized format-check buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/appldata/appldata_base.c | 113 +----------------------------
 1 file changed, 2 insertions(+), 111 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index d74a4c7d5df6d..c0fd29133f27a 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -26,8 +26,6 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/workqueue.h>
-#include <linux/suspend.h>
-#include <linux/platform_device.h>
 #include <asm/appldata.h>
 #include <asm/vtimer.h>
 #include <linux/uaccess.h>
@@ -44,8 +42,6 @@
 #define TOD_MICRO	0x01000			/* nr. of TOD clock units
 						   for 1 microsecond */
 
-static struct platform_device *appldata_pdev;
-
 /*
  * /proc entries (sysctl)
  */
@@ -88,7 +84,6 @@ static struct vtimer_list appldata_timer;
 static DEFINE_SPINLOCK(appldata_timer_lock);
 static int appldata_interval = APPLDATA_CPU_INTERVAL;
 static int appldata_timer_active;
-static int appldata_timer_suspended = 0;
 
 /*
  * Work queue
@@ -412,88 +407,6 @@ void appldata_unregister_ops(struct appldata_ops *ops)
 /********************** module-ops management <END> **************************/
 
 
-/**************************** suspend / resume *******************************/
-static int appldata_freeze(struct device *dev)
-{
-	struct appldata_ops *ops;
-	int rc;
-	struct list_head *lh;
-
-	spin_lock(&appldata_timer_lock);
-	if (appldata_timer_active) {
-		__appldata_vtimer_setup(APPLDATA_DEL_TIMER);
-		appldata_timer_suspended = 1;
-	}
-	spin_unlock(&appldata_timer_lock);
-
-	mutex_lock(&appldata_ops_mutex);
-	list_for_each(lh, &appldata_ops_list) {
-		ops = list_entry(lh, struct appldata_ops, list);
-		if (ops->active == 1) {
-			rc = appldata_diag(ops->record_nr, APPLDATA_STOP_REC,
-					(unsigned long) ops->data, ops->size,
-					ops->mod_lvl);
-			if (rc != 0)
-				pr_err("Stopping the data collection for %s "
-				       "failed with rc=%d\n", ops->name, rc);
-		}
-	}
-	mutex_unlock(&appldata_ops_mutex);
-	return 0;
-}
-
-static int appldata_restore(struct device *dev)
-{
-	struct appldata_ops *ops;
-	int rc;
-	struct list_head *lh;
-
-	spin_lock(&appldata_timer_lock);
-	if (appldata_timer_suspended) {
-		__appldata_vtimer_setup(APPLDATA_ADD_TIMER);
-		appldata_timer_suspended = 0;
-	}
-	spin_unlock(&appldata_timer_lock);
-
-	mutex_lock(&appldata_ops_mutex);
-	list_for_each(lh, &appldata_ops_list) {
-		ops = list_entry(lh, struct appldata_ops, list);
-		if (ops->active == 1) {
-			ops->callback(ops->data);	// init record
-			rc = appldata_diag(ops->record_nr,
-					APPLDATA_START_INTERVAL_REC,
-					(unsigned long) ops->data, ops->size,
-					ops->mod_lvl);
-			if (rc != 0) {
-				pr_err("Starting the data collection for %s "
-				       "failed with rc=%d\n", ops->name, rc);
-			}
-		}
-	}
-	mutex_unlock(&appldata_ops_mutex);
-	return 0;
-}
-
-static int appldata_thaw(struct device *dev)
-{
-	return appldata_restore(dev);
-}
-
-static const struct dev_pm_ops appldata_pm_ops = {
-	.freeze		= appldata_freeze,
-	.thaw		= appldata_thaw,
-	.restore	= appldata_restore,
-};
-
-static struct platform_driver appldata_pdrv = {
-	.driver = {
-		.name	= "appldata",
-		.pm	= &appldata_pm_ops,
-	},
-};
-/************************* suspend / resume <END> ****************************/
-
-
 /******************************* init / exit *********************************/
 
 /*
@@ -503,36 +416,14 @@ static struct platform_driver appldata_pdrv = {
  */
 static int __init appldata_init(void)
 {
-	int rc;
-
 	init_virt_timer(&appldata_timer);
 	appldata_timer.function = appldata_timer_function;
 	appldata_timer.data = (unsigned long) &appldata_work;
-
-	rc = platform_driver_register(&appldata_pdrv);
-	if (rc)
-		return rc;
-
-	appldata_pdev = platform_device_register_simple("appldata", -1, NULL,
-							0);
-	if (IS_ERR(appldata_pdev)) {
-		rc = PTR_ERR(appldata_pdev);
-		goto out_driver;
-	}
 	appldata_wq = alloc_ordered_workqueue("appldata", 0);
-	if (!appldata_wq) {
-		rc = -ENOMEM;
-		goto out_device;
-	}
-
+	if (!appldata_wq)
+		return -ENOMEM;
 	appldata_sysctl_header = register_sysctl_table(appldata_dir_table);
 	return 0;
-
-out_device:
-	platform_device_unregister(appldata_pdev);
-out_driver:
-	platform_driver_unregister(&appldata_pdrv);
-	return rc;
 }
 
 __initcall(appldata_init);
-- 
2.53.0



