Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050971;
	b=XePMxMZV0JNe9YJCe0rVGIRzHd6KGkHEIecuww+0MNxa7/43yLZ4UDkWvP624C8i7456
	 A8FuS23l2AOELlzNynUe8yZC1bZZQEI35NR4/a6KqdWel25WKxlRv+E6jz+vzE35Uh0F2
	 JXRzf+A+PyeAjEcnHposPak9XSn9a64SbePWARslNNZ3lu+YQzTYIkW7aFS9VJRINulTo
	 Twk8EkbFC/jn6PRh1k6TEu15CF2Eg2wM+LiaYm1mxlC++F1A+0wDivQQ5bUGk/VwLgdN7
	 DTIU3NqfA+Tj9zv8KZaqgAs3z0BwXHvIHVMT14lYRGiMzwOzAG4sR0kIOGi2dn9JZkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7yjNVWce0gwRmgh52LDh4oNjAJhJFFFdO+m1QqZajC4=;
	b=W0TFdaoBXlbZoeE2xMrMn6nJifiq929ty7F6sW2RviDuJgKR330iJF51ahxYUhtureve
	 D7yHIsQuSry4b4fhDUmJ85IrMZhY3pHjP8yTbmon5PRa/jab0vEC/U0JTMQZnKij20lLg
	 x3WDB87d7FpoU4dh+KvRYQbVU2Zwx0+hi+JveZCUwvRSgWxHPY7hpUpkML+f7wq60qcPh
	 EsklqmcLfacjaV8QcYIU1bCH/P5UgP+ZRgLsZnb2zYgse9u2BXIzw+TtMtPaUxkL1MwM8
	 qkGqFBMvzlr/hLRvD1mUsVxx+eCCrB7Z5z6mAadba26GunQeUa66+L36d28C41ED77Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=utQtXK2S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E588606A320;
	Thu, 19 Nov 2026 01:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=utQtXK2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE9C1F000C4;
	Thu, 19 Nov 2026 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050970;
	bh=7yjNVWce0gwRmgh52LDh4oNjAJhJFFFdO+m1QqZajC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utQtXK2SC0puW9XzC6y4av8DrMDF/2LXeHF9IluaQvuyn0ErzdF94hNyL99YVBvMv
	 SsPd/yl0gneYkmJ/GyWzLs8zorSsrnjEK61fbkK2lIufFIvxIX3m9cgnTUKBer9Jv/
	 uYaAjEXaMLqu/NSdFk19ihy7adcanj16jI+bm4gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 0011/2214] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
Date: Wed, 18 Nov 2026 15:28:07 +0100
Message-ID: <20261118150010.597730300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 24f07e8c07a0c0dd275331cbb41c79a78741eef9 upstream.

When poly1305_blocks_neon() resumes from a base 2^26 accumulator and the
next update contains an odd number of full 16-byte blocks, it processes
one leading block through poly1305_mult() so that the remaining NEON
work has an even block count.  That requires converting the accumulator
to the base 2^64 form used by poly1305_mult().  The final ADC of that
conversion stores the carry into d2, but the following accumulation and
poly1305_mult() use h2.  If the conversion carries across bit 128, the
carry is dropped and the emitted tag is wrong.

This was introduced by Cryptogams commit 03dc4adf91c8
("arm/poly1305-armv*.pl: optimize branches."), which removed the
reduction that consumed d2 shortly before Linux imported the code.
OpenSSL's copy did not take that change.

The carry is possible because the NEON code stores the accumulator [h0,
h1, h2, h3, h4] in a lazily reduced, redundant base 2^26 form: its final
carry chain leaves h0, h2, h3 < 2^26, but h1 and h4 may slightly exceed
2^26 - 1.  For example, the reachable state

  h0 = 4
  h1 = 2^26
  h2 = 2^26 - 1
  h3 = 2^26 - 1
  h4 = 2^24 - 1

represents 4 + 2^26*2^26 + (2^26-1)*2^52 + (2^26-1)*2^78 +
(2^24-1)*2^104 = 2^128 + 4, despite the bit representing the 2^128 term
(bit 24 of h4) not being set; the extra comes from the h1 limb being
above the normal base 2^26 range.  When this value is converted into the
non-redundant base 2^64 form, a carry into the new 2^128 bit (in bit 0
of h2) is necessary to preserve the value.

Given the above bounds, a carry into bit 128 happens exactly when
h1 >= 2^26, h2 = h3 = 2^26 - 1, and h4 mod 2^24 = 2^24 - 1.

Store the carry into h2, matching the other base 2^26 to base 2^64
conversions in poly1305_blocks() and poly1305_emit().

This bug causes an incorrect tag to be emitted.  However, this is
unlikely to happen in practice where Poly1305 is used with a random key,
since the random key tends to distribute the accumulator values
throughout their valid range.  There isn't an obvious way for an
attacker without knowledge of the r_key to cause [h0, h1, h2, h3, h4] to
land on the precise values where this bug occurs.

[EB: Rewrote the commit message to more clearly describe the bug and
 its impact, and simplified explanation about why there's a carry bit.]

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20261009125354.315476-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/poly1305-armv8.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/crypto/poly1305-armv8.pl
+++ b/arch/arm64/crypto/poly1305-armv8.pl
@@ -372,7 +372,7 @@ poly1305_blocks_neon:
 	adc	$h1,$h1,xzr
 	lsr	$h2,x14,#24
 	adds	$h1,$h1,x14,lsl#40
-	adc	$d2,$h2,xzr		// can be partially reduced...
+	adc	$h2,$h2,xzr		// preserve carry into top limb
 
 	ldp	$d0,$d1,[$inp],#16	// load input
 	sub	$len,$len,#16


