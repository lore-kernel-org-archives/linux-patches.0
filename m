Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027852;
	b=LMdntCKyzK/gOuEs1comPSdh905PhuGk16HItugEAC8H7wD69zm+5B9Cfr8JTl5XCMqX
	 5vMasFGZdXnC6spULR1zpn1oTfNqJwY/k6m8qOq4poHeXzjb53oqXl3rBgEIf1cnmR0y3
	 UNKja0AOKs2NEtcA7x9x/DDOWhFaq3MCAf4m5X6R4nhuPMQO1AfrjHaalrZZSWKFSwAao
	 xYIU/y9o4F4LvYvdkPfT4haYucaRhG2DF4gSTxhp1yALyiLKY/AYRtD+X4JD6gAcuGu/q
	 XK/47y3Xnp8udYzLibQ+F84gEfuMuuMNy/Yvvdbrny/9kuxjLg7GJg0J0No8FvEDpJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=amkJ/si7T0tLPm8CWDBFpOXbO6xlK5sy8PgnAiEwgEE=;
	b=CDQ4IlTzCz+GizZKgS7FGgZCgTvopox0gCkljA2/rQ0f0zaLLLdnM/cF1T7PlUh0FKZh
	 jWvCnIQVtH0D/pPVml6l3mUs7jglNOJaK77fPQPsLRMqDvz03Dy5+oaIGSmJ6K0nA6/55
	 ojFrzXiSQvjIObxABZJzEVtdpxzyu85TeFyqVUz1HFW3BFeNssfE0MI2Yb6gHjTVwv7Up
	 UZJiP2rKfM/lMVlBkp5x7NeU/97H2xWaNYUqQQdyywTeI+7TzrEDBDoS7/mjFhSJxeaIE
	 srJZ0DiQgiaBthXdeX7Vr9i8ybNxM9oy7xDflx2NtXiTYfqgsnO12SXGH0aRD1ssyPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DgV/9I7L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3135606A31C;
	Wed, 18 Nov 2026 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DgV/9I7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C118E1F000C4;
	Wed, 18 Nov 2026 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027852;
	bh=amkJ/si7T0tLPm8CWDBFpOXbO6xlK5sy8PgnAiEwgEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgV/9I7L4HW6sC9QSLxn8/IAR/G+OM2wi2+28xNynbaAMgMGuN9pst3naRcP5607F
	 KmhbMzkQnLqCzY/qcAftWGucUzOj82O05e/juzIS/Osok0Z6ZDYscCYwzjKjtag+cD
	 ZpaLL/Btb1o2uElxGniMGsyMrD7Qhpp9Ge0TatZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Aditya Sharma <adi.sharma@zohomail.in>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1936/2151] bpf: Remove nmi_uaccess_okay() check in bpf_send_signal_common()
Date: Wed, 18 Nov 2026 16:01:11 +0100
Message-ID: <20261118150232.297431349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 1d30f154078f2..01a8b85c21857 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -837,15 +837,12 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struc
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



