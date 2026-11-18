Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022567;
	b=IQox/TmlnGDhyrKJ84ny46XnAqUKdHx7/u/+WRf8DOblTONfXwEhTKzoGm85JdGP2QBF
	 YO8P4e5l5+9xdfik/nrc8aHWyVCjWf6FW1txMdhjRKDS4AKeJpmpOQSiWPAR5nb/7LoR6
	 zy/3X+6zomrmRETF9RS+gAREWUjOVATQ/VdfCYxKgIeXZjNNVoY8Wu8nvMDLoWgG7o23I
	 hB6HSm++Fa/QeqFyR+KKQP9nXr9O2Di+ICJT4qx/xfoJCf/IObvZcZwyTtx1DA1fy2mTS
	 fRqYnUcaKrBV7+0sDSr4xgtjSb5Cm//mwgnH8kes3bQq8C+kan+WtodKR9l+/m8C1Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8XQ/OdJirr0fbmFIt95HE2o3sUebaAoToJ0b6pBorHM=;
	b=Rc47MyB2w3pvQJqvbFsYG1c6bitbZ8IM55Zl/eGEPirlGWBIvq65Fc2fymTIdlOFvZCZ
	 s+QUDOWD0ePr3tkKsUbdCyqms/j7xShhhknH/01TcbdQura+75/qhbTdBeYFAX3mKxzSV
	 xK7BPWXgyEmAmru415lrRFzVsGl/Cip3Di6gWgXbfnRvT07sUBELgqd8hN1j19bBilxfZ
	 z1zHkCQx1N+RHKMSQrQ6GCDfahZ+Q6KX1V2VPVVE0pFnKMUvTvoCfAAUkSKJMQbQ5FxT4
	 QgiX85ocT4GVj2D60z3DOEFoMrDl6qD/KwRlG68vvnDvDQTjw5VJI4nhYEAGQQnlSgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMZupsDH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B17D606A32F;
	Wed, 18 Nov 2026 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMZupsDH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29C11F000C5;
	Wed, 18 Nov 2026 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022567;
	bh=8XQ/OdJirr0fbmFIt95HE2o3sUebaAoToJ0b6pBorHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMZupsDHLafRTQaB6sBiPVdU7xhhDcAVT9d4hFDNxmQB8T5j4aHAeqVEnjgziuLFI
	 7eAwgJjHCoVVVf/fmpMybzTuV8wWUFDCA1+wG9LyNl66JBZr1XQqtf8vWwFsEy7OCT
	 x0+8WKgcD/iBSmn2Fu6SBBWZN/lNk4q9ZE+fP4mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chanwon Park <flyinrm@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0060/2151] mm/page_alloc: let the highest memory node recover from hopeless state
Date: Wed, 18 Nov 2026 15:29:55 +0100
Message-ID: <20261118150123.937365726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit 83367658a01087375ede31ae343c99da03f72ac8 ]

free_frozen_page_commit() clears a hopeless node's kswapd failures once
its zone recovers above the high watermark, but only if another memory
node exists for allocations to fall back to.

The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
with a higher id.  The highest-numbered memory node therefore never
recovers on this path, and its kswapd stays disabled until reclaim on that
node makes progress and balances it, or demotion is re-enabled.

In many cases, direct reclaim many never fully run against a lower node
(CXL/kmem), and that means its kswapd can end up full disabled in rare
situations.

To reproduce, fill the highest memory node with bound, non-THP anonymous
memory and no swap until kswapd gives up, then free it: /proc/zoneinfo
keeps showing node_unreclaimable 1 for that node.  A lower node recovers.

Count the memory nodes instead.  Adding first_memory_node != nid to the
existing test would also work, but a count says directly what the check
means: some other memory node exists.

Link: https://lore.kernel.org/20261019184850.3427905-1-gourry@gourry.net
Fixes: e7a5f249e6db ("mm: re-enable kswapd when memory pressure subsides or demotion is toggled")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chanwon Park <flyinrm@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: Retained direct atomic accesses to kswapd_failures because the upstream helpers are unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bce50449902cb..2578475dd5d3f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2938,7 +2938,7 @@ static void free_frozen_page_commit(struct zone *zone,
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
-		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+		    num_node_state(N_MEMORY) > 1)
 			atomic_set(&pgdat->kswapd_failures, 0);
 	}
 }
-- 
2.53.0



