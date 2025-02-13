Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEB71C863C;
	Thu, 13 Feb 2025 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458488; cv=none; b=sv3jBQIciozTOOFZsF5CUvG/ckGf2GG8AsWPXhSDpnZcDUNFZJ3GE+YSwcdju+vPSasXm7+zUagcrXd3gEbxvxH23U7eQWgxw4tegkhaEEn8LF4rua4+/2UQmhGBlSruDe2gwSFVH53+CIhwbbEdE4cSDcN+KMgCVD76wKAQQKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458488; c=relaxed/simple;
	bh=0NXWlmckeu8fXqmV3yCVRNMo1MC7kldubx2s43s8oLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hXp8BGVcqzMIMo6lC7X2rRurnyqCnEJWGlrjWnkKQkfKIXYo8m+Oy9ZI3/OkcpYvgJIlgKEitknDof4OJ3CjoDtdmaq4ibngd1BWyXLTyUMZ6+IHEE/wPR0PJyjOeMYJEQpjXbzeNajX7PfD2RwDU3B2pZVlttf4gyqt7BXi7L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMuVnmfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMuVnmfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C566C4CED1;
	Thu, 13 Feb 2025 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458488;
	bh=0NXWlmckeu8fXqmV3yCVRNMo1MC7kldubx2s43s8oLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMuVnmfNYjS8cGJff6T6inxnE+BxpArf7ASgM088SRbkPy8DOhBeToblrlFhhnlcq
	 eELMpK9hk091Y/Uos0uwWYI6u6xrNzh9RhixFBy7CazJUyfvFjtjYTvGuHiBZ6ZsBO
	 9WaQI6jZ5E3i91RB7y7SpD0u1sxbctDgLuLVfr5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Libo Chen <libo.chen@oracle.com>
Subject: [PATCH 6.12 415/422] [PATCH 6.12] Revert "selftests/sched_ext: fix build after renames in sched_ext API"
Date: Thu, 13 Feb 2025 15:29:24 +0100
Message-ID: <20250213142452.578076494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Libo Chen <libo.chen@oracle.com>

This reverts commit fc20e87419e59d86f3bbcee2d4506bcd01c6450a which is
commit ef7009decc30eb2515a64253791d61b72229c119 upstream.

Commit "selftests/sched_ext: fix build after renames in sched_ext API”
was pulled into 6.12.y without the sched_ext API renames it depends on.
The prereqs can be found in
https://lore.kernel.org/lkml/20241110200308.103681-1-tj@kernel.org/
As a result, sched_ext selftests fail to compile.

Cc: stable@vger.kernel.org
Fixes: fc20e87419e59 ("selftests/sched_ext: fix build after renames in sched_ext API")
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c         |    2 +-
 tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c        |    4 ++--
 tools/testing/selftests/sched_ext/dsp_local_on.bpf.c                |    2 +-
 tools/testing/selftests/sched_ext/enq_select_cpu_fails.bpf.c        |    2 +-
 tools/testing/selftests/sched_ext/exit.bpf.c                        |    4 ++--
 tools/testing/selftests/sched_ext/maximal.bpf.c                     |    4 ++--
 tools/testing/selftests/sched_ext/select_cpu_dfl.bpf.c              |    2 +-
 tools/testing/selftests/sched_ext/select_cpu_dfl_nodispatch.bpf.c   |    2 +-
 tools/testing/selftests/sched_ext/select_cpu_dispatch.bpf.c         |    2 +-
 tools/testing/selftests/sched_ext/select_cpu_dispatch_bad_dsq.bpf.c |    2 +-
 tools/testing/selftests/sched_ext/select_cpu_dispatch_dbl_dsp.bpf.c |    4 ++--
 tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c            |    8 ++++----
 12 files changed, 19 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c
+++ b/tools/testing/selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c
@@ -20,7 +20,7 @@ s32 BPF_STRUCT_OPS(ddsp_bogus_dsq_fail_s
 		 * If we dispatch to a bogus DSQ that will fall back to the
 		 * builtin global DSQ, we fail gracefully.
 		 */
-		scx_bpf_dsq_insert_vtime(p, 0xcafef00d, SCX_SLICE_DFL,
+		scx_bpf_dispatch_vtime(p, 0xcafef00d, SCX_SLICE_DFL,
 				       p->scx.dsq_vtime, 0);
 		return cpu;
 	}
--- a/tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c
+++ b/tools/testing/selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c
@@ -17,8 +17,8 @@ s32 BPF_STRUCT_OPS(ddsp_vtimelocal_fail_
 
 	if (cpu >= 0) {
 		/* Shouldn't be allowed to vtime dispatch to a builtin DSQ. */
-		scx_bpf_dsq_insert_vtime(p, SCX_DSQ_LOCAL, SCX_SLICE_DFL,
-					 p->scx.dsq_vtime, 0);
+		scx_bpf_dispatch_vtime(p, SCX_DSQ_LOCAL, SCX_SLICE_DFL,
+				       p->scx.dsq_vtime, 0);
 		return cpu;
 	}
 
--- a/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
+++ b/tools/testing/selftests/sched_ext/dsp_local_on.bpf.c
@@ -48,7 +48,7 @@ void BPF_STRUCT_OPS(dsp_local_on_dispatc
 	else
 		target = scx_bpf_task_cpu(p);
 
-	scx_bpf_dsq_insert(p, SCX_DSQ_LOCAL_ON | target, SCX_SLICE_DFL, 0);
+	scx_bpf_dispatch(p, SCX_DSQ_LOCAL_ON | target, SCX_SLICE_DFL, 0);
 	bpf_task_release(p);
 }
 
--- a/tools/testing/selftests/sched_ext/enq_select_cpu_fails.bpf.c
+++ b/tools/testing/selftests/sched_ext/enq_select_cpu_fails.bpf.c
@@ -31,7 +31,7 @@ void BPF_STRUCT_OPS(enq_select_cpu_fails
 	/* Can only call from ops.select_cpu() */
 	scx_bpf_select_cpu_dfl(p, 0, 0, &found);
 
-	scx_bpf_dsq_insert(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, enq_flags);
+	scx_bpf_dispatch(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, enq_flags);
 }
 
 SEC(".struct_ops.link")
--- a/tools/testing/selftests/sched_ext/exit.bpf.c
+++ b/tools/testing/selftests/sched_ext/exit.bpf.c
@@ -33,7 +33,7 @@ void BPF_STRUCT_OPS(exit_enqueue, struct
 	if (exit_point == EXIT_ENQUEUE)
 		EXIT_CLEANLY();
 
-	scx_bpf_dsq_insert(p, DSQ_ID, SCX_SLICE_DFL, enq_flags);
+	scx_bpf_dispatch(p, DSQ_ID, SCX_SLICE_DFL, enq_flags);
 }
 
 void BPF_STRUCT_OPS(exit_dispatch, s32 cpu, struct task_struct *p)
@@ -41,7 +41,7 @@ void BPF_STRUCT_OPS(exit_dispatch, s32 c
 	if (exit_point == EXIT_DISPATCH)
 		EXIT_CLEANLY();
 
-	scx_bpf_dsq_move_to_local(DSQ_ID);
+	scx_bpf_consume(DSQ_ID);
 }
 
 void BPF_STRUCT_OPS(exit_enable, struct task_struct *p)
--- a/tools/testing/selftests/sched_ext/maximal.bpf.c
+++ b/tools/testing/selftests/sched_ext/maximal.bpf.c
@@ -22,7 +22,7 @@ s32 BPF_STRUCT_OPS(maximal_select_cpu, s
 
 void BPF_STRUCT_OPS(maximal_enqueue, struct task_struct *p, u64 enq_flags)
 {
-	scx_bpf_dsq_insert(p, DSQ_ID, SCX_SLICE_DFL, enq_flags);
+	scx_bpf_dispatch(p, DSQ_ID, SCX_SLICE_DFL, enq_flags);
 }
 
 void BPF_STRUCT_OPS(maximal_dequeue, struct task_struct *p, u64 deq_flags)
@@ -30,7 +30,7 @@ void BPF_STRUCT_OPS(maximal_dequeue, str
 
 void BPF_STRUCT_OPS(maximal_dispatch, s32 cpu, struct task_struct *prev)
 {
-	scx_bpf_dsq_move_to_local(DSQ_ID);
+	scx_bpf_consume(DSQ_ID);
 }
 
 void BPF_STRUCT_OPS(maximal_runnable, struct task_struct *p, u64 enq_flags)
--- a/tools/testing/selftests/sched_ext/select_cpu_dfl.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_dfl.bpf.c
@@ -30,7 +30,7 @@ void BPF_STRUCT_OPS(select_cpu_dfl_enque
 	}
 	scx_bpf_put_idle_cpumask(idle_mask);
 
-	scx_bpf_dsq_insert(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, enq_flags);
+	scx_bpf_dispatch(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, enq_flags);
 }
 
 SEC(".struct_ops.link")
--- a/tools/testing/selftests/sched_ext/select_cpu_dfl_nodispatch.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_dfl_nodispatch.bpf.c
@@ -67,7 +67,7 @@ void BPF_STRUCT_OPS(select_cpu_dfl_nodis
 		saw_local = true;
 	}
 
-	scx_bpf_dsq_insert(p, dsq_id, SCX_SLICE_DFL, enq_flags);
+	scx_bpf_dispatch(p, dsq_id, SCX_SLICE_DFL, enq_flags);
 }
 
 s32 BPF_STRUCT_OPS(select_cpu_dfl_nodispatch_init_task,
--- a/tools/testing/selftests/sched_ext/select_cpu_dispatch.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_dispatch.bpf.c
@@ -29,7 +29,7 @@ s32 BPF_STRUCT_OPS(select_cpu_dispatch_s
 	cpu = prev_cpu;
 
 dispatch:
-	scx_bpf_dsq_insert(p, dsq_id, SCX_SLICE_DFL, 0);
+	scx_bpf_dispatch(p, dsq_id, SCX_SLICE_DFL, 0);
 	return cpu;
 }
 
--- a/tools/testing/selftests/sched_ext/select_cpu_dispatch_bad_dsq.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_dispatch_bad_dsq.bpf.c
@@ -18,7 +18,7 @@ s32 BPF_STRUCT_OPS(select_cpu_dispatch_b
 		   s32 prev_cpu, u64 wake_flags)
 {
 	/* Dispatching to a random DSQ should fail. */
-	scx_bpf_dsq_insert(p, 0xcafef00d, SCX_SLICE_DFL, 0);
+	scx_bpf_dispatch(p, 0xcafef00d, SCX_SLICE_DFL, 0);
 
 	return prev_cpu;
 }
--- a/tools/testing/selftests/sched_ext/select_cpu_dispatch_dbl_dsp.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_dispatch_dbl_dsp.bpf.c
@@ -18,8 +18,8 @@ s32 BPF_STRUCT_OPS(select_cpu_dispatch_d
 		   s32 prev_cpu, u64 wake_flags)
 {
 	/* Dispatching twice in a row is disallowed. */
-	scx_bpf_dsq_insert(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, 0);
-	scx_bpf_dsq_insert(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, 0);
+	scx_bpf_dispatch(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, 0);
+	scx_bpf_dispatch(p, SCX_DSQ_GLOBAL, SCX_SLICE_DFL, 0);
 
 	return prev_cpu;
 }
--- a/tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c
@@ -2,8 +2,8 @@
 /*
  * A scheduler that validates that enqueue flags are properly stored and
  * applied at dispatch time when a task is directly dispatched from
- * ops.select_cpu(). We validate this by using scx_bpf_dsq_insert_vtime(),
- * and making the test a very basic vtime scheduler.
+ * ops.select_cpu(). We validate this by using scx_bpf_dispatch_vtime(), and
+ * making the test a very basic vtime scheduler.
  *
  * Copyright (c) 2024 Meta Platforms, Inc. and affiliates.
  * Copyright (c) 2024 David Vernet <dvernet@meta.com>
@@ -47,13 +47,13 @@ s32 BPF_STRUCT_OPS(select_cpu_vtime_sele
 	cpu = prev_cpu;
 	scx_bpf_test_and_clear_cpu_idle(cpu);
 ddsp:
-	scx_bpf_dsq_insert_vtime(p, VTIME_DSQ, SCX_SLICE_DFL, task_vtime(p), 0);
+	scx_bpf_dispatch_vtime(p, VTIME_DSQ, SCX_SLICE_DFL, task_vtime(p), 0);
 	return cpu;
 }
 
 void BPF_STRUCT_OPS(select_cpu_vtime_dispatch, s32 cpu, struct task_struct *p)
 {
-	if (scx_bpf_dsq_move_to_local(VTIME_DSQ))
+	if (scx_bpf_consume(VTIME_DSQ))
 		consumed = true;
 }
 


