Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046145;
	b=j4gWnet8E1QEjHYBODNdcl699YVUPxvB+sfFr1uhyTT5gXVUVYHGrKYR2ls2fz3vN+Cq
	 G93DYpBN/3X7vnBjP3SNFpUtheoXyASAH+sP2GlGc6YGUurui01kV4vd4L6koptpkJ+TU
	 7iGRWJpgxWXitsI8rt+9ym3Ydl+UmcTGBgiX2YfgMnYsQ4HFNx+yu9QqX1ACWTRpPTgC+
	 cjeeJz/L1aL/UsxvPWTwxG1cu62khBaFbrVepIYScbUZm/FBpVIztVpsrlkZBOnKvlnx4
	 HuLrQL3G9LjWVeDuPEhqyHO16B7mG4ZLzN4nykeRonZOqk7dV7HTCGmSVv4raRpifeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WKRZtQPeJ2PT4qYHUjsvLaClII+Nx6OJvD9mFkE8B8k=;
	b=UqEldDC37R/YdxF0n6ZVAzG714lenmMoZmAYRRCOhdcncZz6o278i22uhA1uvs8VAA9K
	 J4xx6hc26Fw0x0XWFzMh6LLaUDHYwAoVMEsbw1mr0a5RFs8IjLvBG7u6COnKuSsKq8Qte
	 HLCdZ/i//6UGkSFbTh470tpUkqZW8qJvl1mshDcwIlsDgQgiB1ogtZY9iSGEaG8sjPQ5c
	 tT83PciON19i3wdzRt/FR7oqakXtiK/Z90SLqyhnXhZ1zLS/j+58S56NtgzSLesLYJnfZ
	 OHyhrHi+ZcqHq0UKRI0JONN+A8StcfN9Ks7ncRsMMnuTfeChpJby75QQu8AbOqOGomA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyxdtNe0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2AB606A320;
	Wed, 18 Nov 2026 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyxdtNe0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF631F000C4;
	Wed, 18 Nov 2026 23:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046145;
	bh=WKRZtQPeJ2PT4qYHUjsvLaClII+Nx6OJvD9mFkE8B8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyxdtNe0Ne+5ePhCTRS1hYRCUrnLY3j6emgthWDn35fGz2sGAvG6SzSKUTzM9mBXD
	 zxiJvMTgYkVUcBxXzB3vqqlRKK7A5wAA92IHo4S8zxANOeoJyWMfgx5/6RI3WM1wQ2
	 N+q0l3p9SOZRQ/DuoHPw11mGwLkuDCCHvyQHvC5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1177/2857] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Wed, 18 Nov 2026 15:36:51 +0100
Message-ID: <20261118150243.982465698@linuxfoundation.org>
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

From: Rupesh Majhi <zoone.rupert@gmail.com>

[ Upstream commit 4334dc4092c271e6cd010c2ee70b7f4415c4c199 ]

Driver defines them as BIT(4), BIT(5) and BIT(6). Per datasheet P_SHIFT
is bit 2, FIFO_EN is bit 1 and SPI_MODE is bit 0.

Only P_SHIFT has a user. dps310_set_pres_precision() sets it at
oversampling 16 or above, so with wrong bit the result register is never
shifted and stops matching the scale factor compensation divides by.
in_pressure_input returns -ERANGE at oversampling 16, 32 and 64.

FIFO_EN needed by FIFO support later in this series.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Fixes: d711a3c7dc82 ("iio: dps310: Add pressure sensing capability")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/dps310.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index 0057e14a45ddc..ed7f2b21c8582 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -50,9 +50,9 @@
 #define DPS310_CFG_REG		0x09
 #define  DPS310_INT_HL		BIT(7)
 #define  DPS310_TMP_SHIFT_EN	BIT(3)
-#define  DPS310_PRS_SHIFT_EN	BIT(4)
-#define  DPS310_FIFO_EN		BIT(5)
-#define  DPS310_SPI_EN		BIT(6)
+#define  DPS310_PRS_SHIFT_EN	BIT(2)
+#define  DPS310_FIFO_EN		BIT(1)
+#define  DPS310_SPI_EN		BIT(0)
 #define DPS310_RESET		0x0c
 #define  DPS310_RESET_MAGIC	0x09
 #define DPS310_COEF_BASE	0x10
-- 
2.53.0



