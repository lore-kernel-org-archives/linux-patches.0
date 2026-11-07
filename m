Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064627;
	b=G2s+1zESFOx19rJschN1PeDIFIMOrDaLTvYLmQWS7Z01o19cEWSaEPQNTaYbWtPgGVmS
	 h9U+IlkVevNPon0QdKhWBme7jqw5HOGsK5mhVTTvqe5+to4BYpIixlIz1uVET7whKh4eC
	 atMMH6PYEsWqw4rYYg4ToOFvjPQ4IxkhhSxv1+2Rrv4tdQF38ZlNfI625DSarO7d+JXr4
	 Cf42gQzXI95MUx/camHpuaqWPcbINX66iZ0P4bL1JCCB3RyVCT2hfcnnKiTWX9jTNJZKV
	 HM2eMbLYRU+tEZ6TyJfFtVKQrZ5+B90TlVRQeeCxVi9F33V6IJ8g21aK8J6ZwmaHTaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4DAgMtBzBAUNZz/0+KdDJeiCOWIUEvsooZmk98nsso=;
	b=Tuw/OFJpjAGQRgwbovQcZS1yL+PNHHo5rIephbefh1EZf28FoEPIG4jU4FZyHRukvLHB
	 u7neullcVIT7t7ICILuG+J78kRz9jwyorGp4VN3BphBPV65SnHnmlzJRXs1aRJr5WZ4it
	 Uw0dSg8fyQpeUUv2oMxjjuHfdTwxW6MZd4oez13eVs9kb8cHESD/gd9OlzxyXDlXvgKMp
	 VUtewrapgsSCixMle2k3DXd47hWKDCa54qoEQwWwoMHUjngyzBDu1iXeF4H4vQ4hb9fKR
	 4Tgxvmgg4yTwHPVmVL0sEeViAQul22/W6Ulfr38a+bkLquUfMg2s+mOLiHymTLSDP+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcqFcKkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513CD6082BC3;
	Sat,  7 Nov 2026 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcqFcKkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000601F0089F;
	Sat,  7 Nov 2026 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064627;
	bh=N4DAgMtBzBAUNZz/0+KdDJeiCOWIUEvsooZmk98nsso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcqFcKkcImXNQ9m7IGMXtoQY6mGPps7YZeC92x6/GW1re3/kcsnx1X4reF8GDjFuL
	 L2Mmsu/5kz+Qvm/D5EKtWW594MXdk+iD7jjcyb7fl9hKsdUcSu/QKBpHZJPncrWfvl
	 tn5gkZL2nYTnaJ/YIFOxmmHvDVrt6b5hTaeVovZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Christopher Lusk <clusk@northecho.dev>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0636/1257] m68k: Fix seccomp filtering on ColdFire and 68000
Date: Sat,  7 Nov 2026 08:48:52 -0500
Message-ID: <20261107134956.846631086@linuxfoundation.org>
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



