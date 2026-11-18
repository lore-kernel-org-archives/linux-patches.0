Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044996;
	b=32jCTMS2Kjv77iMp3MhuzeAgC69vSY5G8giXomkzcGJkN+HmQ8jppHTrCIb40pflp1VT
	 Ql6iJc0X1RjGgsDgMw3JGsJoP+UTjYuMKhES2UWP1L2FPu/JS/NP86TdEoVX3rHy39AYy
	 vB0Q0eFSUOZUkmW+sfzKWgGXFFGwqtA38S3rNCF+eRinGpWtWdY6A7sn876r8d1FCmpqJ
	 f5R9B2Z5iIcWwN6dWa7xL49xqDFRlGaeQ+Xe8g6ufiEFUhvkvVegVrcw2nfYUCL3kmcOH
	 hN2Jl2KHaMKmMO9BUDPEiSOCjZRWRemB7GP4a5UoRcChmYujZpIrXc1YCHuEWUlKD3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NEajxrvHpWQd/BUxfSqpn0SdimDJ2ugGSlD/xL3qKCE=;
	b=xUDveAU+B1lV1zxFsOkdqWS11fZfaXkNGLNSxCq1stAH9y23dcFPnDMbPLt8igHZ9UoR
	 81MjgDhq0mJG28EQKULJ6YoZzNWqaPcXp/idSLe/zP9GQ+tPfReJsLczagdGOdz/bao9l
	 +RIhJCUtu+UrHZ8QdjxUnXQ4N1YeP9aGaRrs6yhAQaqGpqUleVttpn393QNdkZ+WSm1Da
	 cXxb3JtMEnEuuabeVqkhOWZPN7LecSlNX1+1jwppX2VGZN9SV3coVkUAaprXkwii8B4NM
	 8xm28KFyRpxyaNNDvMnBgJ/g10ur0NGW0+aCKjodeFw0hdeGCIlciyCTkLD7+oM2ksg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqYp4IKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521D1606A332;
	Wed, 18 Nov 2026 23:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqYp4IKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C741F000C4;
	Wed, 18 Nov 2026 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044996;
	bh=NEajxrvHpWQd/BUxfSqpn0SdimDJ2ugGSlD/xL3qKCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqYp4IKSTaUR3nz3kRazfKObKBjl0nRro4xNxCXnanukkFaw2xx+NylDSx53F8pxZ
	 LF+CUORl46Ndpmd7bDxDbiG5ofpvCLK13Pa2F2yvDprx+1expbpi22lbeqyn22JTKk
	 bQlfoEZ0JNJk/T/RL2YoK/sttlq8NlBVhi8zd7i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0765/2857] lib/842: require a complete history block for repeat templates
Date: Wed, 18 Nov 2026 15:29:59 +0100
Message-ID: <20261118150229.105243843@linuxfoundation.org>
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



