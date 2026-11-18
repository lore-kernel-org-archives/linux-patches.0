Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022017;
	b=KcZBYs6ua5vJAEd+5h9mrshca744oljPTMdtsmZtsiMLShB1F18gG8jSCxM8SVgFzSab
	 6cp98fvKaI+PPLgbcmgwQt6r5+I5TOPwkOAcgrQ039vMTnMBbXDwSN7dFf6O2LnhX0Qw0
	 oXKVtOIkZH0n/qUw3Xr4wsCJibcH88+wCvCwu+6x8qSbWUTeXIBMPKpmFYHLc4tKXrYjo
	 Bcap9cA9Z7SOK9DccB441/HndUg77ThOVDdN6Xl9Z4hgmrBElvxNVhMK1nZg41EbIs9RL
	 fpAJtT56tt/mPxsHqvrzzlxLCM65fc1EZnl+o2KP00ag+aoZ7HqTPcyfe15ujF4G7/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=M6lr9zTr9vcuE9hruAn6WV0ke83Fd3l3r8kQGrZqXw0=;
	b=0pSh7MntTuItiFfgjBa/J2Hv7GO+gXSbK0EHt+GjgQ4KpjC2myjZOJeDfPXyWoNhgrTo
	 +Eu/zaS8+FVtfHjaTvOAoFbOeKEbSFjl28cpUqlX0B4QMi/xKXWFO5V+XHbdwm4mKSM9t
	 zg3NrWymSCSXle5ykhuQ+4RpdznWRsEEJUSirzZuBiF5Xc4GOhZWm1sHJhN4vsPmla325
	 +SCeztb/d6Ttz0pJvQ4j92vXRedm0YcvvsNW5cq9XcR5K9HrPMjIMocMwfxuavZAfsGE8
	 gs6W0TjcQBUIU50v4PiS7pmWdljS7UqFz+AzRdKbA6KYvU37xuh42/4Ef8w4LwxUgZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Og0Sk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF74460A2602;
	Wed, 18 Nov 2026 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Og0Sk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B291F000C8;
	Wed, 18 Nov 2026 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022017;
	bh=M6lr9zTr9vcuE9hruAn6WV0ke83Fd3l3r8kQGrZqXw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9Og0Sk17pfXB/4RSo6OzNGhP8cQ9mZFvPh010h71n6I5MtRCwX6HZCsn3qYGauzJ
	 nxXxY1KmTXZhHzIkLrO6FHz5hkU98/P9TYo9YeBOyGB/JIQgHwUz4JJT+vRYIPHil3
	 dn6agtDC06QJUMgfNQvhRoWPsXxfuqDFIAg9K1gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2513/2651] selftests/bpf: Enable arena LDSX tests for riscv64
Date: Wed, 18 Nov 2026 16:02:33 +0100
Message-ID: <20261118150415.199612442@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit 8f2087a1b43bbc57231eca4b99415cc18fb3429a ]

Now that the riscv64 JIT supports signed arena loads
(BPF_PROBE_MEM32SX), enable the arena LDSX tests on riscv64:
add JIT disassembly assertions for arena_ldsx_disasm (arena base in
s7, add into t2, sign-extending lw/lh/lb loads) and run
arena_ldsx_exception and arena_ldsx_s8/s16/s32 on riscv64.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Tested-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/1bab696ec36f196fa6ec74a0f056030b39730da7.1787140923.git.cp0613@linux.alibaba.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Stable-dep-of: 4d0f560f4926 ("bpf: Keep stack arguments in arch_bpf_timed_may_goto()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/verifier_ldsx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_ldsx.c b/tools/testing/selftests/bpf/progs/verifier_ldsx.c
index 41340877dc9d9..ed0a0f159bc12 100644
--- a/tools/testing/selftests/bpf/progs/verifier_ldsx.c
+++ b/tools/testing/selftests/bpf/progs/verifier_ldsx.c
@@ -286,6 +286,19 @@ __jited("add	x11, x0, x28")
 __jited("ldrsh	x22, [x11, #0x18]")
 __jited("add	x11, x0, x28")
 __jited("ldrsb	x22, [x11, #0x20]")
+__arch_riscv64
+__jited("add	t2, a5, s7")
+__jited("lw	s3, 0x10(t2)")
+__jited("add	t2, a5, s7")
+__jited("lh	s3, 0x18(t2)")
+__jited("add	t2, a5, s7")
+__jited("lb	s3, 0x20(t2)")
+__jited("add	t2, a0, s7")
+__jited("lw	s4, 0x10(t2)")
+__jited("add	t2, a0, s7")
+__jited("lh	s4, 0x18(t2)")
+__jited("add	t2, a0, s7")
+__jited("lb	s4, 0x20(t2)")
 __naked void arena_ldsx_disasm(void *ctx)
 {
 	asm volatile (
@@ -317,6 +330,7 @@ __description("Arena LDSX Exception")
 __success __retval(0)
 __arch_x86_64
 __arch_arm64
+__arch_riscv64
 __naked void arena_ldsx_exception(void *ctx)
 {
 	asm volatile (
@@ -338,6 +352,7 @@ __description("Arena LDSX, S8")
 __success __retval(-1)
 __arch_x86_64
 __arch_arm64
+__arch_riscv64
 __naked void arena_ldsx_s8(void *ctx)
 {
 	asm volatile (
@@ -369,6 +384,7 @@ __description("Arena LDSX, S16")
 __success __retval(-1)
 __arch_x86_64
 __arch_arm64
+__arch_riscv64
 __naked void arena_ldsx_s16(void *ctx)
 {
 	asm volatile (
@@ -400,6 +416,7 @@ __description("Arena LDSX, S32")
 __success __retval(-1)
 __arch_x86_64
 __arch_arm64
+__arch_riscv64
 __naked void arena_ldsx_s32(void *ctx)
 {
 	asm volatile (
-- 
2.53.0



