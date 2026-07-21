Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1759B46D2DA;
	Tue, 21 Jul 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655883; cv=none; b=Z9SG/oIHn/zcOy3mkZlhwvXLQP/MPg+RS3tyF0DR3ZhwD6MbdCX6Q8eGZw7xmfWTTgl1Bivh90pWMmsyQVGoe+86JCOZrL0FBAIeyg3DcSjIaKv8ipLPCgiiJdSwpPcWXj/C47Cp3rDSw7ud6YhtTxs3IFQ9BJ7SpOTHaLbd67Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655883; c=relaxed/simple;
	bh=qZzxwEtiH8DDKN58CkRHw+wIoGazNVB4trDq6ouK+U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAylTyiieGvLhWY4HFJ4uAgLiesJxdNOLMFfK7T5mKSTAsIgIS3d474OVc1eq92nmhVgrLbV9yqV8BQROOPH5HNMB3ECzENPpXLgMvIxTOoVef21ytzO7/eVSuQA3yBWPKWgv9lV++0oLhz/tGKD1/R8c0Qos3RtQTkVnEbuSV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFjB8PsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFjB8PsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAF81F000E9;
	Tue, 21 Jul 2026 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655882;
	bh=lM2F1A3bS4wZg/j0xt/wyNTRra1hN5wxQduNFrcim+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFjB8PsVYj+HZde/+hHZTVVh+/V0RUWO46kCJeZgOlMxqFTx/ezVLA42Y5zqwkh1X
	 Z0uJk9Pw26SmpSXSYXe7qP9pnk7VEkkf/zzwBAAm2B6uN/O29MzW+p9FcHfvcFIDSB
	 TzaQ1dlPOcui0zotsJVBg7gPIxgEi+k6HdW6psnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0176/1611] bitops: use common function parameter names
Date: Tue, 21 Jul 2026 17:04:52 +0200
Message-ID: <20260721152518.866207049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



