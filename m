Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032823;
	b=oqRJt7UI1/CLt6g6NyeGpmsRPRceREkEItk8C0tTDttRN+8bk3+UNKASX3vycycueNLG
	 OwDLZpoJYgsIPSDgU9UZcB3hAhSzL0ShBhkmAUj0czH0HLAZdNquMXwVk1kFIz7ZQGYXH
	 X6SSHzRiwn9nRkosBfN7YjBGTIEhskwU26+Awi1n7ZIeHEUsmoGpaP41nDb1Ykgoxl1nE
	 B21t7RgQD080pG8IQk8e3W0vZ4XfTWJuQEi2nPLKzGfQpfWB/UxBUFeRD3gLAwWEQp24t
	 sC6GIrPHJ1fhy5IuThJmFlCHyFMZV+JJl1kf7xKO5HKtr9/F1QK0edwoZ92Ysa1fwhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cr3m0mztcNyc4D40qA2WIKspKpPu8vqkPfwod39LPNA=;
	b=tJoOlPwH0/qcYs54KYQOdUZ7GZa3Dsp1ARYHofrVFBfTDJOwi2RBZxKv3ZjeSBvb0GzE
	 TuJ/7+8zjdXIHSUIru0e2vlxOX0xb1UtUh3C2F3ptnIx5Z5UxBpJ96Q7sH2HUWF/i2Dev
	 oT1oQVQ9qpy8bvkjVK0HiUIK79Fu7e1saA9EXj1kO+EgmRpUWTcng+TJkW/VsjG1/mPox
	 epwGluG6bOz5um+4Rg6dIXRK8U2/0iJLdDZUIs8BpY5014a+U/bNPs+EYPmovT0HchIx0
	 1uT+NOtfEK8Eqx6snspa6uIY56/5atCPC4prJFGodQxtVp7htuQPo8Cz3IKHN5Fm83w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDajwzPa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F273606A31C;
	Wed, 18 Nov 2026 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDajwzPa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6388B1F000C4;
	Wed, 18 Nov 2026 20:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032822;
	bh=Cr3m0mztcNyc4D40qA2WIKspKpPu8vqkPfwod39LPNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDajwzPaczFp/3sakJJpCo+pY8LHa4+G5oNn5XaTUwljMceNmJ+DYTPLpTXYwFpnK
	 tWMFvXh/eOtTNYUyizmjYX5BpMShkbMdgjG6Jbl0hS0kQEpCxix5SntwZkSDYuqSWr
	 aOHP+LwKHs5V+MI+1IUSVqf/aL5m7LZ/G/hET5u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Aditya Sharma <adi.sharma@zohomail.in>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1547/1756] bpf: Remove nmi_uaccess_okay() check in bpf_send_signal_common()
Date: Wed, 18 Nov 2026 16:01:14 +0100
Message-ID: <20261118150110.511114250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Sharma <adi.sharma@zohomail.in>

[ Upstream commit 93bd472336ac2424f5f3cf05cbb24e02242343b7 ]

nmi_uaccess_okay() takes no task argument and is a statement about
current. When commit 6280cf718db0 ("bpf: Implement bpf_send_signal_task()
kfunc") made the PF_KTHREAD/PF_EXITING and is_global_init() test the
supplied task, nmi_uaccess_okay() was left testing current.

As a result bpf_send_signal_task() returns -EPERM whenever the
calling context happens to be a kernel thread, regardless of which task
the signal is aimed at. The same call with the same target succeeds or
fails depending only on what the CPU was running:

  bpf_send_signal_task() from tp_btf/workqueue_execute_start : -EPERM
  bpf_send_signal_task() from tp_btf/sys_enter               : 0

The check was carried over from bpf_probe_write_user() when
bpf_send_signal() was added in commit 8b401f9ed244 ("bpf: implement
bpf_send_signal() helper"). There it guards a user memory write, but
bpf_send_signal_common() does no user memory access, so the check has
nothing to guard here. It is also already a no-op outside x86.

Remove it, and drop the part of the comment above it that described
the memory access checks, as none remain.

Fixes: 6280cf718db0 ("bpf: Implement bpf_send_signal_task() kfunc")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20260819124324.43162-1-adi.sharma@zohomail.in/T/#u
Link: https://patch.msgid.link/20261001072449.1377267-2-adi.sharma@zohomail.in
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5abd26d3a8ab8..d6d9ca8c79746 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -845,15 +845,12 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struc
 		siginfo = &info;
 	}
 
-	/* Similar to bpf_probe_write_user, task needs to be
-	 * in a sound condition and kernel memory access be
-	 * permitted in order to send signal to the current
-	 * task.
+	/*
+	 * Similar to bpf_probe_write_user, task needs to be
+	 * in a sound condition.
 	 */
 	if (unlikely(task->flags & (PF_KTHREAD | PF_EXITING)))
 		return -EPERM;
-	if (unlikely(!nmi_uaccess_okay()))
-		return -EPERM;
 	/* Task should not be pid=1 to avoid kernel panic. */
 	if (unlikely(is_global_init(task)))
 		return -EPERM;
-- 
2.53.0



