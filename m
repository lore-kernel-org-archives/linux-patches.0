Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1434B35F176
	for <patches@lists.linux.dev>; Mon, 25 May 2026 07:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695112; cv=none; b=TqGKP4y9uMnzbOW8GOLXao/uXWCYYzqaq5YznRqgKpOmtlkhM0yhuI2ZhjELN3lVkF3QJ4rgAo+fFs10vKTiNtnpuNsTI+zoPhxOrfdsXrxJreDTvaM/XuQhJdoVo2s7pgjqII+HoSVUjB3O+hYGC3sb2nqVZ0r6YaqU8npMLbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695112; c=relaxed/simple;
	bh=TIAz4wlLKlIAPWQt9dfhOzCP7ACSiDb+V5filsopots=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=lNd776wxD/W0RUJhBYMN0Mb+eFeoMFjqgShbI0lmSZaVh43sSlA80RbxvrGibZwATaZybTxTCpACgb/IbZ2DaojkQwvxhekioUSFylNtzklXvY5udb12dR6jNOqa7DHrqRKE8m9sXkjHlZO4j18KR3cIXILoTWaNI34FBw/eDig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=SDKF4niB; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="SDKF4niB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1779695098; bh=jGZVhuzIUBDvzr37jEcw5y55t/s7RWVAMdOgkWac4OI=;
	h=From:To:Cc:Subject:Date;
	b=SDKF4niBWdaf55WAMiAORXm5sDrJ7tl28anQWGAYc23HBY7qcZS4X4CfzEAWC9u9r
	 HeceK3/wtdzK/wERMnr3zpCwqlYVfzBdPkIWd6fzm3HjLBUs8FNizjGxv71YA4KyQV
	 SDifCJl1DHuLc5YOxQ5ZI9p9+KrLwZd24ZTwi1eI=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id B3689645; Mon, 25 May 2026 15:44:54 +0800
X-QQ-mid: xmsmtpt1779695094tc2zzl5dk
Message-ID: <tencent_C9D9ED71D51B177EDF71B708417942F4F206@qq.com>
X-QQ-XMAILINFO: OIJV+wUmQOUAFbPCqhgAqlKhFTUmK401BqGnC/2AUQ0N66PdlRJPLvhh1uzbH4
	 sDLlRr0vCPeBHnh8Q1jglZviTR5VNsHD+I+mPMkS8jN3B+JfTtcKkKEi3HoMNMVLZqKLOR2Ax0XT
	 lWPSuuTCUZg3kjSwjrrOhLyn6F1FegzS0T4S8RokViRMHeZgi77VyDkDwRVKzK7a2bnCWy8CCKEL
	 oqKHMolv9IbqEvT6rzCT+MYLtKj/rPHC+YwLyXcc8/wBucwVyfR3Rjulbl3pcVWhxcOrgTKEAXJ5
	 NAm7NQqv7E+n/gq7sWdJ0z9hQoDli+qL/Pj/atv9y/1G9BWs+dwuYw7EBBrRGJp4ktFsc29Btq03
	 xkhxssIS+mOU3+T5pM2C/QBEsjL5rwzZKQo7Lom4qx3ffaiBPhLCd0TRFsYXF6La6GBAGRJAbpFT
	 vfoCfs7L2INhoe/Nv3Hx5rtbcj5hlSRJYb3q5t6HlbRxxchjCEcxUPxbt5w7sVDJe636sXFI4mX4
	 MEVbY7CAmoTykVmkNYflzTn00GKcFgprWMwADBHWtZ6SiK3dERjmkQFNcY5UxPM8WitjHg6/+Bd2
	 tmysrpEKFt3qds7APAKERq6hBhScWlDSSbClscXatsCkh6aVmNoi4OOKCpQQk5jkxgBRcUIVfagQ
	 z+ApHJzZ83R+9ynyaHY6aRWbgF0FYLJBkBJgASxxBhzXXattcw/vfDOYmr0dNm01dPKUVKNZ/NH4
	 9GkqAGTKMitJnCpEthfnqdYM/X5/67+3tvomuinhp5kreKDDGK0DbBxUwRWfCJUDOLk4TxXh8IKs
	 0a1HbdzrwOeeUSVhCODa+lXAADyZqDyLrQuK4WATuUSiV5ETSRpeuJGWKWMIUqJ3WVHt+t6D4Iqc
	 +KLGhJSe+L3o5a6/X40nCKXEbyKn7mUVrH7mcCaI6QyRESb8bh5qr0f2qb+4l53ogE2tCGBCLoXL
	 lIWlsyOTuezJRvsoBUkHOpMns/93x7J/Xz5s+s6SedREGi4tooZm1RqbtSzpunxCf4Vd04fPMg+0
	 cnWl8QpnHXYhqxzNmSDwOYJLK/U2k=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	alison.schofield@intel.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	ming.li@zohomail.com,
	linux-cxl@vger.kernel.org
Subject: [PATCH 6.6.y] cxl/port: Fix use after free of parent_port in cxl_detach_ep()
Date: Mon, 25 May 2026 15:44:54 +0800
X-OQ-MSGID: <20260525074454.1150115-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 19d2f0b97a131198efc2c4ca3eb7f980bba8c2b4 ]

cxl_detach_ep() is called during bottom-up removal when all CXL memory
devices beneath a switch port have been removed. For each port in the
hierarchy it locks both the port and its parent, removes the endpoint,
and if the port is now empty, marks it dead and unregisters the port
by calling delete_switch_port(). There are two places during this work
where the parent_port may be used after freeing:

First, a concurrent detach may have already processed a port by the
time a second worker finds it via bus_find_device(). Without pinning
parent_port, it may already be freed when we discover port->dead and
attempt to unlock the parent_port. In a production kernel that's a
silent memory corruption, with lock debug, it looks like this:

[]DEBUG_LOCKS_WARN_ON(__owner_task(owner) != get_current())
[]WARNING: kernel/locking/mutex.c:949 at __mutex_unlock_slowpath+0x1ee/0x310
[]Call Trace:
[]mutex_unlock+0xd/0x20
[]cxl_detach_ep+0x180/0x400 [cxl_core]
[]devm_action_release+0x10/0x20
[]devres_release_all+0xa8/0xe0
[]device_unbind_cleanup+0xd/0xa0
[]really_probe+0x1a6/0x3e0

Second, delete_switch_port() releases three devm actions registered
against parent_port. The last of those is unregister_port() and it
calls device_unregister() on the child port, which can cascade. If
parent_port is now also empty the device core may unregister and free
it too. So by the time delete_switch_port() returns, parent_port may
be free, and the subsequent device_unlock(&parent_port->dev) operates
on freed memory. The kernel log looks same as above, with a different
offset in cxl_detach_ep().

Both of these issues stem from the absence of a lifetime guarantee
between a child port and its parent port.

Establish a lifetime rule for ports: child ports hold a reference to
their parent device until release. Take the reference when the port
is allocated and drop it when released. This ensures the parent is
valid for the full lifetime of the child and eliminates the use after
free window in cxl_detach_ep().

This is easily reproduced with a reload of cxl_acpi in QEMU with CXL
devices present.

Fixes: 2345df54249c ("cxl/memdev: Fix endpoint port removal")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20260226184439.1732841-1-alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Fang Wang <32840572@qq.com>
---
 drivers/cxl/core/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 7f28d1021fa9..5326150a1c64 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -527,6 +527,7 @@ static void cxl_port_release(struct device *dev)
 	xa_destroy(&port->dports);
 	xa_destroy(&port->regions);
 	ida_free(&cxl_port_ida, port->id);
+	put_device(dev->parent);
 	kfree(port);
 }
 
@@ -657,6 +658,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport_dev,
 		struct cxl_port *iter;
 
 		dev->parent = &parent_port->dev;
+		get_device(dev->parent);
 		port->depth = parent_port->depth + 1;
 		port->parent_dport = parent_dport;
 
-- 
2.34.1

