Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049804;
	b=5h5LlEqfuA1mdrnWx8Q768aVbDVazf0VzfZyuXGWlSfNQX51I/4HBC6thEuijT8KXpzu
	 Kc4OpaccBZzTJ1lE+JqvApo1l5M6fPm7yZg0rtqIVG+zYufz3scNBzFIvJm1mGKZ0LEAK
	 j1eNi/Mnu1TCcFzsphVVosaQLirVxgctrfwS/rvSmr4AVtTd83WlsdaL3SEpPb5UP4DVU
	 GUAAyoE24+MUhZRQRpxWgqcjJt/fdyaciX2dA9F6wtBZ/dzwRWu4C/YBEg6/7tWgpcxkF
	 X2wJ63IB0jywOfxDA2r68FOq25zeryLDaHRtbSDJbzOjcVLJRix95VMCm9JIBoNAqaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSEG0R9UOrP61b6OXqImg6nifECeNcnwd0nsdCn4TVA=;
	b=ofbiZLYU+n03+8hz0zX60WBLfwtnC3FckYvY6MQ9AoTFG4tUPJAcyPHWN1J2NaiC0RqX
	 D7KYgExhiBMtjwj+sc020gz3NbNut/TCVxhSlDPhIp2fPYQGa7DPH9tWMa6i7ltyjeRl2
	 kKBNejyOCF7LWOAlCWOhorg2fPkHgcUPOUGLcsCnlqNLdSfJ3yDdNGdRm/b021i5KcbXN
	 v6CCiJMLiBeZWmB7+WKpla2E8CfESQNyGR9q0I/ROWUPhQxIVl/KtxIBDNIjhDVE+GCVc
	 eRKZXSumiiohbUOP483sdPnv/16tPITy2XwjuvbVaRV3HAHgunYy5j8tysCgu8/40sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dc6CQ62j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E68606A31C;
	Thu, 19 Nov 2026 00:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dc6CQ62j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AB21F000C5;
	Thu, 19 Nov 2026 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049804;
	bh=pSEG0R9UOrP61b6OXqImg6nifECeNcnwd0nsdCn4TVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dc6CQ62jwDSwNOWAjb4osGZfJtCgq0Edbgv4B7u4KSVHLZy23CdRYiPmWnsK+XVpZ
	 85WlJTijdeX2th0zInJ4mJfQl3L1CSsBAZZ/7gwyztL7elI4PZZ6/6pZTiAdg7tYBq
	 DXiovVB/4moizV8Se7JW+ZR/sg4g5VPDnxOlmpfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2481/2857] rpmsg: virtio: Remove uncallable offchannel functions
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150330.891334673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Dr. David Alan Gilbert <linux@treblig.org>

[ Upstream commit 68decaf24d4d24f4f8708a248e65e9d77ea19b85 ]

The virtio_rpmsg_send_offchannel() and virtio_rpmsg_trysend_offchannel()
are wired up to the send_offchannel and trysend_offchannel members
of rpmsg_endpoint_ops, the only dereference of those was by
the unused, and now removed rpmsg_send_offchannel() and
rpmsg_trysend_offchannel() functions.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Acked-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20250429234600.301083-3-linux@treblig.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 7dd4cffdf4c2 ("rpmsg: virtio: fix error handling in TX buffer wait")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f1af0f6746150..9d1921c76b15f 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -141,13 +141,9 @@ static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
 static int virtio_rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len);
 static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
 			       u32 dst);
-static int virtio_rpmsg_send_offchannel(struct rpmsg_endpoint *ept, u32 src,
-					u32 dst, void *data, int len);
 static int virtio_rpmsg_trysend(struct rpmsg_endpoint *ept, void *data, int len);
 static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
 				  int len, u32 dst);
-static int virtio_rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src,
-					   u32 dst, void *data, int len);
 static ssize_t virtio_rpmsg_get_mtu(struct rpmsg_endpoint *ept);
 static struct rpmsg_device *__rpmsg_create_channel(struct virtproc_info *vrp,
 						   struct rpmsg_channel_info *chinfo);
@@ -156,10 +152,8 @@ static const struct rpmsg_endpoint_ops virtio_endpoint_ops = {
 	.destroy_ept = virtio_rpmsg_destroy_ept,
 	.send = virtio_rpmsg_send,
 	.sendto = virtio_rpmsg_sendto,
-	.send_offchannel = virtio_rpmsg_send_offchannel,
 	.trysend = virtio_rpmsg_trysend,
 	.trysendto = virtio_rpmsg_trysendto,
-	.trysend_offchannel = virtio_rpmsg_trysend_offchannel,
 	.get_mtu = virtio_rpmsg_get_mtu,
 };
 
@@ -545,7 +539,7 @@ static void rpmsg_downref_sleepers(struct virtproc_info *vrp)
  * the function will immediately fail, and -ENOMEM will be returned.
  *
  * Normally drivers shouldn't use this function directly; instead, drivers
- * should use the appropriate rpmsg_{try}send{to, _offchannel} API
+ * should use the appropriate rpmsg_{try}send{to} API
  * (see include/linux/rpmsg.h).
  *
  * Return: 0 on success and an appropriate error value on failure.
@@ -665,14 +659,6 @@ static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
 	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, true);
 }
 
-static int virtio_rpmsg_send_offchannel(struct rpmsg_endpoint *ept, u32 src,
-					u32 dst, void *data, int len)
-{
-	struct rpmsg_device *rpdev = ept->rpdev;
-
-	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, true);
-}
-
 static int virtio_rpmsg_trysend(struct rpmsg_endpoint *ept, void *data, int len)
 {
 	struct rpmsg_device *rpdev = ept->rpdev;
@@ -690,14 +676,6 @@ static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
 	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
 }
 
-static int virtio_rpmsg_trysend_offchannel(struct rpmsg_endpoint *ept, u32 src,
-					   u32 dst, void *data, int len)
-{
-	struct rpmsg_device *rpdev = ept->rpdev;
-
-	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
-}
-
 static ssize_t virtio_rpmsg_get_mtu(struct rpmsg_endpoint *ept)
 {
 	struct rpmsg_device *rpdev = ept->rpdev;
-- 
2.53.0



