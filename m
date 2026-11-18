Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036370;
	b=jdV5/RiFL5xhk7Lzy1Fll3RZltijI7Bsl0FJ2w1NijghgLEwmM+OKi+yrd0UktED5lYi
	 FB5aOA2afUZDFe+/+K+ooG7ci9MGbf8h1XGSYUIL88RQI3fUCuk9VcM49AMajDFJJDTBz
	 5ZOlJWu740/HZx+zbcwq5Ai5pSpqslLTJ0b4szb44AN7KWD0UQW1kTgGEnVE5uUoyh5Oc
	 zP+8JkyKenx3hEDHXMSCqxVADece/pj9PzIkITdXmBorKTDs+XXhFtS93icUVmu6CwwwL
	 Jk8Kl0oixig2ITjNQomL4YvHA2/0NrqTgh4wTxh/MUeZuWff3p30OlXwQKszBdJediA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YkTWbAmCcY4FIes1nsUEETS+19AH8uP8dyXgM3wxMoo=;
	b=N/kTKtoAVAuGKQEBKYGr3StRvW0ut/qbsNKJjaiA6JC9dM1kedyms6UYqFIpPkub0ud0
	 ymWkTVWCgpkRQs0DbyQe0HE+Pbp7YeL164mKw+LgGYuXQpgzyEg/gYqFatKchhrTkvdyB
	 os2eETzt82IBcNwC7e2lwXZrykTQgXNYTPv9E89/pzTjjMKcrO9frZsh4QUWRvbeTB0lJ
	 Y8OkGghaUWNca4sb8SdbSnLtcCH/Ae16QHGMMNpR4EcsGm+bfWFbJU123eeJsN4byhXsM
	 c60f8qLXN1FYWEcyAlbkbwXRvpm0ozNMGDO5cnQwA0dKN2fI91USfVNIzgGVIBmwslQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOJaybLH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4406D606A325;
	Wed, 18 Nov 2026 21:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOJaybLH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF5E1F000C4;
	Wed, 18 Nov 2026 21:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036369;
	bh=YkTWbAmCcY4FIes1nsUEETS+19AH8uP8dyXgM3wxMoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOJaybLHLviTsVLgFtU/vRng9/tkvqc9w+viyHWzBZ1bGGnj7VE33Yuc2qD+oYsNX
	 +tiCYnyYNwDOCt9xalGukPZWvr0b5Pl3myb4agqg2/jd0hR9H25tVczmdGBiHPrU+h
	 yxcP26vC7ZHzg/OAxxss4WYbOkyeWAFd9SqQVQbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1035/3318] aoe: pull in the headers each received packet type reads
Date: Wed, 18 Nov 2026 15:27:37 +0100
Message-ID: <20261118150350.952425232@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e1274a6bc40a4618f6fbaebbdc51cca865d51bed ]

aoenet_rcv() only pulls the AoE and ATA headers into the skb head when
the packet is long enough to hold both.  A shorter packet goes through
unpulled, and aoenet_rcv() reads the AoE header from it anyway.  CFG
responses go on to aoecmd_cfg_rsp(), which reads the config header
after it, and ATA responses get queued for ktiocomplete(), which
skb_pull()s both headers.  Ethernet pads frames to 60 bytes, so this
mostly takes a virtual link, but nothing stops a short frame from
getting here.

Pull the AoE header up front and drop the packet if it isn't there,
then pull the ATA or config header in the switch arm that hands the
packet on, so each path gets the headers it reads.  This also replaces
the open-coded __pskb_pull_tail() with pskb_may_pull().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261007-b4-aoe-short-packets-v1-1-db5155f7bb9c@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/aoe/aoenet.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 1e66c7a188a12..03bc1ca3ad472 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -132,9 +132,7 @@ static int
 aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
 	u32 n;
-	int sn;
 
 	if (dev_net(ifp) != &init_net)
 		goto exit;
@@ -145,12 +143,8 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 	if (!is_aoe_netif(ifp))
 		goto exit;
 	skb_push(skb, ETH_HLEN);	/* (1) */
-	sn = sizeof(*h) + sizeof(*ah);
-	if (skb->len >= sn) {
-		sn -= skb_headlen(skb);
-		if (sn > 0 && !__pskb_pull_tail(skb, sn))
-			goto exit;
-	}
+	if (!pskb_may_pull(skb, sizeof(*h)))
+		goto exit;
 	h = (struct aoe_hdr *) skb->data;
 	n = get_unaligned_be32(&h->tag);
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
@@ -172,10 +166,14 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 
 	switch (h->cmd) {
 	case AOECMD_ATA:
+		if (!pskb_may_pull(skb, sizeof(*h) + sizeof(struct aoe_atahdr)))
+			goto exit;
 		/* ata_rsp may keep skb for later processing or give it back */
 		skb = aoecmd_ata_rsp(skb);
 		break;
 	case AOECMD_CFG:
+		if (!pskb_may_pull(skb, sizeof(*h) + sizeof(struct aoe_cfghdr)))
+			goto exit;
 		aoecmd_cfg_rsp(skb);
 		break;
 	default:
-- 
2.53.0



