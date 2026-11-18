Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041594;
	b=Q8WGKWKjeQWriFSCX9HmczoWV4sDIdNfye7vrBs0oOQBSIcih+mziibr/ITU6OAx1eQe
	 0xAI6VUbU6/J0mD9IuZ9Xj3KJf4dd6hYJm8YAqxyjMOgDv+Yg3gt8GpXzP+qIUD3Haop5
	 8MXaMrYxdwqsWFtNjYiMHy8xc16zWnyR8EVGOeDCWtlaCrHLaYubT8MbjbEHmrXK+moxA
	 r4Vq5j26DTwZ4Y9jB7CAkwBzCsmOYTMToOclOCohPTldeG3O4YdQdifktUkEC9kA3UHvt
	 EUclUejzhTJKRpa0+mYw+0htkgPdlJKjS4HCcAklCgmTdGb7Tz/Dzk2Q8HmnqVfe5kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9dLs6khm1VTwbNtS/Bv1Q4KLNtdslo4GSOFJVHvHzjw=;
	b=aV324l2xzWVtkV+OVnaWst3iASDobU2sr4aQAgepjiem0VFxf/Cl1INBAp6EdEOEaFtU
	 SCjSnTHfjYFYOEqf7o6rQjSggNY/jEtvZgrU9aIX/McfGAMH+x/pRjO+lskoqYSz//K2r
	 Nrh64cSMiJWa6d2Pb6/+IpT1IvYhYI87auOfmK1xjcXKHbf4ticRirwriXUF8HXlrTZs3
	 8z09GTso2sYTZlvwmTx39bFAPchRUj5knVoGouqThUMivPGnnJKZLZXfjmt9/9efzfq3W
	 g46vJbRKNtxdSAUMU3MJqEFz1WWYLReRUJ+ye9NWczEPO9RWfU41qRha6WuyaAXxMLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8zUyvJu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073D4606A6CC;
	Wed, 18 Nov 2026 22:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8zUyvJu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584A81F000C4;
	Wed, 18 Nov 2026 22:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041593;
	bh=9dLs6khm1VTwbNtS/Bv1Q4KLNtdslo4GSOFJVHvHzjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8zUyvJuKC7tDBG2AdlPjKUHRz8o5Qjj+HvJl8p3i36bm1Tj53bVChcP6T8bpnF+c
	 6YBuhJTJMA58lgB2ZTga1tnnyrNDFi4A4CcHJnNn9W5mdONIdj3OPqjY1eOa+MO/HA
	 6z7Upmomouy8tj3J0i1iXCX+r07VULciP63Zd0Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2869/3318] rpmsg: virtio: Remove uncallable offchannel functions
Date: Wed, 18 Nov 2026 15:58:11 +0100
Message-ID: <20261118150446.634624383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 905ac7910c98f..61aa75daa59d0 100644
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



