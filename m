Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062566;
	b=IPFEZOlhjjP89azmXCU0fnO2vjJA9Ps80NAVTUZnf2T59dgOGR0UfbHbVcnst1upg5Gr
	 qVelw61bUKkjIxx3Jm0O39dtuYmZXBPeI003HV6T27qdhZzLL3KhlTyM622WH7YmiX9xq
	 V9BgeiV++nigrjqEOTNoGU2OwRSMj6uZZkY51C842SKbZCl5GpHualliIaslb9bIiJU7I
	 t7gLF8S+kadW/oyuloTgd00az6oCYG7CZnJqrtBC75Y7DU2pDpI5AIZmBFuQxfEQ0k+kI
	 XKpHMnOZc8+KJGy5sA0muYJrblnsUw67F+6ew5a8jN5aeOTL3OIfdT5eFkWucbN6ZxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uj56g6s06BAHAULlVGRMiqjMMNzxskaGSXiqR6RW69o=;
	b=f/7wOutW7rDMRXGyR26zsd2lOvRTTNrI6Icg1pX6MO8UlZyZlZY5fq9uOwt/VH+0wgxN
	 5OG70f00kbwBxrTd1BxyrGSEBZQ5k4b41FBRyiMhYlBIF45Ip2el9G60O/nAZBZu3hyzO
	 gsJrIB7YNJ4mBTWbVabnCvcg+q3N2+4+1/LM4hSBRY8KRq2AoN3G3fs99E7PvwC7Q5TtW
	 V0dN4Ksopju4if/N3w/FoYaRg/gFKb8OfZgwsm31FwuDZwUftpwNnK2S5Be6hHtwgZr6s
	 U9Kzk+hmdvYISSevBMPKMWluu+6Ny7fRMgsq4FIccpeBHPu2l380o/yrq6RhKHLtbuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCUbjJ6a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24161606A333;
	Sat,  7 Nov 2026 14:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCUbjJ6a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE131F008A2;
	Sat,  7 Nov 2026 14:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062566;
	bh=uj56g6s06BAHAULlVGRMiqjMMNzxskaGSXiqR6RW69o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCUbjJ6avDynEq0kjJ8zr3i7gGNtzOT4XIkIJLa94Hqki01C5qMJWhad5pHWBgS2I
	 TouvXckiv/8f3aaZs7q1JQEJi68nCasja2a6Nh+vqsBPb4qClv7xCa8V6HSZ/O/ENJ
	 AVuA/0MdFUg33mvKYTEToFKm3cKtfaovmmSSdWqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1442/1536] mm/percpu: account full object size for percpu memory allocations
Date: Sat,  7 Nov 2026 08:57:38 -0500
Message-ID: <20261107135038.336739066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Harry Yoo (Meta) <harry@kernel.org>

[ Upstream commit c7a467fbcbbc31e57a5077bfc9456d9f29cb1571 ]

When memory allocation profiling is enabled, the pages backing percpu
memory chunks are attributed to func:pcpu_alloc_pages.  However, the
accounting of individual percpu memory allocations via alloc_percpu()
and friends record only the size of a single object rather than its
full size across all CPUs.

As a result, it is often not straightforward to identify which kernel code
is actually responsible for percpu memory, because the size is
under-accounted by a factor of num_possible_cpus().

Account full object size with pcpu_obj_full_size(size) instead, which
multiplies the object size by num_possible_cpus() and adds the objcg
pointer overhead.  This is consistent with what memcg already does for
charging percpu allocations.

Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
measuring mm_init()'s rss_stat counters.

Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:

                  bytes   calls   per allocation
    unpatched      6320     395         16
    patched      418176     396       1056

'percpu' field in memory.stat: 422400 (1056 bytes per process)

Memory allocation profiling now accounts the same amount of memory as
what memcg charges.

Link: https://lore.kernel.org/20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org
Fixes: 60fa4a9e2323 ("mm: percpu: add codetag reference into pcpuobj_ext")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Assisted-by: LLM # Verification
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/percpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 44764720b6d8f..cd28926438da5 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1705,14 +1705,15 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
 		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, size);
+			      current->alloc_tag, pcpu_obj_full_size(size));
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
+		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
+			      pcpu_obj_full_size(size));
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
-- 
2.53.0



