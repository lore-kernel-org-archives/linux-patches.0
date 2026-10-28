Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214723;
	b=jkbhqQbXtBn5/+Si0PB01OXdas4jjAx6FBNqteLOZuRLxRNQBbDIENEQ9MPIXh3TQwUK
	 EThaLZpaL6RBH05RUMRtbxaxAtqkhomfjc/YyzlOWR4WsQV2ogSDykXevKoql9x8+ggzh
	 +aflAx36HQrvJ6UxR7R9IVQbnIDeHD1PUrQTokdj7CwiwzbXHAi8jN/v+wjP1hObES2An
	 Tm00seu80Rz6hiMTpvVJj/pdhrpnTIYldLK3GPcO/I/dRfN/S4Hf2wd/YUOTMs7yV1gbV
	 Ul2hKG9vs1FfFXYYinekUoAGp8Y4x+NtR/D5vQGjbU6wDvDetmsXPxWVtZfksDRe8IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dvDzFCr6sR6pR0lKPanVu5fqbs56ZufY5M6cmeMv6tI=;
	b=oPQqhSXnFRROMCka/CBigUQnW2MLOXF/mSCYzyxt1hQeQ3OXa6m674Doqdu3RdDOrGVw
	 Y8GUuUFtY7ocejzVBDOYumlL2mIFOqX3BfglMWX4GfVOzeqHM+zfKpZlIinJddo6Qvjb3
	 lcUWPMA0lCRFypc0UYxB94s3fGtVp/rXNubcXdQXBcPn5Lbu+y+YUHgucyVUZFx07Ouyf
	 m/j1itw65ovqy7NMiB1NqPCCJyKodGtFra54j6bWrltBANC/SvvvXZjp8PTJ5OnzDvOtg
	 FxONr3zwcrzUZ+xVSruQE3JU0Ctjf+/YbZ1Uoa/SrENRMl174jHTYKzPvNFNn9DEDOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYk85W1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9B3606A33E;
	Wed, 28 Oct 2026 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYk85W1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822D71F01825;
	Wed, 28 Oct 2026 19:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214723;
	bh=dvDzFCr6sR6pR0lKPanVu5fqbs56ZufY5M6cmeMv6tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYk85W1G4R3PnAG2ZkYgqDACHoMlGFS8gbYxRRCyg1q/y6kdR22xV3F82cwY3g863
	 p7f1RodRj4rHJkGvuAReJWJQs5UGSZvDtzI+5iLDtaMxTZ8+BIlpB1NQgt22SKK6o6
	 dDxnlChuQJstBF3JohKK0mSArj0wJi61DZI3nrA4=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0960/1887] net/sched: sch_netem: fix out-of-bounds access in packet corruption
Date: Wed, 28 Oct 2026 17:50:56 +0100
Message-ID: <20261028170521.253694509@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 2c47bd8dba647..5d6e928ab7506 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -508,8 +508,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			goto finish_segs;
 		}
 
-		skb->data[prandom_u32_max(skb_headlen(skb))] ^=
-			1<<prandom_u32_max(8);
+		if (skb_headlen(skb))
+			skb->data[prandom_u32_max(skb_headlen(skb))] ^=
+				1 << prandom_u32_max(8);
 	}
 
 	if (unlikely(sch->q.qlen >= sch->limit)) {
-- 
2.53.0



