Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052218;
	b=G87HPWqO7D6Z4wwLG6+VBGQzU1Uoy2i4/yNROC8KXCcRqscga2IL4yqFpf+RZG5G1G72
	 FGQ8EMOPJM4dON9Wjddtpw7Wx5DbdTcqgBIfYFjYhdQyjgEAMpzF3+m/0isyZWsmFMFZ9
	 aiixJe6AuPxCGAK8srWc1HIKtHYm9WaDiRz7F193gSaopcqSP7PJw+tt4+Fn4BwN7/1sD
	 uwByOsQF6zZ0+Q0UuGqj4IGAFvidOdiDFEuGfSkRMDm4xm/JCss1xZMdmJUFQMNmVixKH
	 iIRVBzL+1TAgO3XSH+fAzBfU2wJhBCMKaX2Gp70JEtxExiAjdB8JJPZISqn4/jL4i9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HuJ4gpqZrncpi9KIn+25Tpcy0Cl3UMBak7jabX6vqCE=;
	b=25+XgHIcI5WF1sh+65fAh+kB70L18F6hRSao+rHP6VCydzuwu9XJKJV3nGqlgiNs1lgE
	 zYOTAREcQDOY8t0UT4XPHFF+KR5piUi7awkfmE+867rCge1ZX3/sJvkGJ7XNWDtrSDjFG
	 2/ElIkqH/qoDAkH2VgkBSXBjzknvziQst3kfj5fiTtw3TZaarvqNHabz79xgckTVZTWeU
	 tlmaePpce9R90B3/e6S2Hnqk0NhVrvZis1upt8h0Q/0HapV0JW0cINWNbW6r8RXpU+FMs
	 bBpR2Fek1UsdB3DLokFTiWhHm+QnxGWzC4h3HW5A1QVT2+NLU6dZpp/+iSj3I1R/DUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL6cZqUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE05606A320;
	Thu, 19 Nov 2026 01:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL6cZqUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1D31F000C4;
	Thu, 19 Nov 2026 01:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052218;
	bh=HuJ4gpqZrncpi9KIn+25Tpcy0Cl3UMBak7jabX6vqCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL6cZqUEX+GzYK+czS+pgWLw5NFqR+NR/cDSzNoSrNmYFq/IhDik1ikIsJM9PD2Yz
	 FeeKZyH9ticWQAMaKAU9/teE7NU7kvsieY93cCFLezY80x8+Ifs9dNSXFYBxD2xkwr
	 2RzkuK3HVL32Cea0JS1fgjA9h7lQgq5c55HgvA74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0486/2214] lib/842: require a complete history block for repeat templates
Date: Wed, 18 Nov 2026 15:36:02 +0100
Message-ID: <20261118150030.646432809@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit deb631649882bbf43f7c2fc79b5990139fd744ba ]

An 842 repeat template copies the preceding eight-byte output block. The
decoder rejects a repeat only when no output has been produced. A
short-data operation can produce between one and seven bytes before a
repeat.

Such a stream makes the repeat copy read before the start of the output
buffer. Depending on the surrounding mapping, this can fault or bring
preceding memory into the decompressed data.

This is also reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
to a short-data-then-repeat stream made a KASAN kernel report a
vmalloc-out-of-bounds read when zram read the page back.

Require at least one complete output block before accepting a repeat.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/842/842_decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 87d1e0f8a4926..45a9815abd637 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -309,7 +309,7 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 			if (ret)
 				return ret;
 
-			if (p.out == out) /* no previous bytes */
+			if (p.out - p.ostart < 8) /* no complete previous block */
 				return -EINVAL;
 
 			/* copy rep + 1 */
-- 
2.53.0



