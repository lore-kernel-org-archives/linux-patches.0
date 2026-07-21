Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D06946C4D9;
	Tue, 21 Jul 2026 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648580; cv=none; b=aI94nQgdMXKfgvwqnInOb0moVdjd8HcKwFLpjJfD8s3OQMEInh6m2HjS/xOhNLzcYoI7Kj3BpjJ/ihFrdM3uzjt2mfKAm0ysbFPcBKFCZeDwJQwkJRWqQo3d7GsHqOfXM6q/OyPflOk1FAB5+PSbc8o0Rx4MXDegg6mdcZVRQS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648580; c=relaxed/simple;
	bh=JDfKaXmCXv3410kGAhMUvp67zHLVDXJ/5VPQ5slWppw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1iXP5n1smpII6UWYIykhqGsQH32jnv1gtbBK1hx/DSSOo/9Xw+/PSXB1U/Yu3o1Q2j4CZNIAloMPmRfyF7vTySeKFJ8RnhN90DtEjsBY4eInv3c1rgLc4k+9JJj+195u7qm8nYUK87B+rYODJpTGAOTzz8lRMB3qoTnw0li6Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YE11/KkG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YE11/KkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A8E1F00A3A;
	Tue, 21 Jul 2026 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648579;
	bh=g0Wqhh980RoKsgQxE+jqYtFuNwQcqjy6XHtJrljiCWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YE11/KkGGfZW4vUR8GtH2Zm/qsa0imjHP+2LgqR8eGY5yvKknJyfGwxaRA8Y5CGB/
	 7L6uVzN73zY5GEcCALmKU8YBdTc2Zqyacmx1+A2kHJSo/a+SfMD6Xm3gkd6yAEAGSq
	 lrQ7L878Ry9da8IX3y92DxuldlG3F5+xub8PDvi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0252/2077] bitops: use common function parameter names
Date: Tue, 21 Jul 2026 16:58:45 +0200
Message-ID: <20260721152558.624024520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8a51b2e874f47a6094353b59ecae421f0968fe3a ]

Fix the function prototypes to use the common parameter name 'addr'
instead of 'p' (common to arch-specific implementations of these
functions).
This avoids the kernel-doc warnings:

Warning: include/asm-generic/bitops/lock.h:19 function parameter 'p'
 not described in 'arch_test_and_set_bit_lock'
Warning: include/asm-generic/bitops/lock.h:41 function parameter 'p'
 not described in 'arch_clear_bit_unlock'
Warning: include/asm-generic/bitops/lock.h:59 function parameter 'p'
 not described in 'arch___clear_bit_unlock'

Fixes: 84c6591103db ("locking/atomics, asm-generic/bitops/lock.h: Rewrite using atomic_fetch_*()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/bitops/lock.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/asm-generic/bitops/lock.h b/include/asm-generic/bitops/lock.h
index 14d4ec8c5152d6..ffb73b6129e736 100644
--- a/include/asm-generic/bitops/lock.h
+++ b/include/asm-generic/bitops/lock.h
@@ -16,16 +16,16 @@
  * It can be used to implement bit locks.
  */
 static __always_inline int
-arch_test_and_set_bit_lock(unsigned int nr, volatile unsigned long *p)
+arch_test_and_set_bit_lock(unsigned int nr, volatile unsigned long *addr)
 {
 	long old;
 	unsigned long mask = BIT_MASK(nr);
 
-	p += BIT_WORD(nr);
-	if (READ_ONCE(*p) & mask)
+	addr += BIT_WORD(nr);
+	if (READ_ONCE(*addr) & mask)
 		return 1;
 
-	old = raw_atomic_long_fetch_or_acquire(mask, (atomic_long_t *)p);
+	old = raw_atomic_long_fetch_or_acquire(mask, (atomic_long_t *)addr);
 	return !!(old & mask);
 }
 
@@ -38,10 +38,10 @@ arch_test_and_set_bit_lock(unsigned int nr, volatile unsigned long *p)
  * This operation is atomic and provides release barrier semantics.
  */
 static __always_inline void
-arch_clear_bit_unlock(unsigned int nr, volatile unsigned long *p)
+arch_clear_bit_unlock(unsigned int nr, volatile unsigned long *addr)
 {
-	p += BIT_WORD(nr);
-	raw_atomic_long_fetch_andnot_release(BIT_MASK(nr), (atomic_long_t *)p);
+	addr += BIT_WORD(nr);
+	raw_atomic_long_fetch_andnot_release(BIT_MASK(nr), (atomic_long_t *)addr);
 }
 
 /**
@@ -56,14 +56,14 @@ arch_clear_bit_unlock(unsigned int nr, volatile unsigned long *p)
  * See for example x86's implementation.
  */
 static inline void
-arch___clear_bit_unlock(unsigned int nr, volatile unsigned long *p)
+arch___clear_bit_unlock(unsigned int nr, volatile unsigned long *addr)
 {
 	unsigned long old;
 
-	p += BIT_WORD(nr);
-	old = READ_ONCE(*p);
+	addr += BIT_WORD(nr);
+	old = READ_ONCE(*addr);
 	old &= ~BIT_MASK(nr);
-	raw_atomic_long_set_release((atomic_long_t *)p, old);
+	raw_atomic_long_set_release((atomic_long_t *)addr, old);
 }
 
 #ifndef arch_xor_unlock_is_negative_byte
-- 
2.53.0



