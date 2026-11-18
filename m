Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056158;
	b=nqbrtF7kphna1YRi9/+XdBdxGIM1jn8FK9ALGqOf6pflrSIaqq5aASfkZzU6g5qXD1Fp
	 DCoQMT3Ahi0nI4UliBHL+9hR64p6q2NPw1v4zZzV0Z33L1PR7HBzXzHEIVx2BYNWjqvTj
	 7XcjoSZsxjAXMry5atPGn78tF/vwSCq84SR461GaDc4ZtY6bloXq5JMkOi5rKrK5Z/kV8
	 paKEsldzqmzlYl7FKozsacTAxur2CD+YNH7qoXlrFW7MicXnjdhG4r5tKpCNcsfxVqDz2
	 uKs/nGgtxBc3hStryJr4TvE5M4RGtQK9SV/drHaHlBBv9UvrCYo0yii+/xZ0pccEU8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GuJjWXs6qWD+aGGIeKvJy4J0Fk7Iro2QxJQpf02vXa8=;
	b=IWqH//UYwfLOtFyJCMMiy9dI5J1M3YBdd6XkM7LHb9V4i8nldxdxSNPvnT7ZwVc93GEi
	 KhLbVbaKbeRtslBH6n5NCmCfCuQnIw5c6JccuXC9A5odZEfN1MJ70xKSeek20OX/hxeJw
	 a8tKgVbkb/n9n1JNpTHIweOHE2l3J0rYQdpaP0zT11og868oV6BiI/5BqpYBv2Yq/op01
	 P5Osjrl9mFgm9zQ5ldpOQQ6l8AdOjg3chRRhlhPHgoSAsK5BVfUMjdm28hpL+djK25PyS
	 Uciq6VvbjxoXGd+9Aq3whU5/tvIZrXHFUjgeFMOOz9wjV/N9iMBFBCbs3RoV7GHfLtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/6URiTM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C90606A31C;
	Thu, 19 Nov 2026 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/6URiTM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBE11F000C4;
	Thu, 19 Nov 2026 02:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056158;
	bh=GuJjWXs6qWD+aGGIeKvJy4J0Fk7Iro2QxJQpf02vXa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/6URiTMvRLQlHYXC0QV+5j5HUTKfsIDW4A9NOdvxAzT+XKJije0DUbJDdpo6cZP4
	 8Hy5qNwIAZMla5t2ib0HPVQbUfMcgFyMniwiswhjzGRYXhmjTBeZjIUyX8eQX2QIr0
	 hSMDLnvlRpCpF7ksikZVDJPb1Cs9MDVl0wh/37Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peijie Shao <shaopeijie@cestc.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1887/2214] nvme-tcp: fix selinux denied when calling sock_sendmsg
Date: Wed, 18 Nov 2026 15:59:23 +0100
Message-ID: <20261118150126.710018529@linuxfoundation.org>
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
index ff6bcc31163e1..5106092a8a299 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1504,7 +1504,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
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



