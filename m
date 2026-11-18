Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030174;
	b=hhZ2vX0337EBqHad1sc7KE1ubmnMoQ/69A7VqM3Vj5+WKcNXTXakuMBiMEEfbRfe6Krz
	 8Y1I+4RTxAkemqZTnvtwoY0pd4WxoXESaGDAg4miET0LEyruUYqgJ7JaZ7NDcie80X/M3
	 1PYcPJdc+DgbB8HNOkVm0P2DmsB1kBzuncIn2DVoyCiyUwUdmwfN+Qav7pbyUGPtaW5Jg
	 2dHIF2I77mcICUBH9bXjeywOPWQyqcMhTnSZc+O1UO2VkTcRxGdSfUFD8TS9HgK674osq
	 UpzkqtviLu0luccPE+jRT/0jPGYnGoI47vDPOZzclAuqXHBhQu1S7RDAbUmUwBwOspA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l8rae8Xq/medagAJZkgcPeffDI2TUdwdXDw+qPRT00w=;
	b=pUZhLuphgmf0idq9JBevElfuGeNU6NqSrwbt+4J/xR3G7yy3QBiBX/RqSNM3g0lpBczt
	 yE2NsD52aJXGIq7dhdxOYrF80iVw9jrx1aKQO89s4ommB2fhaXo9blTPRKQFPlRUurivu
	 skuj06iJCaCX2N6p5mJuEE7j5qdBSGCoAQ9HpfZLJf05ajHBJJoiywz9wHqycJQjNeEPU
	 1Jl4mP3awFilvXSqehpTEmws/MDFbfxjid4m8eg05p2R0bKXeAxLYrmsaBFuAys/izrqG
	 AHV4GmHx+jWyxQKmQJPNMAWwLwgn+cf9jaeNeI6qMY6FD/xRuzPlDNIYpfE4dTIWOYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0B83ZDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115DD606C718;
	Wed, 18 Nov 2026 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0B83ZDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C521F000C5;
	Wed, 18 Nov 2026 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030173;
	bh=l8rae8Xq/medagAJZkgcPeffDI2TUdwdXDw+qPRT00w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0B83ZDCpQTCtfmZZFL+LXl31YZkXWv20w/MoT6AhCiF0OTCLcTpGvtab44wbyBtz
	 NaIQHUmCY1lCFLbS5js4qmj5FkZjTiCgev+N90kL3I0vCjD0Oplo7QUQ8Lk5xQo4ku
	 lAGncmhp7U4o5eo9CXW54RahFNCCX3umTTSzU+v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0612/1756] bitmap: bitmap_parse(): reject non-hex character before 8 digits
Date: Wed, 18 Nov 2026 15:45:39 +0100
Message-ID: <20261118150033.303313514@linuxfoundation.org>
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



