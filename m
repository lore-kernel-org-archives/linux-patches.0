Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022009;
	b=PvWMz0V+BfMtlhei7++7Vug0QdoR0yGDig4zfx7P8sxbz8d6XIzIOwvHb72lkY/IfJgD
	 5C8L7c357yfbDoujX+z4bATBx/UaTHBOZPUkmLgpkvVmC1UyYjf5swohHL0VPU7+2IwAj
	 UmScmlsHo1joHW72iCW7WSQGDKUkBj9vg+UkAi2wGzDvjbwl0MSO52BhFdqaPE6V7Mh/C
	 zp+DXt32bCNwiulVZ1kh+nG+V74ZQgGr0BEZDS9IPV+bmGnGYTHQYW/q9hToBhT7be8Bh
	 6hdVObRtsIUqp+tFhuli9fpccOYMnwQC67P8vaYHtNAgp/VuyWUnVZuz5Kb4p4o5dHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aszbs1g/rzMPW5q3Q2WF2hbM4a156W6eBDcKMgIFTF8=;
	b=TW07/bA5B9sUTTduNd6PHhHOCWtloQR8lhdceB/PZQyjsntxhORdAtjsBWUSFRO9j5JF
	 05qHlN3VjmxpyQWBZgLjLB28mvGQTNn6Q8fV6+VNUB7igMlpOoDc27b5U9zzi0TCrPFx2
	 LxKJZPAEpeJLc/FZpJENLXOo7nNR6tmbT8N0aZrmj8CLx+GpqgQ6gHaTjwA/bMS20RSkx
	 erV6Ahj8FF2wI1CCMBGs5m3siIB3MXQ/tH2FEfqiBrhibZowXCl+ykWnNOch189n+R/z1
	 K+b0VwhUIa4OE1Cg7LMWmwpR6Yh6rG9lt05IMdo39rHCRnVtgoRZJQGrml3vQaxerlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4JmerWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AACC606A31C;
	Wed, 18 Nov 2026 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4JmerWv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58CD1F000C4;
	Wed, 18 Nov 2026 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022009;
	bh=Aszbs1g/rzMPW5q3Q2WF2hbM4a156W6eBDcKMgIFTF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4JmerWvpE7LIDCkhryB5Fp6PXH+x3CoUhPib79vwKqhcjpYXPit7sQkxT4p7ORB8
	 hXzKsBjGiU8PeFr6TtPzGtRA8VnheixLLb8vhvsqFT0RMkGHezOUJZ0iYNTwlUnIxG
	 TVc6Vzh4cJbNo+xrlHOvO05fZgcpSZYiNMwub8mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2493/2651] sched_ext: Reject scx_bpf_sub_grant/revoke() in tracing programs
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150414.594595608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit af4ed5682e62556beb399b76f2f1274ae1aad9e2 ]

A tracing program can call scx_bpf_sub_grant() and scx_bpf_sub_revoke()
through scx_kfunc_ids_any, which is registered on the tracing kfunc hook.
Before returning, both invoke ops.sub_caps_updated() of the sub-schedulers
whose caps changed, so those ops run in the tracing program's context. No
SCX op expects to run from an arbitrary tracing context.

With an rq lock held, this leads to the same deadlock that b07a7450f6ef
("sched_ext: Reject rq-lock-taking kfuncs in tracing programs") fixed for
direct calls:

1. A tp_btf/sched_switch program fires from __schedule() with the rq lock
   held. scx_locked_rq() only tracks rq locks held across SCX callbacks, so
   it returns NULL there.
2. The program calls scx_bpf_sub_grant() on a child, which invokes the
   child's ops.sub_caps_updated() before returning.
3. That op calls scx_bpf_cidperf_set() on this cpu, which sees no locked rq
   and takes the rq lock the cpu already holds.

Add both kfuncs to scx_kfunc_ids_no_tracing and rewrite the set's comment to
cover both reasons for membership: taking an rq lock and running SCX ops.

Fixes: 5f2a9a4c2e6c ("sched_ext: Add coalescing sub_caps_updated() notifier for sub-schedulers")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index d1a4603a66f13..4b04ed0441fc9 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -11218,19 +11218,28 @@ static const struct btf_kfunc_id_set scx_kfunc_set_any = {
 };
 
 /*
- * Kfuncs which may take the rq lock on their unlocked path.
+ * Kfuncs that tracing programs can't call. A tracing program can run in any
+ * kernel context, including with an rq lock held. scx_locked_rq() only tracks
+ * rq locks held across SCX callbacks and returns NULL there.
  *
- * A tracing program can execute in any kernel context, including ones which
- * already hold the rq lock (e.g. sched_switch). scx_locked_rq() only tracks
- * rq locks taken for SCX callbacks, so from such a context it returns NULL
- * and these kfuncs would acquire the already held rq lock again and deadlock
- * the CPU. They cannot be made safe for tracing programs, so keep them off
- * the tracing hook. Members must also stay in scx_kfunc_ids_any so that
- * struct_ops and syscall programs keep their access.
+ * scx_bpf_cpuperf_set() and scx_bpf_cidperf_set() take the target cpu's rq lock
+ * when scx_locked_rq() returns NULL. Taking it while the context already holds
+ * an rq lock, the same one or another cpu's, can deadlock.
+ *
+ * Before returning, scx_bpf_sub_grant() and scx_bpf_sub_revoke() invoke
+ * ops.sub_caps_updated() of the sub-schedulers whose caps changed, so those ops
+ * run in the tracing program's context. No SCX op expects to run from an
+ * arbitrary tracing context. One that calls scx_bpf_cidperf_set() hits the
+ * deadlock above.
+ *
+ * Members must also stay in scx_kfunc_ids_any so that struct_ops and syscall
+ * programs keep their access.
  */
 BTF_KFUNCS_START(scx_kfunc_ids_no_tracing)
 BTF_ID_FLAGS(func, scx_bpf_cpuperf_set, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_cidperf_set, KF_IMPLICIT_ARGS)
+BTF_ID_FLAGS(func, scx_bpf_sub_grant, KF_IMPLICIT_ARGS)
+BTF_ID_FLAGS(func, scx_bpf_sub_revoke, KF_IMPLICIT_ARGS)
 BTF_KFUNCS_END(scx_kfunc_ids_no_tracing)
 
 /*
-- 
2.53.0



