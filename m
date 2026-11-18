Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049658;
	b=Ntl5l/74hlomAfKnXsX6DN0bPGWzs+5XyJKZdJ7fRvaeZe9fiV2wJeWnX+erUSGg4rT9
	 VHev9gyzGAF1LzDwFeEqSjmogEA0uGLyKqLfOJ/b53ZPEFLJ/n2PJKlw8UnOioQQpN61Q
	 lsLqE04yfyHeY26YHgXKExHqtxEunq87s/Qt5TYBbFONNkF9kzZDreOGThySZbPODheW/
	 /YB9HgVP/RGRPw9PyP7msM7Kn+lyudhmo+ok0tQUMJHvvaJv80u0BLMUd9+n21BDorQT3
	 YLTLD8GYpayKun1Z/ipDIlMkhh9wC27puq4OxSAeVRKS6XAobofFoWFeuH3GB2e8Qxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PIHy9x7lcjIfUVwyA3VsA8sZusE09+9FtzjM2fNcsyU=;
	b=FogisPkMoyzaRCx7upk17Y6VrPimnlYQDeTDsldHJrwqyf8tuwEa/t9IIbJHGiEaCWzw
	 Do1drZcbvEKXkmcd8SKzyJDIOMZJsaCi0LdHp4tqfJ+9tZjO0qxxeJuNNoKBciSx+1biM
	 nX2vukX77V59myD03jcJhpwvwK0PNg5hSz2gEBz/uln8gWnr2uLY24nkHOJgcL4yEIEo/
	 PFLcVyxo+GaX+UinFfjRRi7a/Dk15KtcN9lYQiJvLSpfDU5huFQ+w/1CZ2WOlpNccFGFj
	 VEBPo3tlnDFEi2jzqgOrTtTxHAidI2qSRBeNX++2avQ7gajG1ytNCn3+bsJ5BlMJ3Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJ3RMuvL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0093C606A31C;
	Thu, 19 Nov 2026 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJ3RMuvL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D85E1F000C5;
	Thu, 19 Nov 2026 00:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049657;
	bh=PIHy9x7lcjIfUVwyA3VsA8sZusE09+9FtzjM2fNcsyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJ3RMuvL1lKZ/quf9pPESrnTxoaVc9JUIKT0QVC/fgdiUBAc/zO+6zmYFl3UTaWu7
	 TUZsFcSR/9ecvoF9QUgqNYuIiMRUQ8TU/zsImtVgURxLxBG90K3kGSEgqYTNDKR0dD
	 gbk1nlK8fRVgLekj8B+qg5leGjSAe8OrgWz/DQ3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peijie Shao <shaopeijie@cestc.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2430/2857] nvme-tcp: fix selinux denied when calling sock_sendmsg
Date: Wed, 18 Nov 2026 15:57:44 +0100
Message-ID: <20261118150329.058117920@linuxfoundation.org>
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
index 883fe959d5507..13a66bb3b7892 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1621,7 +1621,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
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



