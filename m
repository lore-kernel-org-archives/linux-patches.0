Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063831;
	b=titwOaGOSPQUeo/XG1qVk2VjO6+rsYcXyEI4bKghN/88KrjrobDvlgDqYTzNLVJ9LKh7
	 SkTtDTnqy5AZ7Vw/zTHuQ0zVUWsENhJd2XsYDeeHcb/0/RZEvHilnV0rNOlwcKJSd7fJ8
	 9CF+2IUIhs1W/eDhUpHiRHEkNBfSaEpHjTNVOvBoL1bH07mkdaAgJZc01p2p/JDZe0oPV
	 Q1czd9OuloWp3MHsaKT52wgtgK1vqrSiTrmAkHWx9VmUvE71RRYo/zTuGmasFxw3f8+zl
	 xDsDQZME8XQVHstBKlH2Zg/uVdADtVTa+O6i9tBVOi5+Z21VuLOuHbrcr/NBQF0gzKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vY/ZBYbOuo0rM9Z7Sv/+GVasXNJNTNZf7ZqGZtf/KBk=;
	b=gvQjYi2SM/yYzr7woy3n9bUS0FtGkVSuSFLc87NLUb94MTZhtAXJ711RoEdIfT1MnuK3
	 utp8Odlom3U/1pIO3lSSAegpTDNGbI5EgYWmsOa5u2+xhP9v4UJG5TRzwAKMhkDAG22Ih
	 DsDz5JrGf90EAJnuVmPaPSvf/+z6ZJ5mp0G7nA0KvmaCtZclXmhysxzxy4ZD4qYTPr7H5
	 MCcy4dtI3rLrt7gc9cKGt4UzsjFDFJwiaiAdCU12eOd+gDdihSQ8BFDH/hMmaItJg2l2V
	 P99mWrAjpTbHKnT/TW0gbssTNrtLqdSUCxyU1bSuu/wdNkikJluO4eUVlCHagStbs7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcAnpB5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F344606A326;
	Sat,  7 Nov 2026 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcAnpB5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33361F0089F;
	Sat,  7 Nov 2026 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063831;
	bh=vY/ZBYbOuo0rM9Z7Sv/+GVasXNJNTNZf7ZqGZtf/KBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcAnpB5zKwIBRTXAlXbTEJye+q6U9ygngUL42+3TKjUQKPobcfTnliWCGfq14HHq9
	 3PIUtrRFIM9abSAkUZMraDruMRc1dv1NotMimwkM+xPxxoTE1DkL/dqX1k3/HEPC1t
	 BSftHYMdBNWItO/ChV4y4K5ceeOdpXs0AX553krI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0012/1257] alpha: honor force_successful_syscall_return() again
Date: Sat,  7 Nov 2026 08:38:28 -0500
Message-ID: <20261107134939.764676153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Matt Turner <mattst88@gmail.com>

This fix is for 7.1.y, 7.2.y and 7.3.y only.  Mainline is not affected
since commit 83bd31c2840b ("alpha: enable GENERIC_ENTRY") in v7.4-rc1,
which replaced the saved-r0 check with a flag in thread_info.  That
conversion is far too large for stable, so this patch fixes the old
entry code instead.

Syscalls that return data rather than a status, such as PTRACE_PEEKUSR,
PTRACE_PEEKTEXT/PEEKDATA, osf_sigprocmask and shmat, call
force_successful_syscall_return() so that a result with the top bit set
is not mistaken for an error.  On alpha that clears the saved r0, and
$syscall_error and $strace_error used to check for this and take the
success path.

Commit 55b22075f784 ("alpha: add support for SECCOMP and
SECCOMP_FILTER") moved the restart syscall number to r2 and dropped both
checks, so any negative result now comes back to userspace as an
error with a3 set.  PTRACE_PEEKUSR of a register holding -1 fails with
EPERM, which makes sandbox abort when it traces static binaries during
Gentoo package builds, and PTRACE_PEEKUSR of a register holding
0xffffffffffffe000 fails with errno 8192, which breaks unwinding of a
ptrace-stopped thread in elfutils (run-backtrace-native.sh).

Restore the checks on both exit paths.  On the traced path the success
path also has to stop falling through into
SYSCALL_SKIP_RETURN_RESTART_GATE, which is meant for skipped syscalls
and would turn a forced-success result of -1 into ENOSYS.

Link: https://bugs.gentoo.org/985765
Fixes: 55b22075f784 ("alpha: add support for SECCOMP and SECCOMP_FILTER")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/entry.S | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index 9f2608de25446..fe88cd598492a 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -603,6 +603,14 @@ ret_to_kernel:
 
 	.align 3
 $syscall_error:
+	/*
+	 * force_successful_syscall_return() zeroes the saved r0 (the
+	 * syscall number): the negative return value is data, not an
+	 * error number.
+	 */
+	ldq	$18, 0($sp)
+	beq	$18, $ret_success
+
         /* Restart syscall nr comes from saved r2 (preserved even if r0 overwritten). */
 	ldq	$18, 16($sp)	/* old syscall nr for restart */
 
@@ -700,9 +708,11 @@ ret_from_straced:
 $strace_success:
 	stq	$31, 72($sp)		/* a3=0 => no error */
 	stq	$0, 0($sp)		/* save return value */
+	br	$strace_leave
 
 $strace_skip_call:
 	SYSCALL_SKIP_RETURN_RESTART_GATE
+$strace_leave:
 	DO_SWITCH_STACK
 	jsr	$26, syscall_trace_leave
 	UNDO_SWITCH_STACK
@@ -710,6 +720,10 @@ $strace_skip_call:
 
 	.align	3
 $strace_error:
+	/* See $syscall_error. */
+	ldq	$18, 0($sp)
+	beq	$18, $strace_success
+
 	ldq	$18, 16($sp)	/* restart syscall nr */
 	ldq	$19, 72($sp)	/* .. and this a3 */
 
-- 
2.53.0



