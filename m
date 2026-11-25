Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623099;
	b=kR4lyRK/SCFK4nwaytvDoLFzb+3FV2tEJFXQ0NlmmtzdgHVdylf18NDxwYAslaNBSZMU
	 BQ0RAVJ4xCURcCdBIhAV9STLa6dtK48wI6DpQLiAYSR6IRX6L4isRlnY4Pc+uFVBVRNBN
	 Z2F3P9a0OT+oTO2FSDGe80kKZBNeFgakSpFrEu6lj+uB/iv5WnXNdHM+ahZf/gPgHEWf5
	 0QKj4C3qfy+im4p3l32lYmRBpFHBbhe3L9/4VRRrYi1zGlBmdzZJDWRW6NqKzfc1hPbQf
	 VJogOjEzZ87lJCLwxU0cRjK/wnxWa/M301h172zBoE9P9nlbzv0j0kkgnpfUIxipM0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OaPP0wg6n84DH0mb8m6HryWoCP333UWOa3hzfo4+ikQ=;
	b=mh3wgGdxlrZio9r9OVkeU8omwlsYJF6/6nxAuFMqoAMmaY92W7D5Qo5Qms6iMFfreKSC
	 qKO2XRkiaNZ+k0RzNMwC/+7d01W6K/lpJLsKEYSyMQgtHaHg9W55DJfAlEfJ9z+sHka8N
	 CxEu1i3dKmDhCLgFIu7gwAoljKKAARpwdB1ma/M/gF+lzUNQmw5hrcshW5o0LWs8EBsUX
	 rZHvyxSTM6iZkqn192LCuP/jl9XQxu3vWJ05a1rkzOexaWxqbajcvEIakAmSEFzrm+zhK
	 i6MBSj3OFqKxks0PXd0c5xVCku/5Hnbq+bQnB6vhrNuA9XHH1/hYML6pjEKC2cUaHpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7M2cuAN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BC0606A323;
	Wed, 25 Nov 2026 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7M2cuAN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF7D1F000C0;
	Wed, 25 Nov 2026 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623099;
	bh=OaPP0wg6n84DH0mb8m6HryWoCP333UWOa3hzfo4+ikQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7M2cuANTripEAYgiiHg3UDDy0B9F+jCLTLCS3XLLgBH1A4LQv4w3aQScE2l8Tovn
	 Htmw2oresZ/me8CfJkUByhovwhRXhkR8fresySrpeb43V7tHn/F7gFQE+5aahYTvIw
	 3l0NSdLV2oDI2o1gZgvBGHaiRI17QWtmgYyLPtZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 751/990] arm64: ptrace: dont warn on missing siginfo in a group-stop
Date: Wed, 25 Nov 2026 15:35:18 +0100
Message-ID: <20261125143839.651397957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


