Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043262;
	b=HyUdVXPRPyQ7hn/nU/vkKTmOc8DcxwB6GAymL1s5+DYh5CuhVVYUNM+vDXe9qDWB3Fuu
	 gpPxKgA5qUfmnE5VpLb4n0a6bJlDCsZXI0ljihPzUiCWtEy3KkEM/T+wDNnMkKVM7hLfA
	 VGH1+e5itoGFpMU0+wsNRzyKQSFX0zNWTVtInKv8cnrPAfvQGn11XyyvBs6jfTsjyLyWc
	 rocKJSOz+YGy7Jk/qbCE0nDjkG+WH7r0w7EZaWOKs/6guZJ+eSjnXRarvn6Yk/TlT39UY
	 0NO+CGoEBXFAVnUA3Nx7iSaVQU/quucw/fnvKFuW2UIzkIKkcwAF5WzwdkhpBCacsRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8VFoQm2XN+sqtMNMbmh0AnHC0wee4jaZ7GTe7K401h8=;
	b=iw+Fd0p8RVfpiNemtYhyL8d6ISu5Ut+Lhl54NkOFay/9NtjIWo5LBv0/WRVOVa5YcTFx
	 syPcgnrraoznsFCFkW6gaahuHZRyD66iS1obW/PB5YJwLL58Gayy1KWlwfD3j5PUBiTst
	 X5OoGWpcbctqe3jrVdR1Fb858w3HXUvXbMQe3aL+4SUdTLb0hlDd9rupowEjDN+rZjNxM
	 BXYamfefUnZluG4LIzcBX74+WbssLOmGs1zHi6u57qPjYQvRfE8UxUYfI2a47TdKMdTUL
	 U6V9zV26x4+WH2Q+zyH/UEH6JDrrBlrsMC5QX31t6puaDL3zdGIrCtWmftEOnYvm3ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BApXXozT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C88B606A32A;
	Wed, 18 Nov 2026 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BApXXozT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23031F000C4;
	Wed, 18 Nov 2026 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043262;
	bh=8VFoQm2XN+sqtMNMbmh0AnHC0wee4jaZ7GTe7K401h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BApXXozTwOvp3hqR4MV3IfptdCfrlGSOo7yY/zmISzekQFGIzR/9LKqte0TooENdy
	 EHl5zQgSEZaBAZlJxR2fAFv3LgLu7HjVMp2UNVG1En0HRdBvLYroG+LvzqImZj6oNA
	 xuWIoJzI+Ny8xX8dN5tL4LLQu2NbSQUSRFw8+oIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0146/2857] bitops: make the *_bit_le functions use unsigned long
Date: Wed, 18 Nov 2026 15:19:40 +0100
Message-ID: <20261118150206.605431472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d51beff603755..e3b0da9a25f1b 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -16,47 +16,47 @@
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



