Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623931;
	b=GoHD4jcd7rlv3PB4R45Bt0vrty2Blvup9ADMWwpuhcU039h4AqZjxB38/b3GRzzjzHBz
	 38fCWoenvecvUk2RqFBKYr+bZRNjs4P3/wEKAWspxP0WOhi+jqnILONVSX7mScd46w/AR
	 x9iEkkYJpWbkcPHlpUtF4i18oo/X+mSWNNb9sCfxYndKws1LizMKpDXY1fj8EqK47pU29
	 4lIWlpSXVZChRExAwnThWCS5xmu7P1Waw0DNWRDjtFcqsJTUrVbmdIrmB5CPlo+giaxNM
	 KArruT0/zkyT74hjf5XcqTv8FI3vs4wVvHOsracy0UXGIY/kuXb01qu0/x/eA4MoEBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HMW79THGl0iwJNeyoKSoRW8E1zdvEQh1YGspBdTvRGQ=;
	b=CLAx8NMrH/QZdVgWVwnfu48ooEvL56UzcH9Sogsrex42nNYthuSgISyR7wm7FGUVBVRs
	 EQRhpAUneCWqhnnjqWHEtqVj0PTeRHygVwqgKgO9K5h3wHSi6IeLuvDBwP493Vt3C332s
	 Lyw91fO3wkVy05OQ5q8TT4GfJLmyKMIXkVbOIR3S7Q2YggGmuyuEclegLKzJzIglWvdT/
	 2ShSEfldO/77eQ8/B1EEwfE6ksB1abzFrj/IYLRH6W6P53ZIQDzAj1i8CP8e2fJXusA8i
	 dq/nZH/YzQ0tjZiEHeDcoJqsJW2F4bQVMjow87b9yg0EUM5uykIzFLK1b+f3gsZdXuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2b7KNRAk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CEF606A334;
	Wed, 25 Nov 2026 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2b7KNRAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D433F1F000C6;
	Wed, 25 Nov 2026 16:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623931;
	bh=HMW79THGl0iwJNeyoKSoRW8E1zdvEQh1YGspBdTvRGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2b7KNRAk5DPknzylkVeBFV1RW4k7JqOi8r/zyhHlS/2q4TVYkP3p4fKkQXRJp0Lor
	 6hhkNHkkVLT4APS0zdbmBOy2A02Iwf6ui+7CIO5yUOw/B0aKgyfHait3Sf5ZQj1zzV
	 A4C89ey2T6NGKvhRmdOoFWja99KYM/LjPr2SmNj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuran Liu <electronlsr@gmail.com>,
	Peili Gao <gplhust955@gmail.com>,
	Haoran Ni <haoran.ni.cs@gmail.com>,
	Zesen Liu <ftyghome@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/816] bpf: Fix memory access flags in helper prototypes
Date: Wed, 25 Nov 2026 15:25:55 +0100
Message-ID: <20261125143849.386463897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zesen Liu <ftyghome@gmail.com>

[ Upstream commit 802eef5afb1865bc5536a5302c068ba2215a1f72 ]

After commit 37cce22dbd51 ("bpf: verifier: Refactor helper access type tracking"),
the verifier started relying on the access type flags in helper
function prototypes to perform memory access optimizations.

Currently, several helper functions utilizing ARG_PTR_TO_MEM lack the
corresponding MEM_RDONLY or MEM_WRITE flags. This omission causes the
verifier to incorrectly assume that the buffer contents are unchanged
across the helper call. Consequently, the verifier may optimize away
subsequent reads based on this wrong assumption, leading to correctness
issues.

For bpf_get_stack_proto_raw_tp, the original MEM_RDONLY was incorrect
since the helper writes to the buffer. Change it to ARG_PTR_TO_UNINIT_MEM
which correctly indicates write access to potentially uninitialized memory.

Similar issues were recently addressed for specific helpers in commit
ac44dcc788b9 ("bpf: Fix verifier assumptions of bpf_d_path's output buffer")
and commit 2eb7648558a7 ("bpf: Specify access type of bpf_sysctl_get_name args").

Fix these prototypes by adding the correct memory access flags.

Fixes: 37cce22dbd51 ("bpf: verifier: Refactor helper access type tracking")
Co-developed-by: Shuran Liu <electronlsr@gmail.com>
Signed-off-by: Shuran Liu <electronlsr@gmail.com>
Co-developed-by: Peili Gao <gplhust955@gmail.com>
Signed-off-by: Peili Gao <gplhust955@gmail.com>
Co-developed-by: Haoran Ni <haoran.ni.cs@gmail.com>
Signed-off-by: Haoran Ni <haoran.ni.cs@gmail.com>
Signed-off-by: Zesen Liu <ftyghome@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260120-helper_proto-v3-1-27b0180b4e77@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c     |    2 +-
 kernel/bpf/syscall.c     |    2 +-
 kernel/trace/bpf_trace.c |    6 +++---
 net/core/filter.c        |   20 ++++++++++----------
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1090,7 +1090,7 @@ const struct bpf_func_proto bpf_snprintf
 	.func		= bpf_snprintf,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL | MEM_WRITE,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_PTR_TO_CONST_STR,
 	.arg4_type	= ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6073,7 +6073,7 @@ static const struct bpf_func_proto bpf_k
 	.func		= bpf_kallsyms_lookup_name,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1030,7 +1030,7 @@ const struct bpf_func_proto bpf_snprintf
 	.func		= bpf_snprintf_btf,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
@@ -1808,7 +1808,7 @@ static const struct bpf_func_proto bpf_r
 	.gpl_only       = true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL,
+	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL | MEM_WRITE,
 	.arg3_type      = ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type      = ARG_ANYTHING,
 };
@@ -1943,7 +1943,7 @@ static const struct bpf_func_proto bpf_g
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg2_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6334,7 +6334,7 @@ static const struct bpf_func_proto bpf_x
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -6389,7 +6389,7 @@ static const struct bpf_func_proto bpf_s
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -7948,9 +7948,9 @@ static const struct bpf_func_proto bpf_t
 	.gpl_only	= true, /* __cookie_v4_init_sequence() is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct iphdr),
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -7980,9 +7980,9 @@ static const struct bpf_func_proto bpf_t
 	.gpl_only	= true, /* __cookie_v6_init_sequence() is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct ipv6hdr),
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -8000,9 +8000,9 @@ static const struct bpf_func_proto bpf_t
 	.gpl_only	= true, /* __cookie_v4_check is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct iphdr),
-	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg2_size	= sizeof(struct tcphdr),
 };
 
@@ -8024,9 +8024,9 @@ static const struct bpf_func_proto bpf_t
 	.gpl_only	= true, /* __cookie_v6_check is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct ipv6hdr),
-	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg2_size	= sizeof(struct tcphdr),
 };
 #endif /* CONFIG_SYN_COOKIES */


