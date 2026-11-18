Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031864;
	b=O7YL6sWkvF+226ld8duu3TweBzw9a4Ak8XiJnN6wvkEhJnfRbjBHQqWsgIZTlOdHutad
	 //kkhVM7ZZ2fsKWFgIyJ7zLdfwEUmAapOjjjJCWwWwfU/SexGZRZeKxMVuHfHbB42yO3I
	 37nxcwrdAwYUPFqv4i961EiCT3o0Z4G/JMvqaFFRONInEI5GkduzZu1a8FY4lfx6pN8Fs
	 gyJyFXS7ccyeNNcYKz+fU5gSx071Kp0h1niiihaQGySrtsBMDWTrtvqGmzbWbbo07ck4V
	 Hi3Jey9Xqb7l1LFGgg0jgcM9FVplnpc5u9NdewgS1EygTyDRDN1s6II/FghFpVhylGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/VMWSFHotIk5aJz1kXkBq50ZmZ/a9NmTuoX1xVUzDQ=;
	b=PXoP3vz7JcmIS2kbXi5PbTpe2g/aoo81Jl9z9zbRFgHZxBcgUth9W3Gi8QaBPBsgd5Vu
	 crIAZ1nic6r7fTgBHp5xC3GW+ixPlWP2/HjKKklMIhGSEVEGLJdjsYqqXkaasn0VB3mWg
	 OYn+T79jyZlEOc2CW0jJzfeTnfh/BXmJlosMJ+IbvR95BxMz5KCctJX/Cg//+z0YE9smn
	 Y59w2XXJoeCxFvSGgI+EeyAdxrdoDaimxpGpVxGX89FvXRoFZ5Tl81tSqiDJowSMj1q0+
	 0UhdkEXZblPbZnFbp/Xla6RdqQ02BJMc5U9rKvZl5bsR61F9ctJgv5rC4UYKhMuWs5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzGh5oQ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02832606A320;
	Wed, 18 Nov 2026 19:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzGh5oQ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FB21F000C4;
	Wed, 18 Nov 2026 19:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031863;
	bh=O/VMWSFHotIk5aJz1kXkBq50ZmZ/a9NmTuoX1xVUzDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzGh5oQ5Gt2YT+WF2UdPQpm7+woN4bpEoQuGZ0J7dlz8P1pGWNjTKTz10uyd8cLEq
	 4x5QLiB4o+RW8NfCcIni3O8fF3JltycxQeLoksdeJBXbWd0YJ3kemTVxmFTd68LX6H
	 CmOb+2MQYxg7iEP1g19zqJ3OAF497pNoupI0/OmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1209/1756] rpmsg: virtio: Remove uncallable offchannel functions
Date: Wed, 18 Nov 2026 15:55:36 +0100
Message-ID: <20261118150057.942722400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index ee60e4580c81b..4f446316ba90d 100644
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
 
@@ -544,7 +538,7 @@ static void rpmsg_downref_sleepers(struct virtproc_info *vrp)
  * the function will immediately fail, and -ENOMEM will be returned.
  *
  * Normally drivers shouldn't use this function directly; instead, drivers
- * should use the appropriate rpmsg_{try}send{to, _offchannel} API
+ * should use the appropriate rpmsg_{try}send{to} API
  * (see include/linux/rpmsg.h).
  *
  * Return: 0 on success and an appropriate error value on failure.
@@ -664,14 +658,6 @@ static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
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
@@ -689,14 +675,6 @@ static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
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



