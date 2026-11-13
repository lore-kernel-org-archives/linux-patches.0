Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585620;
	b=fHU1c+VUgkObdQunHbV1WeaPPkgMS/ZseGo4rxszlDOJvZysO94wrkHSlCMXrGoZbFTJ
	 A2D5uhLSwyXjN6oNHZ8riWvZ3qs+Y73k/LdAM4lsaKtn0AwefZdGrxvr/MuKSX/KJwHr3
	 eATOg9Fopa6NMaaE+MhWaPFzUczwKiRmthjwUjge5g3OVlmy5x4MOKQogrGmLWe+A0D/G
	 iaVBJdWlSSGkLA+QF2r0CjYHfhbxNVsY5UrPtICrS998l1YwJ+hpfb7AAFUyUxVByHvXW
	 nnKxPa1tnfxCeS4tZqYLqxCfewMN+LGIfzr6t8rrhb1kye98czsk4JV0SePdO1kQdOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPNV7POUJfttgLws5IZT//4PKBgoJaN288dIsLiMUsA=;
	b=Iozx7FSQCGknrKvVcUVOnCcUsGkdUGkDkYZMl807ocjFdw9Q3GwmO64uOMzkZCnMsUnl
	 VsAXteQrk3BFHfpCeVECCtuZSuQHUY/PZ85EQHxQoLriUjDr7z2wXyuYGBc0kSNm5MHN0
	 GCLsWfTFogL7sulEjCK+YSKfl8BRIY0R4sYRDzlN2/vibyGtpINPbWcHI5MRpdoo/rtDC
	 CKXb2s4IPwupD6rUtZtuT4m0GAsyhYNRP9BY8fWhKHArRf8pXucTMDGsOYo3Y5tRXlEOq
	 UE/kudCfDfB9ihz+/J7jEH8aBRTjy5nmZ573VP80rIrc8FD98zdPGx6/6gZAoF8LXEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knjAXswt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E267606A889;
	Fri, 13 Nov 2026 16:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knjAXswt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7181F000C4;
	Fri, 13 Nov 2026 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585620;
	bh=MPNV7POUJfttgLws5IZT//4PKBgoJaN288dIsLiMUsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knjAXswtCm70hx7Q0WgC7TSMKChZ6R+LbehQLudwTAW3EhY26YGzJpP7BwJeUFAG7
	 uO7RLHji924CwBVqPZ1hF0xt+tn6OZlecqFtb/aZB7h1JHARj8bppAboD4F0w7AC+a
	 1c7ER8FBOJ7vvXvHlMlQSzTLf6uaLwnOKDU4UOuk=
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
Subject: [PATCH 7.3 243/507] mm/cma: accept memory of multi-range CMA areas
Date: Fri, 13 Nov 2026 10:49:07 -0500
Message-ID: <20261113153802.822029713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 5d002001601a163b6c3500cdc098ff66c34f62d8 ]

Patch series "mm/cma: accept memory of CMA areas reserved with
memblock_reserve()", v1.

Pages of allocated CMA areas are released to the buddy allocator with
__free_pages(), which does not check for unaccepted memory.

This usually works because memblock accepts the memory it allocates.

However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
requested with cma=<size>@<base> are reserved with memblock_reserve() and
their memory is never accepted.

On TDX and SEV-SNP guests the first access to such a page is fatal.

To ease the backporting, each case is addressed by a separate patch:
- patch 1 accepts the memory of multi-range CMA areas
- patch 2 does the same for the fixed CMA areas

The second patch won't apply cleanly to 6.6 and 6.12, but I believe the
stable team LLMs will take care of that :)

This patch (of 2):

On systems with unaccepted memory, memblock allocations accept the
allocated range, but when cma_declare_contiguous_multi() uses open coded
allocation of multiple ranges, it reserves them with memblock_reserve()
and they are never accepted.

These pages are released to the buddy allocator by cma_activate_area()
with __free_pages() that does not check for unaccepted memory, so the
first access to such a page in a TDX or SEV-SNP guest is fatal.

Accept the memory of each range when it is reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org
Link: https://lore.kernel.org/20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261da..0035efb1130a5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -678,6 +678,8 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 			break;
 		}
 
+		accept_memory(mlp->base, size);
+
 		pr_debug("created region %d: %016llx - %016llx\n",
 		    nr, (u64)mlp->base, (u64)mlp->base + size);
 		cmrp = &cma->ranges[nr++];
-- 
2.53.0



