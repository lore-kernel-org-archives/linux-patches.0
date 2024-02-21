Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB93C2F;
	Wed, 21 Feb 2024 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522821; cv=none; b=kNY5mAHNJfbolcSouvFjwnRE0vnNWW9JiWWrSC55h72mUdoW8kxZGcqufwLMZ2K2q5YjXV6kaDlbjoy0LLKQIy90C8UxP2hRz5x31DNms2aiVZ417/F/GemGA6l5bAmubbtMidh77mtkzGLJtu1TPFsZ3y5SWvA/YvJArJuVLpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522821; c=relaxed/simple;
	bh=oENsB1eWUjoG9lUMQkruQBVgT5tev11z/GTZoAreGSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNnQipRWtC8dOkng/34NVe/QZ8C3BLP0bIj8IzJkXqMP6upvd8yxufoJbJe1INPIwISGEezQYXU8LyTdWg15a9RWqBLBdeC8HYgkw0JW0LmX9iNSNTi4o63qjVNsSLzrEj213am4Yhv1qsN2iNH5JDXmpng7L2J4x6Y8ht7r6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4pxNT5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4pxNT5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD139C433C7;
	Wed, 21 Feb 2024 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522821;
	bh=oENsB1eWUjoG9lUMQkruQBVgT5tev11z/GTZoAreGSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4pxNT5ST/uBJmfUvZSA4Z9moLy3VRDEk1JnCxRIt/uT6zduQcvdwv24MhSFw5fNN
	 KvTM4EzHgvqoS3ZoONQGYa/vY8E0x0mG7eFVkGqipnztjIa7XR2LRvQIyInm3mPC7+
	 dPLZjsBEpVcIt2uf40LYQDoNZ9mQfkM+AEuCY2w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Peter Lafreniere <peter@n8pjl.ca>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/476] um: Fix naming clash between UML and scheduler
Date: Wed, 21 Feb 2024 14:04:52 +0100
Message-ID: <20240221130016.789902654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2cfd42608a0..cb798a50e8cf 100644
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
 extern int cpu(void);
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index b3fbfca49400..4b6179a8a3e8 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -218,7 +218,7 @@ void arch_cpu_idle(void)
 	raw_local_irq_enable();
 }
 
-int __cant_sleep(void) {
+int __uml_cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
 }
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index 32e88baf18dd..4e429a41565c 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -45,7 +45,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	unsigned long stack, sp;
 	int pid, fds[2], ret, n;
 
-	stack = alloc_stack(0, __cant_sleep());
+	stack = alloc_stack(0, __uml_cant_sleep());
 	if (stack == 0)
 		return -ENOMEM;
 
@@ -69,7 +69,7 @@ int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv)
 	data.pre_data = pre_data;
 	data.argv = argv;
 	data.fd = fds[1];
-	data.buf = __cant_sleep() ? uml_kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
+	data.buf = __uml_cant_sleep() ? uml_kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
 					uml_kmalloc(PATH_MAX, UM_GFP_KERNEL);
 	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
@@ -116,7 +116,7 @@ int run_helper_thread(int (*proc)(void *), void *arg, unsigned int flags,
 	unsigned long stack, sp;
 	int pid, status, err;
 
-	stack = alloc_stack(0, __cant_sleep());
+	stack = alloc_stack(0, __uml_cant_sleep());
 	if (stack == 0)
 		return -ENOMEM;
 
-- 
2.43.0



