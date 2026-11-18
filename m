Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043490;
	b=lg6x69GDECu+5C4F88mzrhp149GjLCO2tiek1NCOJSixUibtA0Z5ykKKGD7CuXCFRuGB
	 E2SNymYk31fHuhCYemUFF5AhqeGP0aoh3+soLaCuJ/4g+uvny0oFtnby6gmLj/YgBay6t
	 id7qSDhZjhAvJjHUCqjJXSQr8DkRO5j5wB3L1fu6HQsEBLUVxVZPM57+fYDUsW6899bFq
	 ig3zA3UZ0Qvo3xO2+Ch29j3xu3EIq7if3HqdA+5EaLd2UqxDwesAcmOHztmhUk7RvkEwN
	 i6WgoKkz/GE/cxo3U98vZng+5X/nAythc4vM/5tF09OIRhY8buFavg5srnUxCJJJaDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BGTJjvkQzJnLNoJPNFPYIYWDdHHbSOBhrxksglMCgyY=;
	b=w+phB0kjWIelXt9OJ7I42osMeQcfVj9PFeieAyh52cisytG4S45/sZ/PVz1AsqNHXdik
	 1lsE7/zYUEdH1nn9d58lwjhrSEdXM7cV9pWiSzlLvaMfPqY2N+lJxBCgzuXpKE7FOYyXX
	 cRzDnTMRqOwSKYJhAzzOeieUiKkGAMOlDYc9XxPvc9EL2vgjqBeEGvw8VWsiewK1qBBuB
	 03EyHpM/HFWxgBI3mFA9ncj9FnAfr9N1+Az7wUzsY1AIytfsFrD2yUiACuRYPTGo/AfPU
	 ydVCbFg7OIVbSIa5ztIBpptzJFw8j1ZSJcCNI9ksT6InoZCbOSsefGSRwP24GeoT7hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3E9n0LN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5B606A320;
	Wed, 18 Nov 2026 23:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3E9n0LN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D571F000C4;
	Wed, 18 Nov 2026 23:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043490;
	bh=BGTJjvkQzJnLNoJPNFPYIYWDdHHbSOBhrxksglMCgyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3E9n0LNr/GNV15x1IlDrXiAIA++JKCAPPbd1rcpm2btLAR4bY0vJ688rCzV8eSqq
	 c+1W5dgifsLL6Hexsxfd+VDyAOpxzHPhQRqb/vuyK3g8v7XvW765lqsO7Kfy0ItEfc
	 ez39y/jrxB3OIt5Ru13onAjt18mj1XvsLKIhiGaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0228/2857] nvme-tcp: look up host_iface in the current netns
Date: Wed, 18 Nov 2026 15:21:02 +0100
Message-ID: <20261118150209.667328350@linuxfoundation.org>
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
index 996940c972cd1..6dea467719256 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2765,7 +2765,8 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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



