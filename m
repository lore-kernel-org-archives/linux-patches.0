Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15346C4D9;
	Tue, 21 Jul 2026 19:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661623; cv=none; b=Eje+USV8IZDaxyHP2iPW2IsGYtg/oFbZUjk90+KbundBr3MoG9BNlwyl6Yyk2CJBjacfoRIfm0MRqw4xFc8TqOi51MQM+myR3+QkjUZQ1FnMgeB3KOWAV7Nmu5gr5NlUihDR+HD7ZWLWq0Gw6qhFRAwH7dLZ5G8EBAm3L84tZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661623; c=relaxed/simple;
	bh=DVUHFNRIdAHovRul+I5P7+J9EJOdifMs39JE2Z7K1TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmCb9XLCJ4bEsSWf2C3YtUgqlAyKQHXZneentSx+1l8Gyila8DfHW1TScuh3hyFFQuAazlZzwbQ6A+dDWD60hiOEAWXqee/WaOJWhMRrCdVeoBQuzyMjN2K3PPaGqFCu94lGxXAR7R/MnmfvDIUDGjCYAB0tizm5ZQIeU1q9JbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=df2kwJEN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="df2kwJEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C1F1F000E9;
	Tue, 21 Jul 2026 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661622;
	bh=NMWUtmDMTqzcF8b+JBiKpRcDzCygrVjUw5FPQZrfYTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=df2kwJENP0PoixAPqKW9iCS6iGQw/3l5F5ntXqe9IlbHkuUJldgg3Vo8Y4No8BDn4
	 ViYcicxyJKZQi4wFDNAakGNOCV/W5smYTtyUDgd6gjdiDYNcvxAaZyyyIfZEGK/Xw9
	 pB3By1dOAivE1eiEYVx1A5kEcDKAkkjdCz8XybYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0134/1276] bitops: use common function parameter names
Date: Tue, 21 Jul 2026 17:09:37 +0200
Message-ID: <20260721152449.100731014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



