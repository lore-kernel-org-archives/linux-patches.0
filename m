Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058577;
	b=QPZ0CVw7x9ALzPgprGb/UocEfTWEjF3BuCEQzclG30udXF1fwip2KIyB8AbOrl83XnSn
	 89c/Bbcm+0iSiaeQm/hHjFu0EmuVDDO2eMgxcf9VJwXbBVWj58T+dhgijLXp2lg3gCFyy
	 dLo0mkwg1ufUvHEqnNzttaG83YexCqNWIbgngdh8GsZFr0mlAbOzNdWEK0/W7FD0oGjPT
	 rltSk4vvw+FHucRnHr3JY8CJ+dTpDgtKux+BfPYDWoErnvtAcvLUjzME3+EUuyhK7tNvx
	 dc5+SuzflCj8Ap6hHqgHf1NRjlUVnXc7uQm+T9lkISdcZu1ntHV1jfd+lChGOiWPjyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+ImGd01Q2XLooCZkDzgrc1n5Ef3JLDglvzDOOjgDxs=;
	b=Vi5d0O96inBGmJubAEw1wcNGoaEp/VATo8UzHB+ZqFwOu1/9Fz9i6loovPYaitz288PZ
	 sLpw2gvcAQKjHN4awbOeD7MdnfsOHroCXf+QArruo8Tvs4q7XivJuvjNa8TNV97yMf1eU
	 YO3BRGKM0qAzxh8MTyurm8dgDP0Nb5UIAgDW3U/P2I8M30KSYa7KxE7OC1ARK0ltMl/YX
	 7d+zHsASEYcfUPOSHfbnIAm0otqKVRfw3Djyq9fGrpg/0havdUv07uA2StifMkPRDzZdK
	 0Uc2DuoskUV3dlFsS+wwSAzX585Ek2p96BPa1N/wnph0EE9PouxVKOdQ8wm1QXlW9vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCfCHM6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646DA606A32C;
	Thu, 19 Nov 2026 03:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCfCHM6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9A41F000C4;
	Thu, 19 Nov 2026 03:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058577;
	bh=1+ImGd01Q2XLooCZkDzgrc1n5Ef3JLDglvzDOOjgDxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCfCHM6d4/jLA3OPvJ6WdbfRtQgueAw7tCrXXUM1gqDFcdRSmsqfq/5wWybsRXs/Z
	 DDnSwJUyrMUsokoy2r7gtWMb26rHbBDKgkGoXU1se/F0NLc4QDkYxOkwlO2ODKk02e
	 vOmVZR1eaM93lcP9SHKkQjObbPf+tNXSWTnBPIr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0485/1848] aoe: pull in the headers each received packet type reads
Date: Wed, 18 Nov 2026 15:42:03 +0100
Message-ID: <20261118145934.516629453@linuxfoundation.org>
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



