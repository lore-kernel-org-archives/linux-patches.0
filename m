Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064554;
	b=IzPB7DUJs+l+n/haw/HYrtwqpECp/FlWCoeTdRJKKpeE38wDoHzwt6qwwW6fbCeBzOwl
	 OPUzzkaO29rbELdnnQBpWPa02GdpbYcDp1Pwo8Xe5rvTCP0OoDBmwefqMBJz7V8wrWKSI
	 qMHPKjCSoupBF1vK4RG5Qi7jGvEzqAJMB2xlkSMVG81Ma75ZlUHm1KJmA9d6r8FpIyaHx
	 /SlCZSmkv+Z23Msarv023/e+biL4bPTQiu4Sqvi3LXiMo9ngPXdeXUcYXPM3OcjE84pB1
	 XuTonVOgmbyNisyuZ+f7GPT6O0bPtzR/jPywaHRlxnQ6kxrIUB1VIcObYbii7QUdMaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+qcsFv9a0dy+NrcuEgn6STPOrxG6HO3ZahEo9BUvQY=;
	b=Yk/qci8i7t9HLC3Q0aeSidAEHwSWy7dwF4/a6k1nhAJPhLjvDAQ/u5CNJ/IpefMygxiI
	 F/BYau8DaohlE1SnFL2kFOqpQlXlTnKs2xx/6xrEn5I7yUdxJSYpO2ryihCKsnJKWO+f5
	 favssuL/BrKCY0pkdCPipzy1hEFj86uvdqOTV1XZnARmS0A44GU2OfOOosK5DVtGnQ6or
	 IYTyivpRKVjpcOiHIyiH9Fbw/WYXlELG5ftejc5M0GQOdkxQbCzx1TuDXUVN9Ws18GpjW
	 T2CubUOXM2RjyJBOFzPde8z1q1zjLxGLy5ieW6WcWLTBUlWQGg1mS/FjEiwNSyDNpHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImRty2O3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301E1606B8A6;
	Sat,  7 Nov 2026 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImRty2O3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F891F008A1;
	Sat,  7 Nov 2026 15:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064554;
	bh=f+qcsFv9a0dy+NrcuEgn6STPOrxG6HO3ZahEo9BUvQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImRty2O3RejXGixbV0cA88/nWPUnrCuvSr0JbZijOW5aOvWLk/YXH1NGCmTfqkLsI
	 zj+ixdV1g96S548g4C+ClkyHZfeCjuTVrlDiqmBrbswAFoscN4vlDRvbuZTN1SbKmp
	 fOWuRUkO7Gj1tfe4aA/hSnSPx/D1j7/cyqTWS0wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0577/1257] mm/execmem: free ROX cache chunks only when they span an entire vm area
Date: Sat,  7 Nov 2026 08:47:53 -0500
Message-ID: <20261107134955.280010352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 52d95a55a0113408acd2d4ce0294a72c527f5092 ]

Patch series "mm/execmem: fixes and cleanups for the ROX cache".

Sashiko review of the ROX cache refill path asked what happens when the
PMD_SIZE allocation fails there.  Pulling that thread uncovered a bit more
than the fallback.

Patch 1 fixes a real bug, although rare bug: execmem_cache_clean() can
free a chunk that is still partially in use, because a PMD sized and PMD
aligned free range in the middle of a larger chunk looks exactly like a
chunk that nobody uses.

Patch 2 handles maple tree allocation failures in the cache.  They are
unlikely, but silently dropping an area from the tree is not a great way
to deal with them.

Patch 3 deals with the fallback that started all this.  The cache exists
to keep the direct map free of unnecessary splits, and the fallback
happily filled it with base page mapped areas that could never be freed
from the cache again.  Ask vmalloc for a huge mapping or nothing, and
serve whatever does not fit outside the cache.

Patches 4 and 5 convert the ROX cache to scope based cleanup.

The series was tested on x86 with module load/unload cycles, with PTDUMP
confirming that the cache is using 2M mappings, and with nohugevmalloc to
exercise the uncached fallback.

This patch (of 5):

When execmem refills the ROX cache, it vmalloc()s multiples of PMD_SIZE
aligned to PMD_SIZE.  For every such allocation vmalloc creates a vm area.

The first part of the vmalloc()ed chunk is returned to the allocation that
triggered the cache refill and the remaining part is added to the cache
and handed out for subsequent allocations with execmem_alloc().

When only the first part is freed, the entire vm area remains in the ROX
cache and can be handed out again.

In the case when the first allocation is larger than PMD_SIZE and the
second allocation from the freed first part of the chunk is exactly
PMD_SIZE, execmem_cache_clean() will free the entire chunk while part of
it is still in use.

For example:

	/*
	 * vmalloc(4M), return p0 to the caller
	 * add [p0 + 3M, p0 + 4M) to the cache
	 */
	p0 = execmem_alloc(3M);

	/* return p0 + 3M from the cache to the caller */
	p1 = execmem_alloc(1M);

	/* put [p0, p0 + 3M) back into the cache */
	execmem_free(p0);

	/* return p0 from the cache to the caller */
	p2 = execmem_alloc(2M);

	/* return p0 + 2M from the cache to the caller */
	p3 = execmem_alloc(1M);

	/* bah! execmem_cache_clean() frees the entire 4M chunk */
	execmem_free(p2);

Make sure that the ranges that execmem_cache_clean() frees cover the
entire vm area.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org
Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-1-11beb2a3d249@kernel.org
Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/execmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 74a178a87e758..33e4e68f655f0 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -165,9 +165,11 @@ static void execmem_cache_clean(struct work_struct *work)
 
 	mutex_lock(mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
+		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (IS_ALIGNED(size, PMD_SIZE) &&
+		if (vm && get_vm_area_size(vm) == size &&
+		    IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
 			struct vm_struct *vm = find_vm_area(area);
 
-- 
2.53.0



