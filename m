Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590362;
	b=3KwAFpgc/pKSU6AfC2a9pdJ+PCVYC57Ya6nqqcQtt0CP9ZRi+zIUvJMwhScX/APWf3/s
	 XG49n9U64juPuV268W8bOD1TL1RwVCALJWA//7k4YH17NMAoJH06/q/enJVitb5sRI0qG
	 qFDu6IarekCSt5EnLDUbSdS7S0erxAledi1i9RHkAtJ1GhNsmIx7zY/mM9jbjiyZitIdX
	 ClQKuN6zFjejlyQ5eZKbLZ2OCPhFQqvomG1d5rvxxCEl0xiGwUm8a8MhaIcl1j4jTax2l
	 6WxnXJknygf2lFNdBevTgfx7ujKF6criemKHmBWxvwddqHs8/qT1hOj2HI7T5fTcB1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Wc0OqCJenM4HLv6hQUAXTS4BPDczhDEuyOSpOlash8=;
	b=T+dcPnn0PBw+zxMbPBAwkmgx/hxHhCV6mSMX4pDLa/ntBqCqWgLQvh3itcRkgKNaDDyB
	 nxCAPFx/dhdeMm2C8crH82OH0q5AH3ZIo+GyGgr4LGWm0xaOqj8yHGAFXFn2XiLYhJDra
	 GqBEcKF9eEsKwG0F/xfGHkWq2vt96VjbaK4PxibsLSP1R3cmhSm5Bni0mWhbnG029AQ4L
	 /E1HHj7V0KK0cO09YedoCmPa9wi87dphFD6utaYb04/NFceeJgi+VFHBfzJ7ciECohI41
	 oMrMnBfr6OM0lc1g8xI172vsQZP8zyzXLTVsjX9LFgZux1+J+z8ZYZ8K2NCjLQe6M6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5vhCbM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A92608316B;
	Fri, 13 Nov 2026 17:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5vhCbM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE71F000C7;
	Fri, 13 Nov 2026 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590362;
	bh=5Wc0OqCJenM4HLv6hQUAXTS4BPDczhDEuyOSpOlash8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5vhCbM8Dzdadh4XR0LD00phMR+E9sl1X2+8MYnj0m/FlT2HqJ5lxz1aB/ufQq+81
	 FqcOai7dnMaBzzBk6/w3FJj4Q/03CIuAIJ5zrvDemOJxOdtvzPEM9/uvhtY4BDR6mB
	 n5xeYwaqh9kU4HUUh+pJOKJ/VerYM/xryw+AMxm0=
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
Subject: [PATCH 6.18 320/686] mm/cma: accept memory of multi-range CMA areas
Date: Fri, 13 Nov 2026 10:47:33 -0500
Message-ID: <20261113153831.776866065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 90d3ab262dae0..d829726319d81 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -674,6 +674,8 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 			break;
 		}
 
+		accept_memory(mlp->base, size);
+
 		pr_debug("created region %d: %016llx - %016llx\n",
 		    nr, (u64)mlp->base, (u64)mlp->base + size);
 		cmrp = &cma->ranges[nr++];
-- 
2.53.0



