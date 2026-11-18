Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061621;
	b=E/q6TjRnDy0aJvJyACDei3osyUzwM6zOkKGh76askHgVpW9zSvd3x4XFil4kxDKIhkts
	 f5a6B0mUPjPFY7I+llt0OTgINzkOybsG+YTuZsMKEz4gekEUFc2HoEBmvrtUQaG+9tVPz
	 E0ujJBRVjWnq7wVUV1VzfajtdFYQt2RpC3ZupP93iJh83Haskh/MK9XdTCGfIilm7J0hH
	 Q9sm8C1/AfoCZAWzK/Ac3RpsYOyQH13TW9OD4aqXKEKFMM3rw2V1fTGAhdUUYi8Okq8XW
	 bH/UcM1biajpg6iFxetfAWxMFdrVWdwfwRd5opNRQGwChC+ffVVJQvl21xTk8Wn8oMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9bXr5ILLDFfuA23Rrp/ZdbuGfbQgWHTXA5RGvrVtMU=;
	b=D5d2p9qYCHOa0XokMTNOgjgygtHwbGfBCbEw5bgy6OXXMWJOnkc8ODTCD/zY1NCXgVZI
	 ab9gNtoOrsC+IwpjxEqKnLlZLZzS8ZyjrIQ8bLcmrzJ4Gih4t9keSMHt6Sk2F1rAZl+uj
	 YkPZCx7kPlpPczyHbErgxqQbIJtqjtRwI6HSGO7iHYNNUKNPvp8yxiJGnsw4860p3f8tt
	 r+Lwxo9nX5GHdnnMLhwx7VkTpkkrFYfFkBdwaDC/bi+da89EtAnlPbFU1p9QjNgbG2eBq
	 MM4XXW8oe3VsfSWh9pWj2PtuZl5MlQNTqqTzvoujKBsvRSUJXW5Zrmt4ydG7TXX6cMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=up58ubHj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136D9606A336;
	Thu, 19 Nov 2026 04:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=up58ubHj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3361F000C4;
	Thu, 19 Nov 2026 04:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061620;
	bh=D9bXr5ILLDFfuA23Rrp/ZdbuGfbQgWHTXA5RGvrVtMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=up58ubHju2ckVUb4cS/usq/3cr5iD2FanuBH/ajfriTY/rgUIF+Ig47q1Zrt2ZMvn
	 SF7ooXpgK9pq4f8rtmTjs2ZD+19+gYhJKfeTGe1AwsYzsp0neck0HGzL20sfjmrM/k
	 nDfNKM5r91eU3n3zJiW6B8nnWBHoFGzdfy9VN2f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	VEGA <vega@nebusec.ai>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1618/1848] lib: validate in-memory LZ4 chunk length
Date: Wed, 18 Nov 2026 16:00:56 +0100
Message-ID: <20261118150027.253828372@linuxfoundation.org>
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



