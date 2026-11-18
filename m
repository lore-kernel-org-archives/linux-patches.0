Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021682;
	b=sYK3Pc48vWqWvBqrVErgfBKDi6gQQYGsvNJDDh2FligbG/DpUXtXIHXOSklyIk5J8/7+
	 UYex7zjPebamdrDbnjvEttkUluuyz0kIFUsN03impJ7KHng2de8w+vgGPLnOUaDc5Nv+B
	 kGTEBZdNiga5aU26z2gM5Xd3WqZAwj4TUgf/z/UNnslrAwbxZgVJXmAp//gTf7sPKI7PO
	 k2rlMemH+7avNiuBfo6qP5omRBnaCvs1hKcI54nRyfW5x5pS90ILFkU9acVZ4lZW1MVp9
	 0yCjhWDLK7GBDJeee0vYd0rIoZzrw5mH3S/HqXMv6LPehdhNHHXmgzRDdAHSH1rYMDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C5M1lwjTFckteHs92M6RTsf86CR2TU3/w8zdNlzjNh4=;
	b=vlKzWgoC8fM1999ZRw3caxK0hkYS5elZNgs+tcrKN85RHzHd97ZvYs/iSfMhlMkO/dm6
	 Vg/bsooEcxUo65Jclhwc0Ia+ggZAEpugoL8UsvscNdfOukUesDahRX/urlJ3APka4gU1g
	 7BafGJ/U/8ILqlByL3W3tAWYfnJvUy7EEIshmlO/eOGyi4Hk26J9W9rqg4g9NwEJxt1UU
	 YQMFOe46YX2SHaQ4C9GO6aGueJJyq0YJQGwb7DldZbWr83Qd2uLzCEUwc5287xvUU9A2G
	 9Ua4sCx21FmsSwL4LxHI+DGcZdZUiLlLuPkVrfwUE+JJISSUr531USjOVYwXu8VEqJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17Oq3iF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C796606A32A;
	Wed, 18 Nov 2026 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17Oq3iF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EB11F000C4;
	Wed, 18 Nov 2026 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021682;
	bh=C5M1lwjTFckteHs92M6RTsf86CR2TU3/w8zdNlzjNh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17Oq3iF8FkqDz1AkcArRFggd1BE2v02vh47Kg1zoIXUc3tz5Nb2uj232QiD12zldO
	 tEMSmWH5VqVnjrnBlvYg876b5yOyiR2Wjg9gp807EA1OmFb1EDndQ4qUgU8/joH3L+
	 j4racy8EueEB46iSr/7vFrvh7ujjSJFZOQ0XYYEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Aditya Sharma <adi.sharma@zohomail.in>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2393/2651] bpf: Remove nmi_uaccess_okay() check in bpf_send_signal_common()
Date: Wed, 18 Nov 2026 16:00:33 +0100
Message-ID: <20261118150411.539088426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index d649aaf13553e..08ddadd80056c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -867,15 +867,12 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struc
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



