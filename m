Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065506;
	b=uRLyAqj61N3d5IvXLW9YcE4A+DXdlYLaRn9+91al7hxn1KnPQkRm2LRGAjFMg3mnJt7u
	 wCg/fhrmWSNSM3RY1xLnYL6KDNcOHp7AgUa9kDIag3+no33gofUwBwtb6PH4jm80eHSXG
	 s0OrV+/aZ3FOIJLkTGjr/t8V++EJ45x3NQJ5JWVFmAor6SMmscXSUSCMu+VnuQ9+9h61Y
	 17x45Cw5jy3mGfs5FkJ+gy0eMVgP1vsaNv3o5CvrxrboNVcHFBll/+t6IbKcTBhmDH2Su
	 dOP1InHKGf99ibFPDiEsDX1h3jmYbT5dsThdgjVjSvfK3EjR8Qaysxxc/ty1PXQ8HVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wth5T4eKwVJQg/uOtKGgwkgeEdrIH+W1N0mfesP2RZA=;
	b=vRpiZ3zCWnb7ho7xOgpaVb4Q0jyYo9rKop1zwnKo53W8DMsdqM2tub+bxBQ6Xq0AAVCO
	 m6rmQTuuIp8qZheHPoRHrQeXuEuKgoQARbUnW5LXRcVedzXPk0eGG1quyphWgzhPg4JvV
	 HC3NXbITvXsH0wHGHx2ySIOkjSt9B/zwkE4ksy5s99mS+Eb8KSoIB9idZVvpMFym65OnX
	 9Tanvru/qdQDYipF6/+NDgLg+O+EO/BeIUmFC66W2/Ig3z91ZOo0gQGxx4JRrEn1ggoVt
	 MFWcDSMfkUR2aOyixu07EkEuasWRPCt09o9gHYyGvzwBVEGByz9ae7FxpHHEGtgBv0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ygj4VsB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8646F606A33A;
	Sat,  7 Nov 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ygj4VsB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F651F0089F;
	Sat,  7 Nov 2026 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065506;
	bh=Wth5T4eKwVJQg/uOtKGgwkgeEdrIH+W1N0mfesP2RZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygj4VsB60iKmjLfuo0xvf68BCP62VBJcvFfYC8mL19VIThInub7RdukSgnY3PlceP
	 P2JnEvtU5tqsJUEyqtobW7C9Cqf4scB0K3gaDsJJ3DKlsJ26Kg6cX3L0+A+3CjJanr
	 ZiEstGHZwKUYNFiaNGOSJyd27yt78G2o1lUGMtZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1165/1257] LoongArch: Remove arch-specific __smp_mb__{before,after}_atomic()
Date: Sat,  7 Nov 2026 08:57:41 -0500
Message-ID: <20261107135011.364540453@linuxfoundation.org>
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



