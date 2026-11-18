Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034135;
	b=nXGVhJ3gSY3XkDfoT7F7Oq7r93JIFzIp1+qN3T8ncoQEIIete3R0enxnjjYfwf4RXM30
	 h6DunsdJhNybzwk5VS1Vodrvv+eGYEMHTrHh15DKBEv+DirMoMbQuZiY7y8zuYYAC8G9j
	 eg0gqx5xkeSvMlsfO0rs4RhI8EXnAFHC+hdD9WKJbNdFC4WeA5d8+AnJLtrfN5wGT7zOO
	 8rWfS9PpkCqcUWSmnTzSPj1T0PtruVFrSjtyiKatmLeClasTHV5dYc1uoynp4L3W4035n
	 Ge2fX97+NBFKWpQfhy8EpBWPTmjO6xlKKmf0i9qGehEd8Rpvz9H0m7V2Tv0wZ6Nef0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lmVIUrCRGpbiXo7agrVQ7p778NePgYXRBxlZRLuCSkE=;
	b=qE6gT/IisY8vxb5nb1evE18yK90rsdcAkcR8dGxBmHIAxthz4P/ORa8dYVqjiKTwbCUt
	 97KrG4pG1NfwyuEKOzbCppWSIWt1zfK8zBurCDhqjwjEBTSuiS9hs2Fuzz9rNn0gtHSZi
	 uFA1pZQiDrbWNU5cjqtBCHjQYH3yjZIu+ujtitOGisCDbZtfme/GEMg3zqu7mMl5i+eDD
	 PftSaVWs5jH7CnbP/KtzTx/Nhs0YnhykWytbNbsZ0srihufVtnIbq+wXuJrefoh7qWOEd
	 hRYbgL4hUFtO3kdab+E70YV59Txk9Ztm0tlLFofM7GJF8g0hhknB/vYUrC0RqqCU97A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVzE+SEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EE160A261C;
	Wed, 18 Nov 2026 20:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVzE+SEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25B01F000C4;
	Wed, 18 Nov 2026 20:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034135;
	bh=lmVIUrCRGpbiXo7agrVQ7p778NePgYXRBxlZRLuCSkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVzE+SEk/tIHQqP79NmI0qd8/uyg3aVIzS+Jc5n8TzZb8JVPzKWGaKvDk/iMp2kWc
	 fo182BRsY3U9/DKJqH0xAWOvWxfIDB6mY8E9wGMPVz2dg3voDq7Pi6SScyZoOsEihB
	 vtwjN678wU+szXKpUqGbdtAlbaFq5wKVomiYkqnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0263/3318] nvme-tcp: look up host_iface in the current netns
Date: Wed, 18 Nov 2026 15:14:45 +0100
Message-ID: <20261118150323.279842799@linuxfoundation.org>
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
index abfa680bdd216..fd27e6a35bbcc 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2721,7 +2721,8 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
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



