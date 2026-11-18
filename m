Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035776;
	b=aVHx61EKvqKWI2R0bhubt3UyVP6MFfCBoNgK7+y5Q9rSw6qHxSyd+7d3OYGeUBx3C6FE
	 bhKBXbouUVA0JG6p3EMmDcjN0ojeleglscsA6CNsbfPwgs4IQeu8NmqTxIqb/WA9/umlc
	 Y3b4PGghOzbbhIBzvAZVcOY5/8qi63DLqjvXQ0Zhie1ZW6i6dqfLqLcQyOsa7kV5z3shG
	 Qnnd9VMzJOUYJPKyrE3XsJuZNMxVk5o0lvaJ//xflknr7aXSYgtYlYgpNbEFQ91wrPN1x
	 aunLdQfYOW7C0OeUpQESMTtWGMuDve7GdZES3UEH5AaXZt9WVU5VrIpVLSQlKBsSEig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bzlacO2wyQVCDn4+jYEwUa1CAO1VSgxsnGEC1lH6ZFk=;
	b=ccYGFrXI+V0XNn5+0plTYTFVF+Ye96+zVWvgJT30zmd8OBWJKRgdc47YH3srlLtv13N8
	 9v/TXcgfiD/OobkiTFmvftlJMzXNl0UdOKk66UsFbh5mxQPJFb0L24kWcVq0Fn0e/QbqJ
	 257/Uo65Dz3p5/wxi1YAqj5o4aUDv1V5oantD3H3hqJ48r3wGC0Vz/CpWZaYSwKaonYkf
	 viVbJkthatfOKgaas0GttlNMUU+LiOXMCcBlXCU/hTbcAgFOZkCjQMM+6epbgoAvoDEHh
	 1qgYAs18twFQXr3WXXpvroXdSX/n6aBHTSVouO6hV2yUOG+J4tQ+DN0Zc8fTfD9bo5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OurDqrpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93001606A320;
	Wed, 18 Nov 2026 21:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OurDqrpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4771F000C4;
	Wed, 18 Nov 2026 21:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035776;
	bh=bzlacO2wyQVCDn4+jYEwUa1CAO1VSgxsnGEC1lH6ZFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OurDqrpGoUMINdFqrGqbR0G5+92LfsP10RS7+K3DMHhr32wSEHn2jXHS3kxa9oLKC
	 +qJVDf2BHnempCzfGpGjC359nTqV+v3ssBlFYqeGqxbXW5kzteOkOtjsQXku3Plv4u
	 WHwOjvxRL65EWDo+mK7+WW4tra3ulENbf7E8tuDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0822/3318] mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table
Date: Wed, 18 Nov 2026 15:24:04 +0100
Message-ID: <20261118150343.720377992@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit b9f34a95a81021fa1f3c9cb8cfd458e66824cad6 ]

The spi_nor_parse_profile1() sizes its buffer from the table length the
flash reports in the SFDP parameter header. But it then reads DWORD1,
DWORD4 and DWORD5 without ever checking the table is that long.

So if a flash reports a length of one, the buffer is only four bytes
while DWORD4 and DWORD5 sit at byte offsets 12 and 16. With a length of
zero kmalloc() returns ZERO_SIZE_PTR rather than an error, so the NULL
check doesn't catch it and the first read dereferences it. And the value
doesn't just get thrown away. It ends up as the dummy cycle count for
8D-8D-8D fast reads.

To fix this, reject a table that's too short for the highest DWORD the
parser reads, the way spi_nor_parse_4bait() already does. The table is
optional, so this isn't fatal. The spi_nor_parse_sfdp() warns and
carries on.

Fixes: fb27f198971a ("mtd: spi-nor: sfdp: parse xSPI Profile 1.0 table")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sfdp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index dcf88ad2a00b2..daa59fd416e04 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1157,6 +1157,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 #define PROFILE1_DWORD5_DUMMY_166MHZ		GENMASK(31, 27)
 #define PROFILE1_DWORD5_DUMMY_133MHZ		GENMASK(21, 17)
 #define PROFILE1_DWORD5_DUMMY_100MHZ		GENMASK(11, 7)
+#define SFDP_PROFILE1_DWORD_MIN			5
 
 /**
  * spi_nor_parse_profile1() - parse the xSPI Profile 1.0 table
@@ -1174,6 +1175,9 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	int ret;
 	u8 dummy, opcode;
 
+	if (profile1_header->length < SFDP_PROFILE1_DWORD_MIN)
+		return -EINVAL;
+
 	len = profile1_header->length * sizeof(*dwords);
 	dwords = kmalloc(len, GFP_KERNEL);
 	if (!dwords)
-- 
2.53.0



