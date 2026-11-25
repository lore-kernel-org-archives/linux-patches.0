Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619734;
	b=43nGIcM18F7Svze/Vl4FvmH0E0wrSKS5jRCO/H5WtNQfzEiPjKm359nPOZE9Nk/zwJC/
	 c7WMxND+TWwINwCdupfUo9b0qmmoqboMsAkdr+j3uQEG3XHXbW9am+HFMMG+VFVUM+GUP
	 AhjWX/BhQBSJZz5VYpIydXgepco4eKTxD+rhWmnOgjrYbtaWcCmg63HY8eHQSiQGYoqqz
	 Qvus4li2xqk13kD+Aewok+OlYKjwYPR90TKSNeC+kFoxHVc+8KGl9A8pLvqjvOpnT1l7y
	 iz2nCdPjtKbZ1ixX2l9RTB3+I7mOra45+g73xDnNdHT+cVxIDnpkMRFqZCzqN6lcLbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LPl656BAo355gM+1z4JYoi/lI4ITRshqodlV9WefDO0=;
	b=d4xcNJBpPHzNwG2SY09kB8PL7t3XGio/JFbUPjGGu7lWxc9YeT5xo0A1WVZ13hmUNBKu
	 nVd0JbuJ+QAblW/UsvmRLnWr9qc99GWYnPtuK1JaRUDzaAfZM0chr29jntIFtixrKxAp4
	 8NbikrVSh4NHtpzOryJH21cKAXNy7YdDvjD3GedSdHyd+DM8shB4hr6Y833d9FjPqOG7p
	 9oJqC8laaAWy7UrWZkizPwY2uxU9U0yAbSSayfjFFN/SNDUfTDmBd4rvNtdyHtw10cIwS
	 VI0ty6INNLBTxWqGBRcWlaxbVQXnGi8aK353S0k7MmWnpIBMBv/0VizXcNbXqlsCzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ScosEA7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006DF606A33B;
	Wed, 25 Nov 2026 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ScosEA7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065ED1F000D2;
	Wed, 25 Nov 2026 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619733;
	bh=LPl656BAo355gM+1z4JYoi/lI4ITRshqodlV9WefDO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScosEA7wd0jNMIDd8gqiytuATQf1v1Rvkib64skAF6t80nnjhJICd7OYooVFXdbyt
	 YcMvpdKJxmD7I0P1ScEQ+0osMWklZVNQNe5H1MZWX74aknFN9BRP4Lz2zhp0SQOcGw
	 Tlu3wC3VXGDTp/Ob3+zniWQExgrUDuHg9oS/CGao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.3 0689/1005] cgroup/freezer: walk exiting tasks in the v1 freezer
Date: Wed, 25 Nov 2026 15:33:47 +0100
Message-ID: <20261125143837.892592754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mani Tofigh <mt4022@columbia.edu>

commit 8ab6980c70076db5f8c0c66a5fac06472b254333 upstream.

An exiting task can stay frozen after its v1 freezer cgroup is thawed.
Since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
the css task walk hides an exiting task once its process has no live
threads left.  That count drops when another thread of the process
exits, which can happen between the freeze and the thaw walk.  A pid
namespace init hits this easily since it waits freezably in
zap_pid_ns_processes() after commit 81933038f5e2 ("pid_namespace: make
zap_pid_ns_processes() freezable"):

  Task A (pid ns init)      Task B (A's thread)      Task C
                            do_exit()
                              exit_signals()
  do_exit()
    zap_pid_ns_processes()
                                                     write FROZEN
                                                       /* A frozen */
                              /* live count 0 */
                                                     write THAWED
                                                       /* A skipped */

A then stays frozen even after SIGKILL:

  [   10.775155] task:fz-init         state:D stack:28152 pid:65    tgid:65    ppid:1      task_flags:0xc0004c flags:0x00080000
  [   10.775176] Call Trace:
  [   10.775180]  <TASK>
  [   10.775188]  __schedule+0x10f1/0x4760
  [   10.775252]  schedule+0xd7/0x2c0
  [   10.775265]  zap_pid_ns_processes+0x2c7/0x5f0
  [   10.775346]  do_exit+0x1bf4/0x2560
  [   10.775403]  __x64_sys_exit+0x3d/0x50
  [   10.775414]  x64_sys_call+0x156c/0x1570
  [   10.775425]  do_syscall_64+0xfb/0x590
  [   10.775450]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [   10.775529]  </TASK>

Use CSS_TASK_ITER_WITH_DEAD in the three v1 freezer walks so they all
see the same tasks, as commit 60f21a264930 ("cgroup, sched_ext: Include
exiting tasks in cgroup iter") did for sched_ext.  With the fix, A is
thawed and exits.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 10s.

Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/legacy_freezer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -265,7 +265,7 @@ static void update_if_frozen(struct cgro
 	rcu_read_unlock();
 
 	/* are all tasks frozen? */
-	css_task_iter_start(css, 0, &it);
+	css_task_iter_start(css, CSS_TASK_ITER_WITH_DEAD, &it);
 
 	while ((task = css_task_iter_next(&it))) {
 		if (freezing(task) && !frozen(task))
@@ -309,7 +309,7 @@ static void freeze_cgroup(struct freezer
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&freezer->css, 0, &it);
+	css_task_iter_start(&freezer->css, CSS_TASK_ITER_WITH_DEAD, &it);
 	while ((task = css_task_iter_next(&it)))
 		freeze_task(task);
 	css_task_iter_end(&it);
@@ -320,7 +320,7 @@ static void unfreeze_cgroup(struct freez
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&freezer->css, 0, &it);
+	css_task_iter_start(&freezer->css, CSS_TASK_ITER_WITH_DEAD, &it);
 	while ((task = css_task_iter_next(&it)))
 		__thaw_task(task);
 	css_task_iter_end(&it);


