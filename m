Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064793;
	b=Wtl7XkNqr+/vwi+JPbAJDD/ek4YH+jg55ksbht5p4MLDHxIsbKvnmjPPbGk4Ns1kcC2d
	 fPOQXZzjNux46A4rfBPiJqG8I9v1uoHzZ3CyTcH30Va5W2Aze9cyMKQ5h9t73tRYdf27D
	 qU0vZV0sNkrWGegIuY9LtXYokXfYgGFjr3HUBIYXtFI4yZeDEt7WA3TpGxASe65jDyQE5
	 y8AJLdPgEilBSR4k/w8cSqqkK3+FmVwzBjuOrCF51azmUCJgukykJn0PdNC7z5xixMvFw
	 vsPqueaLBQUK6qZ4njapsLgzrXnznhWkE2YJRKIk0HyF4q/EBFPRViMxvFbsuQSVoaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOfTf9UxB2QjcNhRt1NgTnJwYYuJlIEkzOlR1573E+s=;
	b=Cvtw7uQqO8GHxl5rrdfpVylKdcNP0MgSzniLmrwH4NOtY92ZHPuJysORiShruMudPP++
	 70ORvJVhaiev4O6L3iPPvbrVGEv1g7MYO63g7iFtTvcACJsAxwU2/0+LOR9/DGnKzFq3c
	 IYVXr0JNLfwT4BTcwMspvbDkTNvKZJqXrBB2KA7srRxWgnZziV7QQ2ey7CnxTszcqdtIb
	 0045S14Juuft9vkjw9J1exueiPy4Y2mS8JjT2Ot6yJ6YvxOzkm/v3ujffEl48MG7LIRtK
	 gcHLm5CiKzz73hdr+o+EgKMTjbtqtcEmkFqI4blTwaTNhOyi1HScjVOFIBLcP8YiwbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIi2r4bX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD9606A9EF;
	Sat,  7 Nov 2026 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIi2r4bX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777CA1F0089F;
	Sat,  7 Nov 2026 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064792;
	bh=UOfTf9UxB2QjcNhRt1NgTnJwYYuJlIEkzOlR1573E+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIi2r4bXdwZuZzUV8Ui4CLr057H8qXO/bL2rS+tUPuzJwaiA2Q42rMBmt/SB1h0oM
	 w2IRM3onhZOgqae1xowpM8iSrYdaUnz+SJG3cf/rGqHhV38DW8iPYX2QEfYclAxgfN
	 pbZbfr5og+l8hTeJ9xJTbXruNC4DVVuwg5bZnlRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0737/1257] lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Sat,  7 Nov 2026 08:50:33 -0500
Message-ID: <20261107134959.633531809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index aaa75404250e2..a9236d3e9678d 100644
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



