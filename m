Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038112;
	b=TRvB610I+hDlCMC7Ry1NRA0snVwh/1P0z3fnwxSDGegxEloHZAxcvmr/Fh3/9Ba5W9cs
	 0G+1wRABWOtGlVIQvqEh422jV6DRec/UxxfQA77SBw6ojuxexmJaSAidP3MY9VEGCGnCm
	 Ovli1VOFeN70XC2bUIalAR6+VsBUISl6iXJ6SIbw/YoDwE0nbfo+iu9mLH7vVCHBH8Tu7
	 RfikhNu78rWzXyiQuzUyI7Uri2SGA91ZIrkJ9F+rvzd93olkYIRm/6NxZAY+6CJniOfG8
	 JX9UmpKmH/YPYSMzHalGoFiuOuYmWZ5G/Nc4i3DbmSQy6X6BzCejXxnv9gizbh9k01w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xKnpRNZFNGixLxh+NJkkOzdSbKPNFGJgR76BvsCJA1I=;
	b=V7fP630wwk5PzD7sjB0gUj4HZKqYAbfvoQVeyiCwmGzdBkXWMadrM9ovKpelX8H80FDT
	 0KsZfwa6iPSFFR/Pjb5wkaIyqPeMqqrbMBz8DRvLm3liqYusiaN43nT0zSRNHe8ZMM7fN
	 2q0CNouRxq72ksikdIef1tm6pqq2AMQJLeFYJdfQW6+8nUSTyD9LpJsOgaH5VMpoijNFc
	 aMWIA6pT9WqiL4rFjaZObkf37HgxvcBeuwaj5N7lIRO1pcOH9aznsU/L+Lvibkpc1/8I9
	 FHqR5xY+YNmN1s8cih4rfqBAZKQGzNbUKOTWkcvdksp/FGdABPFLjkCt8S1yLV05i9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgCyZd+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B796F606A325;
	Wed, 18 Nov 2026 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgCyZd+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102B71F000C4;
	Wed, 18 Nov 2026 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038112;
	bh=xKnpRNZFNGixLxh+NJkkOzdSbKPNFGJgR76BvsCJA1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgCyZd+2nqxx4DvkALVUIyxxm1zj13+PESdHDzr/d2hINsG2WNyFJ4L+4Do4ulHT6
	 6TP/AFB5AVRAz3h7bQ5RXKbaT60uETxvOoZ+GRNLcMl6mV4BOqqRcDMkYP1QrLjSEB
	 t9r05JGWk8W/XjOnnyKX8dKsOVDNST1qZv/15zS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Christopher Lusk <clusk@northecho.dev>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1630/3318] m68k: Fix seccomp filtering on ColdFire and 68000
Date: Wed, 18 Nov 2026 15:37:32 +0100
Message-ID: <20261118150410.644272126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 37926b4b205af..6fc2971463695 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -82,7 +82,8 @@ ENTRY(system_call)
 
 	/* Doing a trace ? */
 	getthreadinfo
-	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TINFO_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
+	moveb	%a2@(TINFO_FLAGS+2),%d1
+	andl	#((_TIF_SYSCALL_TRACE + _TIF_SECCOMP) >> 8),%d1
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
 	jcc	badsys
diff --git a/arch/m68k/coldfire/entry.S b/arch/m68k/coldfire/entry.S
index 35104c5417ff4..95d98dead6245 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -75,7 +75,8 @@ ENTRY(system_call)
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



