Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213949;
	b=M2wUPRxfZ39vwj9jkYhZ3CSEYJ+V8J9Om8iEKsqUTWNMK59n22lntp/6vHjCFJipLdvN
	 ULHnLecQ+6QkKbVoA8Tn3xk7fpZUyDR5sBdoCINxdpzcw5a6CbEYIr2rtHUVYW0p4IwLV
	 tI/AeavUjMOy8DSc3nBLHvUWR8BNQH+nJfMVKL4hxoFji7QaGa2AQGFQfU3os+fITWUf5
	 g32ILyzEE/e76N6tKTIPQqwmTyIMTbiXk059zvIZZrK/VCbQ5jxJNltOBH5eAELq6RA18
	 gn2kyxUxjhn9MGUiy8O4XesVICOVTy3+iLcXlhgcdc7G5rxtqSIJx+PIN8WwWspEfyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5XcEKu2nnCJDqi+PSEmfMtLmBMsIdMa26qMPy9JaSVc=;
	b=SGPqrCPvObr7Pc32Z5uViFsyGygWMjhl8ejoCOKj7hoqTHCGeImGM+VgqMPNncareS1t
	 DLxWs0t/40NxcRUDzAeyoQclHFRopqmNCXJ9G/MSozMmOR1vm7ggneYsvydPpZL8JyJYB
	 23ytGlQUOc31Q3DiilzTf6R1l01jnYP5g3we22S87UL+VTiSQFREOUydc2mdTHsLA//Rd
	 G/gMTf4bSMH9kuylx38X7O/6wVh21fUl4oJdCESHaaDSUkdEwSf08ZbcZnCmSFi66djj2
	 Fg+0sxmSY3y9/VzgFan8rQ6BUcqTtKaiajLPtBdhtdEeb068EGRqFpJwwNRiLfQpGHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAfT5Uab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B080C606A322;
	Wed, 28 Oct 2026 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAfT5Uab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26C81F01825;
	Wed, 28 Oct 2026 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213948;
	bh=5XcEKu2nnCJDqi+PSEmfMtLmBMsIdMa26qMPy9JaSVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAfT5Uab/k+8invTLUZTjrDaYPFFcMpMDkSr7p89uoQxhZtW+D4Q6ls7xlPJGXLq7
	 2QKf2AETmjl2uYWDvUbTjfE13cPEZskBxEN4bfXlj1CnlcUiH3WYEeXj1wbw10X46o
	 sa48XjEeUWfVCEc2bslX57g9bm53Cja8T9wVtA9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0687/1887] firmware: arm_scmi: Move handle get/set helpers
Date: Wed, 28 Oct 2026 17:46:23 +0100
Message-ID: <20261028170515.047273166@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 971fc0665f1361f23251e4d85fac4aed1b683505 ]

Move handle get/set helpers definitions into driver.c and invoke them
through the bus notifier helper.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-7-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 17 ---------------
 drivers/firmware/arm_scmi/common.h |  4 ----
 drivers/firmware/arm_scmi/driver.c | 35 +++++++++++++++++++++---------
 3 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 7514b3e326114..14f96583b6e0d 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -347,27 +347,10 @@ scmi_device_create(struct device_node *np, struct device *parent, int protocol,
 void scmi_device_destroy(struct scmi_device *scmi_dev)
 {
 	kfree_const(scmi_dev->name);
-	scmi_handle_put(scmi_dev->handle);
 	ida_free(&scmi_bus_id, scmi_dev->id);
 	device_unregister(&scmi_dev->dev);
 }
 
-void scmi_device_link_add(struct device *consumer, struct device *supplier)
-{
-	struct device_link *link;
-
-	link = device_link_add(consumer, supplier, DL_FLAG_AUTOREMOVE_CONSUMER);
-
-	WARN_ON(!link);
-}
-
-void scmi_set_handle(struct scmi_device *scmi_dev)
-{
-	scmi_dev->handle = scmi_handle_get(&scmi_dev->dev);
-	if (scmi_dev->handle)
-		scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev);
-}
-
 static int __scmi_devices_unregister(struct device *dev, void *data)
 {
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index feccde5e29650..23f0ab3f2ed7f 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -96,10 +96,6 @@ static inline void unpack_scmi_header(u32 msg_hdr, struct scmi_msg_hdr *hdr)
 
 struct scmi_revision_info *
 scmi_revision_area_get(const struct scmi_protocol_handle *ph);
-int scmi_handle_put(const struct scmi_handle *handle);
-void scmi_device_link_add(struct device *consumer, struct device *supplier);
-struct scmi_handle *scmi_handle_get(struct device *dev);
-void scmi_set_handle(struct scmi_device *scmi_dev);
 void scmi_setup_protocol_implemented(const struct scmi_protocol_handle *ph,
 				     u8 *prot_imp);
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 9fa5632aa2c75..f01097b9e953a 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1934,13 +1934,6 @@ static bool scmi_is_transport_atomic(const struct scmi_handle *handle,
 	return ret;
 }
 
-static inline
-struct scmi_handle *scmi_handle_get_from_info_unlocked(struct scmi_info *info)
-{
-	info->users++;
-	return &info->handle;
-}
-
 /**
  * scmi_handle_get() - Get the SCMI handle for a device
  *
@@ -1952,7 +1945,7 @@ struct scmi_handle *scmi_handle_get_from_info_unlocked(struct scmi_info *info)
  *
  * Return: pointer to handle if successful, NULL on error
  */
-struct scmi_handle *scmi_handle_get(struct device *dev)
+static struct scmi_handle *scmi_handle_get(struct device *dev)
 {
 	struct list_head *p;
 	struct scmi_info *info;
@@ -1962,7 +1955,8 @@ struct scmi_handle *scmi_handle_get(struct device *dev)
 	list_for_each(p, &scmi_list) {
 		info = list_entry(p, struct scmi_info, node);
 		if (dev->parent == info->dev) {
-			handle = scmi_handle_get_from_info_unlocked(info);
+			info->users++;
+			handle = &info->handle;
 			break;
 		}
 	}
@@ -1983,7 +1977,7 @@ struct scmi_handle *scmi_handle_get(struct device *dev)
  * Return: 0 is successfully released
  *	if null was passed, it returns -EINVAL;
  */
-int scmi_handle_put(const struct scmi_handle *handle)
+static int scmi_handle_put(const struct scmi_handle *handle)
 {
 	struct scmi_info *info;
 
@@ -1999,6 +1993,23 @@ int scmi_handle_put(const struct scmi_handle *handle)
 	return 0;
 }
 
+static void scmi_device_link_add(struct device *consumer,
+				 struct device *supplier)
+{
+	struct device_link *link;
+
+	link = device_link_add(consumer, supplier, DL_FLAG_AUTOREMOVE_CONSUMER);
+
+	WARN_ON(!link);
+}
+
+static void scmi_set_handle(struct scmi_device *scmi_dev)
+{
+	scmi_dev->handle = scmi_handle_get(&scmi_dev->dev);
+	if (scmi_dev->handle)
+		scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev);
+}
+
 static int __scmi_xfer_info_init(struct scmi_info *sinfo,
 				 struct scmi_xfers_info *info)
 {
@@ -2278,8 +2289,12 @@ static int scmi_bus_notifier(struct notifier_block *nb,
 
 	switch (action) {
 	case BUS_NOTIFY_BIND_DRIVER:
+		/* setup handle now as the transport is ready */
+		scmi_set_handle(sdev);
 		break;
 	case BUS_NOTIFY_UNBOUND_DRIVER:
+		scmi_handle_put(sdev->handle);
+		sdev->handle = NULL;
 		break;
 	default:
 		return NOTIFY_DONE;
-- 
2.53.0



