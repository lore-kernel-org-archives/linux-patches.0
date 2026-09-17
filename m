Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B134EB87C;
	Thu, 17 Sep 2026 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667066; cv=none; b=Kt6XfVChSrrYucZowTxXi/6cqpgsi8aqYOSgTFdIx6Ou8NBAK3eoWIWo8a+IahbNspPrQiHkF6tATBQt1NqzlKqCwDRD1frpl2oVppyv2Rs4nx6EcidmcqN1HyrZH09llkbbtHu/ByrALMzxs+DdbulWnCF21dXMhKGZ9EHEMDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667066; c=relaxed/simple;
	bh=b1dxcU1sV6mluwIlmrvBxVPaavSGFaIqePwiG/4Xazo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXBl6pJl2WiIRFJwqoDFQO0vzNeIPRSqFPI29LSqSDzMHW/U7stmO10vmKF+XyWKLqw/DOR30bG3mtzg8u/zUAqzS7MxoEAPuVe7RUXTsflbh3ASAG20TzwiBmiHbc+7CZhhbJ7/3Mslw0W1vve5pEZUFusZy+Nn64ANAhisHAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQpiidG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQpiidG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A8D1F000FF;
	Thu, 17 Sep 2026 17:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667065;
	bh=YvCq7db5IBVgA4hODwt6gXRutmG0BVswcZStGfwFsfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQpiidG/AKjIihOUTkUQkvZuAFGHEIJrz2ggyL/xfBgvJt8NfFChegbs5cYm6/Qd1
	 2GBxKlPMYd38YnPr0zL/GAsZKcEt9Hv4gF+196YQsgrCDhjLsbDZOXZgeslI7P1jtB
	 yHvjF0dNxaTX9b6cXGZdOCchYgUm4B1lCOsjPE6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1216/1250] ns: rename to exit_nsproxy_namespaces()
Date: Thu, 17 Sep 2026 16:16:51 +0100
Message-ID: <20260917151625.244830416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 4b06b70c8244b442d58ae0fb59870cf31fdb422e ]

The current naming is very misleading as this really isn't exiting all
of the task's namespaces. It is only exiting the namespaces that hang of
off nsproxy. Reflect that in the name.

Link: https://patch.msgid.link/20251029-work-namespace-nstree-listns-v4-10-2e6f823ebdc0@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: cdd812d0683d ("exit: hold a reference to thread_pid across proc_flush_pid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nsproxy.h |    2 +-
 kernel/cgroup/cgroup.c  |    6 +++---
 kernel/exit.c           |    2 +-
 kernel/fork.c           |    2 +-
 kernel/nsproxy.c        |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -93,7 +93,7 @@ static inline struct cred *nsset_cred(st
  */
 
 int copy_namespaces(u64 flags, struct task_struct *tsk);
-void exit_task_namespaces(struct task_struct *tsk);
+void exit_nsproxy_namespaces(struct task_struct *tsk);
 void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
 int exec_task_namespaces(void);
 void free_nsproxy(struct nsproxy *ns);
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1522,9 +1522,9 @@ static struct cgroup *current_cgns_cgrou
 	} else {
 		/*
 		 * NOTE: This function may be called from bpf_cgroup_from_id()
-		 * on a task which has already passed exit_task_namespaces() and
-		 * nsproxy == NULL. Fall back to cgrp_dfl_root which will make all
-		 * cgroups visible for lookups.
+		 * on a task which has already passed exit_nsproxy_namespaces()
+		 * and nsproxy == NULL. Fall back to cgrp_dfl_root which will
+		 * make all cgroups visible for lookups.
 		 */
 		return &cgrp_dfl_root.cgrp;
 	}
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -973,7 +973,7 @@ void __noreturn do_exit(long code)
 	exit_fs(tsk);
 	if (group_dead)
 		disassociate_ctty(1);
-	exit_task_namespaces(tsk);
+	exit_nsproxy_namespaces(tsk);
 	exit_task_work(tsk);
 	exit_thread(tsk);
 
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2455,7 +2455,7 @@ bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
 bad_fork_cleanup_namespaces:
-	exit_task_namespaces(p);
+	exit_nsproxy_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm) {
 		mm_clear_owner(p->mm, p);
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -241,7 +241,7 @@ void switch_task_namespaces(struct task_
 		put_nsproxy(ns);
 }
 
-void exit_task_namespaces(struct task_struct *p)
+void exit_nsproxy_namespaces(struct task_struct *p)
 {
 	switch_task_namespaces(p, NULL);
 }


