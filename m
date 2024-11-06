Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB61DFDA4;
	Wed,  6 Nov 2024 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899234; cv=none; b=L6QseFsWOeUvd25YZIAygFBn6K3IkwVYCzXamGz6vyb3DOqvpJPVVdnbQFO1RpBYlGKRfQJqw+8jBhcYFIrMIv93YZ6WlxhXsMRWzo0jb3/6GHjb/vFFC4zcFu6y98bvc6sNUb6qhpLVJBC9XXMdk/PBzlCuX0nCesEYfyqXLJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899234; c=relaxed/simple;
	bh=P9lsBEOLUwPtHiPfqNZRt8f34bKuoqxASOyNHtYrBns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiyMOyv3amBA+bh2V/kxBUPitTFEtiHgEQk1pQ6T5mDMCpqPZFSPxRDXmIosLwiinKo1nnjJiqwFqkUROeFyclrNF7c8wPSZzMPYecRK4pQQJncOQaqxL7N1+1wuYkKx4aDga7he0UrWWsNrg54XbKp2dgJaXZgcPKGlEB5MFKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHVxVPlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHVxVPlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B307C4CECD;
	Wed,  6 Nov 2024 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899233;
	bh=P9lsBEOLUwPtHiPfqNZRt8f34bKuoqxASOyNHtYrBns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHVxVPlAMj9IcwJCo2BSO3GO5255/jv50vn00+SuTKLz3NvsqOsMan4BL+J++bvdt
	 iekeXY5NUG7Kfu3xwVrqkQVnajeP0cKIGZ5rwQllSh3RAygqS0wlYxpSRiKMxj++tt
	 P0LBUeOEOkxGZ6RqCnDcg1juv+LrUZDvCJvQ2YxM=
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
Subject: [PATCH 5.15 43/73] Revert "driver core: Fix uevent_show() vs driver detach race"
Date: Wed,  6 Nov 2024 13:05:47 +0100
Message-ID: <20241106120301.251667340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 #include <linux/swiotlb.h>
@@ -2306,7 +2305,6 @@ static int dev_uevent(struct kset *kset,
 		      struct kobj_uevent_env *env)
 {
 	struct device *dev = kobj_to_dev(kobj);
-	struct device_driver *driver;
 	int retval = 0;
 
 	/* add device node properties if present */
@@ -2335,12 +2333,8 @@ static int dev_uevent(struct kset *kset,
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
@@ -2410,8 +2404,11 @@ static ssize_t uevent_show(struct device
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


