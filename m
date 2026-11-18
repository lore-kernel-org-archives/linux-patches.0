Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051408;
	b=akpd5rZBvrLb3OAfYjmAOefKzPP/wFgirGiQQvFBplQBqufSMlkrew+6SwK81vC6kqSz
	 onL4uy9XU+X0JWmFj/5mDB2jo5iaQiAC6c7Ld0C5pZJIoppBHNcDfuicxomnB0D1fb37t
	 nv6DXrdCitkaWdIrisJSer2petupsNfZLCDvWwCqwrMAP4FXZP5TUQOV/OhAhnqCQc3G9
	 bdfBiO7ARGpM/YkF92i/TImNolGUO5IhHj672pjYUXRKA+3njPECMQlAch5TdnAGTrJVM
	 HGPV0JHhnwXN1Mmq8uvD4/zgRzERkt4XpbXdlmlOspiCCfcCE92dNupfqU/zFc862+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=weT/3C1Xd1pByLgtgBX6AECuTRA4JzHc6RRGaNhlZ0I=;
	b=zvrmZbLmZZe3wdpDDCQ38UvM2FOWAUBDbnDShjUZnev0xHozjdKb/wayjIVGwykG2vvQ
	 eZx7Mhk5Pdc338Qm0YU0SQ3UkxaMW8DHxqdfgc2j3B8sz2Ys4nkzRe9j+ugkuqWQxYkgB
	 cqrWQpUqJ2E89nYaw4nqd9upACK6QEq7bPctYT/7sC2KLKNjJGIk6BkL+7Yz3uaiqH+sY
	 Pmb0vmFM1alGfz4Z3g2pMnwx0MsQXtYHinPv/HL+TVGV26kmHLJAKhwpWbsX204b79SWJ
	 1dvk45PERLtMgROJN86N+sIfv+sflOCT6ujPAw/m2hZa/0mAz6ghFzo+u+Tb8Mx7ZfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdmaCQ3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA15606A31C;
	Thu, 19 Nov 2026 01:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdmaCQ3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254CD1F000CA;
	Thu, 19 Nov 2026 01:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051407;
	bh=weT/3C1Xd1pByLgtgBX6AECuTRA4JzHc6RRGaNhlZ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdmaCQ3NiZ03Aya2bUuahDHpUCkZqtKzeo88KWbf/Pqm+3WLUb9MJDGhvNLXfAr/8
	 eZW/E1DFOvmzBhYHylB3uSUxoMkkv7o9AmwZZreQOxINdu7ZjrOKw75IvwRtGkVdLA
	 rFR9WycFb18o2ba4xLQyInJYIrmtL1dh5sfcJD4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0197/2214] nvme-tcp: look up host_iface in the current netns
Date: Wed, 18 Nov 2026 15:31:13 +0100
Message-ID: <20261118150018.100016644@linuxfoundation.org>
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
index 8ce4dc96313fc..98df67f1bff96 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2678,7 +2678,8 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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



