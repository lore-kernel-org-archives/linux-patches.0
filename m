Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031688;
	b=kR2J07x9zvbtynUeToh9PtDgSHlLRW3/ggLkL+ZaMJ20nFq2C5d7vxyrc2pAqUHEjNp2
	 9I7bbXMEqxK/ooOwQIbya9uFSvNdbdAmhcHyT8s4rclJ6n6NN6wsWr3NOL8GfUv9gx1QV
	 JKjvLZU9OFNKVM4Siwx+cVTwLdIbHpgDEnRlhLdkFSMcmXk7A/vo/5e1UmiJVtatiZbZ5
	 aPu+bsDl2h6/lWPtEC2KKlZrpxpUhrQwzgg3irOEynY5s91c0BxMLC7FtbJC9rp6GAysl
	 Hll8H7ObBuAvTXPOlBJE3PPZfP5n2ysJRUc+4zTWncIkLk2jlRanAq06rtSXXNlt0/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G4RB8lzQlM2L6N/6InEtcv5cEfvVZsJ6pgce2LSK5fE=;
	b=3lAORZ2pQZVXEdujedWXmgwvsW80kOBFvv+pz5ytvdiFS4kQMB0hB1mRscxkPLCGS/Aw
	 HPdqGF+AE0Tt/lwp9DErWQYuj04pF1eVuxsoU0qE7GksF4qEneK2p7a/7rQ+t7hDN/ynA
	 3Uulo7dukObK7JmmrGNP388WshArpl+P0HH+juZBXfXdvMusFr9UMXNpccER4aorb0buF
	 zOwX7SQsOe9uHRclUG8LwreRCNsdiyI6SOPrb8wDtaxYrFBjOljfy41l2x4qGpEtG7nu2
	 w3PY6Q9pObq8/mTaKoHayXwbEWBcQkSwMLaH0NHCQ9ISDLoiaXazZiMMjqke3ux/WQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6DGgdJG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874A7606A325;
	Wed, 18 Nov 2026 19:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6DGgdJG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9CB1F000C4;
	Wed, 18 Nov 2026 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031688;
	bh=G4RB8lzQlM2L6N/6InEtcv5cEfvVZsJ6pgce2LSK5fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6DGgdJGZU6sb3JISqbHj4F7oZJfgWyoIgVKMmmB1HsKO2Aq8yqNEFZ04t8Oz2XXv
	 6j1RFm2JNdraweo2SUEKb1DrvmzV2QnXQU2CjQ3cI+Mm1j2V+ppRpgoCZGJkrIo4fu
	 j33l5N5oUokP6kcBcNZA56rw8S1LurJsZVQkNYZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peijie Shao <shaopeijie@cestc.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1144/1756] nvme-tcp: fix selinux denied when calling sock_sendmsg
Date: Wed, 18 Nov 2026 15:54:31 +0100
Message-ID: <20261118150055.587364758@linuxfoundation.org>
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
index 951506216714d..23d559d567d88 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2033,7 +2033,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
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



