Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624470;
	b=48ctlc+sPegXfsTtUUjyT9w4xccCy9veOqStmkxnBFMQ1IUcOWCZxJ7VKu2KTLr0RHiK
	 XWJ3lXfWz9tsoa6I5P7MqIlr4pPNO4kPTL2f4NNbLQlp86GSzzjJJfFt12VfuYnHNb+cF
	 HwA0ZF7qJocGzxoHikb6gfRhF2l8SKh9GQbKm1rYHU78uvp3AULKR94T+t/OU9VUAsDzC
	 8726OsdQ9NoNAqMQBiDXKVI05JThxjos6/wA1/lmtbkxIM+jIfZlc2U87GEkWJffyx8A+
	 j1PKrljoY86FxRn6hM/9ctsxNC5CNkKHj9X9vzk4pDWrbz4B7N7CpQNL84Em0mQtPzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LpRzhF0d3TQs52LPSCStmLJKuJhbt1nRV+q9HkFbv9M=;
	b=mkQIp7+LdpSRKLx7cGoW6XAsZtJzvgtz/4UZMmwaDTECP7pcJVU8QsKeT0v/itqUYMzZ
	 UbJ3txzf/TyZyFgv6rmNVntd1UGKUO8kwLk4ogpX1/Rl/YUBwOs+6pbVBIjRqTCYKXJuc
	 uTfSLfATatUfBP32wWOkLWOxgFrgTQQWuGfFlWDc9vdL49d0xqLSCenUeezk7I0PIja4T
	 yZGFAtkhutgi5eMxqK/8juYp0GV5cuyP0BHRXEP7sBXzPya93Kfm05hFJsfw4sAdf9nZ3
	 xw0VWhq1k6EvtCQmUAlqWWCH7XVUDSBJd2zTsqfKLPoc0onWC8FGOalEYSiuzI8zd0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gDNhwbD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E10E606A33A;
	Wed, 25 Nov 2026 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gDNhwbD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700041F000C4;
	Wed, 25 Nov 2026 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624470;
	bh=LpRzhF0d3TQs52LPSCStmLJKuJhbt1nRV+q9HkFbv9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDNhwbD+rt4svX5pYzyiyI3AVWCYjflevNeTuKR8CFsXStQQW0bz51M7fUp7NAxbu
	 Ufi/OXubVvhk9xp1VZPLTMr9KzPe/dLWe6oc4Cnkqyg9b6VlxdSFGcnxv3X8g7s0KX
	 VxyeK6vMlsDHAZwZy7d44vfHK5nHKegiEWUJgRvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/816] net: skbuff: reject zero MPLS TTL before decrementing
Date: Wed, 25 Nov 2026 15:29:11 +0100
Message-ID: <20261125143853.895451714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 24614e72df484ad50ecba98aaa88c7df2448c122 ]

skb_mpls_dec_ttl() decrements the u8 TTL before checking whether it
expired. An incoming TTL of zero wraps to 255, causing the TC MPLS
dec_ttl action to pass an expired packet instead of dropping it.

Reject a zero TTL before the decrement while preserving the existing
behavior for TTL one and valid TTL values.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261031114135.3784868-2-thnkslprpt@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8bcf153977fb1..fb95a9c627b61 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6643,7 +6643,7 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
-	if (!--ttl)
+	if (!ttl || !--ttl)
 		return -EINVAL;
 
 	lse &= ~MPLS_LS_TTL_MASK;
-- 
2.53.0



