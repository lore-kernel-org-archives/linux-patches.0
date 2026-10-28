Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213934;
	b=d9zAMsYibdAmPJdb7RGyyI5xInUYtAe09wCDA+T84nIUrLZkN6SVa1iARuUpnxRTC7SD
	 p164ozpukv0Gr2n8pgUGcYTN0TUsFuOKu4J9PkqnIk2CW24V9VU6PKYaASEbSE3M0jWgR
	 QMvCKudtUhmdmUdWctbbsIUzAuz5+ZUewIk94WbUlaG+mz4cHJUIrXeZd9S8bc6Si3CB0
	 JcmD1c6Iu05CmnYOEeSwdRZdHzA86V88JmoLqNIsVVMNneJDTXsqTankwlVFe3VGLtQNj
	 o/tkiDsCK10cemPNT1oexSejgMF1sikN4++FmvbkV6v/+Fm9CzpiIcKN2ED8fy283fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdmEY8EoGNQfjgDvKSAkfKzUfjwJ5TuozOph/2+zFNk=;
	b=FT6PlJ2XhHkE5HLCWl30eOId9HBm2QbA/3/Vkrl9fbr15B4Hwd+swulhE9MLO8/S/ibS
	 yXOatL7Yc8co6Bl2KJ0MXOtHnJBWlw1icowF0h1fYn5T9cJMFzah04Yn+5dGseKtuKezN
	 6eF/Q4TDwwvY6YlL2J6ffzlPFE51Z0+b5xrucieh5rPnlFL954wC8uXN5U5dkhJ0C0vK5
	 b15oqcqS482PAnJypH1JnCC+VL3XHL4tPYO6MVeeXy705XgXs9Y4pny3Wt5QVZXtn3v/d
	 3+WF9s62eFR3yvyYxow12JyFbM9zep9IQGIyN57JxvrWSCKaZacajZkKuMqGySLleMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOtBpS9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854CC606A31A;
	Wed, 28 Oct 2026 18:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOtBpS9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8984A1F01825;
	Wed, 28 Oct 2026 18:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213934;
	bh=tdmEY8EoGNQfjgDvKSAkfKzUfjwJ5TuozOph/2+zFNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOtBpS9DFI7IfF/5h2h76YLcFa/WGqEgI9ytqpPEomPIeVPIdprVRCAI2tNQbNbbs
	 09KcZC37Qwbmu9YPHPeYiTjX88UMgp02s4r80xrVEhKtxGjgo1IiG1Ur5hCZ6+it8k
	 dCLIWLqikqmljBusx/MFrYC2GKS8fuCY385zQ7BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0682/1887] firmware: arm_scmi: Simplify chan_available transport operation
Date: Wed, 28 Oct 2026 17:46:18 +0100
Message-ID: <20261028170514.933447844@linuxfoundation.org>
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

[ Upstream commit 7a75b7afd8ff7b891e60b2fc9622148e6d1e010a ]

SCMI transport operation .chan_available determines in a transport
specific way if an SCMI channel is still available and to be configured.
Such information is derived by analyzing bits of device node in a
transport specific way, all it needs is a device node to operate up on,
not necessarily a full blown device.

Simplify the helper to receive in input a reference to a device_node
instead of a device carrying a pointer to such device_node.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-2-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h  | 2 +-
 drivers/firmware/arm_scmi/driver.c  | 2 +-
 drivers/firmware/arm_scmi/mailbox.c | 4 ++--
 drivers/firmware/arm_scmi/optee.c   | 4 ++--
 drivers/firmware/arm_scmi/smc.c     | 4 ++--
 drivers/firmware/arm_scmi/virtio.c  | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 4ac72754c2554..15882266910b6 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -153,7 +153,7 @@ struct scmi_chan_info {
  */
 struct scmi_transport_ops {
 	int (*link_supplier)(struct device *dev);
-	bool (*chan_available)(struct device *dev, int idx);
+	bool (*chan_available)(struct device_node *of_node, int idx);
 	int (*chan_setup)(struct scmi_chan_info *cinfo, struct device *dev,
 			  bool tx);
 	int (*chan_free)(int id, void *p, void *data);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 53fd9b17b9bd3..f6d1063699f1e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2047,7 +2047,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device *dev,
 	if (cinfo)
 		return 0;
 
-	if (!info->desc->ops->chan_available(dev, idx)) {
+	if (!info->desc->ops->chan_available(dev->of_node, idx)) {
 		cinfo = idr_find(idr, SCMI_PROTOCOL_BASE);
 		if (unlikely(!cinfo)) /* Possible only if platform has no Rx */
 			return -EINVAL;
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 81c902672a305..2017f93599e66 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -60,9 +60,9 @@ static void rx_callback(struct mbox_client *cl, void *m)
 	scmi_rx_callback(smbox->cinfo, shmem_read_header(smbox->shmem), NULL);
 }
 
-static bool mailbox_chan_available(struct device *dev, int idx)
+static bool mailbox_chan_available(struct device_node *of_node, int idx)
 {
-	return !of_parse_phandle_with_args(dev->of_node, "mboxes",
+	return !of_parse_phandle_with_args(of_node, "mboxes",
 					   "#mbox-cells", idx, NULL);
 }
 
diff --git a/drivers/firmware/arm_scmi/optee.c b/drivers/firmware/arm_scmi/optee.c
index f5f6ec83d3e1f..78d5dd399aba0 100644
--- a/drivers/firmware/arm_scmi/optee.c
+++ b/drivers/firmware/arm_scmi/optee.c
@@ -328,11 +328,11 @@ static int scmi_optee_link_supplier(struct device *dev)
 	return 0;
 }
 
-static bool scmi_optee_chan_available(struct device *dev, int idx)
+static bool scmi_optee_chan_available(struct device_node *of_node, int idx)
 {
 	u32 channel_id;
 
-	return !of_property_read_u32_index(dev->of_node, "linaro,optee-channel-id",
+	return !of_property_read_u32_index(of_node, "linaro,optee-channel-id",
 					   idx, &channel_id);
 }
 
diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index 42ea308a2c1d5..795f7ccc89b12 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -54,9 +54,9 @@ static irqreturn_t smc_msg_done_isr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static bool smc_chan_available(struct device *dev, int idx)
+static bool smc_chan_available(struct device_node *of_node, int idx)
 {
-	struct device_node *np = of_parse_phandle(dev->of_node, "shmem", 0);
+	struct device_node *np = of_parse_phandle(of_node, "shmem", 0);
 	if (!np)
 		return false;
 
diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 1db975c088969..a917eca7d9024 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -385,7 +385,7 @@ static int virtio_link_supplier(struct device *dev)
 	return 0;
 }
 
-static bool virtio_chan_available(struct device *dev, int idx)
+static bool virtio_chan_available(struct device_node *of_node, int idx)
 {
 	struct scmi_vio_channel *channels, *vioch = NULL;
 
-- 
2.53.0



