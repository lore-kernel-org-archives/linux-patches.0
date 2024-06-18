Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A4713C3E0;
	Tue, 18 Jun 2024 13:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715852; cv=none; b=PeLnHsqwjUMRCVa3CL6yE8nepNxVAZyaNAwjjUb0OuHWFmoOUvQwIOnFwWMHuWtWC77GnEphhxD8dwhgjUDDOMZjTa/gbv73KUweifCdxgfRrQjHErnRa/s4E84LSAXycE8knBbE8s2aoCVzIWokKqD+/QwCg/sHuVLowZyi430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715852; c=relaxed/simple;
	bh=Bin7IkNG3e6UhRXsjNn/21H/0g4ouKOlmIx4L4A7HRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyxdpX2IZ/XY2sZmJ+HcOI5MHgXOde7MWv/X+KsVNMM3nBMuTzYemvkjjTyxR4Jon8lQyFXtjm96goxpXDPXDWUnXanlFoWjwbUWaoxvT8k1QmG8lXe2cRYWrW+dxK2uymFuKznSJmX7h4rctkOPrkvM3JwvmLeBjPxcrTX27FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/2zjpgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/2zjpgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371F6C32786;
	Tue, 18 Jun 2024 13:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715852;
	bh=Bin7IkNG3e6UhRXsjNn/21H/0g4ouKOlmIx4L4A7HRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/2zjpgP2ZQ340k4gN+iz/RjyqroFHC0xfD4Ir7zXFctRvjRyvwRhsGbAor/GIuHf
	 v/f5QFceI0vYrHe/GYLF4xPE7v4ePFww+yxVGaZ39p7Yl2SuffZLsVopDVEiPm6dGm
	 Lw3qYTrys99VT1WQdvMZOhi3TXeI4MXUbarV9QjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/770] exit: Rename module_put_and_exit to module_put_and_kthread_exit
Date: Tue, 18 Jun 2024 14:34:30 +0200
Message-ID: <20240618123423.381341834@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit ca3574bd653aba234a4b31955f2778947403be16 ]

Update module_put_and_exit to call kthread_exit instead of do_exit.

Change the name to reflect this change in functionality.  All of the
users of module_put_and_exit are causing the current kthread to exit
so this change makes it clear what is happening.  There is no
functional change.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algboss.c          | 4 ++--
 fs/cifs/connect.c         | 2 +-
 fs/nfs/callback.c         | 4 ++--
 fs/nfs/nfs4state.c        | 2 +-
 fs/nfsd/nfssvc.c          | 2 +-
 include/linux/module.h    | 6 +++---
 kernel/module.c           | 6 +++---
 net/bluetooth/bnep/core.c | 2 +-
 net/bluetooth/cmtp/core.c | 2 +-
 net/bluetooth/hidp/core.c | 2 +-
 tools/objtool/check.c     | 2 +-
 11 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 5ebccbd6b74ed..b87f907bb1428 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -74,7 +74,7 @@ static int cryptomgr_probe(void *data)
 	complete_all(&param->larval->completion);
 	crypto_alg_put(&param->larval->alg);
 	kfree(param);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 }
 
 static int cryptomgr_schedule_probe(struct crypto_larval *larval)
@@ -209,7 +209,7 @@ static int cryptomgr_test(void *data)
 	crypto_alg_tested(param->driver, err);
 
 	kfree(param);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 }
 
 static int cryptomgr_schedule_test(struct crypto_alg *alg)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 164b985407160..a3c0e6a4e4847 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1242,7 +1242,7 @@ cifs_demultiplex_thread(void *p)
 	}
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 }
 
 /* extract the host portion of the UNC string */
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 86d856de1389b..3c86a559a321a 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -93,7 +93,7 @@ nfs4_callback_svc(void *vrqstp)
 		svc_process(rqstp);
 	}
 	svc_exit_thread(rqstp);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
@@ -137,7 +137,7 @@ nfs41_callback_svc(void *vrqstp)
 		}
 	}
 	svc_exit_thread(rqstp);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index afb617a4a7e42..d8fc5d72a161c 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2757,7 +2757,7 @@ static int nfs4_run_state_manager(void *ptr)
 		goto again;
 
 	nfs_put_client(clp);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 408cff8fe32d3..0f84151011088 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -986,7 +986,7 @@ nfsd(void *vrqstp)
 
 	/* Release module */
 	mutex_unlock(&nfsd_mutex);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/include/linux/module.h b/include/linux/module.h
index 59cbd8e1be2d6..a55a40c28568e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -604,9 +604,9 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-extern void __noreturn __module_put_and_exit(struct module *mod,
+extern void __noreturn __module_put_and_kthread_exit(struct module *mod,
 			long code);
-#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
+#define module_put_and_kthread_exit(code) __module_put_and_kthread_exit(THIS_MODULE, code)
 
 #ifdef CONFIG_MODULE_UNLOAD
 int module_refcount(struct module *mod);
@@ -798,7 +798,7 @@ static inline int unregister_module_notifier(struct notifier_block *nb)
 	return 0;
 }
 
-#define module_put_and_exit(code) do_exit(code)
+#define module_put_and_kthread_exit(code) kthread_exit(code)
 
 static inline void print_modules(void)
 {
diff --git a/kernel/module.c b/kernel/module.c
index 949d09d2d8297..9030ff8c08555 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -336,12 +336,12 @@ static inline void add_taint_module(struct module *mod, unsigned flag,
  * A thread that wants to hold a reference to a module only while it
  * is running can call this to safely exit.  nfsd and lockd use this.
  */
-void __noreturn __module_put_and_exit(struct module *mod, long code)
+void __noreturn __module_put_and_kthread_exit(struct module *mod, long code)
 {
 	module_put(mod);
-	do_exit(code);
+	kthread_exit(code);
 }
-EXPORT_SYMBOL(__module_put_and_exit);
+EXPORT_SYMBOL(__module_put_and_kthread_exit);
 
 /* Find a module section: 0 means not found. */
 static unsigned int find_sec(const struct load_info *info, const char *name)
diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 43c284158f63e..09b6d825124ee 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -535,7 +535,7 @@ static int bnep_session(void *arg)
 
 	up_write(&bnep_session_sem);
 	free_netdev(dev);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 83eb84e8e688f..90d130588a3e5 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -323,7 +323,7 @@ static int cmtp_session(void *arg)
 	up_write(&cmtp_session_sem);
 
 	kfree(session);
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index b946a6379433a..3ff870599eb77 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1305,7 +1305,7 @@ static int hidp_session_thread(void *arg)
 	l2cap_unregister_user(session->conn, &session->user);
 	hidp_session_put(session);
 
-	module_put_and_exit(0);
+	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6afa1f8ca1614..0506a48f124c2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -170,7 +170,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"do_task_dead",
 		"kthread_exit",
 		"make_task_dead",
-		"__module_put_and_exit",
+		"__module_put_and_kthread_exit",
 		"complete_and_exit",
 		"__reiserfs_panic",
 		"lbug_with_loc",
-- 
2.43.0



