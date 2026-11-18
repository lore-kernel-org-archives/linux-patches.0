Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059447;
	b=eTLz+4fv66gBnJUAc7l8+sg1iQVHzQHCTUZQDLdU7RsM5IwA7HjdBuGl1w8IumV8i2tb
	 TyfF0C74p+iSnZHxEIJ/ViQrFPtRDyRvLITPSnbdiv9qd2XLfgwTPXzXFz3DaTVFjmDWT
	 nvqnOXw6RGDA5eYX31McoV+pEWzYjRpJBDpwnZi2y6GVTffqwrh9J0bhkGrYP8ckm5HXl
	 tuuagj0BNP4o6Fdo/l6Hn0svrwLvIjh96lP8xVOklbFozYXklGXse7efJSxTO72CrO3rI
	 4MHFAqX4zsLtCs3+0eM05UBBZp2XzlyZG/55gE7vPC5sPHwVzU6vIIk8j+f/IlXlVKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DQ6HjSdbUKtJzFxgt5Raqe5F+PEulV5bFgXdOlFBRXo=;
	b=tu2XKoykFX67ZLR0oqR5qdK5dDnC1tTOOsy2+pn30MKV6h7/qmo2DrO72G1S2nScp+Ga
	 esj33xk8dOnafWV1SdsSHfjc9k2TsKIuZcfUf3TZF2qevpZw3mEeUkmT3wc4HkcCBDySe
	 H47HMA6HK0mC+xqN7csqJA32Gwqxj9IMH1eEHvZI2JGKet9/IO4ltWaC4jQ7+N2AdmzMB
	 LfDcVzorSRsl0qvPJD3XQU2EEQtegp6CWbP6tjkgAPlukXVYYyeXPXfLa5+EaqKYPA1F+
	 N29ADF+PDYvdYhQE4si5Q+fjfrDRJriWKNzOMPfCBkBATDzl7KrEsRCaLEfYb30nyvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LFYBE5oC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D838E606A32A;
	Thu, 19 Nov 2026 03:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LFYBE5oC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360381F000C4;
	Thu, 19 Nov 2026 03:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059447;
	bh=DQ6HjSdbUKtJzFxgt5Raqe5F+PEulV5bFgXdOlFBRXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFYBE5oCUD3oYUnkH5Vk/17ihW18zhPyfMlDxWRpfXNfF152GanzH9UsJdQNM6LGi
	 2JMsFuWEMKUjg+S1tminszwGGP3dwCMmNUOeZz8UGn9JoQGUeExf5KxP7ZQP2ezL6X
	 wARHMk6HlmUfVtZG1eNedlUH3v/Skfrggce3VX/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0803/1848] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Wed, 18 Nov 2026 15:47:21 +0100
Message-ID: <20261118145949.971800525@linuxfoundation.org>
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
 crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a5673a31bfeb1..d639e4c30440c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -918,7 +918,7 @@ config CRYPTO_SHA512_SSSE3
 
 config CRYPTO_SHA1_OCTEON
 	tristate "SHA1 digest algorithm (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
@@ -972,7 +972,7 @@ config CRYPTO_SHA256_PPC_SPE
 
 config CRYPTO_SHA256_OCTEON
 	tristate "SHA224 and SHA256 digest algorithm (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
 	help
@@ -1002,7 +1002,7 @@ config CRYPTO_SHA512
 
 config CRYPTO_SHA512_OCTEON
 	tristate "SHA384 and SHA512 digest algorithms (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA512
 	select CRYPTO_HASH
 	help
-- 
2.53.0



