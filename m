Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061914;
	b=y0bShfgP5x9dGDhOMzFYa5u03xMwg8UoI7Qn4nhh7xtRruJR5Vv47Y8CVaMJKe8bTqUO
	 yAikdDq3Yz0isMN/FrGwLMJ20Ve9iGuG3uepbLEBVdw/3GxUnA4rfUYEVQ4r1nOGiXCag
	 s8BcDwzBPViG4EQZKBhlEfFazjZnSh6UTgtHe1ktPoRF7om23uicaGmfJ3gGNIqD5B/UU
	 TqEpi5SyA0PuRLk3ucb+iKSf4uTtIcTD5EBPTJQLx2QuKK8RpNvKjpYstYocgrw06+7um
	 Js3CmlRk1sKvtRDIUICsb/En18XkKMi1yZVb2P+9KmMik15TAdSfhOY4De2SC6J4AfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oeq7LmiEkuX8yYn8fLIuJ3oKT94gN6LKH4JyKVr3ZSs=;
	b=HZI0tavuuqotPzwPW2oVpA7wD0iZ2LkJluL6la4TCom3RJ5lxNndN1n9rrGR29Qlzyl9
	 xFZY24af/vEmGWVU9Yqt2vWctuNZ0un3B3sdXykH5ZEtk/CCRwkBrIzVhz6VWTk4H+GhB
	 /LVJp9D4OxbYaGYcdpoESIfyRrYs3Sigmt1KEB7sA7ilYFwhCvMIdUUOXcjtE1U6evKgr
	 MaFM7VANUxaYY8aH7A3yZ0nJw5x5Ma09bq63yqYF/tRbWcqI7NNfbYoT4MSctcGGzjfjW
	 XPsB9a4EN7mPA7Eurf2xM4a1gWxwAxafdbN7Dl68X+HfoSaiYaXebpjTMWkWunFv/9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nNm/N/m2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB64606A326;
	Sat,  7 Nov 2026 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNm/N/m2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC51F0089F;
	Sat,  7 Nov 2026 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061913;
	bh=Oeq7LmiEkuX8yYn8fLIuJ3oKT94gN6LKH4JyKVr3ZSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNm/N/m2r4DZffFELWgSankxb0Dnv4z/tqZOdaf7qwFg7iCjXgGW/PSG8QaEbUV6c
	 6mSDH0afR/12qyPjBEFupyYqsWj+x+rJRhHo63/eyP0IEAV/BinhABttaDiEr27Us2
	 xCVPKXTuQBNB5LnFCwyyL4wNrK1qOaDuO57QpaG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0922/1536] mtd: spi-nor: sfdp: check the length of the SCCR map
Date: Sat,  7 Nov 2026 08:48:58 -0500
Message-ID: <20261107135023.540058566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index e6e86ebadb341..d7e7ad1471997 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1262,6 +1262,7 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 }
 
 #define SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE		BIT(31)
+#define SFDP_SCCR_DWORD_MIN				22
 
 /**
  * spi_nor_parse_sccr() - Parse the Status, Control and Configuration Register
@@ -1280,6 +1281,9 @@ static int spi_nor_parse_sccr(struct spi_nor *nor,
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



