Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030555;
	b=wLHdBlHXmFEtQO+xpRgiXvKUAIH0Hl03lZ4Ema4eBjrCvfQUR/wBRhnoGqOfyFmep2CC
	 9Ge37PqEYByX8JmAoe12e5CvFolnCmFnjxw4SZfwn6D+O8mrtU018cI3mQWmXUb0HY8NT
	 QdyQjtac8fAm8fpZVbfz1Gn+iyBcdVKg+BmnpKizA8JhYxh6OyqZSyK4gkpqz31Ll73hk
	 ICBvqIDz9E0ug/DpfqBwBawJcMuZzbN3io5b6AfHy0D/3n4aU9Sq8ApjSBxAqXT2bz58I
	 zV+cx4lOyUwVlIoypD9qD1ySKWtJ71nnRTn7wx0rjLs6CzGBOM/m65Lmsr1M4hbjNhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7M9vrouzcS/OQH2dGQX47/ABXnJAUpzDMj0DTMUVzo=;
	b=YJ4DOFa8W6XeQo8r4sPQoQ8JEoWjUwWUgF7xlBRM17/EgqYtLg1y6GMe/SPYhlvZ8P1H
	 s2Gl3akpXvAvWNKqil0ZEPlgIET3mUCX5oOyApm2NwQPQfZIUjEQEcK4ltMdqQR22jL+T
	 oqO8DrEgsbGpnXIyYgh1MuCMh0vXnVK9EJgVIQQSAloY2yEkMsbaOYljQWVz1m6IU0FeF
	 6wKYADNA93cgNgMC3Q2sLv3gBZUX4AsyDBfELlxVvJ0Eu3flnkKycTqh2C2LnB7wjqiTE
	 0zpvYyz7izeatxFRu4HrfWhBf924Zw0MuaGWZWXrUkLd04a1AJCc/BQW/hif9Ee4WnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlsINcfp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1508A606D355;
	Wed, 18 Nov 2026 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlsINcfp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B02A1F000C4;
	Wed, 18 Nov 2026 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030554;
	bh=y7M9vrouzcS/OQH2dGQX47/ABXnJAUpzDMj0DTMUVzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlsINcfpH412rK9nJLadtnofpmf/OvmyNgJSV/vvTfHq7himDqJPCJ8cpmdjIV38D
	 NBg5p/aqRArEuuoGiHSCpDdXtFD6Lm54zgFhz+8AqcWozujBhqCdOFW/03RRBclqKN
	 IBpzLw+A2DoiTO4v28Gh/KrfB6FJW5oD9XsKqeTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0739/1756] misc: nsm: fix CBOR short-length decoding
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118150039.037347205@linuxfoundation.org>
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



