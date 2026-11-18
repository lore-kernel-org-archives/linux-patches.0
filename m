Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058515;
	b=UED8QcyJzhYH12zYwa+MzPbk4PbHTg7s9Dccn4MFnEr9j6iuDShCmgQWpdxsZpfwYqDK
	 nnwa4fp4zz5aQ3H9SCFKMhCs0KpoxVn3l1HNr04rIZidEUX6dOrrF8Y+ik9KoZuhkUG+d
	 m6QBJRKXAQqdcsWlRtW5OVf/5LFB0e5sh+tF5gaNEdrDfncGRdE9lOo4yo9Hfd8IcKj1Y
	 wBg8IkjgXaho/ipRy5u/EFSysK9NVQwvtJFCFGxD2uZFmDXwtF0TKhcGGRdYn3V3zGAIS
	 2h+Ejk+ClCPjzT6hzNxoMleeIzKruHSAma9+/M/PK0R4RyxCgr2SnlwGDJ4AXqnIiWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lz7uyiKZ/YU5GBCEp6gXPWPjgPTmLXJB4nQle8i6rYo=;
	b=cyTsYfq7fauGQ90sWUeCBFxf5hdpgMXl+/zHjfw0GG3JBKWXj65anblf1VgWiN/9jbdO
	 PTbA8W8AuTfU+in6dNaGEHWSwc4EjinIldoSvZS1pA60K8PBPdXMrYVmwHVmpEBBxQY4c
	 KfU6EutVgDkiPp04z9vxDGFCPEHDNEWXj1Vk7zL+GIwDt+O7cQ0aeBP93qxOskawARumJ
	 eXo6qr2Rq8eCJo5PdBIGQNdu/6zbB+RDajNI29yenyStnAFfDDSwUQ6AWLpQXKgxlgzbV
	 Wd0IzZ7QioEBagVh3jbR3/o+USpGLa8KhtynuWlDQ4WKVCWW7b4AGxcZTgdaMGJuySw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBeRVNZt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F238606A31C;
	Thu, 19 Nov 2026 03:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBeRVNZt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E491F000C5;
	Thu, 19 Nov 2026 03:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058515;
	bh=Lz7uyiKZ/YU5GBCEp6gXPWPjgPTmLXJB4nQle8i6rYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBeRVNZttB2v/0y1/Z4NEnoArXElSIz6Kd909ECEyfsblZAVbl0RsiW2fzJnjofKi
	 1TfSuKwGf131d6qFQ3R4SooFcj8MnwXxJqSi4Wh7MbwtxEy7UfqEcw/5nGUbgMImqU
	 DeN+r0g5iPuNnOmm0TXcTZXxiHcPi4L22UxFgdog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0513/1848] lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Wed, 18 Nov 2026 15:42:31 +0100
Message-ID: <20261118145936.187532222@linuxfoundation.org>
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
index abbb6a3d1b5a6..33357e2e35a35 100644
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



