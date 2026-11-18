Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040250;
	b=ht+XlTHUPsT+nIc5XHDkEIQl2CDeUZgMbxeKPeMGxl8cU7xGCL7GuVjRvRX4yso1Zi4J
	 S+BawXvfQlvKzgZxix4DJeLsJu0TF7JwCx50hc+ee4hLsg5Xzqs0iG9Zn9F/6W2/0oi0x
	 UWupylntzvfmGA+3ZnkkBVRgX1k/PDpXOTNmlbMPLZFTZ+yPznC/HBZTmus5ML9L4kpDW
	 i8SgR5BxxaJdXQHD2D6pBs+2ZB0bkSgwFiwtuSLSFrLl5EpT+KGys/4ONQIt2Tz5v/2rH
	 hi5GLXX8nXZmLfaqPmcKcyiLl0dg+2f8UIIiyKw4PfLaq9N5epqtMrmLregMz2CqwQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eY8Qe4MuOrtlOvCMn4zJNbqXhit7K8sQA5CTZuMCeHg=;
	b=Nxw3nBxUNVnJAKTZuDTPh/SuqPOxu/Tqc+P3rorHkQ5Bydm/uQsprhf/Atg+DCn65Sh/
	 f7+dYCJdKZx5NDUu9SsXOmjNjtCe3SeDaCaj6stfLGmOgG5hz5z72tLvbgsakQW7+uS9B
	 /35t0b24CexJJaarnme98nmMiEjeoOUtcxpxWh03VyrcH4WZAZjRG/EMOEC7vKF+/7m51
	 3Jaww4UEg49e0ScoPCjQyTeyBhaz4gLmQF2pr9Fqjvy9omLeOJVa0TADRksNXt5rJjvTn
	 RKy+udqwkcTOilCb/3F8FE6bE0dwGINlsQRXifJl8l+NpFdUJqt3fQJsVo4P44mPDzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQvG68KV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462AB606A320;
	Wed, 18 Nov 2026 22:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQvG68KV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4BD1F000C4;
	Wed, 18 Nov 2026 22:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040250;
	bh=eY8Qe4MuOrtlOvCMn4zJNbqXhit7K8sQA5CTZuMCeHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQvG68KVUWhi71BrWUSbbbJtK/PxSekt1RfixaUvIARKfvvEeNlBMQOm/cxYpDDlC
	 FQ6VEPOSmN/mWVmqsI/GCTtcnlWhb9tGQR6lbB/2XHfLMgr2A4TyHsm/Lf54Q8kIB8
	 cIMWMkyICox13xaDUCGxhWYyJLen9Om4d4108jRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2389/3318] bitmap: bitmap_parse(): reject non-hex character before 8 digits
Date: Wed, 18 Nov 2026 15:50:11 +0100
Message-ID: <20261118150433.193413100@linuxfoundation.org>
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

From: Shashank Mohan Jain <jain.sm@gmail.com>

[ Upstream commit 7cee2fb210a198667d3d4200705215e6f315cab0 ]

bitmap_parse() is documented to return -EINVAL for illegal characters,
and it does so everywhere except when the illegal character directly
precedes a chunk of exactly eight hex digits.

bitmap_get_x32_reverse() parses a chunk from right to left.  After it
has consumed eight digits it looks at one more character: a hex digit
means the chunk is wider than 32 bits and -EOVERFLOW is returned.  Any
other character is silently consumed as if it were a separator, and the
remaining input is parsed as the next chunk.  As a result:

  "x12345678"   -> 0x12345678, returns 0 (expected -EINVAL)
  "1g12345678"  -> 0x1_12345678, returns 0 (expected -EINVAL)
  "0x0000000f"  -> 0xf, returns 0, while "0xf" returns -EINVAL

bitmap_parse() backs cpumask_parse() and cpumask_parse_user(), so the
same inconsistency is visible when writing masks such as
/proc/irq/*/smp_affinity or the network queue rps_cpus/xps_cpus files.

__bitmap_parse(), which this function replaced in commit 2d6261583be0
("lib: rework bitmap_parse()"), rejected all three strings with -EINVAL,
and a "0x" prefix is accepted today only when exactly eight digits
follow it, so no reliably working input is lost.

When the loop falls through, *end is known to be a non-separator
character inside the buffer, so return -EOVERFLOW if it is a hex digit
and -EINVAL otherwise.

Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bitmap-str.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/bitmap-str.c b/lib/bitmap-str.c
index be745209507a4..692a150a4d65c 100644
--- a/lib/bitmap-str.c
+++ b/lib/bitmap-str.c
@@ -447,8 +447,12 @@ static const char *bitmap_get_x32_reverse(const char *start,
 			goto out;
 	}
 
-	if (hex_to_bin(*end--) >= 0)
-		return ERR_PTR(-EOVERFLOW);
+	/*
+	 * Eight digits have been consumed and the next character is not a
+	 * separator: another hex digit means the chunk does not fit in 32
+	 * bits, anything else is an illegal character.
+	 */
+	return ERR_PTR(hex_to_bin(*end) >= 0 ? -EOVERFLOW : -EINVAL);
 out:
 	*num = ret;
 	return end;
-- 
2.53.0



