Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058175;
	b=CGxLvX7gl8NnoADQwOwy5iZvIrQ+DBuWxd39FG95Kvb6yJplf09pC/rI5jIF9A/GieFG
	 nCZ2yLldOoOBGftgz5tjml5Rlf0qxgU/IPlmrros/8Rnsgn646aNP4Xvh7afC55e49GaV
	 9PlU3P5bcFcz3ek4Idfu+y+8cv8gncOsQEoQtk13tzMVKcb+IJF3tXpb1pxybRBYta1SQ
	 tPMiEAtNhJNgYPXKpxJhCqFC5Q1dm8RtxxqW1/n7vIigd4GJhL0Vh3bTEsJXgtRAfZ9rF
	 gB52y4yWqwyly01M03R0YHBbB85+rUC6PBbbQT6+1X8zmGdf8KrBtGEavz5XmAjVHHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bAyMc6Z/m3I9O46U3Uy0AT2JIWme1/HPwDLQp65VAUI=;
	b=J7jKw77H9kVSy+JjexAYWDf1IzhJV8h6Hruff2U8lxosXxlj3KpbtxL4JFqksefj6rdx
	 3+h6DWGcEJm3ucgpTuTUUJIBnk56LSctT8fJVzAdIuRKO5DRnAWHzUiW/8s2grO43t0AN
	 gw9KA+rhgPCfIWy2GnojxLhFW8BE6ZR2Dio6Q942S/BPhCAuD2rjxLnozVgAlLNQuIK6w
	 nFhnPFD6r4PV8rf796rl2lKAv8JdW6nd6Em/5fQKjL9TYbgzVvRCeFVxXpx7RCffEfG6E
	 HVj16aFOIq5/1obRI/Jz3VPDEigFo2uKLUq6F6vlv/lGBT+wkNNT3j6AZcfM53rCpiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdsmrab6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B12606A31C;
	Thu, 19 Nov 2026 03:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdsmrab6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DCD1F000C4;
	Thu, 19 Nov 2026 03:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058175;
	bh=bAyMc6Z/m3I9O46U3Uy0AT2JIWme1/HPwDLQp65VAUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdsmrab67Uss9FtP/Jwu9GHJiDnS6uW9JLCKDhbjneHqtbLTrWbLhqIctUmesDtV/
	 w9pDLccm8rW+RABxhNY2BHyApgqbKPd5FjFI3RjGonT3TA3MOeNwFmMPmFKk9V/sBA
	 sfISfZSouzbsRTYpu8Wybn+4BGSFJHsBMzLlq90A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0390/1848] lib/842: reject output overflows from index and short data
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118145930.025863018@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 38ed7182f3491ec1449ff246551e11ad82adba45 ]

The output length passed to sw842_decompress() is the caller's buffer
capacity. Indexed copies write 2, 4 or 8 bytes and short-data templates
write up to 7, but neither checks that capacity before writing and
decrementing p->olen.

Overwriting an undersized destination then underflows p->olen, which is
unsigned, so every later bounds check in the stream passes. Subsequent
operations keep writing past the destination, and a matching CRC lets
sw842_decompress() return success with an output length larger than the
capacity the caller supplied.

This is reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
made a KASAN kernel report vmalloc-out-of-bounds writes in __do_index() and
sw842_decompress() when zram read the page back.

Check the remaining output before both operations and return -ENOSPC,
matching the other output-producing templates.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/842/842_decompress.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 582085ef8b49c..87d1e0f8a4926 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -165,6 +165,9 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
 	u64 index, offset, total = round_down(p->out - p->ostart, 8);
 	int ret;
 
+	if (size > p->olen)
+		return -ENOSPC;
+
 	ret = next_bits(p, &index, bits);
 	if (ret)
 		return ret;
@@ -344,6 +347,8 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 
 			if (!bytes || bytes > SHORT_DATA_BITS_MAX)
 				return -EINVAL;
+			if (bytes > p.olen)
+				return -ENOSPC;
 
 			while (bytes-- > 0) {
 				ret = next_bits(&p, &tmp, 8);
-- 
2.53.0



