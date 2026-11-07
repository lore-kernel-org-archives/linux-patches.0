Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065403;
	b=kgDrAOmLETFXrdzs4WB0S8Ow/z4YIDzS92f07ruVzJN/XX+6AsJfPNbO1roBcREGZsA6
	 CnQm9tpjHAqQPv1DoYbJb6HFES8zjh8ldhqL2ikYyLrn9pSMI5fVitfLI0acJCc2c1fV9
	 ABsvJT8taxkUmOQ2EqoqvSLMioJTPCMBTE4qwNruy++aULe7Z9sMvHBXK7Aw+rJV6TE2j
	 a4y9/+57qwnoxwYvSjmtX+phN5VtStC0GZl62hSUpgi/LO2gKcnm63v1JcTks7MwsjfEB
	 Qh60UlpLYEJHcxQZDoVw9vcYXUzCMMwN9h44g6TPOMztX4tqGJ0vxmsWxOuaN6OOYAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMNJt4znPkPdPr80r32H1PeBb5hBAprPEXSWHyKuYEs=;
	b=jPv2CyGR0yYR+CReNR8BJbovVn0fSvlX2r5kRDss/9oKIoWwxd1B80nNCYlXxV+RTEl7
	 Hv2Nz3381x2moB2YgKD+1GMUa7vBb7/leBENlWJzN3ckeDHbIT+ANysEVZGlfgu04cCcQ
	 c5LfBe6Jr2BMnJYhV4Oe/IJf2fIbkrrBbeCOL58hBmVYQQfmdcovB2BvaB8hfWyqgriJE
	 Al0Sgzudt/I2M//lAk2jbcL+p1qpbNSUa2f0Id5ZE7+qLM1PcOe9ew+sjQdNSBmCmnsgT
	 zq9Ndc9GhvfT/4FW5Wdy/Sbj401p4jpQpqel60RbYzYiY5DpIrjJl5BUwf5pfYEQryQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uVKs/+25";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4129F606A33C;
	Sat,  7 Nov 2026 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVKs/+25
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DCC1F008A2;
	Sat,  7 Nov 2026 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065403;
	bh=UMNJt4znPkPdPr80r32H1PeBb5hBAprPEXSWHyKuYEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVKs/+251/BMqlnZ7cd2FnGjphteWoUkMhzwrwYZW8QlwrPFu3+TEJg7NOKfO/7Ju
	 MdrmrtaWjBu36JV0bkQQtQBZiEDOlGaI6curvaIA0m1ZtcjWq9liMVMrQuiSULCkNA
	 W8Y8k/x3mlMfrDBsR2DHox930y0sXokQm+sWMQA4=
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
Subject: [PATCH 7.3 1085/1257] mm/percpu: account full object size for percpu memory allocations
Date: Sat,  7 Nov 2026 08:56:21 -0500
Message-ID: <20261107135009.227084832@linuxfoundation.org>
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
index a802d72c116fb..b0a4aa4e852bf 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1698,14 +1698,15 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
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



