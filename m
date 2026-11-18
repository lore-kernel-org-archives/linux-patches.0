Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039180;
	b=Teszo7zlAD9pq747RJleYRIkpSg7ZUcW0r0zTQBZTMk2kaddEYW2q8eh0v0+ZFxN+uT+
	 Vyz2JMQiFn80MlBoL34xhtJxu4eMzOzPDm2hspZftN6HcUY4m7yww3cxVItcwsyxTMBLB
	 ZDNfdwv61sTt2w8ewmaneIRQhzPetG2EHMSM9MrR6iU+YS5sNZNI6Gd6dCS9SypdO7vaj
	 WJDUEIOTCKW9B5FsokoJi9Ye+ePjWFzzDgOTmKWRP9KducAE+r+rwKTLnS3ox9itlXZSd
	 lfA0wMBnVOTp3J25mmGe2qrcNydD8REPhcNQHi1qwnjuHAuMAgfnqY2VoBJqYMy8LEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HtbkDzaiXxhOBUDalUy91X/DoNp712wZiKNLLtVG71w=;
	b=tsEIy5V7mYWqtZMrKAc4UiqebiZS0onEegYqKxzMwL6QQ4sbxwqO1038spGLcR86+I56
	 LxwA3IbYRXWqTJUy0YP2dn7PZ3QeIWFW3RBj96Xj22ZsVQDH9DZGEdj8wDD2t6p9tPCBk
	 7n4MQuebqjoqCWI/OWB0E6xBh8/SLU5VC6dNPK6xEJxPHjULHO/2zaraVLiZLRgP1/T7L
	 HlC6FufvrmBJ/93IbWCt+gQUmHqeiw80/ohbGjP6vC+dciNSpNBLhmxP6oPXrUAz89SLd
	 CTgoQGLwjYgzSSHIzQlHBIZjmBPryf8aCZga7F+yvNlwtTIqe+Qkwowwf4H21h0obKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YwhIQKTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6407606A320;
	Wed, 18 Nov 2026 21:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YwhIQKTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD241F000C4;
	Wed, 18 Nov 2026 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039180;
	bh=HtbkDzaiXxhOBUDalUy91X/DoNp712wZiKNLLtVG71w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwhIQKTJJbZkBCCcEfYUp3KrqrSzK04zcWySIaoughApvluaEvCBBdj9kXT/IDnOO
	 Dg8wrqc+QwlDAZzRjMdUvSTBtNT4Ddt2TqbyfURJFZd4o6kgeKQBQDjsOyOLSQ9gUx
	 aqWoGhLOoJXv2m8Dpt/Pkx5PtP3YwjkB6Vwzv/3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1966/3318] mm/cma: accept memory of CMA areas reserved at a fixed address
Date: Wed, 18 Nov 2026 15:43:08 +0100
Message-ID: <20261118150421.070330408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit f8f9cbc34a309a388c052706f3329d1b52985aa3 ]

CMA areas allocated from memblock have their memory accepted by
memblock_alloc_range_nid(), but areas reserved at a fixed address with
memblock_reserve() are not.

If a fixed CMA area is requested by the cma=<size>@<base> command line
parameter, it may be in regular RAM and on TDX and SEV-SNP guests it
must be accepted.

Accept the memory of fixed CMA areas as well, so that all CMA areas are
accepted regardless of how they were reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-2-2cbced8b5cb7@kernel.org
Fixes: 75d090fd167a ("x86/tdx: Add unaccepted memory support")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: moved accept_memory() from cma_fixed_reserve() to the fixed-address branch of cma_declare_contiguous_nid(); 6.6's accept_memory() takes (start, end), so pass base + size ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index ac363f16d3923..906bad0393ddd 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -318,6 +318,8 @@ int __init cma_declare_contiguous_nid(phys_addr_t base,
 			ret = -EBUSY;
 			goto err;
 		}
+
+		accept_memory(base, base + size);
 	} else {
 		phys_addr_t addr = 0;
 
-- 
2.53.0



