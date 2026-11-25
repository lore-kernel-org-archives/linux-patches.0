Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619791;
	b=YOBrlbQmBwJ3Vr2zaB1l80MpGwfOSUYvlotH8AlT4FbgFEBxW/REu0Z2tGp3YgGt5/Gd
	 OwYVZIlWyMX6elGr+cZmemyZeDbOm0O7uBHEz4/wd1p/QKz1eei0Z7BKpoq0Jlg8pWcJp
	 gNOVuN92YyKXlXF39zVuV73Q23dYRS7Ky3xsLF4wJ/PpQNeiS2xHTt+yDT2CVH7LQZA13
	 PeeFkEflNv4xGp3bDLAoOZPy8oEktFZBQGxYumJJjNy7gMt7JXaLJ+AcwAkYPKADiPorr
	 EVuHzRz/CJ66lfHylQ3HzX26q0/7qcxZCYNgQwstontnjjl56857ywsQAOB+Oe+23wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fvKwZiXbqUGTp1/KDcpUcLXpK58vojLMUPKS/2g6B80=;
	b=Zl+qyMu+K/UrHARtGDQdFvyQMlD0RPDGWStB15gHyhwaijMkIqConPmP5Vr6dcRQV6ZM
	 qUqli+r5v+9xHlFZ8vCddPHf0U+uKPywdpKOhIXW0x7t7QcWQMYfb+YTjgu6SvAeXzYho
	 ysj9MYDzBXb2eR6RnVFTVAGp+i5bEKWkhC0dduuQRRtooJiP1vhWPN2PQN7+dfsnumVs+
	 HKVsC37KxmbwKOKBDn3MJZY6DqlDsjp/kLGMGi9zJuZKpzgWfiHSFYDb0WCKrSbJ2FxH/
	 CRZM4SMpwWg+yrntlkYI9TpvUTvE4dl+/VDhmPwZRjYIqsypaYx67f8cQJXzsRmRKFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLzg2E62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FFC606A683;
	Wed, 25 Nov 2026 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLzg2E62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D0C1F000EF;
	Wed, 25 Nov 2026 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619791;
	bh=fvKwZiXbqUGTp1/KDcpUcLXpK58vojLMUPKS/2g6B80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLzg2E62DM5wco2Z273MeiumrL2oSK6WQc3TAFGpGQmXZIpJbTZ80weSbnKAh2nj2
	 y/MfpDFN7XwCvOfHkAuKdGLx4VEELlwVdqRGMIx6otV39QzHJOv/ACjtoxi9BVrLzX
	 dm6SxgWB3ajqDxoLwz4LdLAHboaTFZQs8lJm0EfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0710/1005] arm64: ptrace: dont warn on missing siginfo in a group-stop
Date: Wed, 25 Nov 2026 15:34:08 +0100
Message-ID: <20261125143838.391385350@linuxfoundation.org>
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

From: Zhao Gongyi <zhaogongyi@bytedance.com>

commit 5306f124f3171289b2ef5bac1e08aad175f66d1e upstream.

PTRACE_ATTACH to a group-stopped child can enter do_jobctl_trap(),
which calls ptrace_stop() without siginfo. If the tracer writes
NT_ARM_SYSTEM_CALL, system_call_set() can change syscallno from
NO_SYSCALL before update_syscall_orig_x0_after_ptrace() checks
last_siginfo. WARN_ON_ONCE(!info) then fires for a valid ptrace stop.

Keep the early return when siginfo is absent, but remove the warning.
This leaves orig_x0 untouched at a non-seized group-stop and preserves
the existing syscall-exit-stop handling.

Fixes: 88b839ce497c ("arm64: ptrace: Keep 'orig_x0' in-sync with x0 on syscall entry")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
[catalin.marinas@arm.com: modified comment as per Will's suggestion]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -573,8 +573,12 @@ static void update_syscall_orig_x0_after
 	if (regs->syscallno == NO_SYSCALL)
 		return;
 
-	/* We should only be called when target is in a ptrace stop */
-	if (WARN_ON_ONCE(!info))
+	/*
+	 * For exit-stops, info is always non-NULL, but that's not true for other
+	 * stops such as non-seized group-stops. In those cases, just return early
+	 * as there's no need to update orig_x0 anyway.
+	 */
+	if (!info)
 		return;
 
 	/*


