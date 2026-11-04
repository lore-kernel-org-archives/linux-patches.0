Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829614;
	b=YppJ915++CYQN+mTvKWMgX9fBsnDxA0YGRWzEJzfVvGZynfuQT6jZvr7umn9YO+5IoR4
	 Qx0nv7nbLerMhysmgTTyxOXXUMR0jwowPNJyKwlAm0NVx3pTGM6MLoSGO9IudQEdpECQ/
	 D36kBI9cBoNhSO7pF7QY42yPhzvmIH85I8PDClDs/QGm2UYvZ1EB4FNDvTJSmEBCvpjSf
	 DxeCCmI+rfLxnj0PMhMBy6KKjk8KCHON3t7kj/GazLC5VuU56HlpVftpFP+Sgob24qhxh
	 gSxi1LmiGvPaEgRaF8URkjfsodVnqtI+SiDwNW+h59kg+OVuiPMB+CB94N7ZxrpM08w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WmG2s+IjgIAOLAjqKD7RexLTcYSdy8nGRYuZvn6M85g=;
	b=OE+z1WZ43GgmPQw8cBj8CfD4KzajMN80I8c/x6rEquhaP4rzEDlKJzkwWSThP3/p+/fZ
	 pcsmKBwsK2g+aFGckZllnbcm5ovDJMJ/tHHxFDRuXdF81/U6obiLJ2k5UHiMM75SKzrJ5
	 AXDz2CQXQr5Hp5Gt9Bce2/5WemoizSdIjNle2Ds4Kzt7r4O5wxVEyjKuu+f4TSpPKf7zj
	 7rpewehfRWH6xm0GJYSna+z9kx6MMWkCQLCnjpMVrWdhumtm3oJCJUW+Ebt12Xf6MfFtC
	 RGI35dJoi6HsdbuDWFWazoI8lxkpqwd8gPol8o9AusgnsA87K9SsmG780dI+9SsjjMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wxwVH7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A10608C9B4;
	Wed,  4 Nov 2026 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wxwVH7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AF41F00A15;
	Wed,  4 Nov 2026 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829613;
	bh=WmG2s+IjgIAOLAjqKD7RexLTcYSdy8nGRYuZvn6M85g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wxwVH7QnLKcfEH7DhC4L07qUcpacAjKaKonNOEWxpRTHooOJMrVYodZnl0oDnPgg
	 jonJ78X+pWTYK8YpQefKidXNvU4ihro3+ifSoW9SnoGSXtlkxSwfOjMuhNNITQ+gi6
	 NoCvCOW5AT2YHj+QoVyVQVpjPo9uMDspN5OJwBfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0236/1005] bitops: make the *_bit_le functions use unsigned long
Date: Wed,  4 Nov 2026 15:59:29 -0500
Message-ID: <20261104211050.463257027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



