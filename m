Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065043;
	b=nS9PVMRmLvmeXPzhZsVp8Q6N1OVwCe+8zX1M5mpVlwNrLGKLSxtXvsZqwa8fzQvLPT6P
	 NCzBlsXP0jwVQns8IahBki+FWorilR9nkKQEVgFRfKpTFvZU98KQQXbLbnLQ+ORsOGfIq
	 uHgCcYnT4twGvDf3jiVwqXFWfw0gXkUlek+DyNd+wGyhtQWfCAG9jgIsQ8Quc5aHnhvqc
	 mgkt4HrpwaHCCkm7rbn1YDeyHDHobA8Ls9nDbOAmAAK8D7FF6pxyXc2FVmfItWeVYZZVj
	 VmAozVaFNcxscyX23U9UXOmVXYFrwHp4B4L1dR8ISPcvIepwY+V5xu0pNBWkixrRP9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0NVLmReQYJb2kSqxEbNT/LGJ09Xo0PuvZuI+2O5uhPw=;
	b=SnScEZD2/OdD6ChoLSqjinUBZdhdnYSUKWsW/lufD6LFp42MLdJotXo2ri7QA/NWRc19
	 rSQ/zvyWztTqE8TlICNB/dqGn45rt7F+6gkfsMU3BCxxQPiN6ltjb/XgJZuRdtWd2518d
	 WOBsv8n3BeinTdNYxeWCd8Fn/MMVZPaiSoA1NlexSKCFzmTbrd6R84Nnq7HpQkbI0a6/t
	 T7J1wkBXTGKWPk/OoiVSiNq7EDxIFr4Iu/wjwpoJ2wN52d6kKC//UJAI7b56Vik/yzAU9
	 JbiSMuNEt1sTQr/C8Xguh7CPKzadF/yv4p2Eoo34PmEei65O3NFNC4K+CGY6zWjQd0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vn4oLXpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D846D606A333;
	Sat,  7 Nov 2026 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vn4oLXpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3721F0089F;
	Sat,  7 Nov 2026 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065042;
	bh=0NVLmReQYJb2kSqxEbNT/LGJ09Xo0PuvZuI+2O5uhPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vn4oLXpwebFxmUik1zsdekbkFtdyJZ8uxXLpscbNE96XAjegnotqJGl4ZwLnW3uHe
	 jJ8EeGAicDrvNi7rChujze3yOAphWfMi3rgG1KBYF+5g66D2QvULT6E3JQGxlssUDE
	 tFlM7aS7pZhk65ptNZ/+FI8J4T24dBge1z76AaoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kir Kolyshkin <kolyshkin@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0896/1257] cgroup: fix cgroup.kill for exited thread group leader
Date: Sat,  7 Nov 2026 08:53:12 -0500
Message-ID: <20261107135004.074264197@linuxfoundation.org>
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

From: Kir Kolyshkin <kolyshkin@gmail.com>

[ Upstream commit da13e0e72a7329c95642c44b2d03d194ab071e04 ]

cgroup.kill does not work in case a process' thread group leader is gone
but other threads are still running. This is because __cgroup_kill()
only walks the thread group leaders and sends SIGKILL to each of them
with send_sig(), which uses PIDTYPE_PID:

1. The exited leader is still listed by CSS_TASK_ITER_PROCS as long as
   the process has live threads, but a signal directed at a single
   exiting task never takes effect: complete_signal() does not look for
   another thread to deliver it to, and __send_signal_locked() now drops
   it altogether.  The process keeps running.

2. The live threads of such a process can be migrated to another cgroup
   by writing any of their IDs to cgroup.procs, while the exited leader
   stays behind.  The destination cgroup has no thread group leader to
   iterate, so writing to its cgroup.kill does nothing at all.

In both cases the cgroup stays populated after cgroup.kill, and a
process inside a container can use this to survive the container being
killed.  This also works with a private PID namespace when the init of
the container is the process, as the PID namespace is not torn down
while init has live threads.

Case 1 can be fixed by using do_send_sig_info(..., PIDTYPE_TGID) instead
of send_sig(), so that the signal is taken by a live thread even if the
task found by the iterator is exiting. Note it was pointed out by Eric
in [1] while reviewing v2 of cgroup.kill patchset, and v3 was meant to
switch to it, but the change was only made in cgroup_post_fork(),
leaving __cgroup_kill() with send_sig().

Case 2 can only be fixed by iterating over all threads, so this is what
the fix also does. Once a thread group is being killed, its other
threads are skipped since they already have a fatal signal pending.

I ran some performance checks and the added cost is ~60 ns per every
thread on my laptop (and less than a millisecond for 10K threads),
which seems low. The time to "populated 0" seems unchanged.

The issue was found in crun by Anthropic's OSS Scanner, and crun is
getting a workaround for it [2] (which does what we needed to do
before cgroup.kill was added).

[1] https://lore.kernel.org/all/m1v97x6niq.fsf@fess.ebiederm.org/
[2] https://github.com/containers/crun/pull/2351

Fixes: 661ee6280931 ("cgroup: introduce cgroup.kill")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 42cc77dfa1c8a..a1cc11009e49e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4289,7 +4289,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 	cgrp->kill_seq++;
 	spin_unlock_irq(&css_set_lock);
 
-	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
+	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_THREADED, &it);
 	while ((task = css_task_iter_next(&it))) {
 		/* Ignore kernel threads here. */
 		if (task->flags & PF_KTHREAD)
@@ -4299,7 +4299,7 @@ static void __cgroup_kill(struct cgroup *cgrp)
 		if (__fatal_signal_pending(task))
 			continue;
 
-		send_sig(SIGKILL, task, 0);
+		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, task, PIDTYPE_TGID);
 	}
 	css_task_iter_end(&it);
 }
-- 
2.53.0



