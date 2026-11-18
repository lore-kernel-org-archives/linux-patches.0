Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034262;
	b=WWQdpYwJL4eusBZNxwrLbfPIURdc8nPfzKGw2esbTv2PMGekg8tic60AVaYYZs+JUURJ
	 Ksp87KTGYPqrwuOOcguK3aWnYXAgxyJVsJgRDwGVRYkjFmzy1Qod7ZBVcRLPa6fpgV0jJ
	 3Cst7Yw6u43ailn9F8vxfba2IClaQbDsVzakdQVfSwOutq5DmQmq1NTGjxbQwxgxWLFqC
	 7t7xJniyOTLR2iQCJyDvwo0CipueX+7nVpqJVUgJoXOQl4n/cNlm3KlfpU8a0lwkIn4TE
	 DAoSmgEMsQMCnqBrXn7BdVy+roWhy3Di406UlKTklM06J5l+X8VEodJsUliLhsYzUgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJWKS/63M1j0hfyMZ9LYl4wz4wBOka2tnCunqZYOAhY=;
	b=GzMEz8lx08NsKDNSF8dUPJDoSXU7KUoQ6YY5MWNtsHR4CPlY6A/BNcrfYGmpV68XESJf
	 6FdxndWH/QkB/MF9N7ReatbkNlc7Yn0+oTEqUDI59QEIfukvMjHv5xFYyzrabNXouRWoo
	 ZjklsC0ZVcs/X7HaSIu7qs/c54S9b+FoDRQNVUOCBhnCFVNwGrbqwpRq9i+XfLRFVrrzH
	 ir4/zaCfO6Ccz38jtUbT9M7AW0xZ8oAGAmAovNLla2nQmgi0I3NEEQRoOPj25ZVpROtkb
	 PsX45MfmCQLSFlTLtoegh1JaW3wbwTzafL2pARYKG9/StbwHwbiRowdqyQWUwSdomLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6pSAF9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08AA606A32C;
	Wed, 18 Nov 2026 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6pSAF9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3431F000C4;
	Wed, 18 Nov 2026 20:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034261;
	bh=zJWKS/63M1j0hfyMZ9LYl4wz4wBOka2tnCunqZYOAhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6pSAF9n1I/1M4FVOSGyIvsN0mnMWfexS2cUyjjfWnkamCh2lTpcultmnGKpVpSgW
	 LlhMEC4R4GORcxm/ze1T+SRHTNVXj6R3QmqFU8jM8SHxrB9rHMONqH1WrzM6N5A8YQ
	 Gw3Tn/plVQfEhMh1QYXVcmLvRdzLbjsxZZcCXUaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0307/3318] virtio_balloon: warn on failed buffer add in tell_host()
Date: Wed, 18 Nov 2026 15:15:29 +0100
Message-ID: <20261118150324.987450884@linuxfoundation.org>
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

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 198eda395067b56ee605de076f0519620f4e5d90 ]

tell_host() ignores the return value of virtqueue_add_outbuf() and goes
on to kick the queue and wait_event() for the host's ack. The comment
claims "We should always be able to add one buffer to an empty queue",
but that does not hold once the virtqueue has been broken (e.g. on
device shutdown): the add then fails with -EIO and the following
wait_event() would block forever on a buffer the host can never return.

Warn and bail out on failure, mirroring virtballoon_free_page_report().

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260624140846.2616797-5-den@openvz.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index b47db0e44eb52..34296c1c6bf1f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -147,16 +147,18 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
 	unsigned int len;
+	int err;
 
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	err = virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	if (WARN_ON_ONCE(err))
+		return;
 	virtqueue_kick(vq);
 
 	/* When host has read buffer, this completes via balloon_ack */
 	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
-
 }
 
 static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
-- 
2.53.0



