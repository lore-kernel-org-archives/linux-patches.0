Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033876;
	b=dxkGRF4d48x3AIh0trMvO/ztVA0rz16vehPv6/MaYrsk/Vc9OLo0l9T7dQ59RouIsW+R
	 40Zc0AU4Cq6DqoOdStNlAjvJ6iFnpP13ajhjslgMnJk+amb9dp4gsBEEP+nH6TIQqQIk4
	 X3QXiLkcJgFGtGMweyR4U1NVuM3R7diknejyxxOeFXam8CcMc82lCKGxG0EYQTidhPNRV
	 0YBT0qGubKH5EvijaWkLQCfj7+CA60n7RJ5HdQB8zEKa8ZaH92wKUpmzCZOBWNvtQKmmH
	 RBVuoFiSVjCVaxAsMV3+Atw0RLfsIKbEwjFNQNncjj85eEAQ/TBKrkULtiyNuiQnk8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQGr8awPXI91Fsld0Y3ZkQlcgXVhYEi6lTBbom0TdJU=;
	b=4UXlsQKPSy7NqVWt8WhM3r0o6+0CGBIi38P/clZxo470QZR43cqdYKXHPX+nZ0qeKRfR
	 FKOAGB0ANYsa1FuB68D0SO6jsuxzZJNR6ucKSnnv6g2KpNtR24mLEcpMqh02MXQsZIW5E
	 qQyQRuvwGEa67L8mAiJaVsyJz2YLFvqAKUyF3ZoNsLLbLFbq3tzbWtwQF7tvI0p5K8gRD
	 oY3FC8QcRERi7S5ws0dPzYNqVaMLbTzl80jQnG0hiYlHkLMXuo65LBf/McVMhfKk22CXu
	 LAwQ9eUn+cKMcvRRxFBrS8zPWlLcRQoSztuQc5owItuJf/cnnxHrAC9VGYwLJ4tAkZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/Henxwk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07640606A31C;
	Wed, 18 Nov 2026 20:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/Henxwk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C68D1F000C4;
	Wed, 18 Nov 2026 20:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033875;
	bh=oQGr8awPXI91Fsld0Y3ZkQlcgXVhYEi6lTBbom0TdJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/HenxwkD4ZtDfmc5THkDeJQwr+FSvwKS5/wWkAiFmGn7+ZG66XfkuhBlY5W7Pb9L
	 i1MZoiFFX5Yqcq4mtgN2lfZcW8AX178/iOwDonm3wJ0nYvuCe2QjzErKEbyVYfHd3r
	 zVS7ITJLKtyHgMc+vKuacfYO1dzVHZElQDtgr8S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0171/3318] bitops: make the *_bit_le functions use unsigned long
Date: Wed, 18 Nov 2026 15:13:13 +0100
Message-ID: <20261118150319.786949856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



