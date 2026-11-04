Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830881;
	b=4jeyVj5qyG7DqRtPGc8Qe3fxLiKOlPkjrqntgR+dEvtPCJmi3QqkhZ7G6knMGkOZo3zV
	 Us4UJ4n5SjpXIBr89ZAyGyocJQFdYp+65EY4TH15pOeCgIBTRcmmiucNS/dvEmqx6I8Ph
	 HT0MRQNTH6d8XH6tigw4bN+WXjs3dsI0VqJCQQsMmfDTPov0I6v9aKuebQjbHX0sVYnGy
	 QIP8UdeE0ImuwSXK4ZtcCHDzkD+zkeOmHh2Ivep1Ff7RnpADjE+ZVPfuFRXxuK0IB7DTz
	 DuBQMJC2QD3Si5upc4MWTcElLBUjoX1lNHR1w06+d/bWrTKBXE+jn3DmuOe9ePgVn4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DnyLQYgY+RSliOtRHzD8/ZD3dM9Pbc4pFxHYyG4OO9M=;
	b=t+jvN8r9k5uAJ+IP6sWoaBIjZFPzlKUBKh3gO+TAh5ixrcWUFlisL+VheR6sLlIZt8Jj
	 /xpgnI3JrWd2FHdf41BZf93l0eIpl/Zlrk7LpsR6BS9Q95LhfbV7i/kKTaDldsuJKWLhV
	 ip2/Mxfs+yzQUS8ApOYzcxKZCurYU77zw0ECUcp3JeP+jSsEGOKDf4JRZQH46a+wqPAVa
	 4rrkvFa+iGNkYcVI/qCfeTrGhZg9Yk7fOlNDv0K6L3hqgXBxnNlCvmy1RU08GQTllBO18
	 hxtAqtQ7wwynTgTCAGVYhOh7P15xk+SfbFuPOLSz+ZGWs0C70nRGnjvh5e5nNPBzWUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XN2Nkkfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D219606E831;
	Wed,  4 Nov 2026 22:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XN2Nkkfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7691F0093A;
	Wed,  4 Nov 2026 22:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830881;
	bh=DnyLQYgY+RSliOtRHzD8/ZD3dM9Pbc4pFxHYyG4OO9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XN2NkkfrJ/nVY1X2ksUWLAEgAHsqqYRX1xhYFhnw65yICXvZ7K9p9HragNvzHTuqs
	 zx+b2yuKrd+N79ap4bTyzYlZe9kDEEg1juqITFUmUOBr83MvmzWxkaTakXhb3rQYjp
	 nLNvFTN4DU9pBjbru1dsFJBgqNod0fPAr8Ep+5cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0377/1005] nvme-tcp: look up host_iface in the current netns
Date: Wed,  4 Nov 2026 16:01:50 -0500
Message-ID: <20261104211054.654024296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 58202950e39c127d593ec4f0624d8b8985a285b1 ]

nvme_tcp_alloc_ctrl() looks opts->host_iface up in &init_net, the boot-time
netns. When called from any other netns - e.g. the selftest's ns2, where
ns2eth1 actually lives - the lookup misses and the controller setup fails
with "invalid interface passed":

 nvmet: adding nsid 1 to subsystem nqn.2014-08.org.nvmexpress.mptcpdev
 nvmet_tcp: enabling port 24660 (0.0.0.0:24099)
 # nvme discover -a 10.1.1.1 --tos=0x10 --host-iface=ns2eth1
 nvme_tcp: invalid interface passed: ns2eth1
 # failed to add controller, error invalid interface

Look the device up in current->nsproxy->net_ns instead so the check sees
the calling task's netns.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index beef2b576102a..1f26e35d7a99e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2999,7 +2999,8 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 	}
 
 	if (opts->mask & NVMF_OPT_HOST_IFACE) {
-		if (!__dev_get_by_name(&init_net, opts->host_iface)) {
+		if (!__dev_get_by_name(current->nsproxy->net_ns,
+				       opts->host_iface)) {
 			pr_err("invalid interface passed: %s\n",
 			       opts->host_iface);
 			ret = -ENODEV;
-- 
2.53.0



