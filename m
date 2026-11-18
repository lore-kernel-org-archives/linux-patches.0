Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035904;
	b=T3+mQmiiHzZU/wNyw/DbTqf5RotdOZtl1POEYhaH2oZOTiG2peQMLFIMW3DVnYlmljz3
	 nTNzqRaRpEjyCG49+ff2cUJelzmTRPvbKSU5qTTWbj3dRb+VKfsXvCeMj59ZytX/XzJ7s
	 hHJsqsBH/WOpnwt6Im9mmbEbJC0FA9Ibege0hBvitvpBBdkpHyazgJyVxWhFp/dqIKlPR
	 wBx7SArZGRhooX/MFfI80TMWzaJH/dvyVeyJhSJZxDofTqFpIFF6peC7Ye71/u2vrMWi9
	 DBfxjww9mlIAvxuKAJsIUPCxXmFYgnLFJczRYFM/NzVq2tijPCeDNEBTzluaF9Ydeyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ootabSpGYgL9r+mRMqb2K3YlrG76k7/puQmYn2pyrB0=;
	b=kcLbXQ4H3kot3WCZsBEq2FuaXiTcJPyRWKbPbm/N/SKV95/D4/YNqnh7ggliEU0v12/a
	 ZrxIZ/5+HQ4sGQFToAgXLcYI80ERGMAmewnh+1R63IgparKfSG6lOP+lxpXA5F91DTZ+U
	 VNgwZb6BcbkVls6K6KG/E8yVKDBSzxErd2PM0N2sHXPlAJbFzVm3gJRN7bkHYCfIcHZi2
	 IbtImFhp0o074vVtLPCZP9QPbvuP/UG+gzSNWG7/dqruzjhRZjpH1WmP9wFr9r3ZMXQmN
	 EfYQeAzThJncMY0LUUYwULzeKOu8npcGx+sPu8IFYmHMdGltiZNDoLTzxrc3m9MhB3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UW1RSYcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D57606CB54;
	Wed, 18 Nov 2026 21:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UW1RSYcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B803B1F000C4;
	Wed, 18 Nov 2026 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035904;
	bh=ootabSpGYgL9r+mRMqb2K3YlrG76k7/puQmYn2pyrB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UW1RSYcLxssklHac0ntwNLN03H9Sattt9huSqNu+QcaGgC1eHzKkxRdz3j2aQZ9sU
	 avT1Wrn6g4Yus/bMx9Bn/clM7r9YQ7c8wa35BfRH3wHzs/ZhNPIRo26M1rcidz9yzE
	 0BINcvKgaJjGG3E4AaO2FF3H+dYrL5YAQ9E2Oakg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0868/3318] lib/842: reject output overflows from index and short data
Date: Wed, 18 Nov 2026 15:24:50 +0100
Message-ID: <20261118150345.342232960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



