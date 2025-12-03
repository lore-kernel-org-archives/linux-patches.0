Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A4E3385B3;
	Wed,  3 Dec 2025 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777385; cv=none; b=nq079gpeST5e5cPTUrmEyUHSX9vSrUvE5Z+DzSawjwX9TQx/DLFF5McUBqWpzoGvYjBe0uXjieDxRzRhXqCHX2NZPSNm4bJxPnfG/ggBxN8dU6dCrR/E7WdbKuYz4Hn2FpLBtBiIbK2h9zjNuaGmsij3JDazQ3FnXH8iuh19UiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777385; c=relaxed/simple;
	bh=DIqrsKCzsuQzXtRP8vW2xji0XMTYMLJyfoD8ERCiK5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AcFkFZf4edS31MU2fKCXnLifytYSGrEVQxKr4zafacT47/x4qySB7188UhM2RqJOMaoVG2id/gSEOZpjzcnd3sxgHH4iMvnh337wZ5BR9py0Jhu2PmyIaL0YNlX+PA/oebTs78A+NDcFwkmUav3uMDoWXyrtAH0ou0jxUe1kgc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nl2bGZFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nl2bGZFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF7EC4CEF5;
	Wed,  3 Dec 2025 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777385;
	bh=DIqrsKCzsuQzXtRP8vW2xji0XMTYMLJyfoD8ERCiK5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nl2bGZFTfjRKmh0W2uZYAwI+yeFO6knD3kuuGHGyjORbw2alWJt79TPTRTq9qIPZf
	 emQrHpmga2RESim4FZ5M7Nr/c660SCrB0asd/LvvmT+lxg0xYviHdXMp+y9k0lC/H+
	 pStIv5SO4JQqU0A4Z8vC1lRP5QZrdXjBG8nvSSb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/392] riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
Date: Wed,  3 Dec 2025 16:22:51 +0100
Message-ID: <20251203152414.882617939@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 589fed479ba1e93f94d9772aa6162cd81f7e491c ]

Add macros for 64-bit RISC-V PT_REGS to bpf_tracing.h.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211028161057.520552-4-bjorn@kernel.org
Stable-dep-of: 7221b9caf84b ("libbpf: Fix powerpc's stack register definition in bpf_tracing.h")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index d6bfbe009296c..db05a59371056 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -24,6 +24,9 @@
 #elif defined(__TARGET_ARCH_sparc)
 	#define bpf_target_sparc
 	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_riscv)
+	#define bpf_target_riscv
+	#define bpf_target_defined
 #else
 
 /* Fall back to what the compiler says */
@@ -48,6 +51,9 @@
 #elif defined(__sparc__)
 	#define bpf_target_sparc
 	#define bpf_target_defined
+#elif defined(__riscv) && __riscv_xlen == 64
+	#define bpf_target_riscv
+	#define bpf_target_defined
 #endif /* no compiler target */
 
 #endif
@@ -288,6 +294,32 @@ struct pt_regs;
 #define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), pc)
 #endif
 
+#elif defined(bpf_target_riscv)
+
+struct pt_regs;
+#define PT_REGS_RV const volatile struct user_regs_struct
+#define PT_REGS_PARM1(x) (((PT_REGS_RV *)(x))->a0)
+#define PT_REGS_PARM2(x) (((PT_REGS_RV *)(x))->a1)
+#define PT_REGS_PARM3(x) (((PT_REGS_RV *)(x))->a2)
+#define PT_REGS_PARM4(x) (((PT_REGS_RV *)(x))->a3)
+#define PT_REGS_PARM5(x) (((PT_REGS_RV *)(x))->a4)
+#define PT_REGS_RET(x) (((PT_REGS_RV *)(x))->ra)
+#define PT_REGS_FP(x) (((PT_REGS_RV *)(x))->s5)
+#define PT_REGS_RC(x) (((PT_REGS_RV *)(x))->a5)
+#define PT_REGS_SP(x) (((PT_REGS_RV *)(x))->sp)
+#define PT_REGS_IP(x) (((PT_REGS_RV *)(x))->epc)
+
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a0)
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a1)
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a2)
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a3)
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a4)
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), ra)
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), fp)
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a5)
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), sp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), epc)
+
 #endif
 
 #if defined(bpf_target_powerpc)
-- 
2.51.0



