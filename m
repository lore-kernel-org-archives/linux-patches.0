Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041430;
	b=Tk6wxOZgTOGZjjmJHjBcU2VsoRDvxMD9eK2VKVaxLj0OzRgEfAggDC3gOgp5nzOgykyf
	 xX0pWlq06F9PnVturpMVH/1wZ0KhIUs0MDgIf+B91dOY7aTBxAvaWFTMijf46F+C0qTmh
	 imw95OzUox+0Bi5eMg9SpVqh+sFz2HNDAqWsB8RtVoVTptlf4lYQhg2UK6Z80apvsXjbb
	 C+nPHJ726MOriYb6vk3d2Hk7MZADiCv9b8gY9Zws2HI10jPrsso39MSt0EevLrd87Gvlp
	 w3VCdGwnsLsyfbHDKNmZK+8PNNx73uqzLA3I3e93Plwxsy8DZIAvL+Gm0nxYnzQV6FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFRdXM6kgEf/W3s/h4jWYkjgdECGtq2aB5f8kldSxAc=;
	b=XNMIPe0Bh/mlS1n2ChN+AHly/dJGixh5VUDfK05nSwIiAeRIWRlzxxrylA98Zkv0avaJ
	 REss5gzNZBB+enGNKtwwcoc8ZfctgwlMJ2Ctzvkm+4jFTbV1pjkFfdAlrpXStCDSjyEH1
	 2ePZjRNFgDOxZ9obRfxLeDCs3iQrMmS0cGNtXAeIdjTwrMIBcPAlXK1M8jPgPkkNUCzqD
	 OM+76OYBtpT7PYyM5s1kH1cVjw3h8wv0TJEsN3lYNe7MaO/06lwuHXhMiIHlDu6Qjeyy7
	 l8yjJT6/VoFw9SgsfSPkgf2bJ+k7CKYom2MXLyKc/2OJahudk/FnmA/oWkRuPKcnyWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=blllHvxK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E33606A33F;
	Wed, 18 Nov 2026 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=blllHvxK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2651F000C7;
	Wed, 18 Nov 2026 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041430;
	bh=gFRdXM6kgEf/W3s/h4jWYkjgdECGtq2aB5f8kldSxAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blllHvxKOps5N7k099vwZ0e7pz6MeSI02V8juLhOEf2mEpPZNFdkq/Nb//J7TZAdP
	 AK7h4mX8k6qfqtrfe8cqjqhTS+8zzIvF9YBQvLq2+uBzE8txJ8QTw7D6lf/U6doHJI
	 d6jC8pf2Ev7FcS8IxmaB8L5XheKKpZjFfan133sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peijie Shao <shaopeijie@cestc.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2812/3318] nvme-tcp: fix selinux denied when calling sock_sendmsg
Date: Wed, 18 Nov 2026 15:57:14 +0100
Message-ID: <20261118150445.020566733@linuxfoundation.org>
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
index ad55b9e3e1050..f87a726a0afd8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1650,7 +1650,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
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



