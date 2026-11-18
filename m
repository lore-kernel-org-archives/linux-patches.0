Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026662;
	b=dH7W7iHUvrRIUAvqQfrl60MlA6elVKng7qlgY40mS8B9ObSmUYVM/qrYGcv9dklgxKPX
	 hUXhR+AJdFnPrkwbbMBkz6vsTkUxO3gNZSPbxcSWQOdSaQMrUC5nuILmv84Xm4jl+/wWa
	 ucqBbAOW3Q12T+3r5wBP5i03a1xcyRiI+7DBE5xy657zFpqAoHsK1KqiGebF6Qa1u5gHM
	 EnuJiXnEyJDfjK5TjzfnSiICSjrBMm2Qy09Ca+OkAbGfbVWvtR8jZT4lj3CKHrL7IM4gv
	 9cTsIRawd4ZSSIRGut7PNA18Sqr+tWGVLA/mpYh33c7I4n3OvPdZABH+tDQKFfsroWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=23BG8hDUlmg4jV59zY8Xk4XhvN9jqF+miwKxkUXAdL8=;
	b=by36ycRljMTkhgT2+6fJ8E9H8a+HCT4Mv20571Z099/xNpVj0c4Oq9JVWV0WTL9QmHoN
	 ch4apIYKmXaYCEllUb00rl/xwIJvC4av4Fx0361YFGkxSiJ1on67dCGhz0bZRr0SKRlfs
	 meuRLZCi4FvnWgB1fQpeloS494cG0ZR4RhCPVmPpTNZQ+YTdlrliw31og8uS8cuwNDFgP
	 Dp5InXAVBzznRE0Li6qBIBBe3SXr63BghcPQ7L97SNEAi1IULrdwzIP+tVhbpyYoqve3E
	 SiXUVPkHo2ioXKd8tc0ftCW4fUb7Hh47tQ2RMLhzFfJcv7SigrzZF6gl7/VZgS2gUFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J23sNGo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36450606A31C;
	Wed, 18 Nov 2026 18:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J23sNGo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36951F000C4;
	Wed, 18 Nov 2026 18:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026662;
	bh=23BG8hDUlmg4jV59zY8Xk4XhvN9jqF+miwKxkUXAdL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J23sNGo0gy83tOu3TCCSmGTiaNqax+g7dLTZI/YjX1Ti2xDkb8oGyQz3OE/xbONLA
	 8YJw6McRiqZ74EW9TrWQ4m2jrWFJm63J+qFfcXnVu3hiAy6ySHUSK4nVt0jreI3nBp
	 X9gg6o4aq/DfZI1zqNa8yqlh/0rJX5Pw8x2OnCHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	VEGA <vega@nebusec.ai>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1472/2151] lib: validate in-memory LZ4 chunk length
Date: Wed, 18 Nov 2026 15:53:27 +0100
Message-ID: <20261118150215.510654021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c0dbb3cea915e..86e9aaec04f6d 100644
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



