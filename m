Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052772;
	b=cVpKmOip6L2h5sQDPkdqwQc2mjxmA4mJkPgGqRFQgWmLROGxFbfGMbqQ940npiBzP2ly
	 ZbLRehr0sQ2yVA9HIPJ7UfYhCoGX78udwie4w892thHEHn4fRSBB7m2+NeCQPZ3k39+G/
	 j+bOz4gM3PopT7w93Wo1XPONIZ1yDWR/Am5njM9dH1FryvDiJjsfpCnNyNBiE5LvU1Rrn
	 qYoJT+SWF6lO1xKJA0kqGl/g+LyJamzO+iuAcQsa3zBhQ8NjZ6Xj9e4yuOsUG4JEqv0tU
	 qh6hZhNtblWlGOXj4dXDwmOrRdtydFvPPNxK/v8IBxBjdVft65EIntQSLh3A0XCf4UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AsGDFVAOFwQj+Cd9Idazl7Nxv727/igo344xHvw0Te8=;
	b=Ep8dmgIOR4SVlY/joVMg1nVgVLkhSstuU0ju2V/cx/DujOCFK1qETdkNHjOIYOV4bFdC
	 cD5P6q2imvpmXSjyqFYXk7StlEpPzslBykEWpFuJrFyjzhtqq0koQNUL98q3pRTokcRQM
	 303XQX9pLNrrMbrEHgaKifhjoTw0SQckT0IIgy+XZFk158HYo0CLlNzbPwSi1uAJcm68R
	 eXnUlqS/iOP3s3pzPbCxVOjEYhn1o9GPAnXVpC4r8MAsgZBY3PtjHqiimyOC9osk6sGG/
	 W4HeKwBzvlSzMIozdLkHCzUq3N3LCgDLDLCPJGJ4i/2ew0owcnWFbUZBY+TxM/M4vQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iECpX51f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5F6606A325;
	Thu, 19 Nov 2026 01:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iECpX51f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9A31F000C4;
	Thu, 19 Nov 2026 01:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052772;
	bh=AsGDFVAOFwQj+Cd9Idazl7Nxv727/igo344xHvw0Te8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iECpX51feYvSH28VtrcFDW8IZX7LxCcK8s1nA95dGlh//+koSZHZ+5sv7+VwF7Hoe
	 1Rfdyusd31E8nrtm5Bmzv93Ykq2VM1WveZ3A35jh1H+j5XCnMwU2m9YckSRJIxmp/i
	 pO21XhkMV4LYEBfdDYLEymydHzXpNN0h+j4qTkTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0634/2214] lib/decompress_bunzip2: fix off-by-one in run-length bounds check
Date: Wed, 18 Nov 2026 15:38:30 +0100
Message-ID: <20261118150036.708619650@linuxfoundation.org>
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



