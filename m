Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056277;
	b=33AjZd9l2YR/YiFaZW2m/PSDY2avqBpHcq74Uz5iMbzzJK/4D04BKgl+XdZXti+VCB7Q
	 bmWYoCLbgXAYiadJN45aKXIAAOqIkG/qKxSL8mFuY7A7gG3wJ7/0d6SY0v2GjF2GFZT/F
	 Xgoy+m4VGvjCFsuWPI5nrwu0Lxg1eOWqs44SEtdmeaImTmakNTlIIY3tmH9WSwMY76zIr
	 M5OHzy9EgXwu1DRI5GSD5AJ+QhboTcYadSRqrd1LyQlU1d+p9DTXymXxyxzbMpoOwGHEW
	 udzvwAiUJyZ6IKedDvwnlB+n18112lm6RpqiU3w0q8p9UbVEIwZH11HSx+k0Nz6J4BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsqaOYxY2YNO9Gjr+p8ctVHC6BEB6P1o/zRmpB2sSBc=;
	b=ONmldqLmHZ30LUkSp81CJpvd7dpjK8CDp9zY9dRBZTL3fNlRu2Tqvzek5UlkAFf3cX8S
	 g4lxRr6oydWpsF4EkMmhCjzKGE4u5H91wxIWw1Pppx+8j3EzPpOgSoPS8aGskCOjD1774
	 odyK3VBxlAtjMwlCKSYW9tFxs3+pqOJdhZs5crvFvUgd7pWEJCsRprizdpvFtUhikHz2k
	 rCXRQIKScpjlLr+p6F+T/9uDwkyxNBnL7JnwfcukHnqrgysUwAbFt/dWZ3u2PLyLCxJJy
	 CwO6yAS0Y0O+uoaJFi4XrB3kSWV4lN0ah7QLXl+fIG+HqY6yJt9e9DQ4sfEFgzNBL9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZDdEDBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F7D606A31C;
	Thu, 19 Nov 2026 02:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZDdEDBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95001F000C4;
	Thu, 19 Nov 2026 02:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056277;
	bh=UsqaOYxY2YNO9Gjr+p8ctVHC6BEB6P1o/zRmpB2sSBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZDdEDBasi1JgGmOnwS1IHgZKP6sCb/XDtRLH/Ohc4H1qnZUzmJ9Rkj1MpwHGeXRT
	 S2UChYXiUmVbhk9DFWg1NhXFAH+B5U8dp56xbRgoTA2QmFG97g1lTIM0gpxPeH4n19
	 QEafwxRbPuKTSJ5uOEKbktoV+iypHksmURDkX2jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1929/2214] rpmsg: virtio: Remove uncallable offchannel functions
Date: Wed, 18 Nov 2026 16:00:05 +0100
Message-ID: <20261118150128.185501417@linuxfoundation.org>
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
index 21826d13ca79f..50c0747c05aaf 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -142,13 +142,9 @@ static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
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
@@ -157,10 +153,8 @@ static const struct rpmsg_endpoint_ops virtio_endpoint_ops = {
 	.destroy_ept = virtio_rpmsg_destroy_ept,
 	.send = virtio_rpmsg_send,
 	.sendto = virtio_rpmsg_sendto,
-	.send_offchannel = virtio_rpmsg_send_offchannel,
 	.trysend = virtio_rpmsg_trysend,
 	.trysendto = virtio_rpmsg_trysendto,
-	.trysend_offchannel = virtio_rpmsg_trysend_offchannel,
 	.get_mtu = virtio_rpmsg_get_mtu,
 };
 
@@ -546,7 +540,7 @@ static void rpmsg_downref_sleepers(struct virtproc_info *vrp)
  * the function will immediately fail, and -ENOMEM will be returned.
  *
  * Normally drivers shouldn't use this function directly; instead, drivers
- * should use the appropriate rpmsg_{try}send{to, _offchannel} API
+ * should use the appropriate rpmsg_{try}send{to} API
  * (see include/linux/rpmsg.h).
  *
  * Returns 0 on success and an appropriate error value on failure.
@@ -666,14 +660,6 @@ static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
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
@@ -691,14 +677,6 @@ static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
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



