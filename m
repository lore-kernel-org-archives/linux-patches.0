Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026451;
	b=q7iDfN9yeiTY0IdSqtxZ9Z1KI8GoM684p43kRqDBAyDl9AbQ9UnLJJA/iHHk5QhRW9/E
	 x+n1XOnfwzgKxJTp2JhEKSgYM3j+MXDl2+hooQnqxMA3mYbqPhPe6QpBuaxxsXwfZd4eI
	 TLpleu1Mw6DKb10PyyO4MPsKLvUU5Cb0l0fNYno+y+SxDa+iSAzFjQ7D8tfE2F0EoJVLn
	 IpxDxAilQ8wt4h9fjTvngm3Vbl8Zmhub5ktVobXufhZPXza2J0KM0F32E98R5FELOdBom
	 H/w0155DpyBvyeJGrDd0g7sTg+cn6EnKWYml5CQ08pQD8MKAv7WZXoDavolRBR7EnDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlclnxIkEba/cwqL0F+PKEH8n4zDW6XpBonXpxuP0Eo=;
	b=OxcZlqiBpJcQVwBw7YGAZHOa2ukyTBMDJS/JXndcNnlxH4hP6h04VmV2P4BHcmp5D74W
	 ssYM/YJG4XKQNEiYA77Qa4Tyw3knLBjJ1PiwBrLYGujXwCz2+4uJomQ/x7Z3A7OBIJAE+
	 pSeEggsm9hrQk0wnsRUbOd8akdsuRxbOim9VakxvBzs6/jUxDODV5yT4g/IhEUTbYmpF1
	 hYZZ+2CMM6uQ1mYBMXhD4r0F6q2aMWNZv/06aD+TizkI0eKunpAOHOXTuNRHIp70i7lLb
	 GsXOoD7Hi0PN357JgUCK2GdgfuEqhxPQmJ0FDtBknc+qYk8WegoDn20ErH0FE/Hn08Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syl5vZ51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32D4606A325;
	Wed, 18 Nov 2026 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syl5vZ51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F107C1F000C4;
	Wed, 18 Nov 2026 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026451;
	bh=nlclnxIkEba/cwqL0F+PKEH8n4zDW6XpBonXpxuP0Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syl5vZ51H/n6glvs73omRzwTK9kh/YyHk0843RwPx/TiLB8K6P5REhwLZWTYBKUbq
	 MbH4tPIeuryonGjZj5Ar7lHFtfkSlrIToucMv028P8pO5jFJwZ3nXNeaZG9pmbum9r
	 wm55gBhvbWq1yPZ/m+YSD8VSQDmts1id3SPwVedA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1440/2151] nvme-tcp: store and use the callers network namespace
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150214.389552105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fad2f2f969a08..72afdd73939f8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -221,6 +221,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	struct net		*net;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -1999,7 +2000,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create_kern(current->nsproxy->net_ns,
+	ret = sock_create_kern(ctrl->net,
 			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
@@ -2781,6 +2782,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -3177,12 +3179,15 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
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



