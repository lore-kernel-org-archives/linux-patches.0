Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057391;
	b=WK3KHv8r0JXkllMonLThtQpN+HcGtPPRNjAypydnSp98VwDPdAM4DJqekdfRgzrvvdMv
	 7vC8z+HLc525GogFIP2mcQJdsOWO1e+YF950PosR5JLMdNigoKwE6V2+LnDPuPiDjmzHX
	 uJNDiXvTCUrJLZ2n0SKF6xmmSWP5yOCEjsd628KLjR3NoVD9lGTPKUYB3Nltfv7o9X50J
	 SSikFhkhalaP8NoRpCyE6auf9WrXrbuhu0VunnW8noXPhKGjJoHUwaQvlxAYbqqD+YcYr
	 cmhj5rGPAAFTuvgKprAkWM09NA35J3D2ilS/BXQBZoKb7geDf6nRF3V/nXXH5qLNPJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+FItY5ghECZTxOWcBcll7yJhV7XCpukqyJ2kmNityPM=;
	b=Sd4LdMEE6BpCnQwhd+OQexAlND23Rj14IR++Dr9OaHaYVP9Ohh8Mqb0m4+tpwc1NgjGD
	 kM4CRlYzqJlD8N4LGvUu+v6xBzC70lHj7pMo7XYJR0mAtpNeTcHTPU3911LBjblKp/Pcp
	 hh1aZTu1Yx3bzdEwGrJm7DWd5U9FG/9LA1WkE/iPnrID5/evczhTva/jJMDqC6k/zjDms
	 AJUf9Ki5UhC+WgJXE/Vkd52VJjS0KX0JK0h9Ve6Pyecrv7ZKAj6d7hqFaALXVw4clQZVr
	 Xo1+56SQduMhB3NqXIjbTs1o0zsxFJ88MPH8MAL/qsPb0PKBSOEPlQnWfNjz/xcijhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VdiStQF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A647606A33D;
	Thu, 19 Nov 2026 03:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VdiStQF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF4C1F000C4;
	Thu, 19 Nov 2026 03:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057391;
	bh=+FItY5ghECZTxOWcBcll7yJhV7XCpukqyJ2kmNityPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdiStQF+r+xSVc5GeJYaJNHYugghmeeh8MU9KVTgo3MpzwvOhFeK71LHquaSv+1xE
	 Ih0Op/f0Ds6+ntnRCLZ96EhF4UAvAP/iepfbfplozGWKABrGw8WkNqlfZlUdu8qcyF
	 FEl4lyn0g7dQ9M9FdfXXHx1F/K4Nfa7sIsubYI6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0114/1848] bitops: make the *_bit_le functions use unsigned long
Date: Wed, 18 Nov 2026 15:35:52 +0100
Message-ID: <20261118145915.759951414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 1c61b0a6e5c472737619f74f79c390363ee258df ]

The *_bit_le functions use a signed integer for the bit number.
However, the *_bit functions can use an unsigned long. This causes
problems if there is a large bitmap and a bit number > 0x80000000 is
passed in. Since that is a negative int, it will get sign extended to a
long when getting passed to the *_bit function, turning it into a huge
bit number. This usually ends up with the memory address wrapping around
and the function accessing memory before the start of the bitmap.

Avoid this by making the *_bit_le functions take an unsigned long.

This can be triggered by faking an almost 4TB dm-mirror device, which
uses bitmaps to track the mirror regions:

$ dmsetup create bigzero --table '0 8589934590 zero'
$ dmsetup create mymirror --table '0 8589934590 mirror core 2 2 nosync 2 /dev/mapper/bigzero 0 /dev/mapper/bigzero 0'

This will access memory before the start of the sync_bits bitmap, and
likely hit the guard page of the previously allocated clean_bits bitmap,
causing a kernel panic with the old code.

I looked and didn't see any crazy code using the signed int to
intentionally try and access bits before some address within the bitmap.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/bitops/le.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 188d3eba3ace8..e83a53ecbc6df 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -50,47 +50,47 @@ extern unsigned long find_next_bit_le(const void *addr,
 #error "Please fix <asm/byteorder.h>"
 #endif
 
-static inline int test_bit_le(int nr, const void *addr)
+static inline int test_bit_le(unsigned long nr, const void *addr)
 {
 	return test_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void set_bit_le(int nr, void *addr)
+static inline void set_bit_le(unsigned long nr, void *addr)
 {
 	set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void clear_bit_le(int nr, void *addr)
+static inline void clear_bit_le(unsigned long nr, void *addr)
 {
 	clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void __set_bit_le(int nr, void *addr)
+static inline void __set_bit_le(unsigned long nr, void *addr)
 {
 	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void __clear_bit_le(int nr, void *addr)
+static inline void __clear_bit_le(unsigned long nr, void *addr)
 {
 	__clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int test_and_set_bit_le(int nr, void *addr)
+static inline int test_and_set_bit_le(unsigned long nr, void *addr)
 {
 	return test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int test_and_clear_bit_le(int nr, void *addr)
+static inline int test_and_clear_bit_le(unsigned long nr, void *addr)
 {
 	return test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int __test_and_set_bit_le(int nr, void *addr)
+static inline int __test_and_set_bit_le(unsigned long nr, void *addr)
 {
 	return __test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int __test_and_clear_bit_le(int nr, void *addr)
+static inline int __test_and_clear_bit_le(unsigned long nr, void *addr)
 {
 	return __test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
-- 
2.53.0



