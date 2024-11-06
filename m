Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C91E0DFD;
	Wed,  6 Nov 2024 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897542; cv=none; b=iPF6mz7dXlumvBUEBSopqu+F/FHZ1GGGa7NbA0J7u112ixzY1DlOH8FXlsd/UYNNFsBc5MlJP0l7EBQ7yojug8YwxFt2Qn/HQWeDck++mO8t54/ofoys2KFdiOdXrvW04GkOCZJ2LIFBj6TV28oETZlzhAM/s4K9q8TYePIDE5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897542; c=relaxed/simple;
	bh=nARz/Pet3FI15A7l9Dc9wrOfZzNthy+HQGNld95ZFFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZU2RbA5NltOS+LWwrs8AxVoHQP5THgkkutmldg70CgmriL3ape+sLxd9/25PTOHissKNCrZTiFtHaL073XvU3x0udDosh+xh5pSoAY+YEBdgEV1u3H11uS02r8i2UoYE3zP9SO159DNR/afSKvHf36Sfjqydczw8MhJGgN+ebc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZMv1Ost; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZMv1Ost"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E895C4CECD;
	Wed,  6 Nov 2024 12:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897542;
	bh=nARz/Pet3FI15A7l9Dc9wrOfZzNthy+HQGNld95ZFFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZMv1OstsJ/JRQuktgLV/h+fOHYp5a+Obq/th8+SH/Kh2JwTwZD8X/+tSIqnyAJAP
	 zNq1+Q5Sojhsi2kWjaqJfBz2ZPx/yoaSvADMZQYWavGDVPicIZmCCtT0cMnHyCW0Xx
	 EX50p73+4hBJkmZbAiiDr1ZLe/V8YsqbugiamNKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Dirk Behme <dirk.behme@de.bosch.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 089/151] Revert "driver core: Fix uevent_show() vs driver detach race"
Date: Wed,  6 Nov 2024 13:04:37 +0100
Message-ID: <20241106120311.316159223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9a71892cbcdb9d1459c84f5a4c722b14354158a5 upstream.

This reverts commit 15fffc6a5624b13b428bb1c6e9088e32a55eb82c.

This commit causes a regression, so revert it for now until it can come
back in a way that works for everyone.

Link: https://lore.kernel.org/all/172790598832.1168608.4519484276671503678.stgit@dwillia2-xfh.jf.intel.com/
Fixes: 15fffc6a5624 ("driver core: Fix uevent_show() vs driver detach race")
Cc: stable <stable@kernel.org>
Cc: Ashish Sangwan <a.sangwan@samsung.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c   |   13 +++++--------
 drivers/base/module.c |    4 ----
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -25,7 +25,6 @@
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
-#include <linux/rcupdate.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/string_helpers.h>
@@ -2566,7 +2565,6 @@ static const char *dev_uevent_name(const
 static int dev_uevent(const struct kobject *kobj, struct kobj_uevent_env *env)
 {
 	const struct device *dev = kobj_to_dev(kobj);
-	struct device_driver *driver;
 	int retval = 0;
 
 	/* add device node properties if present */
@@ -2595,12 +2593,8 @@ static int dev_uevent(const struct kobje
 	if (dev->type && dev->type->name)
 		add_uevent_var(env, "DEVTYPE=%s", dev->type->name);
 
-	/* Synchronize with module_remove_driver() */
-	rcu_read_lock();
-	driver = READ_ONCE(dev->driver);
-	if (driver)
-		add_uevent_var(env, "DRIVER=%s", driver->name);
-	rcu_read_unlock();
+	if (dev->driver)
+		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
 
 	/* Add common DT information about the device */
 	of_device_uevent(dev, env);
@@ -2670,8 +2664,11 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
+	/* Synchronize with really_probe() */
+	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(&dev->kobj, env);
+	device_unlock(dev);
 	if (retval)
 		goto out;
 
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -7,7 +7,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/rcupdate.h>
 #include "base.h"
 
 static char *make_driver_name(struct device_driver *drv)
@@ -102,9 +101,6 @@ void module_remove_driver(struct device_
 	if (!drv)
 		return;
 
-	/* Synchronize with dev_uevent() */
-	synchronize_rcu();
-
 	sysfs_remove_link(&drv->p->kobj, "module");
 
 	if (drv->owner)


