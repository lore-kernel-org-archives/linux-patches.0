Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217260;
	b=B889iScg6MlpJQ55EG+U/NEFXf8fkL9weq8aLg3CIX05dgaDH9rc0Qm53LGTK7fnkzR2
	 d2BVzyHtzY24gc+Gqqkz+JbYBSNKz4QsyJgEP2iup++4GxqNY9AVy5BKZ9w+t3n6PidJi
	 JgGoAJjQAYdHiWS5MZ/w/OgZ82+yOMiLpVczS44o7OBFdWlY3L9YXeJOoFg9Y6jpGjaHZ
	 ZUU0TmjZYt6UPINgLiZR7HP5MeiGcP9TZKAbt14YEQ48Fma/XjhHf8rZOimjWKtYNh6jv
	 i+zeGDNFILacwCowLY9N6Oo7vcZqJBGnLEmXO6rKI1WhCj/cgRHJznfI2RDtYmjMGog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DY35QU8EJCpowLwzEYoEHwMXnu0Bw7HcdtYJmxpYuDA=;
	b=2+4Jp5bth/5cvDvtnwUl0b0NeCceOS8oUCvT5wrk+yEOrDkXs/xP4Q8mddk4mxeh3WAA
	 HXwP2g9+eRI2XrFB5vd5EZRv2bBeWgKcnTbGPETzSfw3OpsGkwPXOWgH46SaHQeXAP/Mj
	 oDgHA1f7rasl4RUoeuDdVp55MrYwEyui/n53XcxeGTKXXK/p4TDLXy+8vdPKhE/m2Izh/
	 h6hONXoMFH+d+UAEvnZ7iQ57ZDCwOqXXwvTw4ON1t9+KWlFw1yt0dKNFzh8QZfKVCRNX1
	 10tGASBwL0eDPe0Py9SkGi//pgF42CobK64c7+kD+FIQolrQcxyqXCJB6DBSrFeArOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaD4M70p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24A606A31C;
	Wed, 28 Oct 2026 19:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaD4M70p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509631F01825;
	Wed, 28 Oct 2026 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217259;
	bh=DY35QU8EJCpowLwzEYoEHwMXnu0Bw7HcdtYJmxpYuDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zaD4M70pG9nHy14GOebF3cyu9xC6bbkJxW17d/kZqD9MZXi95O/vUowzWYjXN3EZW
	 xmIRByh1brTbIKj/K/mOwLg6Pt1M26tj7bkfHFbV/0bDh18m9COrn2zgKOZY4Yu0Xh
	 acA2zp+H8+PUvyvLludHBLwebvuUVn5HIPuasY9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1843/1887] firmware: arm_scmi: Drop handle on protocol bind failures
Date: Wed, 28 Oct 2026 18:05:39 +0100
Message-ID: <20261028170541.388906325@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit e3a5c30d233ca5d3e799a80da806554c703bda13 ]

The SCMI bus notifier acquires an SCMI handle when the driver core emits
BUS_NOTIFY_BIND_DRIVER, before invoking the protocol driver probe
callback. The protocol probe path only checks whether sdev->handle is
set.

If device_link_add() fails after the handle has been acquired, the
protocol device can still bind with a valid handle but without the
dependency link to the SCMI parent. A concurrent parent unbind can then
miss the child and tear down the SCMI instance while the child still
holds a handle into it.

If the protocol driver probe later fails, for example with
-EPROBE_DEFER, the driver core emits BUS_NOTIFY_DRIVER_NOT_BOUND rather
than BUS_NOTIFY_UNBOUND_DRIVER. The SCMI notifier only released the
handle on BUS_NOTIFY_UNBOUND_DRIVER, so each failed protocol-device bind
leaked the SCMI instance users refcount and left sdev->handle set after
the failed probe.

Make the link helper report failure and drop the acquired handle if the
link cannot be created. Also handle BUS_NOTIFY_DRIVER_NOT_BOUND in the
same cleanup path used for unbind so failed probes balance the earlier
BUS_NOTIFY_BIND_DRIVER acquisition.

Fixes: 971fc0665f13 ("firmware: arm_scmi: Move handle get/set helpers")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-10-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 31 ++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 57c608ebb0bbe..85791e836d1e9 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1958,21 +1958,31 @@ static int scmi_handle_put(const struct scmi_handle *handle)
 	return 0;
 }
 
-static void scmi_device_link_add(struct device *consumer,
+static bool scmi_device_link_add(struct device *consumer,
 				 struct device *supplier)
 {
 	struct device_link *link;
 
 	link = device_link_add(consumer, supplier, DL_FLAG_AUTOREMOVE_CONSUMER);
 
-	WARN_ON(!link);
+	return !WARN_ON(!link);
+}
+
+static void scmi_clear_handle(struct scmi_device *scmi_dev)
+{
+	if (!scmi_dev->handle)
+		return;
+
+	scmi_handle_put(scmi_dev->handle);
+	scmi_dev->handle = NULL;
 }
 
 static void scmi_set_handle(struct scmi_device *scmi_dev)
 {
 	scmi_dev->handle = scmi_handle_get(&scmi_dev->dev);
-	if (scmi_dev->handle)
-		scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev);
+	if (scmi_dev->handle &&
+	    !scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev))
+		scmi_clear_handle(scmi_dev);
 }
 
 static int __scmi_xfer_info_init(struct scmi_info *sinfo,
@@ -2251,6 +2261,7 @@ static int scmi_bus_notifier(struct notifier_block *nb,
 {
 	struct scmi_info *info = bus_nb_to_scmi_info(nb);
 	struct scmi_device *sdev = to_scmi_dev(data);
+	const char *status;
 
 	/* Skip transport devices and devices of different SCMI instances */
 	if (!strncmp(sdev->name, "__scmi_transport_device", 23) ||
@@ -2261,18 +2272,22 @@ static int scmi_bus_notifier(struct notifier_block *nb,
 	case BUS_NOTIFY_BIND_DRIVER:
 		/* setup handle now as the transport is ready */
 		scmi_set_handle(sdev);
+		status = "about to be BOUND.";
+		break;
+	case BUS_NOTIFY_DRIVER_NOT_BOUND:
+		scmi_clear_handle(sdev);
+		status = "NOT BOUND.";
 		break;
 	case BUS_NOTIFY_UNBOUND_DRIVER:
-		scmi_handle_put(sdev->handle);
-		sdev->handle = NULL;
+		scmi_clear_handle(sdev);
+		status = "UNBOUND.";
 		break;
 	default:
 		return NOTIFY_DONE;
 	}
 
 	dev_dbg(info->dev, "Device %s (%s) is now %s\n", dev_name(&sdev->dev),
-		sdev->name, action == BUS_NOTIFY_BIND_DRIVER ?
-		"about to be BOUND." : "UNBOUND.");
+		sdev->name, status);
 
 	return NOTIFY_OK;
 }
-- 
2.53.0



