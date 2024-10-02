Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62B51D0788;
	Wed,  2 Oct 2024 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876080; cv=none; b=hx4sTW1leqKZqBAstgi1i/bA7pso5YcyUhMNSv0CkdvIT5sZZla3bLyWiV9o1GoEohFYHtL94A81OcVpomV5UVZdMjALTylYZ6+n8nmUXqUDHmX0aDYdlg66RuqTCosDzKM9w+M026cZsf7ZI6G+Yrz4SZHn9pX4QRAy9PER2Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876080; c=relaxed/simple;
	bh=zhsHDZLAPv1Foyc+yFDh7985Pc3VAG42QOE0PFzumzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj5/4n1LxjL3Xd9Mz2gSXiKeX5gnAtS/MmgUMcjRKXRhtKKNsLrq7SwgXQwbP9Ea4aiSk3UD94/kyYMU3BFYEZr9AMuGCTmbKvU1q0dQcaWCgou5JYD8RFLfI+CEbpyE07IWSFDUcKrrFv6eNQ7uAEI8SeEyb7koB0stHx0b9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIByOZEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIByOZEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256DFC4CEC5;
	Wed,  2 Oct 2024 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876080;
	bh=zhsHDZLAPv1Foyc+yFDh7985Pc3VAG42QOE0PFzumzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIByOZEILnKVbyqWjR/tevdP0emwg4oraSiQMSmo1MQV8KPFDpROPsYknAyEZDpeF
	 wJkmqUpu3+iEUgg9nwDzhwPeb8xxK1eEFyrj3FNmt0j+WY1wWZ5F7yk3bjnH8UfzHD
	 yWIHcMHFHlV86h4eyO3DbNc4Z4CruaFj1wEpTM10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Qiang Wang <wangqiang1@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 291/695] samples/bpf: Fix compilation errors with cf-protection option
Date: Wed,  2 Oct 2024 14:54:49 +0200
Message-ID: <20241002125834.055681229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit fdf1c728fac541891ef1aa773bfd42728626769c ]

Currently, compiling the bpf programs will result the compilation errors
with the cf-protection option as follows in arm64 and loongarch64 machine
when using gcc 12.3.1 and clang 17.0.6. This commit fixes the compilation
errors by limited the cf-protection option only used in x86 platform.

[root@localhost linux]# make M=samples/bpf
	......
  CLANG-bpf  samples/bpf/xdp2skb_meta_kern.o
error: option 'cf-protection=return' cannot be specified on this target
error: option 'cf-protection=branch' cannot be specified on this target
2 errors generated.
  CLANG-bpf  samples/bpf/syscall_tp_kern.o
error: option 'cf-protection=return' cannot be specified on this target
error: option 'cf-protection=branch' cannot be specified on this target
2 errors generated.
	......

Fixes: 34f6e38f58db ("samples/bpf: fix warning with ignored-attributes")
Reported-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Qiang Wang <wangqiang1@kylinos.cn>
Link: https://lore.kernel.org/bpf/20240815135524.140675-1-13667453960@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 3e003dd6bea09..dca56aa360ff3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -169,6 +169,10 @@ BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
 endif
 
+ifeq ($(ARCH), x86)
+BPF_EXTRA_CFLAGS += -fcf-protection
+endif
+
 TPROGS_CFLAGS += -Wall -O2
 TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes
@@ -405,7 +409,7 @@ $(obj)/%.o: $(src)/%.c
 		-Wno-gnu-variable-sized-type-not-at-end \
 		-Wno-address-of-packed-member -Wno-tautological-compare \
 		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
-		-fno-asynchronous-unwind-tables -fcf-protection \
+		-fno-asynchronous-unwind-tables \
 		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
 		-O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
 		$(OPT) -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
-- 
2.43.0



