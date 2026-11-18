Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052530;
	b=5JJLF2se5ZEa9hLvuY7AmNTFvqrTZcGd5GxkTkpa9RqScbnJ8f0nvZDbDby4h7A4GDB5
	 +mCDmWRrEh1dqot8Qu4se/0liMSBWS1/+xXrK7MssEswTzviSUvXissh+sHJjxzIDkTwh
	 h8tl9t53zh8NyqHvbqdc6FEu92p/MaUQddOCPbBoY/8uiE9NNmZLPmFijLPJVOI5BFn78
	 f/btIIZqv3NU9x0OINE3V7jBXUjZeqiVh2iUE3xYOC6Q7knL2/tiyKhnyrhUCwB/LK0sb
	 dQONunwtSH1GsKQm6LkSXapNXV1jDWEk6Xz4UaZ6KQCoTA5Z/WzRvYSDWhAbFQHYP+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UIY1CD25kzCPNC1v0B7XlsDPOonT7/fLLl8o29IFnuA=;
	b=qGgodlOPIzL7+TWtT8NGFC4DJYf/EspX1azw91QqfkTCTw837Lshi6wXiI1FVnu4WYyl
	 XLDzGr1ke6jjFlJdTgrCsKMRYtfYclodpKj1INoOsksh99aeaJRGWfVo1tRtth+xXjAoe
	 NW2z5pE79Eh/lb8rZMN6qDQKUKcc30EBWaBLBFsHETkFQDMb/nfO3Q2ptN1NjgVABO2ZS
	 fYQJL4LZ3PoVD2AGc7t/LQtjC3CqiQjzmMH4mK5gzaJGzksrURXZTuGjzOj4zmfY35K83
	 9ibXptRJVvP+mUnKBbEC8tNmBBGIzl3ZOdV6Z8Pldk0k9aFLwiogd9/ncyKzjFVuEIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8gkzHtb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE98606A31C;
	Thu, 19 Nov 2026 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8gkzHtb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1D31F000C4;
	Thu, 19 Nov 2026 01:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052530;
	bh=UIY1CD25kzCPNC1v0B7XlsDPOonT7/fLLl8o29IFnuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8gkzHtbiktCSlqbb7sJW8KBfOp11LwmDmd9/trk8w4FeukZGWdkPmXrYVpdM/g1o
	 1z7jfPSXJQRJkeMoVrtEs1ULfj3USoaypd1OB/ZJPQnNhSfnQSRi0QHtUuOuARNZBW
	 Br4Rk6XzCmqgv/9e0UMl5Cs1dIMPA2xd+/AceviI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0596/2214] aoe: pull in the headers each received packet type reads
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118150034.814639245@linuxfoundation.org>
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



