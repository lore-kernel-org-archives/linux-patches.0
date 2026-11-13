Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585401;
	b=UjZvOn0LKo1U4dUtYbQv+KEi84ipbxapM+2snw+TAUvj9+U1BTeUA0E4ulRh1jwNvP5T
	 FKmUpvXTK2Zab7+7dTaBkvkXmMFZ/SHKUdoBpeAInqPP+BWBYWgK7LXnEUIDpE/rW8ogn
	 HSY9oA13Qvd2JQpXTd3nhN4So23DSZyAtNZhzdNJNMG8saObJVnsnekdwCm5zeSzsZrSy
	 KicF9a3Ek3Rzm59ppINqRxK258YZ+AvB3oyCpr8lhGYECr+gOpZbIh3cMl3s6onjQMPUd
	 FjxgfV5jWTjUc/8vJdWOnRKWppOoIfcoW7C3JgX0Fe0nYDQe7N97fMuQ1mekT5Jdf1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMs8rDJMBNBtTEqRMGlN5wotcUXIg+swuivFqMdSet4=;
	b=UTzPRPITC+ea7IUalqo1MXU+QYXNqQDOuhWQztaVq+MZNb1WJRuwjHWOdDE8AR3GDEtM
	 Tt2ybVoX4IEw5tYH6o1ZgAVLoONLX2HYt7twbQEOKvOnLZQjW5LN7Wur+Ltzzz2IIpNkp
	 /Tq5uttZEp2pd3+u+vRJ01AmsK7svaz8BFNTfl4iR9aKzZBUGtWyEBT8edj1kpOuljUEb
	 eV7ctaAQBv4sPax+qhwXjeccDnTd4UswX3MtCO8hje2iQufyIK+9ZBJMudv0g34rXJnDb
	 4iSLe1jiSuU6inpajuprCh6yFpcjVqlWZ3EtJnAu4LGuFUP+L4G7i+Aj+VcAOCUP7Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iTy2oLX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EABA606A88E;
	Fri, 13 Nov 2026 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iTy2oLX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2441F000C7;
	Fri, 13 Nov 2026 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585401;
	bh=UMs8rDJMBNBtTEqRMGlN5wotcUXIg+swuivFqMdSet4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iTy2oLXMLv9ALknW1kxLj6gHLnyGCT166LHwq2lDQdjK1SGb+QKlbIrWO87wM3lA
	 1bRiFMzqZYPrtz1PlS/OfZcwRiTuSK0RU5ZC9Gz3hChmzOsaxF4JUdMJ0OjguH9ljI
	 XJhzDMu550hd8yvsM8Z3dVhT0fo7laOr+vWecAgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 070/507] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Fri, 13 Nov 2026 10:46:14 -0500
Message-ID: <20261113153755.939432431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit dd2a4edb26e1c78823c50ba10c42f2d3de2e5ec4 ]

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
 lib/crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 56f308dd02731..83b4a211c15d6 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -237,7 +237,7 @@ config CRYPTO_LIB_SHA1_ARCH
 	depends on CRYPTO_LIB_SHA1 && !UML
 	default y if ARM
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if PPC
 	default y if S390
 	default y if SPARC64
@@ -255,7 +255,7 @@ config CRYPTO_LIB_SHA256_ARCH
 	depends on CRYPTO_LIB_SHA256 && !UML
 	default y if ARM && !CPU_V7M
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if PPC && SPE
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
@@ -275,7 +275,7 @@ config CRYPTO_LIB_SHA512_ARCH
 	depends on CRYPTO_LIB_SHA512 && !UML
 	default y if ARM && !CPU_V7M
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390
-- 
2.53.0



