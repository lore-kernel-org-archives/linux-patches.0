Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058178;
	b=CpfcpS55VMebE9Nqm4CvOeIVfYtR+3H+EJoTY2gHXtLfk1SMiDPQQtnisuepCyuE+GIY
	 BV91cG2fHXPV3HnkPS7hA+GW+jt6q47Q2aWWGBExZ4RQYUy3gy1NKY/G3EQhvzQmORJWq
	 DblUL0L9RvclGy5p4QYvTVvhvA43hSAZNsg/2qVb+HTna3+aB6RYXPGd8enpSUq/n6sR6
	 wmzx7NhQ3deHaBKkngyDnLRmzHr3jCbTSDt8dQdBpCEojw/UZyRUKUty7S3OM6uHLlgOr
	 RsHsbbvnX536RjMu+IriGNE7AP2r90LKMJMUZ43f3xafVbOTkBkS5GKUzJOOFi2b2fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jeMnguxTuCB2ti2Uenfk7umlAHiZnoAX433RNQB7cI0=;
	b=G6kn7zLcXTYG65Q6v5YGwe+GEFewpvUf96zA50sv7WLDRJNH7YGM9PLKA0k2tBFf1y0V
	 DW4n/o2hP/tL4Y2jNhEm55XtC4nU7zUqvzLskVv+lHg8I85EuyMGCvTeIqIoN3pdXhPpC
	 mZ8f/PCX9L8LTvC77wjX00G8bvAH+hEs5Qey3XjGqt2UkykR82IEQDtLdjhBicYXvfXnM
	 4CKJSeCPvBy9gtWid0gjUCNeOkXX80EOk0iCdtKdhkSWVnAyxB96v2CYq++yA+58EWMvj
	 /VQTcudR+9hzIYzS1XEkeg7sZ/vvI6XR5WoS2dP5Zub/ASZOo7Iiov4g6r72oYop4nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqJvJ6B3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BEA606A31C;
	Thu, 19 Nov 2026 03:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqJvJ6B3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4631F000C4;
	Thu, 19 Nov 2026 03:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058177;
	bh=jeMnguxTuCB2ti2Uenfk7umlAHiZnoAX433RNQB7cI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqJvJ6B3I9oQG4fQhatXtgWTb9VI/YHsG2qf+K8jqsQPlS2goYkV+GXysR3rN8Efe
	 uJan/5ZG+cWYp3pp+2wwkrsE2nD8Y0xqiduFXcppsJkrGc3Q8ISfLcponoa0rgzkzE
	 pV44NWzsszes8PUZ/5QRA54uF89D74p1J37WmFsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0391/1848] lib/842: require a complete history block for repeat templates
Date: Wed, 18 Nov 2026 15:40:29 +0100
Message-ID: <20261118145930.092383091@linuxfoundation.org>
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



