Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062756;
	b=PLB3e5Pk3tTWz5KXG3Ln6pueYzVFNAeeRyVTYqSBGa5/JHlKuv6I0Mckw4lyNRF6/Ygo
	 fXhpnXt0bU56SQncR940T/yIdAmdAGaEdqmal1MscLKIUmzAL0gX/YPwsh9oQUFGzx+8v
	 g5McbU9GQxCqulc6t3pVbA5wk0FE2HUIyc9GfF3MuI4y1hq35H0klN6Cdu1wggtEdhh1N
	 bQUEOiUUy5E76Ke7lHsiofMqLkZpTeXetmy3OXo7uaS4CNqIHSW4/131OK5GC0z+0UX8c
	 LiTrIjJ5O8VDn6a6/8DUzulhoDObyb5bnEakK/u2Qjb9UvgdqcRaPT+H9WAxY6ocYkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTpr89IlhSFoQVWtYNre0xxUSLVzq7FLNbbU5FKGgZw=;
	b=IgrOFnq9FJx7Fi/Tg+cnh0rGi2FqoVoMW8btV4YaTtcCCISig7ZRUcyF056aNkayFRoK
	 Xejx/WDPiZBP2zjjJd48GFE+zBmhuiUgHFaPGQbNPPk2n09XsE9teT2K/NdZum3yGHJvS
	 owkHLLl2qdJUqYgnqpTV/Bc647BApSvU89L87IBlyEEr+9CjkcXzVNRwefwzClYhITWhW
	 LUHKNQXMRbA/OTYUEBtZrS19jxZNIM0NGiPdf3Zv+AOPo8vIRWW/78Lb95fXbEDLFawBA
	 v0lXBEAiOWOYA0FvV0F3Feo3hcE7WRiZByHgacLkCtR7JRBckPb6oqXGzJMGzuF9G+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIIsnAJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007DA606A326;
	Sat,  7 Nov 2026 14:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIIsnAJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A190F1F0089F;
	Sat,  7 Nov 2026 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062755;
	bh=KTpr89IlhSFoQVWtYNre0xxUSLVzq7FLNbbU5FKGgZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIIsnAJCZENIYrE5YqrEbH5S8zg/1xdRHfk6bx8M0iPr3DUFd9VSgiZjyYwUOXhhV
	 LxJ9J1aLx0Mcxl0v+INdNpKT5BEuSm9Hk1BNe2hNzCBacgZYV3QjSZF6/M50S49eG0
	 U+gPeBSv5Sz97/azf2cr3Rs11ciWTWhdvRUl8DLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/869] mtd: spi-nor: sfdp: check the length of the SCCR map
Date: Sat,  7 Nov 2026 08:45:50 -0500
Message-ID: <20261107134854.718332755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 1413f38f37194673502e61cd3749e091c031370b ]

The spi_nor_parse_sccr() sizes its buffer from the table length the
flash reports in the SFDP parameter header. But it then reads DWORD1
and DWORD22 without ever checking the table is that long.

So if a flash reports a length of one, the buffer is only four bytes
while DWORD22 sits at byte offset 84. With a length of zero kmalloc()
returns ZERO_SIZE_PTR rather than an error, so the NULL check doesn't
catch it and the first read dereferences it.

To fix this, reject a table that's too short for the highest DWORD the
parser reads, the way spi_nor_parse_4bait() already does. The table is
optional, so this isn't fatal. The spi_nor_parse_sfdp() warns and
carries on.

The spi_nor_parse_sccr_mc() doesn't need the same check. It works out
the number of dice from the length it allocated with, so its highest
index stays inside the buffer.

Fixes: 7ab8b810757a ("mtd: spi-nor: sfdp: Add support for SCCR map for multi-chip device")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sfdp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 7d6a604b89954..a9668c83ac5ef 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1266,6 +1266,7 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 }
 
 #define SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE		BIT(31)
+#define SFDP_SCCR_DWORD_MIN				22
 
 /**
  * spi_nor_parse_sccr() - Parse the Status, Control and Configuration Register
@@ -1284,6 +1285,9 @@ static int spi_nor_parse_sccr(struct spi_nor *nor,
 	size_t len;
 	int ret;
 
+	if (sccr_header->length < SFDP_SCCR_DWORD_MIN)
+		return -EINVAL;
+
 	len = sccr_header->length * sizeof(*dwords);
 	dwords = kmalloc(len, GFP_KERNEL);
 	if (!dwords)
-- 
2.53.0



