Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025127;
	b=uj7CEUoOZdbCQz5/3Bng+XNR6wVkujdnpQNP+ZiPHVafnTCR68aP/7gQWbuKFZCm1NLZ
	 bwxFR7NwCqh+UI2++xOmR1a9vAz/jV/cue3XDyM9kv41xSyquhNgKFlV6kTPKpGlw+fW5
	 NlebGIEZ+dEzT9wjc7RhjdnUcXXHJpV3AdWY1cuDrJsXtxdr8rlJeuvNjLtjAW/RZz+wh
	 BP/aln4wu9Z/v+TeDEvkKWf0AtPv23n6p/AsFM9riuhIY6agE0B/KBg7l/tZBHK9KtqhV
	 hF8wKOTP2uoiOAAZ1ykigbuPl3RA9N4dyi+yXPDJ9KVuvs0Ti+C47KH1bnFAVLa33hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MxTSIdlck80VXR2/ZP6zMqOgCsOQZ02m4nQbcYRWTU=;
	b=GOuyh8yHqGKthNGSeGbZ3zYVe5wrKlSP4UCoOCyN10dPjhfxkloxIRl7nCJtJK0Lqr6T
	 2jRiN33SYc9GUxl5GstOvR2s23/qsbnU2eb1HOj5wpJcVnoaWVj8iDbyVjyI1aElG0iX0
	 CaPYukrcZ4VXPA0xNqHLTNi3hsMItvmsz4GXlgzE6y4NFBXhhDz/FdGPDDTJGwT0xhZTI
	 ed9Nlkq3mhak07+/yjlvpKlSKoCBE6Z0PqvxkyDXUzVE71f+ix4oZTMqfqW3/bagCFIuF
	 IWlXttg2OJqjjQYTN97r3WAJ5IDyJ74hw41XUYxCGEnqLXTbFvAFzKlQ5kXkZkDmG0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6YKQ0lJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78872606A325;
	Wed, 18 Nov 2026 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6YKQ0lJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7011F000C5;
	Wed, 18 Nov 2026 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025127;
	bh=0MxTSIdlck80VXR2/ZP6zMqOgCsOQZ02m4nQbcYRWTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6YKQ0lJbGf2qmUNgi5Nawt6kMjpBLXfdTLGEhf0PG8UbOQR92qvGyvqev4qXr5JK
	 uVmf9k9C4jN8zWZKAnN60I+7y9uKWe/GUDuzxMWKs8QJ/yQxIj2POkDgpgw8ITdOAe
	 12H3tL28goHxE/Yqeh51Zv/CRo2iQuRBmV2xXxLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0932/2151] misc: nsm: fix CBOR short-length decoding
Date: Wed, 18 Nov 2026 15:44:27 +0100
Message-ID: <20261118150156.441080838@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 6edddc1d101bfd5cafc94ca2dffaf13e4394662d ]

CBOR encodes byte-string lengths from 0 through 23 directly in the
additional-information field. cbor_object_get_array() only handles 23,
so shorter byte strings leave array_len uninitialized. Reserved values
28 through 30 and the unsupported indefinite-length encoding also fall
through without assigning it.

parse_resp_get_random() then uses the indeterminate value for bounds
checking and as the byte count returned to the hwrng core. This can
reject a valid short response or report an incorrect amount of entropy.

Decode the complete inline-length range and reject unsupported values.
Extended definite-length encodings retain their existing behavior, and
the existing size and INT_MAX checks continue to bound the returned
slice.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: b9873755a6c8 ("misc: Add Nitro Secure Module driver")
Assisted-by: unnamed:claude-opus-4.8 typestate
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260815151745.3758574-1-ruoyuw560@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/nsm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/nsm.c b/drivers/misc/nsm.c
index ba43946b9e39a..d303f48af2bdb 100644
--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -117,7 +117,7 @@ static int cbor_object_get_array(u8 *cbor_object, size_t cbor_object_size, u8 **
 	array_len_p = &cbor_object[1];
 
 	switch (cbor_short_size) {
-	case CBOR_SHORT_SIZE_MAX_VALUE: /* short encoding */
+	case 0 ... CBOR_SHORT_SIZE_MAX_VALUE: /* short encoding */
 		array_len = cbor_short_size;
 		break;
 	case CBOR_LONG_SIZE_U8:
@@ -132,6 +132,8 @@ static int cbor_object_get_array(u8 *cbor_object, size_t cbor_object_size, u8 **
 	case CBOR_LONG_SIZE_U64:
 		array_len = be64_to_cpup((__be64 *)array_len_p);
 		break;
+	default:
+		return -EFAULT;
 	}
 
 	if (cbor_object_size < array_offset)
-- 
2.53.0



