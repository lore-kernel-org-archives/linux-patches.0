Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D711DFE13;
	Wed,  6 Nov 2024 13:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899064; cv=none; b=LRA5AcPwUVncbhRIeyklMad9wMKAraltNjpbdEsJDcDf1Jid74WXhqIvaKb4WuYORbAcR7915LCaQBHGToeaogle1wst+Iw+9vozkLA+bI8of4jKJXsXaHMXTkuHXK1XFBgE/tGX5W7W7lFCF2qhnWdNudwTSVDzu+y/0cA+X5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899064; c=relaxed/simple;
	bh=7nLtlVxJVRgX3Bjky/KIhOEPNdXLJta9ku0avmVulvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttIAspDBMMitPBQy0/aq/37FKuudBoq9su9jgwpbbzcQnKnW3xHsAkaUmarJOmaOzk7poJ5keu31RgvPA5//Qna0Zy9LCGru0rz2Mj1b5xPZfO+AGoQqY4L6BI3ZwSwdRYI9vsCJQIR4WADn3lEpAZZjYn179BQzUpJsGhQYeX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeqHEkyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeqHEkyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B2EC4CECD;
	Wed,  6 Nov 2024 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899064;
	bh=7nLtlVxJVRgX3Bjky/KIhOEPNdXLJta9ku0avmVulvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeqHEkywFkOmS8wPhgjhZGYtapIBR6YSV4jIpvyOzPVS/vD+RG7RfUfmft40/GSxj
	 vRclZ5UGFXQvOoBYGslP7TcHiPZESQy4KWQIb+nBCowqQ3o2kjcs09u4fYQ6m4RHaH
	 yQPWgj/Xn8BwiGfLpoBUM8xdWYlhIGR+7+VltRJo=
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
Subject: [PATCH 5.4 449/462] Revert "driver core: Fix uevent_show() vs driver detach race"
Date: Wed,  6 Nov 2024 13:05:42 +0100
Message-ID: <20241106120342.597348225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 #include <linux/sysfs.h>
 
@@ -1175,7 +1174,6 @@ static int dev_uevent(struct kset *kset,
 		      struct kobj_uevent_env *env)
 {
 	struct device *dev = kobj_to_dev(kobj);
-	struct device_driver *driver;
 	int retval = 0;
 
 	/* add device node properties if present */
@@ -1204,12 +1202,8 @@ static int dev_uevent(struct kset *kset,
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
@@ -1279,8 +1273,11 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
+	/* Synchronize with really_probe() */
+	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(kset, &dev->kobj, env);
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
@@ -78,9 +77,6 @@ void module_remove_driver(struct device_
 	if (!drv)
 		return;
 
-	/* Synchronize with dev_uevent() */
-	synchronize_rcu();
-
 	sysfs_remove_link(&drv->p->kobj, "module");
 
 	if (drv->owner)


