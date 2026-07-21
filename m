Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACAA3783D4;
	Tue, 21 Jul 2026 20:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665802; cv=none; b=MQbWIPMbP59YnMPmi+XvuTIXbVdMxF101xVewoWw8mNFNrcNDpY54+jx8nACUNw1DxiiA6Vah5JOqqAbPTPKY6K3TVEi0+Y7fhpECkfiSh73KR87cOOyvkQ/Oi2HGzE4Xq43YrtikM0c0w4B+TQM6Gtk4oRwZJvxuDXMtCt4KC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665802; c=relaxed/simple;
	bh=vYzJigOAwTrOs5+VJQU8de6I5XgvUxEc08Syo6A78Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJHaXt7Nsk1B3zB/h9Vqo83jBJeoOxGM2B+ZkhQGfVVf7wz3E5DPLecCUzLSR9FNDtjqy6amE3YkccxdKK6oOceGk58JP9r1Z8MAViNE6j/yRWVqr167QGIyZ4kuoG8tJVRVUtwwHcJ+Blv05yrqvqpN6XP0c+AVUdOqeJDMz5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYP6kEx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYP6kEx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2451F000E9;
	Tue, 21 Jul 2026 20:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665800;
	bh=HqJmgbrIDRQSRPwjYrug+aNjuUebPGpKuOHb+6BumXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYP6kEx40d1xDyLZ0mJnrLJ3TL7SV2dorusgSIfkkwCfKK/lPlarPfCOECYD3PeOP
	 ho/QzqiHZHuy/DW6MvwkJim63Z/n3eYeRY5nfS/kFfHj6ZOcOXyzCZBzkvxjbiMxId
	 piUk8WknqG82//fckaxZa7R+GTFzTl7l+u/0xXBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0414/1266] bitops: use common function parameter names
Date: Tue, 21 Jul 2026 17:14:11 +0200
Message-ID: <20260721152451.103588589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 40913516e654c9..b78be6c6c73e74 100644
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
 
 /**
-- 
2.53.0



