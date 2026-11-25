Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618679;
	b=PiuVAATeEvV7IRav9BVmSrMn3dP499JI2zkAukv0SOIS8xBlMb2dHI8wM48AVyX9uQ5H
	 LcLo4EszPkElN9nIgJxqa8Ep0eZUlhkjMW97JTc80t7UlrjM17pa1cmA/8sIxTLZafS2B
	 upaCEEPYfTViIC+hcDnTeL8h6cXxdazyCBTP0Ake12jwcFC2OZhwFUMsXdcWFJ5g1jgZg
	 +ynOeyzJEmwYYm9mIIf2v9KotbwBq3FXf9DWjdVeWIIOQsk3xGUbaRgpXgxrpeIys+hED
	 SVjnDGX9gJStqFN3EJyCNPda3qWi3w6m5VCzqQNoCBHKw2oioij/8WcdyNL+3MFFAyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eWkhe/zquvr2h0PEeMjt/jQcEkkrMbKtLokfUOMxcfA=;
	b=OphZBJ0hcDWGw4c92KlRXxmsxeh2qz2eLKxddyqL48HODUOwvJZKNl9tW8EntZIENGcX
	 42IXi8xCGwYfHYMF6qlruEGwIG/Ljb4P1UyteE1uVBDLkFSbLhCQUvWeYostqMvwrQzJE
	 Jb2KvesuYKUzCubZWeRpFQ5v8Md5J6MOwY64LhRVcbRHyxQm7x4HBtTrpY+O09wv+Vv/U
	 h1kof8djjxoJ2wOMGmJaOyjjJGgOhlWNqlcM5XvHO467qX8KHCQKEu+IaSPELqDpFFm4b
	 IiB4CWmY2sEyOZD/pqhXcvaK41PD8Xwm1r7fv0XMle4wVXfE5ip6ecKJGL3Vr+wtBoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLIZMPbW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDFF606A31E;
	Wed, 25 Nov 2026 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLIZMPbW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E718F1F000C6;
	Wed, 25 Nov 2026 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618678;
	bh=eWkhe/zquvr2h0PEeMjt/jQcEkkrMbKtLokfUOMxcfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLIZMPbWZVSPb95OQOPhBwQb/YYyGVHa09dx7zV5tyVE9qVVWjSZUcXFbT77Xi+pI
	 g+ReYbXGRwGVC7euSSszFze7aqBBf7/A9q+yB9r5gctCfuHvgGSsjPnAzaLIhbSMNX
	 trIGVHOlcgjT04+aioSTOahzBIATGUMnZTSJ+5Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhuangzhuang Wang <3050681779@qq.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0353/1005] locking/lockdep: Fix inverted "on"/"last" CPU label in lockdep_print_held_locks()
Date: Wed, 25 Nov 2026 15:28:11 +0100
Message-ID: <20261125143830.005004543@linuxfoundation.org>
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

From: Zhuangzhuang Wang <3050681779@qq.com>

[ Upstream commit aa63c0df79920f6abe1b66e1f8b6443ad2d62d0e ]

Commit 051f5d223dfc ("lockdep: Enable the printing of held locks of
remote running tasks and print task CPU") added the task's CPU to the
"locks held by" line. As the comment above the printk() describes, a
running task should be reported as "on CPU#N" and a task that is not
running as "last CPU#N". The ternary has the two strings swapped, so
the labels are inverted.

Swap the strings so the output matches the comment.

Fixes: 051f5d223dfc ("lockdep: Enable the printing of held locks of remote running tasks and print task CPU")
Signed-off-by: Zhuangzhuang Wang <3050681779@qq.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20261030-lockdep-fix-cpu-label-v1-1-96875c74b15b@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c3dc84a7cef26..fdae495bf918b 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -811,7 +811,7 @@ static void lockdep_print_held_locks(struct task_struct *p)
 	 */
 	printk("locks held by %s/%d: %d, %s CPU#%d%s\n",
 		p->comm, task_pid_nr(p), depth,
-		task_is_running(p) ? "last" : "on", task_cpu(p),
+		task_is_running(p) ? "on" : "last", task_cpu(p),
 		depth > 0 ? ":" : "");
 
 	for (i = 0; i < depth; i++) {
-- 
2.53.0



