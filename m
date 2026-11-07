Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061832;
	b=LxGfjvmc1UNNnVIiNHkUwRjTTI8dXG4bDDDEUfh+IdRyD7UpKKe1ehuilzpUcg3a42Yb
	 eQesuVQe001ykaw5b1HmSejrdSUkjKswT5j32V9nl3CyFBXeNc5I2B/k2JCXqx/73ipGO
	 RMZmvFKMkaQAo393MwooRHFVA399zBI1f072KaC6TR5tiBo7767hJZW4h8XUCVuyshDfY
	 IiPwd/Ik2wv9Mt1NMMSlVySpjuExHYObdo34E+S6xT/bvx1JpEsMlbbqw6JqG3sDzKbP+
	 0uEPh0265RDKWlgvtONmBTmCYHH3n7evZGlBiVTSzvrruVqgiVzREPHM4CsjsBigebg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPgkCEIFDu9wBptWiuXqmQ1rmEmO6PjzfBHbRLZGCds=;
	b=kFQP7qi037oCwAgQpi0k8fkEsDPv0eEKtMUV72u6+dUPaUtRiJBeuGpehkEiOMQ/OuzS
	 ojc7HWDjW0RFLQQWtKWO8ul1rhiQ5YwzBvAif/xiTkKpnjacmsiUyz5hl7iWQXmsLL3uw
	 a9f2SejAw5mUbaJ9GUoSeVfbdnqA752xuNOEXJZAVbohFds3bJ2PpvTTFZUsG9FJEqHFF
	 NMiksIhC75OzKPLUYpBif29jhMjCIGaMlKa8AMkh1r/eOvTfrpZ4MLuugiiJRqbbAWbwx
	 qIXb+2xxVSUvRuumHwpo7jkoEVVS7qHW6e/S0jrYY63vCB1eb+5B9hmesrtGlqRd8Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSiF7lCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D0606A326;
	Sat,  7 Nov 2026 14:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSiF7lCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B71A1F0089F;
	Sat,  7 Nov 2026 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061831;
	bh=sPgkCEIFDu9wBptWiuXqmQ1rmEmO6PjzfBHbRLZGCds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSiF7lCMZulCvInz04iWdoRYfArT7a2ma8XJcTiV95oehIl0fB8BAm+ELREPQzzuz
	 QugZZ66kRRIvYeWdx2daME4eq3RGFg5EWyOUMvcBuMyZz74mCfq+26dk0yPvpkgDjT
	 8YguqbWrEl5w88jDEgNWu9ZRGqJ2NcP/uKhQrdc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Peter <mario.peter@leica-geosystems.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0853/1536] driver core: take parent lock in async device attach
Date: Sat,  7 Nov 2026 08:47:49 -0500
Message-ID: <20261107135021.506268263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Peter <mario.peter@leica-geosystems.com>

[ Upstream commit 187a62f99da29b1a55602b0d401a783d8dc86161 ]

For device types with need_parent_lock set (only USB interfaces),
probe() must run with the parent device locked. A synchronous attach
after device_add() gets this from the caller, e.g.
usb_set_configuration() holds the udev lock while adding interfaces.
__device_attach_async_helper() runs the probe from an async worker
instead, where that lock isn't held, and only takes device_lock(dev).

With async probing enabled for the hub driver (e.g. driver_async_probe=*
or driver_async_probe=hub), this races when a multi-TT hub is
configured. For multi-TT hubs, hub_probe() calls
usb_set_interface(hdev, 0, 1) to select the TT-per-port altsetting, and
usb_set_interface() creates the endpoint devices of the interface a
second time:

  usb_set_configuration()           async worker
    [udev locked]
    device_add(intf)
      queues the probe  ----------> __device_attach_async_helper()
                                      [intf locked, udev not locked]
                                      hub_probe()
                                        usb_set_interface(hdev, 0, 1)
    create_intf_ep_devs(intf)             create_intf_ep_devs(intf)

create_intf_ep_devs() checks and sets intf->ep_devs_created without a
lock of its own. If usb_set_configuration() has created ep_81 but not
yet set the flag, usb_set_interface() skips removing the endpoint
devices of the old altsetting and creates ep_81 again. With a
synchronous probe, hub_probe() runs inside device_add() with the udev
lock held, and usb_set_configuration() then finds ep_devs_created
already set.

Single-TT hubs don't call usb_set_interface() from hub_probe() and
don't show this warning, but their probe runs without the udev lock as
well.

On an i.MX8MM board with an onboard USB2514 hub this hit 11 of 100
boots:

  sysfs: cannot create duplicate filename '.../1-1/1-1:1.0/ep_81'
  Call trace:
   sysfs_warn_dup
   usb_create_ep_devs
   create_intf_ep_devs
   usb_set_interface
   hub_probe
   usb_probe_interface
   really_probe
   __device_attach_async_helper
   async_run_entry_fn

It also shows on v7.3-rc6 in QEMU, with dummy_hcd and a raw-gadget
program emulating a multi-TT hub: re-authorizing the hub in a loop,
while a SCHED_FIFO task preempts the writing task at random points for
3 ms, hit the warning in 29 of 6000 iterations.

Take the parent lock in __device_attach_async_helper() as well, like
__driver_attach_async_helper() does, and move
__device_driver_lock/unlock() up for that. With this the warning was
gone in 300 boots on the board and in 6000 iterations in QEMU.

Fixes: 765230b5f084 ("driver-core: add asynchronous probing support for drivers")
Signed-off-by: Mario Peter <mario.peter@leica-geosystems.com>
Cc: stable@vger.kernel.org	# 4.2
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ johan: switch to async_schedule_dev_nocall() to avoid deadlock if
         async_schedule_dev() runs synchronously when parent lock is
	 held ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261014133109.1392265-4-johan@kernel.org
[ Fold the nested conditions into a single if statement; correct commit
  message to mention "device types" rather than "buses" for
  "need_parent_lock". - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 83 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 57aa8d8b00428..5e8de1c3f7e95 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1040,6 +1040,38 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	return ret == 0;
 }
 
+/*
+ * __device_driver_lock - acquire locks needed to manipulate dev->drv
+ * @dev: Device we will update driver info for
+ * @parent: Parent device. Needed if the device type requires parent lock
+ *
+ * This function will take the required locks for manipulating dev->drv.
+ * Normally this will just be the @dev lock, but when called for a USB
+ * interface, @parent lock will be held as well.
+ */
+static void __device_driver_lock(struct device *dev, struct device *parent)
+{
+	if (dev->type && dev->type->need_parent_lock && parent)
+		device_lock(parent);
+	device_lock(dev);
+}
+
+/*
+ * __device_driver_unlock - release locks needed to manipulate dev->drv
+ * @dev: Device we will update driver info for
+ * @parent: Parent device. Needed if the device type requires parent lock
+ *
+ * This function will release the required locks for manipulating dev->drv.
+ * Normally this will just be the @dev lock, but when called for a
+ * USB interface, @parent lock will be released as well.
+ */
+static void __device_driver_unlock(struct device *dev, struct device *parent)
+{
+	device_unlock(dev);
+	if (dev->type && dev->type->need_parent_lock && parent)
+		device_unlock(parent);
+}
+
 static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
 	struct device *dev = _dev;
@@ -1049,7 +1081,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 		.want_async	= true,
 	};
 
-	device_lock(dev);
+	__device_driver_lock(dev, dev->parent);
 
 	/*
 	 * Check if device has already been removed or claimed. This may
@@ -1071,7 +1103,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 	if (dev->parent)
 		pm_runtime_put(dev->parent);
 out_unlock:
-	device_unlock(dev);
+	__device_driver_unlock(dev, dev->parent);
 
 	put_device(dev);
 }
@@ -1128,8 +1160,11 @@ static int __device_attach(struct device *dev, bool allow_async)
 	}
 out_unlock:
 	device_unlock(dev);
-	if (async)
-		async_schedule_dev(__device_attach_async_helper, dev);
+	if (async && !async_schedule_dev_nocall(__device_attach_async_helper, dev)) {
+		put_device(dev);
+		ret = 2;	/* retry synchronously */
+	}
+
 	return ret;
 }
 
@@ -1156,48 +1191,20 @@ EXPORT_SYMBOL_GPL(device_attach);
 void device_initial_probe(struct device *dev)
 {
 	struct subsys_private *sp = bus_to_subsys(dev->bus);
+	int ret;
 
 	if (!sp)
 		return;
 
-	if (sp->drivers_autoprobe)
-		__device_attach(dev, true);
+	if (sp->drivers_autoprobe) {
+		ret = __device_attach(dev, true);
+		if (ret == 2)
+			__device_attach(dev, false);
+	}
 
 	subsys_put(sp);
 }
 
-/*
- * __device_driver_lock - acquire locks needed to manipulate dev->drv
- * @dev: Device we will update driver info for
- * @parent: Parent device. Needed if the device type requires parent lock
- *
- * This function will take the required locks for manipulating dev->drv.
- * Normally this will just be the @dev lock, but when called for a USB
- * interface, @parent lock will be held as well.
- */
-static void __device_driver_lock(struct device *dev, struct device *parent)
-{
-	if (dev->type && dev->type->need_parent_lock && parent)
-		device_lock(parent);
-	device_lock(dev);
-}
-
-/*
- * __device_driver_unlock - release locks needed to manipulate dev->drv
- * @dev: Device we will update driver info for
- * @parent: Parent device. Needed if the device type requires parent lock
- *
- * This function will release the required locks for manipulating dev->drv.
- * Normally this will just be the @dev lock, but when called for a
- * USB interface, @parent lock will be released as well.
- */
-static void __device_driver_unlock(struct device *dev, struct device *parent)
-{
-	device_unlock(dev);
-	if (dev->type && dev->type->need_parent_lock && parent)
-		device_unlock(parent);
-}
-
 /**
  * device_driver_attach - attach a specific driver to a specific device
  * @drv: Driver to attach
-- 
2.53.0



