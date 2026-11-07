Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060954;
	b=zKk4u5R9EMz7b9Gf9t+Qcw5NJ83FNzQmwez1QFZ2SACJOUfuPLDMy1v4JcnGIqRKko0D
	 WNOkq9DfeYiK19unKuhpilQvYuaOlTH0shVnWnkOLoEZRubX1E/6FpQhfzXIUcW2PpVku
	 HcAD4yitFlkk9ZQFzbGqgEkTsLT6xKPettPJtZdivMSjGYFCgOP3CnwXOj5ZcQWu5fDWQ
	 nrQuNx7FF1GHq113Walj//FSMe9uIgAArhcp1vUaPR9nJuKsszPWdkcdT5jmyl26NIP7Y
	 RCLXOHzcIu1NAADJc84ByojLd/POiwbS4dj+9/nrNNEzsnOMzAoVxBg42KxB2qKRvpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qyC0sAQH4mapRIbmXQBx1Vxb+t/mYKvfqex/EBH6PiM=;
	b=rGHfcZus8WSqbo3BA5t/zbDNxjWvDXKDq2nyU85VNeq5oFnqjdsGDWyM5Nn4jeqRexo9
	 yYze0nZx7q0dfGbyGubPM3s8ia0aUN65KuXEsmgrjZegcVexgkVKzwDKhlvJ96LpF9Rfc
	 BHywiF+lGeB4B5co7VrvUCGeZfB6zXELuu24rdfqkMUqcyeqlgvOp6o0xhHTLLJbhEDuy
	 8L9DvSMZ6o/GK63HHduXmFP+ncNfjDSHXHxyHj2zz8mknm0HCRlbbki9i+8EMymxPSOHI
	 heA4ajk3dlUwpkFkPe8Ele8b5/pfgq+sLTx5F7tFQJW12zfss/25sKIwYNTyS5F0WTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=inoPep34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218C6606D814;
	Sat,  7 Nov 2026 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=inoPep34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B333E1F0089F;
	Sat,  7 Nov 2026 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060954;
	bh=qyC0sAQH4mapRIbmXQBx1Vxb+t/mYKvfqex/EBH6PiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inoPep34wj6NezRHd6tLi9TnaLLLvrMnAbrZc3E3WiEPoSKJpxl8Db+HmpCUdmv4V
	 FN09FD0jNUVCBl3zkqF1bQ8d+V5qTka04F3tJEvanE85UnVHU4o5RK4t1GJjXDFNaz
	 lkYfHARb5DRqVHIus2+M55FePdxRqGT1+U80TIC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0312/1536] nvme-tcp: look up host_iface in the current netns
Date: Sat,  7 Nov 2026 08:38:48 -0500
Message-ID: <20261107135006.483606617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 1a1a11671826f..93e743d6e9846 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2997,7 +2997,8 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
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



