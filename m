Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031753;
	b=uaKz3nhKJVHZeoZVL/WxlGVaR/1/1d2owxx1gHVmPM3zWVZDcQLFbVKrxW4Lvo/8bvdi
	 fhaJFc7dJB1b6Y6arPuLviRuFyvnt1hdtiHLkPTI4wy06uvRU09noH6a8qvRh33K/lRCd
	 +KpN4v/qRRVMb5A8tXNbKKE+BAorhw0JXS7wH3Z4D7lX9qFsa8DgdvWeSlgfB+kL0QX5a
	 pGVFnuFtrbk538kF8aJGh18gHaWz6GH498YXtNHPVSjeUv7bb3TRs51oy7JWxSFFHKx0z
	 x8jAUDzwWmQnfmELbiiCE2mEcNEFc/fb+TlIrNBu16U7o/m/8O+H51A3zCJd17o7EiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1T1Q7fzsLc6YGy+VlX7ncATRJG9rkTc9tyYyeO2NBQ=;
	b=ABaJtTBuw3SfBYpJQ97BOhQrxATfEaNP6yNdTxb0xo5Sd7pmMvF+veOdhPstwa+OK1Ki
	 k1oybum8kbMz7G7KMyrh4P2Ns4QIpXuogpy5Lf3I+g9I5aCiSeWIsfoEb2/Ze5yBCKAaU
	 kvH4Et5YZ6cknm04a7xSjlQpJAyj4wD7jTMruNJrkhld+6AFNvK35oOa6/wsxwX6ivIEG
	 DeAdje8plDieBFVT1+Ut0c98RsQe+g0iy8FgZXxb1T/s5UxgWdysYBMZHz0kSuFmAKt66
	 51rUBf+hvK4wkWWaj7Hdz2imiVwZw4/M7ISfiOO4t8YvlShwqCop3Z9Dm5KndUgZF8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLqrDZTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52164606A31C;
	Wed, 18 Nov 2026 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLqrDZTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2601D1F000C4;
	Wed, 18 Nov 2026 19:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031752;
	bh=x1T1Q7fzsLc6YGy+VlX7ncATRJG9rkTc9tyYyeO2NBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLqrDZTUFMLPkLYiwXJKeMauxf4bb0hkGmCxl/pvgouKr9vcBBiKU4IvQLzEAaTlV
	 NTjB1qtsVq5iOKvksaAXpuCSw4/+hKDP5fs81TbgkmuAF2M+SVqU2q+kx+X/cpvciw
	 U36+lkhbzMUwcg3TmLhR1T1o4ASZrPzSt4hu5spE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	VEGA <vega@nebusec.ai>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1169/1756] lib: validate in-memory LZ4 chunk length
Date: Wed, 18 Nov 2026 15:54:56 +0100
Message-ID: <20261118150056.507505935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



