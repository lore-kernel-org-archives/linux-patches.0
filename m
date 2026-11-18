Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057827;
	b=F6Jh34ryyJsu+UTVFD0k0/vi2T2+i20cxqo4OjhAcyKZX15U6me+N5bu2jiAF4GPDds0
	 qDeHyuRwnXJDG/SWgH36VxI1olWIsuN/DNoT/Uf2tBAmxXqzGgYhHqb8706yEg5FefCiS
	 M27q67y7f1+9VGDuOfQOCbIVPRBSCAD167F/fdTeDFKjIHJxm5spLgxMVeWMpVLTjk2ID
	 eV/kCWkaO1uteQB2fpUS6qF0MkZoJNtOW+h5g5x+Zgpg7QxzZDDJMv3ZaIdQDGddNQb56
	 nq2EPc8xdHg5QYRKhbScE78wG3eugvwi8o7rO3wyv5YMLzMIMO0l5lkG/53+vUTo7mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UxxbaacC0zpi6qyMM09QkakcHDFurkNgo45iD3oTaGs=;
	b=C9MMntoLUiY2l5DC3MUc3A2+C6lk4aveVBdNJ07E+oRrc76T7Xpwfqgv9BpJsjjAF+Da
	 ZR6Tg7eiSaa35W8My/vi7UHso8iXgi6HOQPoYfFJTzULADsVAXs4FBvIyLyaOvhkgJPON
	 R+e5gpEPv7d3MliLruIv98XLyzO4p4HyvSG1ViD0msuJsOccjU35D9/V72ZzKZ/wJiBD1
	 rJf2VYh/cSrwITpEXnn7rfDV61JQT6aKxbmj3jaJHe5alwzs4mPkAu5LNeSQhHMxqqwpT
	 ktQbCTTR4j/Z6XJprdfmYF3OjI8CMx38pMqkb7E13XN2gUwG7RGYiwzJrvD8/X5ODuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSo2UDFp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA32606A31C;
	Thu, 19 Nov 2026 03:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSo2UDFp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1361F000C4;
	Thu, 19 Nov 2026 03:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057827;
	bh=UxxbaacC0zpi6qyMM09QkakcHDFurkNgo45iD3oTaGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSo2UDFpntK1f9D7+KrZEKghvSmwfFFACPu9pGe+Y/Suuf885wuuWVizRgeQ+pSWQ
	 eNnl5Xo/B1SqcmHIcXrN+LIlPQRZ7Wa+zo/9AD0zPgfEAIkfxJX2xdy9b+m1zGfFoB
	 xuCX19GNGXcPqyvXrPcNCc9cY2Li/pqTA3MSt7uw=
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
Subject: [PATCH 5.10 0227/1848] net/sched: sch_netem: fix out-of-bounds access in packet corruption
Date: Wed, 18 Nov 2026 15:37:45 +0100
Message-ID: <20261118145921.501561002@linuxfoundation.org>
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

Conflicts:
	net/sched/sch_netem.c
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
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



