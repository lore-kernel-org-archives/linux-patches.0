Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625572;
	b=xkf5Qbj9f4M8i5LrPW3lLlQhYBAHjzmstUONzzXY6ZFYZQ98LQuWTDhi2L8pHpqgDW8l
	 icN01iPI3w1TG2Jwn3HK3S1p0+SwyYIcIkuX2JufS8ntkOvYsLuRdbUBcRCiVsIvksQtt
	 rKoowcQFld8gXGQ2KGFcmFAYN6H2/JFRFOU91HgIMCs78JWjvFiKu15J5fQQz1sjyt97l
	 aXnY1IIBpDmQEzmI2Vw1XX1gIZZyqRUKzEOmgYRkeXa+6glDNShnLze0R68sB5TIy0x44
	 VruAiyUAiSsWagotKuF/kpEny/b9odKEtjmlfeipPd3NXF9FpEgmoHB1ScbZgoU82yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/BOrpr2iXhnQO5IPygfHQR7vju5B/g/XWHh+Xzul0vI=;
	b=QE8pau87Zueg7aQPwvE+yccM5ceFGDVP1ZkFBT5eDIu6ICPF1qWHLrnLJfKSTC1lx5kp
	 4fNSyt/OfrF2lc/riCIEztG94RFAD7mE59xqdlvOJlrihbX9prlqxeyS0HUXY5dFHwc8X
	 DXWB6meUcRpE/lsmfa7BO0Mt80+0cQbjFAQn/xKb6MWy6NUqinnmh8tYKi1+JxAOmbNhw
	 scuA20ITS3HLNqOMS9c2NNiWi5sMxVIcBSIwAqhDeuHxYy8B9zTT+fZ9FBeRpJzAkX1Pb
	 joDFyjQLr/DZjs/hVm8Xeai+ntwuX/5FR3BlpHKQYIgyZgHgD8SCyO+VaboKlFaB50w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USV8NODN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62008606A331;
	Wed, 25 Nov 2026 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USV8NODN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD701F000D3;
	Wed, 25 Nov 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625572;
	bh=/BOrpr2iXhnQO5IPygfHQR7vju5B/g/XWHh+Xzul0vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USV8NODNo2IWty75RAb+tGtMpNkkgnOkPlJYJ09q/+e3/4uaLbnbKvqZH3fiLc6Wh
	 rVIntv60lsjVQ1gjVeJnNjhWMw1v8pa42aHtayuxFsxHeuCSv/DBsh/gXuWWSfJvzH
	 wBm5ZPikY2RCSDLSEpKdWjLl6qTbhqpFWNOteSXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 516/816] locking/atomic: arc, hexagon, openrisc: Define arch_cmpxchg_local()
Date: Wed, 25 Nov 2026 15:34:24 +0100
Message-ID: <20261125143901.129800673@linuxfoundation.org>
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
index 76f43db0890fc..07d7a01d26de0 100644
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



