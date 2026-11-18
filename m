Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058745;
	b=ZBV5RU0TS5XfMq6VDb4ZWUyXNf9jwWMKS3DonHWlGR1NxJKZiYWaBupgLuw2n1uEY3o1
	 wa6DEU0k5fyLT4q6MLat9tDD7HU/dLdZcdEhog+t8Bz8gUtppfvWVBJn65YXWXOUV0V1L
	 yIHruzUF6GQ0JgvElDj8tngqc5EeQeaT7eQlxcPV13at64thfFI1V9l3FaFT/lEqh7Uph
	 /acgzu3RDHLc6ydrRg8b5g9NEuzR5Q5UVIu7C23peX3vb9J0/ezBlfmK8OQpDYos1pcxY
	 E97hj8b30Cm7RA5zkDbhX4XyZUtMtPzKXON2RQKrltuej2AnLnQHIvqN5xHUVdW6U/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6NXjpfsg5491p3ekHmfMBOdlsYgEfDUo8JeOE2rjc80=;
	b=I/X77CBUbmqK9t30U6QYQQeFj+CK6dwM12CT6UGdHZ+fCqnxv1HcIUCMIFKkaa2acFK3
	 GOmvyrF2SMdhL7/pbnY6jKqJmNrr9Wx//cpfe3rvp8qnRd21+PgAsNtS7nZR86r84dmGJ
	 p5tt8W1wqTQ86/PzZOdVxiZmyOL/xpBKTO+mtJvYdwzD7ksdpbRZLInVbLrKMiEWq02cv
	 oqH7ZucWS1H57MM4jk40+LGUAcsbULxMoAz06/szWJ88ilduQNY3tA8JYaMa1sUWuaVuk
	 1kVLfe5tjxO1eOrHGz2BW8OBuy2584DptMF/MO/jhl71zo+WwV9800+4kXJKD2vCXiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bD2J7vXP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85F4606A31C;
	Thu, 19 Nov 2026 03:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bD2J7vXP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA221F000C4;
	Thu, 19 Nov 2026 03:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058744;
	bh=6NXjpfsg5491p3ekHmfMBOdlsYgEfDUo8JeOE2rjc80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bD2J7vXPwlYqSWEobmGK3WuYczgYTV6zmP4RXKa+DrhTDRCWhTEsiiVIHcvY9rDqQ
	 qHC+OEBVrkkeq1smUC4wshKzbX3i+EdIvdsuJyq2InsEU4Mb7TR4+J4K5WK/cUbQWj
	 ZRTj2/OVBggvX6xaIg/zJCbwSGlk6fha5hZIBYNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0595/1848] net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring
Date: Wed, 18 Nov 2026 15:43:53 +0100
Message-ID: <20261118145940.289541078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit d54b21d824302af52d06574870817fbe14774dab ]

hisi_femac_net_close() frees the receive ring while the RX address queue
still holds every address that was pushed to IQ_ADDR.

A port that keeps receiving then DMAs arrived frames into buffers that
other slab caches have already taken back; on an EC6108V9C (hi3798mv100)
the queue still held all 52 armed addresses right after the interface
was closed, and had dropped to 43 after 15 s of broadcast traffic.

Reset the port before the buffers are released, so that the receiver no
longer holds any of their addresses.

Fixes: 542ae60af24f ("net: hisilicon: Add Fast Ethernet MAC driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20261025182022.2959333-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hisi_femac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index c16dfd8693639..a0b6be1f51b2d 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -491,6 +491,7 @@ static int hisi_femac_net_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
+	hisi_femac_port_reset(priv);
 	hisi_femac_free_skb_rings(priv);
 
 	return 0;
-- 
2.53.0



