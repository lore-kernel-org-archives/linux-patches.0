Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035907;
	b=grguXKmgLOTe7NN6A6HqmnAqtwzaRjVYYqIoN9Cfi9E4yIOqacZsdLT4tT788eyVQA3D
	 CHRQk1pOzCyznIs0APfGUexmCkWtHXKfVkxvh/8cVRVri/tncXPUnyCm8qrevsAPdZsw0
	 wc6dZ77VDcx8k9gyld7ody8UHGLpj7+QEM5/vDglcwR7lFaMWAoSN7LCMkHAy76/vjt/W
	 31ms8iT1CckmhGCMLBbIHE1OJTTcYE1NSwJG+9AGfkTVmWX4Bo0HNsD/5TYZaQC2+8Cbq
	 fZGlges1clwSqlQmGHPQcUUhWgD92h31DYPFEbdOP6aPXlWHMBlVU0YQ9MSGa0ThgEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s6MQoj0ThX4U3pz/Eb4HLKqdYxckfbEXwoFAnUgs/fA=;
	b=5Z0is+Q6Yb0dBhc078wfXsnAe58aWUYVk5rPQjWDp37EKT1QQm0mSr1Hu862XcZL47TJ
	 a3VCOUZFbjhYCLM5XYO6W+1dxlFBMr2jjAgQuzbayuZTwOSsqlNM+CiSIOtGQW45v9I3K
	 SjK1aN4B5IJNa+kjTFPRcCujjWRISF9ry+e3+WwfurxPE0JSlD4vcFm5VY17fIAXG56j3
	 FI6P+54G+UfMXVGmC8EoQQSAN8z2BtRBuiXzTHNFSKu17gX41/BHoS0CqdROHnXYzny7x
	 XpOZzyT08JycmkLlByslBfZ9lN/A+B/pW5Vtzg4+Mmaov3xbVBNYIOqxkm1fz9fF+iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt7gEANr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3096F606A33A;
	Wed, 18 Nov 2026 21:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt7gEANr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AC91F000C5;
	Wed, 18 Nov 2026 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035907;
	bh=s6MQoj0ThX4U3pz/Eb4HLKqdYxckfbEXwoFAnUgs/fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt7gEANrsJM4m5U1dLGNE42xnOoTQLD7SJiqolQftmuDhTAFcQw7xoYAghljqtAG8
	 RqM3cCNJheuTnCEXXHO60bfBSPzgkmEF1azNW2D8escG/MqZUZglLn9s/lXXxd9TJz
	 u4pWtXFEiE07yMk2spntmfKmHgT5TOXD3F/nqKW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0869/3318] lib/842: require a complete history block for repeat templates
Date: Wed, 18 Nov 2026 15:24:51 +0100
Message-ID: <20261118150345.372077276@linuxfoundation.org>
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



