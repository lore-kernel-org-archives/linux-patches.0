Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217283;
	b=xp0V1gUQUjgUDisNeuyZxrd46ZnsBZzh7e5VCvl+KfHtz/UQKQbBKcv1gLY8MXTkFvOf
	 gjwXH3FXgzCtU1w2yfaA1okG36JgIQAztMw0NShQY7CO73D6URNfiajTcD1qQu35f12BT
	 o0Yv6Rm+ETH5jhdiIvzvLTS7jS0+lw/YDvLk/6uG0lY8JlRAGTLL5dbaMhFPzloxYTGLO
	 dheE2mmjc+nZ0AkND3MvHxOpLBCgMYj9UFnrKuY7FAVN/E/gxhBAnkVQnPvxYn2DiV/y3
	 fV2Bh2l3/ylOospOGXUh8bQ/viFxiGnC7+AVKCbb0R8AeQuAktwg3gRnMJweON/llxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1rzphSgPxAJUnB/TQtkqYQE6CjzmkEGDKPO413eMx1c=;
	b=IrXTA18BI4rSIPY+QZFgXG0nxGX+6ShCoJ4lTGlv3tLmcP3w2uXANPA7eObvJ7Pl/6Ub
	 gb14oTZopleSlm6yDa/b7opKcXZU684ZJG3cRSQZxtedSejCSajynYXFq+HO9DeB01h6B
	 UbjTe9bZnLuRzVgxjU9mLxdioTi6yP/Tfi+pMNpVK2OP6lc2Ax8odf7AGgqzBIw8ygxOx
	 pCumdeRsOKtguIYnsRkT84F+DkTuF1U9/8/1Dq6JKnSMJ5DyvakejUuiA35o4HMS4ef7H
	 S0uSORP3YFzeKnxTmyF0w+aEWoiDqejOJaX1tZU+sYCiaXNFkbrGML5rBfqYK0L4TNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWSkwrSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A481606A31A;
	Wed, 28 Oct 2026 19:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWSkwrSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4EA1F01825;
	Wed, 28 Oct 2026 19:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217282;
	bh=1rzphSgPxAJUnB/TQtkqYQE6CjzmkEGDKPO413eMx1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWSkwrSgr5/3BxvUFBdx9Tc4cHLnE8sLqwaCnyWoEAPuM9a3EvQV/P0xnInydatFE
	 JEY0NV3TVsT8f8nhedBfHHFrLZCfPFV4tCB7fZy7iB8lEGu6eHpJZ/aAeTZa95U77P
	 46CbiLHKvv2ZPfrqa+7Gx5hjNYOiBRhjCiRChUdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1833/1887] firmware: arm_scmi: Add internal platform/channel identifiers
Date: Wed, 28 Oct 2026 18:05:29 +0100
Message-ID: <20261028170541.157794341@linuxfoundation.org>
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

[ Upstream commit 75c86dc72dc80604e5e50fabb3c0cadee8c6087a ]

Add a couple of unique identifiers to channel and platform instance
descriptors in order to emit more descriptive message dump traces.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230118121426.492864-8-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: a71a3d4d8a6e ("firmware: arm_scmi: Use channel ID for transport teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h |  3 +++
 drivers/firmware/arm_scmi/driver.c | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 39bf362affa76..10409b43fb29e 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -159,6 +159,8 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
 /**
  * struct scmi_chan_info - Structure representing a SCMI channel information
  *
+ * @id: An identifier for this channel: this matches the protocol number
+ *      used to initialize this channel
  * @dev: Reference to device in the SCMI hierarchy corresponding to this
  *	 channel
  * @rx_timeout_ms: The configured RX timeout in milliseconds.
@@ -170,6 +172,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
  * @transport_info: Transport layer related information
  */
 struct scmi_chan_info {
+	int id;
 	struct device *dev;
 	unsigned int rx_timeout_ms;
 	struct scmi_handle *handle;
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 49b4a938cdb20..6c9107c32993c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -37,6 +37,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/scmi.h>
 
+static DEFINE_IDA(scmi_id);
+
 static DEFINE_IDR(scmi_protocols);
 static DEFINE_SPINLOCK(protocol_lock);
 
@@ -96,6 +98,7 @@ struct scmi_protocol_instance {
 /**
  * struct scmi_info - Structure representing a SCMI instance
  *
+ * @id: A sequence number starting from zero identifying this instance
  * @dev: Device pointer
  * @desc: SoC description for this instance
  * @version: SCMI revision information containing protocol version,
@@ -128,6 +131,7 @@ struct scmi_protocol_instance {
  *		bus
  */
 struct scmi_info {
+	int id;
 	struct device *dev;
 	const struct scmi_desc *desc;
 	struct scmi_revision_info version;
@@ -2102,6 +2106,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	}
 	of_node_get(of_node);
 
+	cinfo->id = prot_id;
 	cinfo->dev = &tdev->dev;
 	cinfo->handle = &info->handle;
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
@@ -2314,6 +2319,10 @@ static int scmi_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
+	info->id = ida_alloc_min(&scmi_id, 0, GFP_KERNEL);
+	if (info->id < 0)
+		return info->id;
+
 	info->dev = dev;
 	info->desc = desc;
 	info->bus_nb.notifier_call = scmi_bus_notifier;
@@ -2345,13 +2354,13 @@ static int scmi_probe(struct platform_device *pdev)
 	if (desc->ops->link_supplier) {
 		ret = desc->ops->link_supplier(dev);
 		if (ret)
-			return ret;
+			goto clear_ida;
 	}
 
 	/* Setup all channels described in the DT at first */
 	ret = scmi_channels_setup(info);
 	if (ret)
-		return ret;
+		goto clear_ida;
 
 	ret = bus_register_notifier(&scmi_bus_type, &info->bus_nb);
 	if (ret)
@@ -2429,6 +2438,8 @@ static int scmi_probe(struct platform_device *pdev)
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 clear_txrx_setup:
 	scmi_cleanup_txrx_channels(info);
+clear_ida:
+	ida_free(&scmi_id, info->id);
 	return ret;
 }
 
@@ -2462,6 +2473,8 @@ static int scmi_remove(struct platform_device *pdev)
 	/* Safe to free channels since no more users */
 	scmi_cleanup_txrx_channels(info);
 
+	ida_free(&scmi_id, info->id);
+
 	return 0;
 }
 
-- 
2.53.0



