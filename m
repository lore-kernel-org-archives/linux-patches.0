Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063711;
	b=h13afZ2lIUy2YWjdSkW6XRq3Xo3T2bz6IbBPYzm+U3XcnJ7UO4UV6KeTxkupddkV4xCf
	 8d9qiU8asCOTRqzkdKEyAbhaGxBehCYsWRTEYKzFsrhFVghrKkB9N5F13dyCao9o3Fzvt
	 56D5Wi/o7q5Xwwq5352NuprDUYD/z1/z0Vz9jR/Pe/YdQsGSc8D+8nsmXeWKl6mdg/hjE
	 6WDQKy63FJDFE1bbGfVbgKmSykxTCVz1jX8ugHePyb8t5UevUTQ0qB9AajtUJ3wRIr85H
	 t9OHo67rGwndgH+aN9wwJ7XzFwGX0LQuDF6U9ytw/69sZF7Z3fdVHzdZZP695RPArbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDHohq66J67P/NJ1bvaYWTh7a+f5o5eSQDCpTLiq09E=;
	b=whaeYDr057KJUJvt6JK4mO+VDCFRkL47YcEQHZdym0YSIvkAFUoPvFdW/42hs+RER+Hc
	 DHyN/dXU2Nx0eoWnkLRUqqUiqBwJxUAre7N68DTliK8cPNXbEdExFAF17dyFFZSuy81oE
	 adyGQyC6N0+C1zGpoI+rsYEBdJWXquQ+pBTW1ovR3Vc75pdMOHTZzszhn74KdWx3ULrtK
	 aXJrDCwArVIfWbs51tDmkd82SEtJBDvoFKh7jtRPvxqUjrpmp+5I6QdMo5TRBibwSRXvu
	 z8wpPcr7nUy6QSfRTFVVo4MeBegrIDCzGbQ6lDUEWaj/vIdhKy2F7xI1UFjitOaV6Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JizUWvZ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250E606B8AF;
	Sat,  7 Nov 2026 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JizUWvZ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B66A1F0089F;
	Sat,  7 Nov 2026 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063710;
	bh=zDHohq66J67P/NJ1bvaYWTh7a+f5o5eSQDCpTLiq09E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JizUWvZ3KJnFbHvOJremtEjAU00Yl9w+Z/P7YKX+IjPP3ViSaMucr+BVoIZlCZqnG
	 jziBEvtK1DggoJjnCjLktLrDxN9q4dH91fxB2UbS7gmSk0vSnxiANqdtM44CXiYjy6
	 XoSogud1CtQEGFlYyY/mwCezfV6DGWSHWx9jGHa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 804/869] LoongArch: Remove arch-specific __smp_mb__{before,after}_atomic()
Date: Sat,  7 Nov 2026 08:58:06 -0500
Message-ID: <20261107134920.183466995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 85cebdfee765e92e748e71b9b91889eef5988282 ]

When running BPF selftest "test_progs -t timer_lockup" on a LoongArch
machine, the kernel intermittently experiences soft lockups and panics
in hrtimer_cancel().

The root cause is that the bpf_timer_cancel() implementation relies on
smp_mb__after_atomic() to provide a full data barrier after a relaxed
atomic_inc() to ensure the proper store-load ordering before performing
lockless dependency checks on weakly-ordered architectures, such as on
LoongArch, but the current definition of smp_mb__after_atomic() is just
a plain compiler barrier.

This allows a subsequent read to bypass the prior write due to store-
load reordering, enabling concurrent CPUs to simultaneously bypass the
software deadlock detection, enter hrtimer_cancel(), and then trigger a
severe ABBA deadlock in the hrtimer core.

Moreover, there are hundreds of smp_mb__after_atomic() call sites across
the core kernel (kernel/, drivers/, mm/, net/, fs/) that currently lack
necessary full data barriers on LoongArch, which have potential risks.

To comply with the LKMM specification, fix this by removing the arch-
specific definition of __smp_mb__after_atomic(), so that this macro can
automatically fall back to the generic definition in asm-generic that
maps to __smp_mb() and emits the required hardware DBAR instruction.

While at it, do the same thing for __smp_mb__before_atomic().

With this patch the BPF timer_lockup selftest was stressed for millions
consecutive loops on a physical LoongArch machine, without encountering
any further lockups.

Cc: stable@vger.kernel.org # 6.7+
Fixes: affef66b65889a0e ("LoongArch: Relax memory ordering for atomic operations")
Closes: https://lore.kernel.org/loongarch/CAK3+h2xOSEZUHhou7N2cRL-aGrZCNSm45g+P7thObMe+fpgYCA@mail.gmail.com/
Reported-by: Vincent Li <vincent.mc.li@gmail.com>
Reviewed-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/barrier.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/loongarch/include/asm/barrier.h b/arch/loongarch/include/asm/barrier.h
index 4b663f1977061..84c6d739119d1 100644
--- a/arch/loongarch/include/asm/barrier.h
+++ b/arch/loongarch/include/asm/barrier.h
@@ -57,9 +57,6 @@
 #define __WEAK_LLSC_MB		"			\n"
 #endif
 
-#define __smp_mb__before_atomic()	barrier()
-#define __smp_mb__after_atomic()	barrier()
-
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
-- 
2.53.0



