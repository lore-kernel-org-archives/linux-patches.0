Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017244;
	b=MHCzN/EpctgZRLA4aPBdBHwfaEvVLxr0bBh6mgIN0tYCy5JY51O1MhOyhDol+6G9fZyy
	 A4fSyw+Iy8zi/q2JJ9R1EOwB+OZKsNPYizhXHLHDt0darwhJcx53f8FMNWvNJd6a0Ai8Y
	 VdizlgQuoIwSvkPzwZsqIqU1bFO67sUA4ycBdiJ1z58zMqow1nxcbTOLA72iZkvcDZXrd
	 OUFiPdhlbN324bFyT7XHSiSbqdrCSBHERT+PW6riC/JOOdaIsZr2vOhnsju4VFyokdmGv
	 QdWyim9cl5P5B3uMmX6wudAGXXt44Sibkd5iWBSf7gFT+xwxk8ereMQj3dShVUB2tTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nw26Jjdk1o8NfJnSedxa0j46+HknvrUROF1XmHu48FI=;
	b=18nAkB2To+oIZ3GXenBv3+SHEeDwFb8AviOd6/FoXKWVhH3PobiEtghNrVhrOyZ7WHax
	 JpUfz+WsItGv1+LwoeaC9LHyISS0CCSkf/9xM8Dkt4BAUnURlN7t1OZDffIqQI0EJBHf6
	 u6fJFySM4H1bJ60hZOcVtC/L+y50omqufvwH1QGazyzymJNR5GR1HKmS+nnaaD7MQyJLJ
	 3ZxyVpzooSMv5iiu0F/KKLnf6DSUghRy6eyU1n5F+W/QzcSqzdx3TIFVnVap0oorXWuJZ
	 hgEfwPlw9RXRgYJwh+v45G6UVYvoL9Ja7YyFgDrOZjWGL4kMGi68hwCbY/XefqX898Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xjdgKbLi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E7B606A32F;
	Wed, 18 Nov 2026 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xjdgKbLi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF111F000C5;
	Wed, 18 Nov 2026 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017244;
	bh=nw26Jjdk1o8NfJnSedxa0j46+HknvrUROF1XmHu48FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjdgKbLiAcMi4FVJwgb+yGrONvKCq9S+kNqwiS+3rtBmuxo+H2plV4cqY/PcXLtbg
	 AyC1EsjNjiKeGzaMzjVAcQDg6ix3WnHVAkP9KG5geT2dk0Ww94WchCpXTiZsl7N0gd
	 bkOKApgXJO6nIMduBwsetD9u6WLd0prSMO/nxlUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0814/2651] bpf, x86: Fix timed may_goto with private stack
Date: Wed, 18 Nov 2026 15:34:14 +0100
Message-ID: <20261118150317.204201760@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit bb83425b3cdcb7bb3c629598a4d5efad9cc80733 ]

arch_bpf_timed_may_goto() computes the address of count and timestamp
as rbp + offset. When the prog uses private stack the JIT maps r10 to r9
and nothing is reserved under rbp, so bpf_check_timed_may_goto() reads
and writes the timestamp in the kernel stack, where
arch_bpf_timed_may_goto() has just saved r0-r5 or further down.
The following loop in fentry prog with r0-r5 set to zero:

  1: may_goto +2
     r6 += 1
     goto 1b

leaves r3 with ktime in it when the prog has 64 bytes of stack and
ends after 65535 iterations when it has 128.

Add the frame pointer to the offset in the JIT, where rbp vs r9 is
known, and pass the pointer in AX.

arm64 and powerpc JITs keep the address of private stack in BPF_REG_FP
and are not affected.

Fixes: 2fb761823ead ("bpf, x86: Add x86 JIT support for timed may_goto")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924233130.1213812-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c       | 12 ++++++++++++
 arch/x86/net/bpf_timed_may_goto.S | 10 ++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 6bca87457e872..476d77acd031b 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2658,6 +2658,18 @@ st:			insn_off = insn->off;
 					return err;
 				ip += err;
 			}
+			if (func == (u8 *)arch_bpf_timed_may_goto) {
+				u32 fp = priv_frame_ptr ? X86_REG_R9 : BPF_REG_FP;
+
+				/*
+				 * AX has the offset of count and timestamp
+				 * in the stack. Turn it into a pointer.
+				 * add r10, rbp or add r10, r9
+				 */
+				maybe_emit_mod(&prog, BPF_REG_AX, fp, true);
+				EMIT2(0x01, add_2reg(0xC0, BPF_REG_AX, fp));
+				ip += 3;
+			}
 			if (priv_frame_ptr) {
 				push_r9(&prog);
 				ip += 2;
diff --git a/arch/x86/net/bpf_timed_may_goto.S b/arch/x86/net/bpf_timed_may_goto.S
index 54c690cae1908..6c6e03f725a30 100644
--- a/arch/x86/net/bpf_timed_may_goto.S
+++ b/arch/x86/net/bpf_timed_may_goto.S
@@ -11,12 +11,6 @@
 SYM_FUNC_START(arch_bpf_timed_may_goto)
 	ANNOTATE_NOENDBR
 
-	/*
-	 * r10 passes us stack depth, load the pointer to count and timestamp
-	 * into r10 by adding it to BPF frame pointer.
-	 */
-	leaq (%rbp, %r10, 1), %r10
-
 	/* Setup frame. */
 	pushq %rbp
 	movq %rsp, %rbp
@@ -30,8 +24,8 @@ SYM_FUNC_START(arch_bpf_timed_may_goto)
 	pushq %r8
 
 	/*
-	 * r10 has the pointer to count and timestamp, pass it as first
-	 * argument.
+	 * r10 has the pointer to count and timestamp. JIT added the frame
+	 * pointer to the offset. Pass it as first argument.
 	 */
 	movq %r10, %rdi
 
-- 
2.53.0



