Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062239;
	b=Va/vzTTEZ2vSIz9kIxkgEqYoAsMXTf2Z7zy1tVZJFkQyUfd+EtwnFU5nAJpC/2xN1oke
	 UvisZrKhr8y5WXv9nLGWbJVfqeoicU+arRqL3QyavFkDc2nydyanO61Mbs2Z+2KPTq84i
	 qdh3LyNlKuv3FgPRFeSJ8jQuawPcIuvNVngIWksopNHOawpEpLi2D9ukDS14yE92CWbxl
	 ODN2Cf6xKsYhZ0VMIKkBu0+1yZn51TGEgEtMzMqrLVtM0hnn3Sz2qpIhZ/oZADP51Gkp6
	 RIACYH0KHMVpprV7mgT5/s+6XSqsm914Ol94PF8H98BI7CbELatGwztOsf/6gE6XZmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vn2YXjud74qt29M5N0ZuMsYCnIHyekpmEVjjTLtl+PA=;
	b=fewUIWXERpIiY466m08d9jBARknXcjhLwPjxLB/TfxFOjtEdLqcSc23FRcLcXp4+7Lgh
	 4YSaNKTmRqnRf3wGuKN0L3RDgLIaFsvPaKZL0YX/ARGCMPpEnmckSdK/QuwPcQiSrAOIE
	 Ncr5DBmDrcrMi3HS9r6z9UhgzFpftyrQYLVgFtP2POS1ou500JrXAH9tJxxeRR3kmMViX
	 Wh0gFL0mYsgmv/0JcJ32qGEfe2nkbMXI0HtXRQZnZU7QRkhldhc+fFZ+otVbGN7IrJLxY
	 +KT5Q4KCxCP0+7yapTMW68p8Rc+9We3cJLe83dQ1WBlw7PEG0OWjS5+ReXwr6OtGZng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7kJSs+Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02E7606D827;
	Sat,  7 Nov 2026 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7kJSs+Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB771F008A2;
	Sat,  7 Nov 2026 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062238;
	bh=vn2YXjud74qt29M5N0ZuMsYCnIHyekpmEVjjTLtl+PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7kJSs+ZuXqQW8LrYMkAYZJMhcfJV7NROJ7XTgonHzoE2bxnk/ULjTP0gQoqZ2gfE
	 TCTLbKu7p4M+crmP/GgqQ1AEL7xPP5P80wW58A8KZsXza+2nwc9eWCLvE3wHdBMb/2
	 kNq4qzAmdFZgAan2t8m4yJ8RSSfTGDyFNmlgfIDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1187/1536] aoe: pull in the headers each received packet type reads
Date: Sat,  7 Nov 2026 08:53:23 -0500
Message-ID: <20261107135031.082829672@linuxfoundation.org>
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



