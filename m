Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056271;
	b=x848TYmnGPTeiHwuCaeQcAlIz4ah7MqxhsWsO+4YejGxjI0zG/TlPgxhU/u1LIhRvBph
	 s7+X4fJXP3GNtQ+rCZrLVSGq0S5Fx1Eg2G4NuCwu9cIyIijMh804kv3jT/FwBUkUa+eQF
	 17L9RwyPxVT6DgmDXeM4vjAsuDyncABm+fC5JQwzb0Hs6NwPlfU/0dF9omHzFK0+sEqXR
	 mbtTjiEkqnf+fHddJ+yCgg8dyOU2xR+rn6mcyaR5l6oH3M51TTAfW01dYHBHHzz1bQsqZ
	 Mhz8Vwn+6yHFLvJ0cidDYUh2pbugYBH7Gwfl0tSyT9juhB5WwIpRvtMPbiE34WVnRCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QnR664uuoJlnWrtbHyW9oqLagxxd029hddkJ/NL+KR8=;
	b=liyoTevEYbJDC+u5tzlLYLnQ1+divka79oIjiWG1pQAnvK6hhrXAPj+x0krbmHlGW7Ed
	 eGfzMxhTonsqxAZwzGjhZhx3iQqS5wxK7W8xKrtkaLk2c9+T2cxaxoLYee7a7r/rDAGQ7
	 zK3flQ6zQN/T0kBGUjR+gwZtG//H0vLEm5/CLcY5wvPC7+ax1BZ7P+ejW1HN2bs7GQyzC
	 fqadtz/omfC/7C1VDSlwuvDmBBP9Xz0GC1u3Q0nORnAIEFTR6BgDHQTXe21Uby3vBCRAv
	 XEnWrIRhTbkBK5G9y6M3Q5LUep5oTO5sY6EBP5xUKefvjq2mKb1bgtaDCio3mZtEG/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SckzMpGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB09E606A31C;
	Thu, 19 Nov 2026 02:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SckzMpGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE001F000C4;
	Thu, 19 Nov 2026 02:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056271;
	bh=QnR664uuoJlnWrtbHyW9oqLagxxd029hddkJ/NL+KR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SckzMpGgV+MBXJZsIZajR5zfG+rvPwz+STy30u1DHn9X/7GS0Fdtr8FstDSFb2ObD
	 JvI8vDvnJIb3ZKLMBLLm0oqIahRJLJcfqaaZq2vzYwx/ZIVXkygCnV6LiFLcFFy5NU
	 6qrnRtAmYJAHCG/iuYz781WuhBPQRvkiXaVDh/xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Suman Anna <s-anna@ti.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1928/2214] rpmsg: core: add API to get MTU
Date: Wed, 18 Nov 2026 16:00:04 +0100
Message-ID: <20261118150128.150879716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

[ Upstream commit e279317e9aeb11d8670e0a5acb10d50566eea9c9 ]

Return the rpmsg buffer MTU for sending message, so rpmsg users
can split a long message in several sub rpmsg buffers.

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20211015094701.5732-2-arnaud.pouliquen@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 7dd4cffdf4c2 ("rpmsg: virtio: fix error handling in TX buffer wait")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/rpmsg_core.c       | 21 +++++++++++++++++++++
 drivers/rpmsg/rpmsg_internal.h   |  2 ++
 drivers/rpmsg/virtio_rpmsg_bus.c | 10 ++++++++++
 include/linux/rpmsg.h            | 10 ++++++++++
 4 files changed, 43 insertions(+)

diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index 71a0af90eb882..62ee5ae789cf9 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -327,6 +327,27 @@ int rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src, u32 dst,
 }
 EXPORT_SYMBOL(rpmsg_trysend_offchannel);
 
+/**
+ * rpmsg_get_mtu() - get maximum transmission buffer size for sending message.
+ * @ept: the rpmsg endpoint
+ *
+ * This function returns maximum buffer size available for a single outgoing message.
+ *
+ * Return: the maximum transmission size on success and an appropriate error
+ * value on failure.
+ */
+
+ssize_t rpmsg_get_mtu(struct rpmsg_endpoint *ept)
+{
+	if (WARN_ON(!ept))
+		return -EINVAL;
+	if (!ept->ops->get_mtu)
+		return -ENOTSUPP;
+
+	return ept->ops->get_mtu(ept);
+}
+EXPORT_SYMBOL(rpmsg_get_mtu);
+
 /*
  * match a rpmsg channel with a channel info struct.
  * this is used to make sure we're not creating rpmsg devices for channels
diff --git a/drivers/rpmsg/rpmsg_internal.h b/drivers/rpmsg/rpmsg_internal.h
index 7985af92aa489..9304a8a2aadaf 100644
--- a/drivers/rpmsg/rpmsg_internal.h
+++ b/drivers/rpmsg/rpmsg_internal.h
@@ -53,6 +53,7 @@ struct rpmsg_device_ops {
  * @trysendto:		see @rpmsg_trysendto(), optional
  * @trysend_offchannel:	see @rpmsg_trysend_offchannel(), optional
  * @poll:		see @rpmsg_poll(), optional
+ * @get_mtu:		see @rpmsg_get_mtu(), optional
  *
  * Indirection table for the operations that a rpmsg backend should implement.
  * In addition to @destroy_ept, the backend must at least implement @send and
@@ -72,6 +73,7 @@ struct rpmsg_endpoint_ops {
 			     void *data, int len);
 	__poll_t (*poll)(struct rpmsg_endpoint *ept, struct file *filp,
 			     poll_table *wait);
+	ssize_t (*get_mtu)(struct rpmsg_endpoint *ept);
 };
 
 struct device *rpmsg_find_device(struct device *parent,
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index b863ebb9f6ec9..21826d13ca79f 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -149,6 +149,7 @@ static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
 				  int len, u32 dst);
 static int virtio_rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src,
 					   u32 dst, void *data, int len);
+static ssize_t virtio_rpmsg_get_mtu(struct rpmsg_endpoint *ept);
 static struct rpmsg_device *__rpmsg_create_channel(struct virtproc_info *vrp,
 						   struct rpmsg_channel_info *chinfo);
 
@@ -160,6 +161,7 @@ static const struct rpmsg_endpoint_ops virtio_endpoint_ops = {
 	.trysend = virtio_rpmsg_trysend,
 	.trysendto = virtio_rpmsg_trysendto,
 	.trysend_offchannel = virtio_rpmsg_trysend_offchannel,
+	.get_mtu = virtio_rpmsg_get_mtu,
 };
 
 /**
@@ -697,6 +699,14 @@ static int virtio_rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src,
 	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
 }
 
+static ssize_t virtio_rpmsg_get_mtu(struct rpmsg_endpoint *ept)
+{
+	struct rpmsg_device *rpdev = ept->rpdev;
+	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
+
+	return vch->vrp->buf_size - sizeof(struct rpmsg_hdr);
+}
+
 static int rpmsg_recv_single(struct virtproc_info *vrp, struct device *dev,
 			     struct rpmsg_hdr *msg, unsigned int len)
 {
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index a63c5a4ff3e15..523c98b96cb41 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -190,6 +190,8 @@ int rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src, u32 dst,
 __poll_t rpmsg_poll(struct rpmsg_endpoint *ept, struct file *filp,
 			poll_table *wait);
 
+ssize_t rpmsg_get_mtu(struct rpmsg_endpoint *ept);
+
 #else
 
 static inline int rpmsg_register_device_override(struct rpmsg_device *rpdev,
@@ -306,6 +308,14 @@ static inline __poll_t rpmsg_poll(struct rpmsg_endpoint *ept,
 	return 0;
 }
 
+static inline ssize_t rpmsg_get_mtu(struct rpmsg_endpoint *ept)
+{
+	/* This shouldn't be possible */
+	WARN_ON(1);
+
+	return -ENXIO;
+}
+
 #endif /* IS_ENABLED(CONFIG_RPMSG) */
 
 /* use a macro to avoid include chaining to get THIS_MODULE */
-- 
2.53.0



