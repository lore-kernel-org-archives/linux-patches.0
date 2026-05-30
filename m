Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67C6395AD8;
	Sat, 30 May 2026 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162915; cv=none; b=k0cy87eAD3gm8uyW8vvmn1Yk5vt5UIfaCAaHfzIzla/EeKDVLhi0LQ6ejbqpDhuQRI63uzCa5LsD2VrxzvJ0EB5qISPkd6aY1vPA1dF+ygwhM2ig4WSXc+HXA9UguZN9ERVwWE4J0WcATZoNeaxZap8xRRefWRdzl/tHVKcaij4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162915; c=relaxed/simple;
	bh=EY57U94O04EKB6RUiUql61rOj4lglPC6+m5U3aKDEDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElzelGuopkU9B4CGlvxF+pH85PuU8+9USueK7ZGKVZQrYZ/+K6R4U5yJgU/gz+PQYHzzEnXOMk505f2dDzEaiaDW1IXcbS8BklbCLiDC+UqOlA3DFWosxJs4uDWr3IruZ5ZjeY5KIWQFyXm1mtJ6GZkPy4ZHTx6NESFMbRCAQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJUCQPhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJUCQPhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C141F00893;
	Sat, 30 May 2026 17:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162914;
	bh=x8o7Gg/lIVCib7YhW0DYcg7R8kEQRny3Y9meiQ71rr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJUCQPhvAUxOb/tbpHzAAi4GAL5Jbrlhe3bZicCczGxnI125+3+OrEGatCBq3oPMi
	 pFI8l5hU/dYKA6z8+gfS5wJ0olpBp7INtODzIZ/pDvRc6ugttsYzRDheVCLapeb2Z5
	 JomdSJbUqWCzmSCb+TZrU2LiM09DaW158MSljzH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 100/776] powerpc64/bpf: do not increment tailcall count when prog is NULL
Date: Sat, 30 May 2026 17:56:54 +0200
Message-ID: <20260530160242.927829198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Bathini <hbathini@linux.ibm.com>

commit 521bd39d9d28ce54cbfec7f9b89c94ad4fdb8350 upstream.

Do not increment tailcall count, if tailcall did not succeed due to
missing BPF program.

Fixes: ce0761419fae ("powerpc/bpf: Implement support for tail calls")
Cc: stable@vger.kernel.org
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260303181031.390073-2-hbathini@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Conflicts due to missing clean up commits
    b10cb163c4b3 ("powerpc64/bpf elfv2: Setup kernel TOC in r2 on entry")
    49c3af43e65f ("powerpc/bpf:   Simplify bpf_to_ppc() and adopt it for powerpc64")
    036d559c0bde ("powerpc/bpf: Use _Rn macros for GPRs")
  and missing feature commit 2ed2d8f6fb38 ("powerpc64/bpf: Support
  tailcalls with subprogs") resolved accordingly. ]
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp64.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -239,30 +239,32 @@ static int bpf_jit_emit_tail_call(u32 *i
 	 * tail_call_cnt++;
 	 */
 	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], b2p[TMP_REG_1], 1));
-	PPC_BPF_STL(b2p[TMP_REG_1], 1, bpf_jit_stack_tailcallcnt(ctx));
 
 	/* prog = array->ptrs[index]; */
-	EMIT(PPC_RAW_MULI(b2p[TMP_REG_1], b2p_index, 8));
-	EMIT(PPC_RAW_ADD(b2p[TMP_REG_1], b2p[TMP_REG_1], b2p_bpf_array));
-	PPC_BPF_LL(b2p[TMP_REG_1], b2p[TMP_REG_1], offsetof(struct bpf_array, ptrs));
+	EMIT(PPC_RAW_MULI(b2p[TMP_REG_2], b2p_index, 8));
+	EMIT(PPC_RAW_ADD(b2p[TMP_REG_2], b2p[TMP_REG_2], b2p_bpf_array));
+	PPC_BPF_LL(b2p[TMP_REG_2], b2p[TMP_REG_2], offsetof(struct bpf_array, ptrs));
 
 	/*
 	 * if (prog == NULL)
 	 *   goto out;
 	 */
-	EMIT(PPC_RAW_CMPLDI(b2p[TMP_REG_1], 0));
+	EMIT(PPC_RAW_CMPLDI(b2p[TMP_REG_2], 0));
 	PPC_BCC(COND_EQ, out);
 
 	/* goto *(prog->bpf_func + prologue_size); */
-	PPC_BPF_LL(b2p[TMP_REG_1], b2p[TMP_REG_1], offsetof(struct bpf_prog, bpf_func));
+	PPC_BPF_LL(b2p[TMP_REG_2], b2p[TMP_REG_2], offsetof(struct bpf_prog, bpf_func));
 #ifdef PPC64_ELF_ABI_v1
 	/* skip past the function descriptor */
-	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], b2p[TMP_REG_1],
+	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_2], b2p[TMP_REG_2],
 			FUNCTION_DESCR_SIZE + BPF_TAILCALL_PROLOGUE_SIZE));
 #else
-	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], b2p[TMP_REG_1], BPF_TAILCALL_PROLOGUE_SIZE));
+	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_2], b2p[TMP_REG_2], BPF_TAILCALL_PROLOGUE_SIZE));
 #endif
-	EMIT(PPC_RAW_MTCTR(b2p[TMP_REG_1]));
+	EMIT(PPC_RAW_MTCTR(b2p[TMP_REG_2]));
+
+	/* Writeback updated tailcall count */
+	PPC_BPF_STL(b2p[TMP_REG_1], 1, bpf_jit_stack_tailcallcnt(ctx));
 
 	/* tear down stack, restore NVRs, ... */
 	bpf_jit_emit_common_epilogue(image, ctx);


