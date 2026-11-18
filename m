Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061590;
	b=b1b04DZUXQ5xQyHR5kRRI5vOWHBHFCQKU9hng17J1vWDXQAyRyyGlgHuGN7SUNbN8U+L
	 73GI59bthe+tfWpVi8SEOWTAvDAd+7DhKuxM2kT5Lx/Ld88JXS0YYHiSc2RMKpIRjkri4
	 RCMIDQVDSjE05519G/FCW5cbSivvRrBqYEbBqrfpfFb9pLeVdIu1SAT5YWC2uEr/TdgIg
	 2n/7AXHXJkWlr3RjpBQiYBXDpyEDugu4WGb2NpyBTHVm7bxW3dg4aDitWlVYfuYRaM8v0
	 V40k0Cqlko+v3VYhp3bF9RCrxAYD4mv4vIWPQQDNQ3EPQxaHZ6rce4E+Xj6WxO8j3fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9VJsJ5ilirJoBFAessncNTgq8hN5Sr1Iu4whr7MH48=;
	b=lknrr5cbqZdnnHDR+b6/sAVUM7hjONIW5lRCk+Yj9VAYH1ULGLMdLBX4G8K6wzRIbs0f
	 YFTdOYHXKxBNA+M0xhDl8oIRAGfng4z5dtzkoKRFGkQtjN603RWenb1eP2WliDSdrZCUC
	 v7ZKLPe2jSZg1JagQyKFFekUBr+mAHP35ls80RobR3yvT+KkQuVPgOyCmEh1lSjQtXlTq
	 Z2apgyzWeIfuYdSyPj6MUSvhAwb6CVplPWMmZxv/5zSQMTYqugn4rLSmdPLfqQ92f2yiI
	 X81A0Uou/57udFqHHhD0HqulnIMYB+70Yp1jVF+n9gAPDSbhDz3SMy4Fy3fwkuklbpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tz9ZkwY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859E1606A33A;
	Thu, 19 Nov 2026 04:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tz9ZkwY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F0D1F000C4;
	Thu, 19 Nov 2026 04:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061590;
	bh=V9VJsJ5ilirJoBFAessncNTgq8hN5Sr1Iu4whr7MH48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tz9ZkwY0zPTmfmpm3W/C1c3j2EgrJ1e1jC2me+QNKskyAPg9AbBQvX8XhFkxGHMZV
	 OjMRHYUMLFuUPSUJDwSi/85LbUAR/7ET2k0bxatwWG0Hplqux6g5rYJgpsYfRkHgVL
	 b8qLxvygO7v4D+H49RPmiKk2DnxHT/45sjxdBMx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peijie Shao <shaopeijie@cestc.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1608/1848] nvme-tcp: fix selinux denied when calling sock_sendmsg
Date: Wed, 18 Nov 2026 16:00:46 +0100
Message-ID: <20261118150026.860938037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peijie Shao <shaopeijie@cestc.cn>

[ Upstream commit 1be52169c3488ef98582ed553ab35cefa3978817 ]

In a SELinux enabled kernel, socket_create() initializes the security
label of the socket using the security label of the calling process,
this typically works well.

However, in a containerized environment like Kubernetes, problem arises
when a privileged container(domain spc_t) connects to an NVMe target and
mounts the NVMe as persistent storage for unprivileged containers(domain
container_t).

This is because the container_t domain cannot access resources labeled
with spc_t, resulting in socket_sendmsg returning -EACCES.

The solution is to use socket_create_kern() instead of socket_create(),
which labels the socket context to kernel_t.  Access control will then
be handled by the VFS layer rather than the socket itself.

Signed-off-by: Peijie Shao <shaopeijie@cestc.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 87a1ac965502 ("nvme-tcp: store and use the caller's network namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 306c13dec74a5..e9776ad102d0e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1503,7 +1503,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create(ctrl->addr.ss_family, SOCK_STREAM,
+	ret = sock_create_kern(current->nsproxy->net_ns,
+			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
 		dev_err(nctrl->device,
-- 
2.53.0



