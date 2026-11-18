Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051626;
	b=e+c3f0pqx3nU9iaASotQyKoH9krKCOXQcR+oKimOpba2IdnCtY5aZPe6tL7Cuqi/jZKC
	 qUMbcGLLF0eMp+EDDANQKIuMp27ULz4vD4BpkBqTAip/LS3CpNJ8sG90xRFxhtA9LSZhw
	 9mXyx64orOp3Z7xbC3VyWf4Dwrvkb+VeHvVv4Oi/Fln6pPXf0WzggtNfCsTCOZJzpfUmx
	 H832wz33I9i99652Ak1h7gPGlMXy585vtgMZt+DHoqSk8+LrcDZplDI7qR8juiCCj78DF
	 yXxccl/ZrVAuXrS9WheOTCTPLYOOSBtmI5TZ/xZeflHu+A9f9VLWgX5uQk/o9bZGJig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=brv48x/2JAsHOZdWFdrqEVph1gGLNddRHnk8eBqWoDw=;
	b=Jo1PkCUJjcKuL9EzoTbZcRUihv7fam/ET+TRF70qe366BsCPMJCXLxA5rF8t3IpRo1jp
	 pwk9d6P61vqQrrP4/pmRt3eO4m6xuexRx/M37VuQaV2o7bgonjRuFKbuIVrSwkC7jg0tU
	 Cvy81czmbwW/4aYMK2v1oGn2rqfMHP2mO1xbn4GLt4VIkXkZW5OvPJsrcHflggXnt5V3Q
	 l/NtIUNEPkKRnNoPIY6at3FmYyynqPE2Ed32SwFdu9rOugJNHcJv3vj0uIW3cqZqwNaBG
	 WmFiOY/X9sfUle9aLvHnqA/V7rvHJ1f6FLToyxkFUcapKTNaSMP+BnTyvstjrReHlJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAvlnXLt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72FA606A31C;
	Thu, 19 Nov 2026 01:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAvlnXLt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F2D1F000C4;
	Thu, 19 Nov 2026 01:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051626;
	bh=brv48x/2JAsHOZdWFdrqEVph1gGLNddRHnk8eBqWoDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAvlnXLtpeh260HXGdWxkG8qycD8wRMkcnP8L3/Ad5Gk8BWG2yp9DRvt5oBzwzReX
	 pMY0c8sNSnZkF4TBRRCWDuXeUsc6/upfA2bFoq5OQKqGGhuPtYlKA2njltrBvnN42i
	 AmOJPYfma9JF3VmHcze3e0jH/WmXVbHuNjJv6Wrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Yucheng Lu <kanolyc@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Wengang Wang <wen.gang.wang@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0276/2214] net/sched: sch_netem: fix out-of-bounds access in packet corruption
Date: Wed, 18 Nov 2026 15:32:32 +0100
Message-ID: <20261118150021.108282419@linuxfoundation.org>
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

From: Yucheng Lu <kanolyc@gmail.com>

[ Upstream commit d64cb81dcbd54927515a7f65e5e24affdc73c14b ]

In netem_enqueue(), the packet corruption logic uses
get_random_u32_below(skb_headlen(skb)) to select an index for
modifying skb->data. When an AF_PACKET TX_RING sends fully non-linear
packets over an IPIP tunnel, skb_headlen(skb) evaluates to 0.

Passing 0 to get_random_u32_below() takes the variable-ceil slow path
which returns an unconstrained 32-bit random integer. Using this
unconstrained value as an offset into skb->data results in an
out-of-bounds memory access.

Fix this by verifying skb_headlen(skb) is non-zero before attempting
to corrupt the linear data area. Fully non-linear packets will silently
bypass the corruption logic.

Fixes: c865e5d99e25 ("[PKT_SCHED] netem: packet corruption option")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Yucheng Lu <kanolyc@gmail.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Link: https://patch.msgid.link/45435c0935df877853a81e6d06205ac738ec65fa.1774941614.git.kanolyc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit d64cb81dcbd54927515a7f65e5e24affdc73c14b)
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Conflicts:
	net/sched/sch_netem.c
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 3e3bced82c564..6c206c97759a7 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -508,8 +508,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			goto finish_segs;
 		}
 
-		skb->data[prandom_u32() % skb_headlen(skb)] ^=
-			1<<(prandom_u32() % 8);
+		if (skb_headlen(skb))
+			skb->data[prandom_u32() % skb_headlen(skb)] ^=
+				1 << (prandom_u32() % 8);
 	}
 
 	if (unlikely(sch->q.qlen >= sch->limit)) {
-- 
2.53.0



