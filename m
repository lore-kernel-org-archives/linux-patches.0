Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831355;
	b=LWWLbX1/qYMQA/PZFvP5N0FYVBCPtS6HJ3h0Ce/apJaGmci+CNZ7A7eFpFF6PQx4QdS7
	 Afpm78G/+NU75j3LWqQuqQwefQsHPTAbM2pFwacA1iwOR7+jz7p5dnV7gLdIldF02reMu
	 8EkjBtPRektVEoW3TsdtNnudVMUvCx7v2umRSAVssApXQA0kBSjW6hQ1SPxP3HFyXuCHV
	 ZDjDS8XozFWPG+QgRHwPu8GelSUr5WObR/IxVoCF2WdlgmTmdLoRrZ0s6c5rXkHvGr2GL
	 ao2slhaSTJX0MwndBU3qUZqYaZ7iXFjDYwMPd2v2nfFeU1qvi6P62n4vjWlnFcMfE4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ii5/s0VV54db2BimFgMvmy8QQqoaoedKtShAn2rIRc=;
	b=e7zdjZ3BNpvopNHzeTOjtx8NgGG9yeW7ei21uzyWTVQ+8nBej32FHV1h88qfduoo7Vnf
	 AYMWJZl9soRmcDds2j637Ib3M7y7CUlXFNFf4QjaCwUdlobaY1uiTIW1vYPDpkBiXa8ZF
	 6U2/DaAs1UY404/EQXIdVYL9E0KLarB7ZrSYs8oY8WiZuc6o1iSZ3oFLmnnBA5CtafjYs
	 E0S9UhG9iGzKGN6wKsy2ysDJN08TfoelDJUDxVnrHh75ImxCxtTB1ALUGRSSwAhQXXoym
	 7hazW+3FlB2XDhZGwnjwumP5qs8tTLCTWiW7NH1mE6SXeXIAIO0N4sfObnuh2xV9dXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0rvk+oB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774B4606A336;
	Wed,  4 Nov 2026 22:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0rvk+oB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098001F00919;
	Wed,  4 Nov 2026 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831355;
	bh=3ii5/s0VV54db2BimFgMvmy8QQqoaoedKtShAn2rIRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0rvk+oBdgQAuB8977MYq87JGB9OvOhrj/4syIhkB1aEZ9evYWWe7U+bfvfqMSnRZ
	 KUaJKFILeT9HlrbMwlt49gwObZKPL34KZAnuJznAtfR+G1R2E0GFogdg7h17A1ix8s
	 xQMnTo4L6rTnUd3kvz0ErkCaq9O2o56lB+UfTo7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0654/1005] cgroup: serialize migrations of newly forked processes
Date: Wed,  4 Nov 2026 16:06:27 -0500
Message-ID: <20261104211102.027798651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit bf6fbf46b5ff68c4eebad5aa52309eb124f4509c ]

With favordynmods enabled, a cgroup.procs migration takes the target
threadgroup's cgroup_threadgroup_rwsem for writing. A process fork holds
the forking threadgroup's semaphore for reading. These are different
semaphores when fork creates a new process.

copy_process() publishes the child's PID before cgroup_post_fork() links
the child to its css_set. A writer can find the child in that interval,
take its uncontended semaphore, and migrate it while child->cgroups still
points to init_css_set and child->cg_list is empty. Migration links the
node into init_css_set.mg_tasks. cgroup_post_fork() then adds the same
node to the intended css_set as though it were unlinked, corrupting both
task lists and their css_set ownership.

This regresses the fork/migration race fixed by commit b12b533fa523
("cgroups: add lock for child->cgroups in cgroup_post_fork()") and
restored again in 2012 after the lock had been removed. The old task_lock
protection was later superseded by global css_set and cgroup threadgroup
locking. The change identified by the Fixes tag narrowed only the migration
side back to a per-threadgroup lock, recreating the different-process
exclusion failure.

Take the new threadgroup's semaphore for reading before the child becomes
visible and hold it through cgroup_post_fork(). Use a nested lock subclass
because fork already holds the parent's semaphore. CLONE_THREAD children
share the parent's signal_struct and remain covered by the existing lock.
Migrations of unrelated, fully initialized threadgroups remain concurrent.

An AI coding assistant was used to identify and reproduce the regression
and to develop and test this fix.

Fixes: 0568f89d4fb8 ("cgroup: replace global percpu_rwsem with per threadgroup resem when writing to cgroup.procs")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 275c335c02a7f..07e1e29228197 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6702,6 +6702,31 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 	return cgrp;
 }
 
+/*
+ * A new threadgroup gets its own cgroup_threadgroup_rwsem.  Once its PID is
+ * visible, a cgroup.procs writer can find the child and lock that rwsem even
+ * though cgroup_post_fork() has not linked the child to its css_set yet.
+ *
+ * cgroup_can_fork() already holds the global read lock, which keeps
+ * cgroup_enable_per_threadgroup_rwsem stable.  Lock the child's rwsem as a
+ * nested instance until cgroup_post_fork() finishes.  Threads share their
+ * parent's signal_struct and are covered by the existing read lock.
+ */
+static void cgroup_fork_child_lock(struct task_struct *child)
+{
+	if (cgroup_enable_per_threadgroup_rwsem &&
+	    child->signal != current->signal)
+		down_read_nested(&child->signal->cgroup_threadgroup_rwsem,
+				 SINGLE_DEPTH_NESTING);
+}
+
+static void cgroup_fork_child_unlock(struct task_struct *child)
+{
+	if (cgroup_enable_per_threadgroup_rwsem &&
+	    child->signal != current->signal)
+		up_read(&child->signal->cgroup_threadgroup_rwsem);
+}
+
 /**
  * cgroup_css_set_fork - find or create a css_set for a child process
  * @kargs: the arguments passed to create the child process
@@ -6867,6 +6892,7 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
 			goto out_revert;
 	} while_each_subsys_mask();
 
+	cgroup_fork_child_lock(child);
 	return 0;
 
 out_revert:
@@ -6901,6 +6927,7 @@ void cgroup_cancel_fork(struct task_struct *child,
 		if (ss->cancel_fork)
 			ss->cancel_fork(child, kargs->cset);
 
+	cgroup_fork_child_unlock(child);
 	cgroup_css_set_put_fork(kargs);
 }
 
@@ -6998,6 +7025,7 @@ void cgroup_post_fork(struct task_struct *child,
 	if (unlikely(kill))
 		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, child, PIDTYPE_TGID);
 
+	cgroup_fork_child_unlock(child);
 	cgroup_css_set_put_fork(kargs);
 }
 
-- 
2.53.0



