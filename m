Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212684;
	b=UdJvTr2Fe56mq6RCdN8txFB3nbR6JHWEeukAsTKpXe/tQLh9ybU4djB1k+N84HczPylC
	 KHcT3uLnnLll/iK5BVaydjkhni7ESqbhoTAbmeglDJ5AuCXxnzi96spaAuetQgXy5HK63
	 leALKdUilHP3Ej5DVDxHJ2mDgw+kVvcKxGCZK9NybUy/+eSUZv9r9BYW7nQr6IBQqWnE4
	 86EGIYxTRGxEoeypJkLZEK76dbCiNHk59vtPUPH4Hxf/XFxnKLLw4K1xqTUFs0EvhbH24
	 378R5IcHK/1PGAHfy6fm+K+YVBnU7J+Bfz3Q8NKW8Os06DTFD19+PavnCvWihgyQnMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTPtsSYpHrVk9xoNybE9E1eBYbEH1+nUz2qsl/AwBjw=;
	b=PYZrSqphHL1U3pTKDqd/c6DPj4ZfOOa19ZySfRjiq2gMcBKagk7eBylAXJYfb3SSC87b
	 VWSj4TblW7nmhsz04zBirILMPmn2G3PLyx/5ix2kLNURM1/Y6Hfo0n+LxlTNnpSKrVt+u
	 UN/U0GXzpFPqN2tikOM6GWMtOUzXFIxY/yMaxUvTPh3dmYnIOwkl37p64lyEh2YwqXV8Q
	 LfJ09L4Mp+jOXmGjRYdCvjDsBH0VT8o5rXhhjY1lDg7eze1akgfbTCIojtLgD7wt42D0A
	 6fiPNtC2wQAEFh/2UPty3a7IN1mEyJmyofguIWx7nDypjdkviHXEszz65vDgUyv1sGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OeIoMWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2762606A31A;
	Wed, 28 Oct 2026 18:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OeIoMWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41CA1F01825;
	Wed, 28 Oct 2026 18:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212683;
	bh=YTPtsSYpHrVk9xoNybE9E1eBYbEH1+nUz2qsl/AwBjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OeIoMWUhoev6AKI5/N///UQuwOdKIl1EYByy8PpLl7HBmcpaV7hdhKeaDFskwd2u
	 NVcI/zNXKzKBiDWQhAtX+nr8cWeiWaVjHH/rCZeuS9Bphl94X7zTfzvVZ863cIYtaB
	 fLTYOlxJqO5r315XLFf+/ft5cEWiLpR7i6LE3HH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0239/1887] net: bcmgenet: fix NULL dereference in set_coalesce before first open
Date: Wed, 28 Oct 2026 17:38:55 +0100
Message-ID: <20261028170504.670531455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 19419faf58dfe5bcc8a9e60e622976c5f8e3ddc1 ]

The Rx ring priv and index are only set in bcmgenet_init_rx_ring(),
which runs at open. Setting the Rx coalescing parameters on an interface
that was never opened, e.g. "ethtool -C eth0 rx-usecs 50", dereferences
a NULL ring->priv. The oops happens with RTNL held, so networking
stays stuck until a reboot:

  Unable to handle kernel paging request at virtual address 0000000000002788
  pc : bcmgenet_set_rx_coalesce.isra.0+0x10/0x88
  lr : bcmgenet_set_coalesce+0xe8/0x180
  Call trace:
   bcmgenet_set_rx_coalesce.isra.0+0x10/0x88 (P)
   __ethnl_set_coalesce.isra.0+0x490/0x570
   ethnl_set_coalesce+0x48/0xc0
   ethnl_default_set_doit+0xf4/0x230
   genl_family_rcv_msg_doit+0xe8/0x160
   genl_rcv_msg+0x220/0x2a0
   netlink_rcv_skb+0x68/0x140
   genl_rcv+0x40/0x60
   netlink_unicast+0x338/0x3c0
   netlink_sendmsg+0x19c/0x3f8
   __sock_sendmsg+0x64/0xc0
   __sys_sendto+0x124/0x198
   __arm64_sys_sendto+0x30/0x48

Set priv and index at probe. Writing the registers while the interface
is down is harmless because open resets the MAC and
bcmgenet_init_rx_coalesce() reapplies the stored values.

It was observed on a Raspberry Pi CM4, but should apply to all other
genet devices.

Fixes: 9f4ca05827a2 ("net: bcmgenet: Add support for adaptive RX coalescing")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260928105642.856210-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c729da84a19bb..9753b48cfac47 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4079,8 +4079,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	netif_set_real_num_rx_queues(priv->dev, priv->hw_params->rx_queues + 1);
 
 	/* Set default coalescing parameters */
-	for (i = 0; i <= priv->hw_params->rx_queues; i++)
+	for (i = 0; i <= priv->hw_params->rx_queues; i++) {
+		priv->rx_rings[i].priv = priv;
+		priv->rx_rings[i].index = i;
 		priv->rx_rings[i].rx_max_coalesced_frames = 1;
+	}
 
 	/* Initialize u64 stats seq counter for 32bit machines */
 	for (i = 0; i <= GENET_MAX_MQ_CNT; i++) {
-- 
2.53.0



