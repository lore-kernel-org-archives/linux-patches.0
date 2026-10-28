Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214734;
	b=r36o4bifAmpRxEy40tFysBIJd0frLeqtqwSMc/KNObvfsiB9sCtNuYes8ZxZ6urRTEXW
	 k4P51FjTvBtMGGBYbropYa4uIfHx7yYMyxhf4FR1T4Q9n9Z+r7ppXUk15mZG2jhicHOfm
	 O+M6u9MPcL2L4Bk0imOXoNfbsAYb4+S+EuMyZSyfwAEHRUfwWjbmCYao9pQ6CVeuzPEW6
	 HrvX0AXT3UDaAbQmXhLFWKc3jt73BanzHE+X6e/8+4dmBTGraqxTZQf7/TDNv0EjFuZAy
	 O7dHbwvcTkWz1/W9yGaDguVUUWzqCTxzLCVY7XMIXc/4sHL+ub9XKyqSphfIzWf5TRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=61QqEj3MpiLb0fnG3QTu/1KZLtrjSad2V2fX/Elm88I=;
	b=1A2Az0e6nWvfqvwcmzIt5VwKc13WhH++iaPAcEmZJ8d2W1r5D3KW8aN4HCUWRBKArTm8
	 9jWRqZcZ/Smzu2nwiLRjPZgAUoBpm9HrRTdoBCY/vjP2INM7gvUnIsSiiwdHHHWQa1Wsi
	 cy9Oft1bb1CVyGK6gX7MbzvyucO1Q1HpHdYMrww0SdeyHV9ubH/41Vc9wpNnOo17RKEh4
	 Iu+VngBXkb8Mv/3zEJ1usjGfWoXw0ALezwxmDuiTGy4dxf1WKmuJHTpXw8Y3+Dwvc2mD6
	 VpF6EnveE6uXRf150x+uE40cNTkEtoGYH3R1m8WAmceiP4h5TjD4zlhHKyvtYYHK+qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qA0PuMjC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD1E606AB2A;
	Wed, 28 Oct 2026 19:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qA0PuMjC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C741F031E1;
	Wed, 28 Oct 2026 19:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214734;
	bh=61QqEj3MpiLb0fnG3QTu/1KZLtrjSad2V2fX/Elm88I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qA0PuMjCOlqDPQ3c8iT+cXpAzT/l29jf5lpGp3caha+EA9iR4jJiBudDu2c3K/zJV
	 eA34ckwDTfzLAiePL/5r5nXk4tO3k5EubPlMeByTXEcH72hrek/sAy7Xgyd67luvKq
	 SjmoDuu2GpZPwbfIIb9NPd9HbwQMD9WXLgwNdO38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0964/1887] usb: gadget: f_rndis: Fix net_device lifecycle with device_move
Date: Wed, 28 Oct 2026 17:51:00 +0100
Message-ID: <20261028170521.345870045@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit e367599529dc42578545a7f85fde517b35b3cda7 ]

The net_device is allocated during function instance creation and
registered during the bind phase with the gadget device as its sysfs
parent. When the function unbinds, the parent device is destroyed, but
the net_device survives, resulting in dangling sysfs symlinks:

  console:/ # ls -l /sys/class/net/usb0
  lrwxrwxrwx ... /sys/class/net/usb0 ->
  /sys/devices/platform/.../gadget.0/net/usb0
  console:/ # ls -l /sys/devices/platform/.../gadget.0/net/usb0
  ls: .../gadget.0/net/usb0: No such file or directory

Use device_move() to reparent the net_device between the gadget device
tree and /sys/devices/virtual across bind and unbind cycles. During the
final unbind, calling device_move(NULL) moves the net_device to the
virtual device tree before the gadget device is destroyed. On rebinding,
device_move() reparents the device back under the new gadget, ensuring
proper sysfs topology and power management ordering.

To maintain compatibility with legacy composite drivers (e.g., multi.c),
the borrowed_net flag is used to indicate whether the network device is
shared and pre-registered during the legacy driver's bind phase.

Fixes: f466c6353819 ("usb: gadget: f_rndis: convert to new function interface with backward compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-7-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_rndis.c | 42 ++++++++++++++++-----------
 drivers/usb/gadget/function/u_rndis.h | 31 +++++++++++++++-----
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
index 57c2246d0a4aa..8cdb2f4088950 100644
--- a/drivers/usb/gadget/function/f_rndis.c
+++ b/drivers/usb/gadget/function/f_rndis.c
@@ -679,6 +679,7 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 
 	struct f_rndis_opts *rndis_opts;
 	struct usb_os_desc_table        *os_desc_table __free(kfree) = NULL;
+	struct net_device		*net __free(detach_gadget) = NULL;
 	struct usb_request		*request __free(free_usb_request) = NULL;
 
 	if (!can_support_rndis(c))
@@ -696,21 +697,18 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 		rndis_iad_descriptor.bFunctionClass = rndis_opts->class;
 		rndis_iad_descriptor.bFunctionSubClass = rndis_opts->subclass;
 		rndis_iad_descriptor.bFunctionProtocol = rndis_opts->protocol;
-	}
 
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to rndis_opts->bound access
-	 */
-	if (!rndis_opts->bound) {
-		gether_set_gadget(rndis_opts->net, cdev->gadget);
-		status = gether_register_netdev(rndis_opts->net);
-		if (status)
-			return status;
-		rndis_opts->bound = true;
+		if (rndis_opts->bind_count == 0 && !rndis_opts->borrowed_net) {
+			if (!device_is_registered(&rndis_opts->net->dev)) {
+				gether_set_gadget(rndis_opts->net, cdev->gadget);
+				status = gether_register_netdev(rndis_opts->net);
+			} else
+				status = gether_attach_gadget(rndis_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = rndis_opts->net;
+		}
 	}
 
 	us = usb_gstrings_attach(cdev, rndis_strings,
@@ -809,6 +807,9 @@ rndis_bind(struct usb_configuration *c, struct usb_function *f)
 	}
 	rndis->notify_req = no_free_ptr(request);
 
+	rndis_opts->bind_count++;
+	no_free_ptr(net);
+
 	/* NOTE:  all that is done without knowing or caring about
 	 * the network link ... which is unavailable to this code
 	 * until we're activated via set_alt().
@@ -827,11 +828,11 @@ void rndis_borrow_net(struct usb_function_instance *f, struct net_device *net)
 	struct f_rndis_opts *opts;
 
 	opts = container_of(f, struct f_rndis_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
-	opts->borrowed_net = opts->bound = true;
+	opts->borrowed_net = true;
 	opts->net = net;
 }
 EXPORT_SYMBOL_GPL(rndis_borrow_net);
@@ -889,7 +890,7 @@ static void rndis_free_inst(struct usb_function_instance *f)
 
 	opts = container_of(f, struct f_rndis_opts, func_inst);
 	if (!opts->borrowed_net) {
-		if (opts->bound)
+		if (device_is_registered(&opts->net->dev))
 			gether_cleanup(netdev_priv(opts->net));
 		else
 			free_netdev(opts->net);
@@ -958,6 +959,9 @@ static void rndis_free(struct usb_function *f)
 static void rndis_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_rndis		*rndis = func_to_rndis(f);
+	struct f_rndis_opts	*rndis_opts;
+
+	rndis_opts = container_of(f->fi, struct f_rndis_opts, func_inst);
 
 	kfree(f->os_desc_table);
 	f->os_desc_n = 0;
@@ -965,6 +969,10 @@ static void rndis_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	kfree(rndis->notify_req->buf);
 	usb_ep_free_request(rndis->notify, rndis->notify_req);
+
+	rndis_opts->bind_count--;
+	if (rndis_opts->bind_count == 0 && !rndis_opts->borrowed_net)
+		gether_detach_gadget(rndis_opts->net);
 }
 
 static struct usb_function *rndis_alloc(struct usb_function_instance *fi)
diff --git a/drivers/usb/gadget/function/u_rndis.h b/drivers/usb/gadget/function/u_rndis.h
index a8c409b2f52f9..4e64619714dc2 100644
--- a/drivers/usb/gadget/function/u_rndis.h
+++ b/drivers/usb/gadget/function/u_rndis.h
@@ -15,12 +15,34 @@
 
 #include <linux/usb/composite.h>
 
+/**
+ * struct f_rndis_opts - RNDIS function options
+ * @func_inst: USB function instance.
+ * @vendor_id: Vendor ID.
+ * @manufacturer: Manufacturer string.
+ * @net: The net_device associated with the RNDIS function.
+ * @bind_count: Tracks the number of configurations the RNDIS function is
+ *              bound to, preventing double-registration of the @net device.
+ * @borrowed_net: True if the net_device is shared and pre-registered during
+ *                the legacy composite driver's bind phase (e.g., multi.c).
+ *                If false, the RNDIS function will register the net_device
+ *                during its own bind phase.
+ * @rndis_interf_group: ConfigFS group for RNDIS interface.
+ * @rndis_os_desc: USB OS descriptor for RNDIS.
+ * @rndis_ext_compat_id: Extended compatibility ID.
+ * @class: USB class.
+ * @subclass: USB subclass.
+ * @protocol: USB protocol.
+ * @lock: Protects the data from concurrent access by configfs read/write
+ *        and create symlink/remove symlink operations.
+ * @refcnt: Reference counter for the function instance.
+ */
 struct f_rndis_opts {
 	struct usb_function_instance	func_inst;
 	u32				vendor_id;
 	const char			*manufacturer;
 	struct net_device		*net;
-	bool				bound;
+	int				bind_count;
 	bool				borrowed_net;
 
 	struct config_group		*rndis_interf_group;
@@ -30,13 +52,6 @@ struct f_rndis_opts {
 	u8				class;
 	u8				subclass;
 	u8				protocol;
-
-	/*
-	 * Read/write access to configfs attributes is handled by configfs.
-	 *
-	 * This is to protect the data from concurrent access by read/write
-	 * and create symlink/remove symlink.
-	 */
 	struct mutex			lock;
 	int				refcnt;
 };
-- 
2.53.0



