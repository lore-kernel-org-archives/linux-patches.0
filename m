Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052597;
	b=wnda5nDLccDq1B82O5PJIdv6nK1bWqzbhTu4UnUtZM2U+iMvwOi1Kk5P/sMkd5MgkTXq
	 Z/KFYwK6elKe/tp9vWwklK1zzQx1rw6VrlKnlQaDOPwPA1yVzEVWAo1ZPknLaEoGh+8CJ
	 jFthjCdR6DO8gIxdUf+wuqSX3lrLj0giyjW7P26D/zGa9mxJ7GAgCXfPchFkleGjfjxxK
	 wVuRZ6wDWapi4yh/mnujVr3MsJ5PFgY7mC0XVqRGhUDw67wV3+IrEmJOnPoK6VTR2GxbE
	 kT053VFKAHXoXeIRqZNWz+p912oriPprts6j2a/IS9wn48cJzW9PkJ6rdwI8f3SP/rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mANXZeb87p3U/4asOLiEr8a83ZX1sAS3u6V9Dmj5KZs=;
	b=kEWAkbzgSVouBi14X1bxy1XjBPV8bRCuKfSXw9Sol/son+YYUOn2ZMwr62z/JLQBY4Tu
	 51tXtZESeKOP81oe/zQTXpZN4XyT5J0Aa7qBhSuwcDOFe8Ggfr3T9Y1XsY1ugow3FZV0P
	 uqC/y/86TpN5C1EcM+tVRKXeC9vM6tF9HxxTk0gqhtclpulU62E0Vk6Y1gHfAvDZ0U732
	 EECXZbPRyV7xh0lDeSIQtc6hBE+o9U/GHsBiWGpbl9aaHlkTc07Gpmi9FONPFgf+FcZ+x
	 etwc4eTYWjRILlRZiwcQHMsaDCj1sU13D90Z5jPRVPZ90vlil3LwBXjLnk64S0eG9PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UWfWJdjJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0049A606A31C;
	Thu, 19 Nov 2026 01:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UWfWJdjJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC681F000C4;
	Thu, 19 Nov 2026 01:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052596;
	bh=mANXZeb87p3U/4asOLiEr8a83ZX1sAS3u6V9Dmj5KZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWfWJdjJUfrHrtC6tgZkf56NLmI4unMT9ryo3suNyz/D214hIHoStPvqp/bXw0uXR
	 8uI0SNEVrlZRGHkzBQtl2SrEyUxJ55D4aWhc/TmeEarDqlRpj3/N9zK8ZRp1kPMbd9
	 AcaWrYQsH2MKqK8yOkJJDEWsq0J4+uerPvAm1WjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0618/2214] mtd: parsers: qcom: fix offset/size overflow on large partitions
Date: Wed, 18 Nov 2026 15:38:14 +0100
Message-ID: <20261118150036.108949063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 2f7fa8d90694d21dce68ceabd8383252b111cfea ]

In parse_qcomsmem_part() the partition offset and size are computed as

	parts[j].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
	parts[j].size   = le32_to_cpu(pentry->length) * mtd->erasesize;

Both le32_to_cpu() and mtd->erasesize are 32-bit (u32). The multiply is
therefore evaluated in 32-bit arithmetic and the product is truncated to
32 bits before being widened and stored into the 64-bit (u64)
parts[j].offset / parts[j].size fields, so the 64-bit destinations are
never used at their full width.

The SMEM partition table is firmware-provided and the per-entry offset
and length are not bounds-checked against the device geometry (only
numparts is capped). On a sufficiently large flash, a partition whose
(offset|length) * erasesize is >= 2^32 gets a silently truncated
offset/size and is mapped to the wrong region of the master MTD, which
can overlap or extend into an unintended area.

Cast one operand to u64 so the multiplication is performed in 64-bit and
the result fits the 64-bit fields without truncation.

Found by static analysis tool CodeQL.

Fixes: 803eb124e1a6 ("mtd: parsers: Add Qcom SMEM parser")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/qcomsmempart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/parsers/qcomsmempart.c b/drivers/mtd/parsers/qcomsmempart.c
index 32ddfea701423..cfffe3dbf28d3 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -142,9 +142,9 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 			*c = tolower(*c);
 
 		parts[j].name = name;
-		parts[j].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
+		parts[j].offset = (u64)le32_to_cpu(pentry->offset) * mtd->erasesize;
 		parts[j].mask_flags = pentry->attr;
-		parts[j].size = le32_to_cpu(pentry->length) * mtd->erasesize;
+		parts[j].size = (u64)le32_to_cpu(pentry->length) * mtd->erasesize;
 		pr_debug("%d: %s offs=0x%08x size=0x%08x attr:0x%08x\n",
 			 i, pentry->name, le32_to_cpu(pentry->offset),
 			 le32_to_cpu(pentry->length), pentry->attr);
-- 
2.53.0



