Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045445;
	b=I+BAyCCOd42W5hmz68FP6LqD/oMJV/NULJWkOcOvaqov4wF6sS7iWH7ROXXhzDutb++c
	 QF6x32iOInZzFlha63L9cyhHU6hzp2AwCwCLabFij2w/2QMlWdQJ7gJvxBOMLnLeOjWfa
	 g3Q8Oo7b+FYU1eWyRowXaVUMxdtu6B/FrzpUU2lvAkZHhoVZqaHXgAq1ixUxBJaqKkeCJ
	 CvFzRxLJ5/xjP/fUYCgT541tRC2OBKpwf4eeKMwzPgvJyGC+kzvQRfYtJ6d2xIjfqEgl5
	 BflzkVBVmNptshov1v9veVKzxoKJNWZSZeJBZaqexD6nXuLPkoUMDMU+FZ5bhqd5QCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8j65A4dFov6n05ofdf42N86VUeMJp5+l5W6ogWpT1A=;
	b=HY1lD1jWeR/2ktVmLCosMFQJtycnXQYWLXDjbm2qXJdCa6S+3ns5re5eMB+yk25mGP7n
	 8RYHyY/DejZWY1NfwGd2Lf8K4rIHV/JUKSAxKNfX8GFiA0HCbNhz1cs2kyurGWkfGIqLL
	 O5Fjuc6Na+9ZeaZGFObhy7mcjpnRGbOOC6VGnpKGns1oT6fvYxY/3GS4xdd0MoLg1ek+J
	 e9z3YAdeZGiqbucJxNh/Ak6WHbOl46aAC+LgW8moW33GorLNV0QfmTtEZheUuxRyV9IfM
	 xQ35rxZwutdOYRmuO3vHuxw7LznHJm3jTAKFQtABzEpjUT2Fq86WsGbSsEohyLfh7Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GumDj0aZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3FF606A31C;
	Wed, 18 Nov 2026 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GumDj0aZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077461F000C4;
	Wed, 18 Nov 2026 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045445;
	bh=X8j65A4dFov6n05ofdf42N86VUeMJp5+l5W6ogWpT1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GumDj0aZJ/ajeCwW7heJMqW8ZzDtNqumGPn3VsHBNnyYAJpPQNqLuVWxQPRCT97Xp
	 aZjSJ4T/nCILSs+aH1CpxGJYwP+9bwOw/C5azDFZ8WswF0SZHNJVJbTE9DfKvK7u4D
	 YgB1j1LYiNUb3OfjZ1P47Ov8b3ZxwY7eFyHYokfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0925/2857] mtd: parsers: qcom: fix offset/size overflow on large partitions
Date: Wed, 18 Nov 2026 15:32:39 +0100
Message-ID: <20261118150234.890886463@linuxfoundation.org>
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
index 4311b89d8df00..b12d87c3b0232 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -143,9 +143,9 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
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



