Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829331;
	b=Pjo/LJ6haYdUgv7YJDctqTVrnAWsQCgrflzay+ZfT7dNay+de/pz74LRdIrdSH1Js6jV
	 aGI5jqVAFBxaDb0kB+yByyljlEjfm7ari803ykNVmd2FLs8aCf0yHrgH1FRwm5nM26oIc
	 ZUSCSXAjo2GAPtCbhiKhlC2EoIAuiMZENhgqSqjj33PuhuaJ2sW0nKCW1jdVgP72gvtpK
	 +erYDVFXBr40fHsRHF1Xvrxm0Fhxy5Ai01nCoyE/28La4jQjYmbsuyqE3i2Pe6SuwrWjR
	 4N6RFVkJl5jFeEfKdqP7IhcuR8jFDpjkvOrZ8YDKOvjLONohfCQm3O/hlfyHMacmbfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yXGoauUPj9cPxY7JxQliCaO7oLPa3++Ru9Jw5ettexc=;
	b=uGUjMMKHbl+Rbq/HZuEIApnvwwJEStmr3WtBYLaYdkfLl9TX3+iXMhNj+uEysEbO+Ojg
	 5sOgv8giFSvqlzcKAK2CDuYP8TeAWIDPpY0Q7U98T3t0kqSiRosCEukSD3XkuNh2TrxPY
	 8AlHJ750uZm9YoFnk03yyBkEV+85ALS1KzIIIy8rhfaZVKUweSgqCNJLCLThEDt3V660/
	 Dg0jqBWvQm09gvaGu5qgVGUovbYs+9r/eatv6YyrNvREXq33QR75irbQSt61o0QqP/csI
	 /u6rOTtjH1nIxtqBADcqfoyteJ6ZeOAOSZVF1KTns//VXrrsLo4y9UmbXkbF2eITHYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzwwD32U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC41607491D;
	Wed,  4 Nov 2026 21:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzwwD32U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789341F000C1;
	Wed,  4 Nov 2026 21:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829330;
	bh=yXGoauUPj9cPxY7JxQliCaO7oLPa3++Ru9Jw5ettexc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzwwD32UStkFcB/glN8Eis66J4uOpKS1liBSLiE6URBFEzXSXq050mJ7+qRCxk14f
	 91uuuIzS9OAxUPQoFllQsby/XSLLrg//lrsQZ5/meBF3vSwnqahcvBjSREily3GqQo
	 AgNUIoyYZYiZ2PV7zAkBVsNfGgMVXCCc4ACAjbso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0059/1005] netpoll: do not warn when the best-effort pool refill fails
Date: Wed,  4 Nov 2026 15:56:32 -0500
Message-ID: <20261104211045.246817322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 84c0ff1efb62b0053aa265b8deb13842f68f1a74 ]

refill_skbs() tops up the per-netpoll skb pool with GFP_ATOMIC and
simply stops on the first allocation failure, leaving the pool partially
filled; a later refill tops it up once memory frees up. The allocation
failing is therefore an expected and fully handled condition, but
without __GFP_NOWARN the page allocator emits a warn_alloc() splat with
a full stack trace on every miss.

Pass __GFP_NOWARN so the best-effort refill stays quiet, mirroring the
same change in netconsole's find_skb().

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260629-netpoll_no_warn-v1-2-f380f0b2cd0c@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9ef344a6932f9..a22de992c8024 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -232,7 +232,7 @@ static void refill_skbs(struct netpoll *np)
 	skb_pool = &np->skb_pool;
 
 	while (READ_ONCE(skb_pool->qlen) < MAX_SKBS) {
-		skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC);
+		skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC | __GFP_NOWARN);
 		if (!skb)
 			break;
 
-- 
2.53.0



