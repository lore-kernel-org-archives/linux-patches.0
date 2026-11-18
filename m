Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041433;
	b=f9XnYMNctgO9N8y033SXQXm7SGieZrtc2qcLbInxswz8BuznpZ2fOFas6wjFQ0PX+94A
	 O6/29A2miOgDIB9Z5vAEusFV0GlW4dRGdXkONfj2UCEGcIUtoqFMNubx0spgntsGFbzu4
	 6bRyMB/BFYWy/O5xBOs8CqfDnj44a3/WIheQJ+g9vi9fY9xY0cUaV3vd9zB+EDV6w8KGZ
	 PfliS/UBsau2wTXTWtIi9KY0d6eMMQ5DwJhYd84h4uvc2hkdW2AfulE7XZeWI/fWdTMmZ
	 JRVGoi9C/IXYKtMgHRBHOdaR3FXp8GUbpVhXG+PicIfB4nkvde1qgcibeIIVbxjXOjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G9ruyDhST8nMy51mPEn1DbooOOJ6wh4IjRQriusDrtM=;
	b=QMtHm0g4dLNsBdgbV1Zrz8nPSiBF7HPGbeEf8ABz49CWVUJrj9ZXwbPhTqnr+I51bdzN
	 OH/wQJNUfiAKH1Y1Ixt8U2U34SztNtjt+r2EF56k/ES9jvziR0bKWVSzhq2FkffWUE32w
	 wHhtam+TENE1f8WfzEUoaCgb2guBvCfM3a/k4q7Dd65cT3AWhfnucgkLTC2815LGnmL2s
	 D9Jg3+Np2sx+cUhUuhOAe8K9PzniLKZD1iJPGhQpwqMgF6KV2eM13HgdIbWnpGAEGzL20
	 3+fmEsWw+r5/ZS5Y8wlx9GmiL0c43KHGID7GuCqx9r9201rOWqQTl+wRqVThHElOvnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAtWAUtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B1606A33A;
	Wed, 18 Nov 2026 22:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAtWAUtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9411F000CB;
	Wed, 18 Nov 2026 22:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041433;
	bh=G9ruyDhST8nMy51mPEn1DbooOOJ6wh4IjRQriusDrtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAtWAUtdtWi4qGZzw3mZYvqpsR9aMi6nSqGvIguiWv6ASY8tDsE/vXiXPn2Dlj8D0
	 nHFONr2Xs6LjpmXlfsn8cZHfMS0OchDaspgzY2elyOz7LreWgde0KowgA4Qzm52i63
	 SJ8w07YCOLBnhUV5lvGSrLXbAm0E6TkQuw22XgQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2813/3318] nvme-tcp: store and use the callers network namespace
Date: Wed, 18 Nov 2026 15:57:15 +0100
Message-ID: <20261118150445.049273301@linuxfoundation.org>
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

From: Surabhi Gogte <sgogte@purestorage.com>

[ Upstream commit 87a1ac965502858f9207153a92c3aef8ecf6d4ae ]

nvme_tcp_alloc_queue() creates each socket using
current->nsproxy->net_ns, which is correct for the initial connect that
runs in userspace context. However, the reconnect and error recovery
paths run from a workqueue where current netns is a kernel thread in
init_net, so sockets created during reconnect end up in a different
namespace than the one the controller was originally connected from.

Fix this by capturing the caller's network namespace at controller
allocation time. Use ctrl->net for all socket creation so that every
queue, on initial connect, reset, or reconnect, is created in the same
namespace.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Surabhi Gogte <sgogte@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index f87a726a0afd8..83347e01929ff 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -171,6 +171,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	struct net		*net;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -1650,7 +1651,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create_kern(current->nsproxy->net_ns,
+	ret = sock_create_kern(ctrl->net,
 			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
@@ -2348,6 +2349,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -2743,12 +2745,15 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		goto out_free_ctrl;
 	}
 
+	ctrl->net = get_net(current->nsproxy->net_ns);
+
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_tcp_ctrl_ops, 0);
 	if (ret)
 		goto out_kfree_queues;
 
 	return ctrl;
 out_kfree_queues:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 out_free_ctrl:
 	kfree(ctrl);
-- 
2.53.0



