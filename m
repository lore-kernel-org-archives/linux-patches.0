Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064493;
	b=wZbS3aeEXe4CQ4U6CxVUnfb/+0Sh9zg/Vf7SuTcqSYSjOADy6VfJp0iEv1CSS8czCAgv
	 5GCixlcTBCkP6s1sx3BgKFJZ643AmjdEiCi1W145ouomF1XqD/UlJuEyA/Ts46ppqWXH1
	 EV0IgvBZKBUdONTfNWYyid7UO6fqeRDtkEhrYDeLYH7faDzRt3SOsORzZ3u6ACnpV+oST
	 TLEMCvSfgBVNyJ6WB69LmMv/Zi4vS7sAGfGjYOo9mbqgs3aLpFkiBeMJNHG0T/8ZVXZS1
	 9lRL/EdC0kAtNjStiTVp5MGVFuOQHl/PF1lcnip6vrbcnVGAU3f3Z6PNUNlDboZgCvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8VoZvj4Dr3N6Yj8cH8df4UYWmfLFh6NBJDszl6Td8M0=;
	b=bxp2OXpVjj5kZd2AahL9lClxmmbiBJpqAxFCNn479eqyPK0W95Q5n9+Zsq5HA9GJjUpf
	 YriPdjo2MbWe5MU281/4TudNOcOhcLbfUnkgbXmsgFWeKevWa1/AKyzFtC+Hj40q1AxUv
	 WVKffGoRBRUzxMA1ckXM3WjuiqZWk/XOStfAz4LzQDO6TffbbHBV4KOAfBBHoGRSv7BtO
	 aL6SfKwxQSckPoX3Wg+Uf7n4n7N+AoK6xIyt84y1emBhGh0NYHVT59IrWd3PNyTnpmici
	 7Sxg/WbR7bJutrcpHxx7OAuZvvgR2eCHrJnne2q+m2HSMpLSLKCceKTPPighqFLjXkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQWbvNms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5C5606A9EE;
	Sat,  7 Nov 2026 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQWbvNms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8705C1F008A2;
	Sat,  7 Nov 2026 15:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064492;
	bh=8VoZvj4Dr3N6Yj8cH8df4UYWmfLFh6NBJDszl6Td8M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQWbvNmsq2d/u2eSm+Z5R+rdmzl49pIEF+OIke3Zan8uur8P+Jhi3fxa5x5Ofjss+
	 6PTcds8obNG32my6xBK2sLWX6wyQrRm6WVvPKXy+qjjwhW/3EA7GF5VoLQ6ltdNqSa
	 WCkElI7ET6Fib+h614RUv7X6+tO+Po7UpkvxtuoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0528/1257] xor: add missing vzeroupper to AVX code
Date: Sat,  7 Nov 2026 08:47:04 -0500
Message-ID: <20261107134953.995725252@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 7b8fc26c40d6cf4c6751a045c9e42bbb7e78d81b ]

Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212248.213805-1-ebiggers@kernel.org
Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid/xor/x86/xor-avx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/raid/xor/x86/xor-avx.c b/lib/raid/xor/x86/xor-avx.c
index f7777d7aa269b..95b21e7225e8d 100644
--- a/lib/raid/xor/x86/xor-avx.c
+++ b/lib/raid/xor/x86/xor-avx.c
@@ -147,6 +147,7 @@ static void xor_gen_avx(void *dest, void **srcs, unsigned int src_cnt,
 {
 	kernel_fpu_begin();
 	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0



