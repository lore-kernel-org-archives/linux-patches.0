Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622660;
	b=XR9nvL+SZtQCiDZDLtwW93px+yBQl7/zay5R5kgJwCdCKeKGq7m8GeOKGsviNW1RGdvR
	 7efG8C4iAdxnEFIIRVY0urRz0HSVbu0Zyf2KHI7GodlolDyI3xyQkvFeszzivNrbVNwvh
	 qlCCIbE+XlS9SA0C7yfsK8arAo6w2iTWphUnE2TNIPPKA0LVCZo0isAn02VqEZRgAas/4
	 OSp2kaTA8FvjRZStqkPaARH1sdPJ1kGmLZpWGL8H86iZiW0NN7PxjoThuiGJnwiSz/S+j
	 Odyxfxya33MykznF81AJvhVaQnaIypqFhnZT5bYJLkE0/JivMgNsrdlP2DUwCnAdPpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VY+0HZfyufsJy7xnJwny+tXQ+Va5TAdOFzJsoINN50=;
	b=iXpGxyUfIYmmVYTmmXHSoxZjpbPmOK57dc2LSzku5Iwi5J0C3rmcGvyCK3oImGFVafyp
	 wdLAWmAVaLKF6IM9vtHfue3Imqhkob8ks5yDzS4ceV+7r78QBEl3FojaQOgLTWD5dNqeo
	 IF0RYn+zSqCLw7pdK0rCkJ89j7lrxo5+feSg+PokK95e8ixxSZjznLSgOUgSrmja2IACm
	 nI9+B6uZnQNGHNfRtKZYDxuZEWxSYjfzELLbPxpoKKgs4SJ3e8bsufLXrdtMSPrqYa0ie
	 D3p4GsZgMtkj7RHNyVduLA88DgFVVL5b4n8QeVWU8wtVeg/f7I3mOYKjqjHlWzIeShQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sS5I2p6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACEC606A33D;
	Wed, 25 Nov 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sS5I2p6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE96A1F008B2;
	Wed, 25 Nov 2026 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622660;
	bh=+VY+0HZfyufsJy7xnJwny+tXQ+Va5TAdOFzJsoINN50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sS5I2p6u/V8NYPnf8HlZe9l53Lk+2UAjWm39A/nf37q7SXC8DbpopMya0wCf8KqPD
	 mjz2FanIikzP1b5r5ObsHwPBn7plzbKDwdP2+zs9qktxpWpH+2QY5ozxYTFCcYp2TG
	 68mmGLpVZCHvS6Ydn0NUdhGgCs4XzjCgxYMwU1Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.18 609/990] locking/atomic: arc, hexagon, openrisc: Define arch_cmpxchg_local()
Date: Wed, 25 Nov 2026 15:32:56 +0100
Message-ID: <20261125143836.358978381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit 8cebaa3be829c88a59957900f8de98fed09daefe ]

Commit ccb88db8dac8 ("bpf: Don't hand out a linked element as extra
element") made alloc_htab_elem() take the per-cpu spare element with
try_cmpxchg_local(), the first caller of cmpxchg_local() outside of
architecture code. It doesn't build on arc, hexagon and openrisc:

  include/linux/atomic/atomic-arch-fallback.h:384:27: error: implicit declaration of function 'arch_cmpxchg_local'; did you mean 'raw_cmpxchg_local'? [-Werror=implicit-function-declaration]

raw_cmpxchg_local() maps to arch_cmpxchg_local() unconditionally, but
these three architectures don't define it, and unlike nios2 and
microblaze they don't get it from asm-generic/cmpxchg.h either.

cmpxchg_local() only has to be atomic with respect to the local CPU, so
an architecture's own arch_cmpxchg() can serve for the sizes it
supports. arc uses its relaxed LLOCK/SCOND variant when ARC_HAS_LLSC is
set and its atomic_ops_lock() variant otherwise, and openrisc uses its
LL/SC arch_cmpxchg(), the way arm64, riscv and s390 alias theirs. The
hexagon arch_cmpxchg() only handles 32-bit words, so hexagon uses the
generic version that disables interrupts, like sh, sparc32 and xtensa
do. Linux has no NMIs on hexagon, so that is sufficient there.

Fixes: ccb88db8dac8 ("bpf: Don't hand out a linked element as extra element")
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261018132907.3823160-1-sashal@kernel.org
Closes: https://d.kernelci.org/i/maestro:78b65519ee4561df1fbf1e72f1dec9da7e5b153e
Closes: https://lore.kernel.org/oe-kbuild-all/202610181750.BoqAddaF-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202610182048.aEaiBP8W-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/cmpxchg.h      | 4 ++++
 arch/hexagon/include/asm/cmpxchg.h  | 6 ++++++
 arch/openrisc/include/asm/cmpxchg.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/arc/include/asm/cmpxchg.h b/arch/arc/include/asm/cmpxchg.h
index 66b3743c94008..93f7153eb267a 100644
--- a/arch/arc/include/asm/cmpxchg.h
+++ b/arch/arc/include/asm/cmpxchg.h
@@ -59,6 +59,8 @@
 	_prev_;								\
 })
 
+#define arch_cmpxchg_local	arch_cmpxchg_relaxed
+
 #else
 
 #define arch_cmpxchg(ptr, old, new)				        \
@@ -80,6 +82,8 @@
 	_prev_;								\
 })
 
+#define arch_cmpxchg_local	arch_cmpxchg
+
 #endif
 
 /*
diff --git a/arch/hexagon/include/asm/cmpxchg.h b/arch/hexagon/include/asm/cmpxchg.h
index 9c58fb81f7fd6..e6114e713db9f 100644
--- a/arch/hexagon/include/asm/cmpxchg.h
+++ b/arch/hexagon/include/asm/cmpxchg.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_CMPXCHG_H
 #define _ASM_CMPXCHG_H
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
  * __arch_xchg - atomically exchange a register and a memory location
  * @x: value to swap
@@ -72,4 +74,8 @@ __arch_xchg(unsigned long x, volatile void *ptr, int size)
 	__oldval;						\
 })
 
+#define arch_cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__generic_cmpxchg_local((ptr),		\
+			(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
+
 #endif /* _ASM_CMPXCHG_H */
diff --git a/arch/openrisc/include/asm/cmpxchg.h b/arch/openrisc/include/asm/cmpxchg.h
index 8ee151c072e41..fcf1bc8db8fe9 100644
--- a/arch/openrisc/include/asm/cmpxchg.h
+++ b/arch/openrisc/include/asm/cmpxchg.h
@@ -140,6 +140,8 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 					       sizeof(*(ptr)));		\
 	})
 
+#define arch_cmpxchg_local	arch_cmpxchg
+
 /*
  * This function doesn't exist, so you'll get a linker error if
  * something tries to do an invalidly-sized xchg().
-- 
2.53.0



