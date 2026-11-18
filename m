Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057217;
	b=rndsGCZXnIJ9lQpa7Rv3eFlBw1pSEtTALoyLhd+HrhV7eyyl7ck4nJzI9Z2hTOWqee9w
	 jeLXQbxYjS7NpDcO1gyzwivdt6TyxMEAvRgWjcl/h7lHzI3dOSgBkYNn3MsZPQ8HnuSGo
	 9Le1NSRXoroaglXILFDGrh+y+s/ynleXatfnqXBXqS592gjCj8/oF3viDqdRzfqhfrzD9
	 GETS6x0jzizTD+lHe1RDtzQm9LbmlZlG2IkI+808PVu2Y09HAu2XV5Rj6d8Tgva9lh74+
	 sKbBrb6xlGPTWzoAZCgXd5Buc9PiCCfoI1l8P68zD4Qzdupjv4XxqzcUytwECV6RXfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p5dihUVBiR4mmYonRoVU4GVYTPuyyxx6lTWiE1a3hMM=;
	b=hq2ht9kwGOrLKaJa2M8iB984zVsDJiKnWjRUzTHzKrw0zSeGJP5dAdqlU1sF7pd++NjP
	 tLHC5esVuoF7iJikBOUVvPxsUSddrb6ZqPRWswp02qD7WIwWtpqjnLk9RjXBKRze1FyLA
	 oIsKZU14FHitxdNRMH2GSEHK8JZo0+F9Aegvw2nMg9URJVGPtCBTpYhE01AKCgMbbD2ZJ
	 u5kj2JgvhMvmEXPYy2/cWCjxpDUmYSQS0rLyQNDKJy8jjHCSXprEJaaCjgClYEo+53DKi
	 o7EAw+aKV5nyBev2b5Vm27ytl5W2gv9b93BWFZpsyYc7D5G5Gl/kIq7jjrz5+//HOIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lIqJvq+q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC6060A2601;
	Thu, 19 Nov 2026 03:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lIqJvq+q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE31F00926;
	Thu, 19 Nov 2026 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057217;
	bh=p5dihUVBiR4mmYonRoVU4GVYTPuyyxx6lTWiE1a3hMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIqJvq+qg7v/gs8zQNZBVEHZ4ifDotZjmKP8ht64Frk+IF93Cr/VWDNa2VfRPAmbB
	 mLWZqryOeNP/RWUFgrHRtTUF/lx7Qk7SgygHKuC2UT01cpSK889uP5Jgd9l9MLuTRc
	 MTa+0AT51njCCqag60pL7DcUkqZv5yjyPqkBRHpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 0010/1848] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
Date: Wed, 18 Nov 2026 15:34:08 +0100
Message-ID: <20261118145911.628595144@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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


