Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056338;
	b=PwbaFcNDA9QOW/EqZ3VJa4M7C7ktyuGXEGIzlTI4ZRV/gRtx42vrrVlcYTD3/3Ze4dni
	 j2etNk9f20O+xN4Ef5VaxjfuNNDwo1+QhdR+GDOcOs2D72feMkbW1D6lo4j7XAd+xvE+u
	 V38PXfZ+4WvuPYaGWd1G0LEvu7wPgM07IERqKW4YmA1RlZdYZoCBx2I77y9I8rBynrBaK
	 T7irmwIQUU5TahlZtVhwC/OlvyFhvN/JS6TzC/xjW+/8XpFSxj1O7XKHuZVavXe5dBaMI
	 Liww5PuuCYx8WujVaLqvAz2K/aJF7fbEIR5loE1AUn5rOdvBsuUj3RbVl0zYNPuJtmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3BOnDBugIqn8oU8RO1m5X0JeZ9f63BvUXasOBWoBiA=;
	b=vDPvFlzMCU3NxhYbxGrgHvLtsmFY9eTtcqkiymthbaD4lgDIQTwGICvOK8U/V9EFC+CY
	 bQk9b/8W5s5WuCG+YO0WXl07CyDahL4LSaRHxSbxm6E6BQv5UQlAOMD9UqEKVNtWCS+Tx
	 8Uk0PpnhKUb5Kz0LL4e2uf4YN8EUxdL1a82VMFeAT49Xzjp86BHNtN2D08v/qOCsg5VL/
	 BYTNl5PRyMSg7DDR/MiGMfh+DKSLX38xIFMfm4JnkQYrcA3hU5ULI26QAY0HHyyQLB+3J
	 LBxiE4KQiLhBHkF6kNYW+PdYHNtVt7QyjkAX4jhEFYBO2uMo4Q+OXenUuodQkObwbYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iiXXsyvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253FB606A31C;
	Thu, 19 Nov 2026 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iiXXsyvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7F41F000C4;
	Thu, 19 Nov 2026 02:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056338;
	bh=O3BOnDBugIqn8oU8RO1m5X0JeZ9f63BvUXasOBWoBiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iiXXsyvBhD/EtGpvImhGKJpAhuYj+uewqKNKjaXNBkiaUr3WKesHar/vAZg3EdGqU
	 nC8G0Zvr+O5ULys3LNdM3JRxf7wCpvKR3lm+7pKD01vUzXvlnrUnUxVDZxg74tsIsL
	 /8IbQM316pF6XzCPzYh+mtPWjblH1F2l2wBJhLXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	VEGA <vega@nebusec.ai>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1899/2214] lib: validate in-memory LZ4 chunk length
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150127.123741895@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 138a84817df01eda67bb23032ab49c23fe2ffc16 ]

We found and validated an issue in lib/decompress_unlz4.c.  The bug is
reachable by a root user through kexec_file_load() with a crafted external
initrd.

unlz4() reads the compressed chunk length from an in-memory initrd and
passes it to LZ4_decompress_safe().  It only checks the chunk length
against the allocation size when the input is filled by a callback.

Reject an in-memory chunk that extends past the remaining input before
calling the LZ4 decoder.  This prevents malformed initrds from making
the decoder read past the mapped archive.

Link: https://lore.kernel.org/59c6555c27aa7ba18ee227f9f02c78d15a37605f.1789219453.git.zhilinz@nebusec.ai
Fixes: e76e1fdfa8f8 ("lib: add support for LZ4-compressed kernel")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_unlz4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index e6327391b6b66..80bd4ea40f95b 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -139,6 +139,10 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		if (!fill) {
 			inp += 4;
 			size -= 4;
+			if (chunksize > size) {
+				error("data corrupted");
+				goto exit_2;
+			}
 		} else {
 			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
-- 
2.53.0



