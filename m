Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063870;
	b=LWayuE7EeLkNdbywczNAW512ALrBu1zWx8sUq8HxwyFX/8ZPaPqCYWPaS570RFvi1svL
	 0DRJEnuAfQInYMA82KVxIwqwPzlMF6Q1iQSiaX0tt7QPjtMrBIAurnXcZwhcwoRY3HIFX
	 /6BYzh6DWzbPRNejVIkVvNse3CSW5UqFdWn/Nsa8B02F/mkiCrcP5fAJSPsaJcnD8IOA6
	 QvWgYF0KZkK+2YNtW29s44sE6U1gpkYb6z9Sk6hnKO2UgNznkzXySjVIB3PlmabkIq5rs
	 AnGukVZl3RqOa8ZoHqdUAb+GKIWvIs7uXoisEHwxpvwcHEkM3cjuhcRzGyp8JdIsm+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WzQo5HAb1mPHyFYeg4tCceTsDSFhjy0RVoymhvoNnWI=;
	b=fVMLlQ+Wb0973GvlQNqROuMTAdq5MQQnhD9o2QTfCz0xNj9QngiunVuwk/8yc6vVJzO7
	 ghjS3kSzAzKGMVnf2SvuuYCYafq2BoLEIuoA+xRZvCMJjlGkCbxjP97TJNm34YGFSOhbl
	 dG0V5bupoZ/KeVDzoAt1Hb1z7HUFJqR2OhNNvDBeRlSOt4v8aNd1+TB68yApub9FcTA4i
	 ClGtOCqa58R9MRE10C4AOOlIHklA8D8IS7aE1haTfjrDFlh0h0An04ngo+grlJ9ZQpoNa
	 7IFtD5KAD30H7V85viu11W/YofbXCCX1uLi3iGberzjwpSCGoe4ZNWXVTyJi57mVfzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWaGVqeo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3F960A6F45;
	Sat,  7 Nov 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWaGVqeo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D33B1F0089F;
	Sat,  7 Nov 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063869;
	bh=WzQo5HAb1mPHyFYeg4tCceTsDSFhjy0RVoymhvoNnWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWaGVqeoV+UJJ8Jdy+v+hb85pSOyr8I9Xbp9e+NCINjhznULCT97qwkGyuhUvRRL5
	 vAJkepQcFuL1U4bCfhN3Mk7EjzocQJUE2n6soOxQZgMfTinvev2cV4GPDuJEEgQzwN
	 1tLatI7Zo7/4ZQTcIJt5I+pE/vwB0jdW3jgemkgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0074/1257] mtd: spi-nor: sfdp: check the length of the SCCR map
Date: Sat,  7 Nov 2026 08:39:30 -0500
Message-ID: <20261107134941.430470615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ece8bbd4bc47d..98559536d41b2 100644
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



