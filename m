Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050976;
	b=lpFaLF7ubk5di/0wBFe+mQMEgXFqan5vneZHZ5JNkNETHF+LzD3kkSFoL+TXa0tazFd8
	 xaYw7/XQnsLnslM9SKWPNjINYlXfOurAk4EP1ORFHEeOwbcdK041m+bcPEqtcRGiW7HvD
	 2QzMMPJmqO0UyWW5Zea0BppUto91qUppnx6x++Xi7+AvJnYmpmZzlpojTKkfugpwFnoYA
	 tlaWRLU6v2FVwNDo+a4sXAeOA8lTVkUSvwvL3N92d8LpiVOyBRfJB+SusXq/MTa8bWK6N
	 jLltvnzK04RglRKHnWrh6gQi8yEfTn7xHTCpgla3m+5H6k4O84i5YIS4Kep5qz/rtvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t+dp1pP0xamwz4n53lyfc97sCh9LQ3eNYV0gy9DVX6k=;
	b=pq8UueEisENy9fTLshXwYCDIOAHwT+UXSJ1t7xS0eiNsxs3pT7bl9DXdn5xnSFTdITIQ
	 Vy4+PaQhb5gDxkBN5Y4huabh+jlOVjI/6n+bO3Pz+AnMevYjVGfe4eIheEO4nnXCma3/N
	 We0C8R1qA29TfOa4k43TabUxuXv+MOpTBNvnId4HFQyvfmMzYVK/Zbds9Gxt5UsaaML6A
	 ipscDTsAi7VVwBczzkyAv6MIqHwJAg8FJmwQcDgEu99YFZU910zwCRDG+6UE/D5ZXLMK6
	 KsWVNXdb5iGP8il2CbT9buWaAST/ORgugszD/1eNu+Fg4lUrnBkQmAl7FMdU5WrS+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vExIB/01";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89576606A31C;
	Thu, 19 Nov 2026 01:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vExIB/01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCF61F000C4;
	Thu, 19 Nov 2026 01:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050976;
	bh=t+dp1pP0xamwz4n53lyfc97sCh9LQ3eNYV0gy9DVX6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vExIB/01+U4IsOaDTF4+zRx9jau1Qxms2c/Gs4JKzb4sXXYbddXNe8K2PFkfCHrd+
	 ex7osYxZ3K0Dakpwn6gnSyP9H2sJt5adlo1mJSBI3/F7GVXXOiCCHiyTtaWqyrTPTc
	 nr3Awhrg9TvmFx4xPQ0YykP4O0toJPxc8ImVNkIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zizhen Liu <pointerliu@126.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0003/2214] net: skbuff: propagate shared-frag marker in skb_zerocopy()
Date: Wed, 18 Nov 2026 15:27:59 +0100
Message-ID: <20261118150010.147157752@linuxfoundation.org>
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

From: Zizhen Liu <pointerliu@126.com>

commit 79dc34beb1fdb3da79753e51e15c68591a2561fe upstream.

skb_zerocopy() moves frag descriptors from @from into @to and takes a
reference on each frag, but it does not copy skb_shinfo(from)->flags into
skb_shinfo(to)->flags.  A destination skb holding the same page-cache
backed frags as the source therefore reports skb_has_shared_frag() as
false.

That breaks the invariant relied on by later in-place writers.  ESP input
checks skb_has_shared_frag() before deciding whether an uncloned
nonlinear skb can skip skb_cow_data(); with the marker lost, an skb that
skb_zerocopy() built for nfnetlink_queue or for an openvswitch upcall is
decrypted in place, letting an unprivileged user write into the page
cache of a root-owned read-only file.

Propagate SKBFL_SHARED_FRAG when frag descriptors are copied, as done for
the other frag-transfer helpers.

Fixes: af2806f8f90a ("net: Export skb_zerocopy() to zerocopy from one skb to another")
Fixes: f4c50a4034e6 ("xfrm: esp: avoid in-place decrypt on shared skb frags")
Cc: stable@kernel.org
Signed-off-by: Zizhen Liu <pointerliu@126.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261022104217.1852191-1-pointerliu@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adjusted context in skb_zerocopy() due to missing from->unreadable propagation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3241,6 +3241,8 @@ skb_zerocopy(struct sk_buff *to, struct
 	}
 	skb_shinfo(to)->nr_frags = j;
 
+	skb_shinfo(to)->flags |= skb_shinfo(from)->flags & SKBFL_SHARED_FRAG;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy);


