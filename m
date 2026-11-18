Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045602;
	b=PRty2MSZlZexiEsp6JPrlR+LmkKOh7besZH0RqCOAqHun9tF1Q1dOVCMcIRfKep9ABvu
	 Xuqp+03foXhJh2JrkuYRiEMEYL9KHzdNKWJf7XNLu7H33xv8YT2NLZf6CSDSYqhar3FRO
	 hj6XWm54ae6XbG6FEfKAoxwEIcc4KLZNzGojhGQ8gipVFumqG67GsE6sEdnxGrW6i3qWv
	 jLz3HFMeoct/vyG3mgRFK+e5Brtl7vi1J4WrqvhVPHEwlGNYAvbdLFSXbB5o5bIx4Y0r6
	 0fkk4XUiVEUPU+XrH5bI0tJ3LBes8Fp7sxETX4JgTLAOuDLtX6x4UYg8R41Zipxtmkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Numm7qwWXXCGFCqYJkp/pt0h0M+EGV3VxQw29LNs8jA=;
	b=w6kw8l2xcwExIVMVVqkXaGw/GIAmbm5eVw5xyW8Ig0SDa8B66UZsw64y/r/kgZTwEcuA
	 WJuW5z7B2aLQF5dFCJsfm4vpAxKffTXTIo0XAW2qEvVlcBejE+IzfWTxar59zg1H4gOg2
	 1GPLwk9cI/OiNvaJArkV1XyM8NFsMlr3zE7e47BW64g093v/kTp0XEHwzeObCcLCir3T0
	 OUt3339Vp2DCDQQfAJxJkqMYfIpMDmCNWMDT4vl0FSIR3slYF6xDaWF+k2uQwaNIpyPiv
	 KZZ1adCoo7Za6ar1XymjI4S0TQJMJSNsj83+SlB/wkCMIU7xFd6iZSNHMZDuVqUQTOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpOG9bRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9829F606A31C;
	Wed, 18 Nov 2026 23:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpOG9bRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A9D1F000C4;
	Wed, 18 Nov 2026 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045602;
	bh=Numm7qwWXXCGFCqYJkp/pt0h0M+EGV3VxQw29LNs8jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpOG9bRjxwReFUKP3/Yk/eb79phm1lVgvmnYfbVCwehT+KD5xgdduN7MdeWlwnF17
	 +1RAGGFmy73XaGadMbchbiOguyESn6Cn2LcOzOou6ff1XPpTK9ALAGvWwUpmnKrvos
	 LuWFvOKoqi06LDh4iycP2Urk+ipf1wPAPsLIup3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0945/2857] lib/decompress_bunzip2: fix off-by-one in run-length bounds check
Date: Wed, 18 Nov 2026 15:32:59 +0100
Message-ID: <20261118150235.634021179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 69919be2b93ef3922f646729ff42b4bd9a30846b ]

The run-length path rejects a block when dbufCount+t equals dbufSize, but
the loop that follows writes exactly t bytes starting at dbufCount, so a
block that fills the buffer exactly is legal.  bzip2 allows it too: its
decompressor bounds a block at 100000 * blockSize100k and checks that
limit per byte appended.  Use > instead of >=.

bzip2's encoder stops filling a block 19 bytes early, so nothing it
produces ever reaches the limit and the bug stays hidden.  Compressors
that use the full block size do reach it: an lbzip2 -9 image whose block
ends on a run fails to decode, and a self-extracting kernel built that way
does not boot.

This code came from busybox, which fixed the same line in 2013 in commit
932e233a491b ("bunzip2: fix off-by-one check").

I ran into this because my system uses lbzip2 as /bin/bzip2 -- a common
thing on Gentoo I believe.  As far as I can tell, anyone using lbzip2
as their system bzip2 would run into this and it's only because it's
very uncommon these days to compress a kernel with bzip2 that no one
has noticed.  I only noticed because I was adding support for various
compression formats on alpha.

Link: https://lore.kernel.org/20260912-b4-bunzip2-blocksize-fix-v1-1-c7384bbfc954@gmail.com
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_bunzip2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index ca736166f1000..4f98cdea7e0b3 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -439,7 +439,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 		   array.) */
 		if (runPos) {
 			runPos = 0;
-			if (dbufCount+t >= dbufSize)
+			if (dbufCount+t > dbufSize)
 				return RETVAL_DATA_ERROR;
 
 			uc = symToByte[mtfSymbol[0]];
-- 
2.53.0



