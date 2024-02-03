Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A9F12B82;
	Sat,  3 Feb 2024 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933639; cv=none; b=MyQRWZ6MZLrYhKUeO/GA6O7H8bsoUd33jwuFlISZ4Tub79sId306xSPsAYHXofEOwbsg6jL+fVrNYBXoE3szXeiL3MLpwwW2Vy7sFPDZCN977vXrQZNZzwHtUsRX6kS3+1f7Uw+Tk0pr93zypKZHCbkvcNIUshaoqB38PSTi8XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933639; c=relaxed/simple;
	bh=ZUOSJEQhoBTrjBj7Ro/7aXgx5pRtzXvoEsr3uEuJa3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSIoRswiQ64aUqZsiosjhSKIhDKTZsLn6CWBSvBvNiDrZS5fBA+neulkCD52duQdSDvlw0qQZQqH+UhM/yWleo+K8M5h8Xg1/L6/Gn1bJtWwWd+AJnZ1UpPki31M2Ci873tPFVswStkHe3gpIa4cfXkcdMdt5ln8QkSXKinxg0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIp/UFMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIp/UFMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D28DC433C7;
	Sat,  3 Feb 2024 04:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933639;
	bh=ZUOSJEQhoBTrjBj7Ro/7aXgx5pRtzXvoEsr3uEuJa3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIp/UFMtqXRYuVs3y44Mf8mc8lVBYYf40tjM2pmfYOxzZb59hoyMxLpgr3vCCmCMb
	 thMBegqTY5R1Cb1P9ESHvDPJAEBsgJKs+6eGoU/ar5TOfmxVzQRIDQWTDke2w29VOT
	 9CCtJ2v3d0CgZ+f04Z/VydKHZMimKjFjJ+DnqZ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Peter Lafreniere <peter@n8pjl.ca>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/322] um: Fix naming clash between UML and scheduler
Date: Fri,  2 Feb 2024 20:05:17 -0800
Message-ID: <20240203035406.350833663@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

[ Upstream commit 541d4e4d435c8b9bfd29f70a1da4a2db97794e0a ]

__cant_sleep was already used and exported by the scheduler.
The name had to be changed to a UML specific one.

Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/shared/kern_util.h | 2 +-
 arch/um/kernel/process.c           | 2 +-
 arch/um/os-Linux/helper.c          | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/include/shared/kern_util.h b/arch/um/include/shared/kern_util.h
index d8b8b4f07e42..444bae755b16 100644
--- a/arch/um/include/shared/kern_util.h
+++ b/arch/um/include/shared/kern_util.h
@@ -50,7 +50,7 @@ extern void do_uml_exitcalls(void);
  * Are we disallowed to sleep? Used to choose between GFP_KERNEL and
  * GFP_ATOMIC.
  */
-extern int __cant_sleep(void);
+extern int __uml_cant_sleep(void);
 extern int get_current_pid(void);
 extern int copy_from_user_proc(void *to, void *from, int size);
 extern char *uml_strdup(const char *string);
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 106b7da2f8d6..6daffb9d8a8d 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -220,7 +220,7 @@ void arch_cpu_idle(void)
 	um_idle_sleep();
 }
 
-int __cant_sleep(void) {
+int __uml_cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
 }
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index b459745f52e2..3cb8ac63be6e 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -46,7 +46,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	unsigned long stack, sp;
 	int pid, fds[2], ret, n;
 
-	stack = alloc_stack(0, __cant_sleep());
+	stack = alloc_stack(0, __uml_cant_sleep());
 	if (stack == 0)
 		return -ENOMEM;
 
@@ -70,7 +70,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	data.pre_data = pre_data;
 	data.argv = argv;
 	data.fd = fds[1];
-	data.buf = __cant_sleep() ? uml_kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
+	data.buf = __uml_cant_sleep() ? uml_kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
 					uml_kmalloc(PATH_MAX, UM_GFP_KERNEL);
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
@@ -121,7 +121,7 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 	unsigned long stack, sp;
 	int pid, status, err;
 
-	stack = alloc_stack(0, __cant_sleep());
+	stack = alloc_stack(0, __uml_cant_sleep());
 	if (stack == 0)
 		return -ENOMEM;
 
-- 
2.43.0



