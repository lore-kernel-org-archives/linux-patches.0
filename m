Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216173;
	b=gjoTX2CRdui0Q0pxYfuU3oOA1v2I3uJhP5Mv0HT2zIvdYanji42X+/Mw/cV2U3a5EcTt
	 13ui73NqKuMz3CVhLmSSZkL4tGsrDI6W09eGq2uJ2jJh46hh7W8koccKsUH6d4I98U/OR
	 zYIKFnEdLhlY7ckdvJjkBKxTVdX5slLTrmvINWnI5cd8Se+hsmNXyWRNBegLVZEVA2Riw
	 TTt1rOiCxd8QV3DwYxGPt0suJQndfvKeivZiVvwySuAsnuQzXDkiwEyR4mgf8LW10LqKL
	 /pr5zymsLLwu7rUWB0lA4YZAlNWuVkpatVCynpFcoZAJc1rl9ci/Z8YQwawOj4j4e5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xchktx0oJeb0x2KbS9cSJoiRtANV6rHwR3XteJuDkp8=;
	b=2FkL5G7O5NiYu1vY/3d1pMs4aeTWkrEBREXSult9KTFpzSUH7OJOvwlv2J2wROYmmV7g
	 YDEUkYP0lY9bJeBUDHzF4iCiQ8Lkoq2rSLVwlm3Q5HSkzoa9LfXunhDFyuc6HJkkWoHr0
	 ndyco9AKUBtvrYsRyjI49FK4O8GIDJFP4nFLUJUhoJ2QG2eoo/ryvhY0SNEJFxw/9SB2H
	 gkygckvFqzIaysSIr2Y8vgQwp03ye0CyxXO6iHw2QEU0hoKri/mKH+79Vz2wdUXekgOr/
	 oUx3XRAxJUDlDS7mpSKYn4clyp7BMVUlMvN2D+j8zCD19Qjm55S6d/WmyuIF8+V+zRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQRLSEJR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462A606A321;
	Wed, 28 Oct 2026 19:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQRLSEJR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AF31F01825;
	Wed, 28 Oct 2026 19:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216173;
	bh=Xchktx0oJeb0x2KbS9cSJoiRtANV6rHwR3XteJuDkp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQRLSEJRj2ObXehyrxUpvqQcpeXLOrOAu/wwysKrCOCPDhMd85+hKeJgge189To5j
	 8LAfemA8ZBRuBC1jlOB1U0962qL31e/sy+opxNzBKHgsVtp+QVFMFKHvUJRPtK1uzX
	 lX37ZN9AlO3MiHWrQ07iYBdxfi2E9A2xX9xKdSWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <borkmann@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1467/1887] bpf: Disable preemption in __bpf_get_stack
Date: Wed, 28 Oct 2026 17:59:23 +0100
Message-ID: <20261028170532.839410011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <borkmann@iogearbox.net>

[ Upstream commit b1a47b2708d4e95dbd23aee2ec83752190897b3f ]

get_perf_callchain() returns a per-CPU perf_callchain_entry buffer and
releases its recursion slot via put_callchain_entry() before returning,
so nothing keeps the entry reserved while __bpf_get_stack() consumes
it below.

A preemptible BPF program (e.g. a non-sleepable raw tracepoint program
on a PREEMPT kernel, which runs under migrate_disable() but not
preempt_disable()) can be scheduled out between obtaining the entry
and the copy. Another task scheduled on the same CPU then reuses the
same per-CPU buffer and overwrites trace->nr with a larger value.
copy_len is then computed from the inflated trace->nr and can exceed
the caller's buffer, causing an out-of-bounds write in the memcpy()
and in the build_id path.

The rcu_read_lock() taken here alone does not prevent this. It is
only taken on the may_fault path, and under CONFIG_PREEMPT_RCU it does
not disable preemption; it merely keeps perf's callchain buffer array
alive (freed via call_rcu()) and does nothing to stop another task
from reusing the entry.

Disable preemption around obtaining the callchain entry and copying
it into the caller's buffer, so the entry cannot be reused underneath
us and trace->nr stays bounded by max_depth. Build ID resolution may
fault and is therefore deferred until after preemption is re-enabled;
by then the instruction pointers have already been copied into buf,
so it operates only on that private copy. Note, preempt_disable() also
subsumes the buffer-lifetime guarantee the rcu_read_lock() provided,
since a preempt-disabled section is an RCU read-side critical section
for the callchain buffers' call_rcu() reclaim.

Fixes: c195651e565a ("bpf: add bpf_get_stack helper")
Reported-by: Tao Chen <chen.dylane@linux.dev>
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <borkmann@iogearbox.net>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803210149.296496-11-jolsa@kernel.org

Closes: https://lore.kernel.org/bpf/20260206090653.1336687-1-chen.dylane@linux.dev/
[ changed Fixes: commit ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index dcbc3b314d5c3..49652d55ba708 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -433,6 +433,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	if (sysctl_perf_event_max_stack < max_depth)
 		max_depth = sysctl_perf_event_max_stack;
 
+	preempt_disable();
 	if (trace_in)
 		trace = trace_in;
 	else if (kernel && task)
@@ -440,11 +441,15 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	else
 		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
 					   crosstask, false);
-	if (unlikely(!trace))
+	if (unlikely(!trace)) {
+		preempt_enable();
 		goto err_fault;
+	}
 
-	if (trace->nr < skip)
+	if (trace->nr < skip) {
+		preempt_enable();
 		goto err_fault;
+	}
 
 	trace_nr = trace->nr - skip;
 	trace_nr = (trace_nr <= num_elem) ? trace_nr : num_elem;
@@ -455,6 +460,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		stack_map_get_build_id_offset(buf, ips, trace_nr, user);
 	else
 		memcpy(buf, ips, copy_len);
+	preempt_enable();
 
 	if (size > copy_len)
 		memset(buf + copy_len, 0, size - copy_len);
-- 
2.53.0



