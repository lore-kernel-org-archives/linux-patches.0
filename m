Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052775;
	b=1nOjxhT++4ArGPJN6lOJCQECl3Uo7deRdoP4dz77IQ6uIU+HFPMEwmLx2BUV/d40nfGN
	 HLfkkHD2FYI8l4RdiFmqYQAgDDx10t9VrKn8msGbaps6184WUoSHRTLYzG0Pf53EryFkJ
	 yWrcUobeEp/pMMYkYnjZhhhgxwl9z9tDlZ3Ft6oQzsuGeaccIIVIk2/uY/b51G/TAoZ8b
	 A+tWqje/GXJefaBg/sKKoztkVjT+oc81DBaGVkXqyQieozgdDqwUSpaqJu0TWyBEJFHAg
	 higZ+wfrIE/33Bn35tj5emu7u8iQReUySter3Tv+ibesMNJEHf2u0dhNJcLKlKsk1Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HRoBNI4y85t8lYQ24MsSkNPCosG0rEzYqvpH35v6Zxo=;
	b=j4yRk92g4h2lQqiixtniBR41AKxiO4Pn5oUJTm3PUStNW2bp5QTZJ4Kn40k0Sk9z54S8
	 y2X1VLALdn3I85DWuw38N41T1hs3D88nKbRmBq1emQtggtGsNIxhZRSysyDEbXAAvjBcs
	 sTabuWM6Mye1wvy49/aHOgIfUv7rpGsoaScXkErZf6tZwvsrr6QG8h/4z8hWkiYsEbvA+
	 5En6Qu9oy5YouqClJ/9hhrhuzyb+qiW+qv/XRS9EiJl8sywh5ONetYapkppXo9H8EW3TF
	 QXaCCzsP+vZ1wBBWZlh9GVY9pID12Ow0R8C73bjNciE3VtR0WawzUg8xR/HNjj69BlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgU2gtaS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AD9606A31C;
	Thu, 19 Nov 2026 01:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgU2gtaS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A061F000C4;
	Thu, 19 Nov 2026 01:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052775;
	bh=HRoBNI4y85t8lYQ24MsSkNPCosG0rEzYqvpH35v6Zxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgU2gtaSRU4oi1k/vpBFqoi7aXIBZNpXrFW6xwBxd34zpCujRkNu85jq+B45Qgh16
	 AkcjgkMc1K622X8SDMIMtlKkxRboXztx2dZgbv8B7t3cC/BtONe+IzLwXl7pInl33W
	 CmNtL4DsiDZtDp1T1t9bF7Ew21cEcB/6D0pqoS4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0635/2214] lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Wed, 18 Nov 2026 15:38:31 +0100
Message-ID: <20261118150036.746212770@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit b822ad8d702df0be9fe3f24f71caeb0522d72319 ]

The RUNA/RUNB decoder in get_next_block() accumulates a run length into
the signed int t with no bound.  runPos doubles per symbol, so t grows as
at least 2^n-1 and reaches INT_MAX after 31 RUNA symbols.  The guard that
follows, dbufCount+t >= dbufSize, is itself a signed addition, and as the
kernel builds with -fno-strict-overflow it wraps negative once dbufCount
is nonzero, so the guard is skipped.  while (t--) dbuf[dbufCount++] = uc
then writes INT_MAX entries into a buffer holding at most 900000.  One
literal symbol ahead of the run is enough to make dbufCount nonzero.

Bound t to the block size as it is accumulated.  t only grows within a
run, so the value tested never exceeds the final run length; any stream
that decodes today satisfies dbufCount+t < dbufSize at the flush, hence t
< dbufSize throughout, and no such stream is rejected.  Because t grows as
at least 2^n-1 the bound trips by the 20th symbol, leaving runPos at most
2^19, so the following runPos <<= 1 cannot overflow either.

Link: https://lore.kernel.org/AS8P251MB00010FE5E38D253CF98A652AC8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_bunzip2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 4f98cdea7e0b3..b8fb40ed06d22 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -428,6 +428,10 @@ static int INIT get_next_block(struct bunzip_data *bd)
 			t += (runPos << nextSym);
 			/* +runPos if RUNA; +2*runPos if RUNB */
 
+			/* Bound the run so t and runPos cannot overflow. */
+			if (t >= dbufSize)
+				return RETVAL_DATA_ERROR;
+
 			runPos <<= 1;
 			continue;
 		}
-- 
2.53.0



