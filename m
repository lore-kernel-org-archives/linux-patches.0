Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064568;
	b=nXHgoN8xpyN2MFeHZuawYTO9NLpv/OHuBgUq+0a4KnDA6aWkS8+PK6u8N8KyFHr04UL3
	 g42whRW0x6XUOiBDycdQr5azqpSGucuNvWhGVXf1umn8cGMyKUUcMowvCSmXG7y4G+6wz
	 AvfNVGHMwobmRQw6oWVfDARJZM0gUw9fd5QSW6Grb+VwAigGKSqHXtsqAOe3iD3hsadsX
	 5GkAucgNNmFIn8po7MQhbtjhcu27zW18sdSy3ghCKPkl8jCv0mtxa8mR3MrOhWtvk2XUK
	 uIn+XXgmlkAxHnTP3l+t3ZImeGI8FsptK0evt7xxDSs8g72bRh4SRVRfxZA7VO77smg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTybZX3tE+317WdxPF9YFnPVz2ArU0s7P6wK2W3w49I=;
	b=2bHgbCzTRbsFfSgJ/HB8nTlq3R+lg0zgb+YDJoo5frxA1LihhUt3zdkANDr+GC+SkHly
	 2AtNivRiqXdjOwzLKqjq5VxTy7MZjYiyGfX+VyafWlpFmHswrrUuU5hYpgmec1oimlsY+
	 7r7bd3qSblqwG7o0RLAxj1/xM6GvwQHcPh3ZGK+XjwTAaPMdf1XcCIsMT22bP96sv7fFT
	 6U9Nzc0wE5jYUhVyyRL051PxykD2c3mBsF73Ab3aP8ocWx4ghP+Wo800uZXXdjjKXjCFz
	 68QGaUDQy0zGO4iB4lygcdN3ENxIbfen+26PgZg/qNtBIv1ZeT15KrGGdusthgygKaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLJIp3Ey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B151C606D809;
	Sat,  7 Nov 2026 15:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLJIp3Ey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E45E1F0089F;
	Sat,  7 Nov 2026 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064567;
	bh=NTybZX3tE+317WdxPF9YFnPVz2ArU0s7P6wK2W3w49I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLJIp3Eyz/xqTbavLz3gJnZG6w8jFhHiie0+Kv5FPRYaQNpvm/fFhmVHGHT2r8uIn
	 GKufWMAQCFuPGKQ5gnNAM6l95eqPm+aVHQqEGdExIhux/yzYMD+TuisA2Qa6Fr4/Xn
	 mbuuvzP8/3wc7+wDkRS2rlqIbNsGu8R362t33vuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0550/1257] aoe: pull in the headers each received packet type reads
Date: Sat,  7 Nov 2026 08:47:26 -0500
Message-ID: <20261107134954.582371292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 66e617664c143..cd7c735bb43b7 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -131,9 +131,7 @@ static int
 aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
 	u32 n;
-	int sn;
 
 	if (dev_net(ifp) != &init_net)
 		goto exit;
@@ -144,12 +142,8 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
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
@@ -171,10 +165,14 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 
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



