Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590637;
	b=OVxbEUY8+erl5uNiNmu+SOPpFGnJKn7j9gXytQc5j8IzjpfBhrkL4UAG4e48p3ucbynF
	 bDGeIWGze46aW8kdsvp0iRBFTcOw6sMsB+lzWCHo9E162ssx6uhY49c9h6XchdzBkP3qq
	 Ce5vOf/NLb+YXjdFRXn4ATFTiXwg9cWE5dwfY1o/msS11KbmubQA1mJh6gfpa+HthWr/6
	 k4jzCHzuJ94IY5fEjNhSseRSqdWW8iwQ1uGlN32p3bRXi/VWFBtDDJrxfm7urk/OA2CxR
	 PCxYgp0Mi42jgr48Qll+zaGDz58nY1x3uAi3NUwOOZhxs1pE5mkDd5JDhgWSxidSmyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NgJ0aKNqMymfngXIOjy0zhXukKcc/XQ08clvMzDX+gA=;
	b=U7yyG6JK2W4xByGQt/dqAJ6yG+B0elD358UCriD7ojsliYOGF/Gfh9QILj1yfHSeOMuF
	 LiJc/2yGX6XLZvARIMFjjz/KlAShd4tDJsTt5okSuR1+2J8TNMKdrimdeGvjPtNCiebAs
	 hOzJuAB1FFNx/XWZzKUcB2giNE5IOtF1LaS0s45iMJDghC34b+VrDHqjE3xgvzcUwYK20
	 TIrn8ZSlSxBGGdKszhGD3K4nplbLEJVlJxdQ9LBT+H4B/IMJB9GC2ZPhTIP3Bf0Bmu1gk
	 T8RTlxe5p/WFm8E3E4RbGcPISRXdqdnFLUrodgZzdJe1WeOnWok9yuZFZfR2/W9WFMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rz9bCEsA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE4560A3820;
	Fri, 13 Nov 2026 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rz9bCEsA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3D81F000CB;
	Fri, 13 Nov 2026 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590637;
	bh=NgJ0aKNqMymfngXIOjy0zhXukKcc/XQ08clvMzDX+gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rz9bCEsAeXX6k8LjxRxth9fdvn/2Sdu4l0akV0KaeMZ3myZq0Mq7L9Y6w5+qgGtFH
	 bpIvZ4DbgUed2MN3ARuKtcAwM9xIao2+ixeEomDIogX6Z4w2hmeu5FsRZ45cvfmiAe
	 ZMhIA/4NaDFdHU9QAv/9lXMuq1G0PGhTpgCQKegI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Christopher Lusk <clusk@northecho.dev>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 515/686] m68k: Fix seccomp filtering on ColdFire and 68000
Date: Fri, 13 Nov 2026 10:50:48 -0500
Message-ID: <20261113153838.554193204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Christopher Lusk <clusk@northecho.dev>

[ Upstream commit 48859f8018d93bd93ef35f7430fdf5b97f2f9715 ]

m68k selects HAVE_ARCH_SECCOMP_FILTER for all configurations, but the
ColdFire and 68000 syscall entry paths only branch to
syscall_trace_enter() for TIF_SYSCALL_TRACE. TIF_SECCOMP alone falls
through to syscall dispatch, leaving installed filters ineffective.

Test the combined TIF_SYSCALL_TRACE and TIF_SECCOMP mask in both paths
and route either flag through the existing slow path. Leave the classic
MMU syscall entry implementation unchanged.

Validated the combined test under QEMU mcf5208evb (ColdFire): filters
denying getpid, openat, unlinkat, and reboot each returned -EPERM. A
classic-MMU control (q800) denied the filtered getpid syscall both before
and after this change. The 68000 path shares the same source-level
omission and receives the identical masked test but was not separately
emulated. Compile-tested W=1 with CONFIG_SECCOMP_FILTER=y on both
m5208evb_defconfig and a custom no-MMU UCSIMM configuration; the latter
built arch/m68k/68000/entry.o and vmlinux.

Fixes: 6baaade15594 ("m68k: Add kernel seccomp support")
Cc: stable@vger.kernel.org # v6.3+
Suggested-by: Andreas Schwab <schwab@linux-m68k.org>
Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Christopher Lusk <clusk@northecho.dev>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/68000/entry.S    | 3 ++-
 arch/m68k/coldfire/entry.S | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index c257cc415c478..0d3cbededc43c 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -79,7 +79,8 @@ ENTRY(system_call)
 
 	/* Doing a trace ? */
 	getthreadinfo
-	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TINFO_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
+	moveb	%a2@(TINFO_FLAGS+2),%d1
+	andl	#((_TIF_SYSCALL_TRACE + _TIF_SECCOMP) >> 8),%d1
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
 	jcc	badsys
diff --git a/arch/m68k/coldfire/entry.S b/arch/m68k/coldfire/entry.S
index 4ea08336e2fb0..d658abdc52075 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -72,7 +72,8 @@ ENTRY(system_call)
 	movel	%d2,%a0
 	movel	%a0@,%a1		/* save top of frame */
 	movel	%sp,%a1@(TASK_THREAD+THREAD_ESP0)
-	btst	#(TIF_SYSCALL_TRACE%8),%a0@(TINFO_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
+	moveb	%a0@(TINFO_FLAGS+2),%d2
+	andl	#((_TIF_SYSCALL_TRACE + _TIF_SECCOMP) >> 8),%d2
 	bnes	1f
 
 	movel	%d3,%a0
-- 
2.53.0



