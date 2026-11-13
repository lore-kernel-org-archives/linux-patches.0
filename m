Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591303;
	b=LljxHBMm91Upm3ARtZrPpjexiTdxWV7NpWaolF3fPjk2wSxFThEPnLnm+IflKDRaEBZ9
	 91CUHn2JWQyMhRZnZwPkI5Gzo5yGTf2XaUHx3cH+iKQoZ0DC1k0C4F0JAjWJqnMGWSP99
	 37oebvnYCgqufuLckS8YzG8HvH3xW+6pgoYyW4h5MtYztKBLgPENforiDUilzqwj2/lCi
	 uipm8dXtFmCI0RZ/Gyb/At+2QARwrUjKAUlOY8ktvrUjlJxx+oIZZUAYLqn1H9pLhUmxx
	 6W4eK5Ow5VMJg6TSF/ZUrgcO74KcPauJeu5MCKQcDlRYM57EfnPldR1ToOE7WhLtBXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1l1y0Dct5dUdKJncxJVsstY6PPSk0Efrd3Nad2EpWcE=;
	b=QEOIwweFe+3nqtOBxrl8FNnsN+EMNBIecYvsZY1JXmoEOR+2Zr5FGP0qrW+3ZuFUcvy/
	 v7S4KSI3/htg5yiZKI+iFL4O36Lxm7+W+smwiP1i8xyQYDeTYvz/O409dObyYZeoNKjIl
	 DSLYVl4MS2KBCgG1fT55RhjZOFZxZ7c053JQQqaO/1OViDGvfgR1SOq4/StD8I5JeKAGq
	 hZMM7lX3+qk9l/NX7ksbH5Oh3rfoRQN8qZcPdCSzubRdjr7KUk9sI2VW2aoby9deypDoe
	 TwmgZH4X7KNAxFiiPPMDE4mGKlFd/gTXJsLDvc1oHaGXQHj9oERKmGo2B99C7kkrR+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJN5RwAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C85D606B205;
	Fri, 13 Nov 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJN5RwAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343EC1F000C5;
	Fri, 13 Nov 2026 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591303;
	bh=1l1y0Dct5dUdKJncxJVsstY6PPSk0Efrd3Nad2EpWcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJN5RwARYhz6IiQy63St7hHiJ1eb/NtoJnkTcsPl+KMBYg4Px3ut99bmMXSCXz4PJ
	 EKZanLHSNdq2kpijsHan2bKXc9Pswr+PMdTKpNKlR2D5ltjRm56h5XhDkWdFrhXcpF
	 AV2Tiypn/OSqWH6H1unkK192IYXCgOoePTQ4cmuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/670] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Fri, 13 Nov 2026 10:49:42 -0500
Message-ID: <20261113153825.908525028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit dd2a4edb26e1c78823c50ba10c42f2d3de2e5ec4 upstream.

Kernels built for the MIPS64-based Cavium Octeon SoCs are normally
big-endian, but little-endian builds are also supported.  Currently, the
SHA-1, SHA-256, and SHA-512 code using the Octeon crypto co-processor is
enabled in both builds.

This code is untestable without the hardware.  However, based on the
code itself, it is implausible that it computes hash values correctly in
little-endian builds.  Such builds write many incorrect values to COP2:

  - SHA-1 and SHA-256: The 64-bit integer that contains the last two
    32-bit message words of each block is written to COP2 entirely
    byte-reflected, due to missing endianness conversion in
    octeon_sha1_start() and octeon_sha256_start() to compensate for
    using native 64-bit loads from the message bytes.  This differs from
    all the earlier message words which are written correctly.

    Furthermore, the state is written to COP2 with each 32-bit word
    byte-reflected within each 64-bit integer, due to incorrect use of
    64-bit endianness conversion in write_octeon_64bit_hash_dword() when
    the state is kept in memory in native-endian 32-bit words.

  - SHA-512: All the 64-bit message words are written to COP2
    byte-reflected, due to missing endianness conversion in
    write_octeon_64bit_block_sha512() and octeon_sha512_start().  The
    SHA-512 state words seem to be written correctly.

Big-endian kernels aren't affected by these bugs.  These bugs also
aren't new; this code has been broken on little-endian ever since it and
Octeon little-endian support were first added in v4.1.

Commit d2a948d2db68 ("MIPS: Octeon: Make octeon-md5 driver
endian-agnostic") made the MD5 code work on little-endian kernels by
adding 64-bit endianness conversions to the COP2 macros used by MD5
(some of which are shared by SHA-1 and SHA-256, despite those algorithms
keeping the state words in native-endian instead of MD5's little-endian,
causing some of the strange behavior described above).  However, SHA-1,
SHA-256, and SHA-512 were never fixed to work on little-endian kernels.

Therefore, disable the Octeon SHA-1, SHA-256, and SHA-512 code in
little-endian kernels.  This causes the generic code that actually
computes hash values correctly to be used instead.

Fixes: 82be2dcfa6a1 ("crypto: octeon - add SHA1 module")
Fixes: c3d0def62001 ("crypto: octeon - add SHA256 module")
Fixes: fbaa4dfd51a0 ("crypto: octeon - add SHA512 module")
Cc: stable@vger.kernel.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20261022054450.20746-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/crypto/Kconfig b/arch/mips/crypto/Kconfig
index ee9604fd20372..f951a75dfef32 100644
--- a/arch/mips/crypto/Kconfig
+++ b/arch/mips/crypto/Kconfig
@@ -34,7 +34,7 @@ config CRYPTO_MD5_OCTEON
 
 config CRYPTO_SHA1_OCTEON
 	tristate "Hash functions: SHA-1 (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
@@ -44,7 +44,7 @@ config CRYPTO_SHA1_OCTEON
 
 config CRYPTO_SHA256_OCTEON
 	tristate "Hash functions: SHA-224 and SHA-256 (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
 	help
@@ -54,7 +54,7 @@ config CRYPTO_SHA256_OCTEON
 
 config CRYPTO_SHA512_OCTEON
 	tristate "Hash functions: SHA-384 and SHA-512 (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA512
 	select CRYPTO_HASH
 	help
-- 
2.53.0



