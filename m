Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064249;
	b=2ozWJgPrZVLN7j8TvXYH4+fggDBGsTHa1y+rEX2F0VrWSyB+skXPO5I7blbmKl+oPNtv
	 IrV5lg7npw0x2DoUVA2FGvNcPwxzBPsX1hJFne8dvHw4eN/JeKYzTq6FvV5bpeCCoKwFG
	 Q0A5V7wmR1xqFLGWtH6d33GtxY0KSM0uc2tTHZA/2/qJzag+Wc+e4rrtIlrugEoznd4tV
	 oQZY975CQ+rvMUdmXfwsybfeJjL3mMRH4otestRjwVb7aQW7StQojGFX6jhc024OkYv6n
	 acrDN8BWzOdmJ17lwLJ1QVyDEbkUyKFS/LZq1Jrb28+Z/qTHX5o1lI9YDU5il/Hb2Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGwqy+HH9GcvoZ0pOlVGw37jIEzuR15ExGH5t19+vXg=;
	b=qhajRKhsRptJrSBY9jd6QbSyjgtitk9jKh1wS/b1M0/kZbkxKgt9saljWafKb266PsEE
	 LegLWBcPlj/bFxBhaVVHMODF5kqIaxmso/xgofCK0w//FnAYzyDC/zjcRFcJP0ETkE1tW
	 YT+URQG+I7+9O1jPI2ZHiMpc0VZkNMc/hS+UVfHYMPG5NUr1UK1/XSPB2X1sMxR4IllMM
	 MhbmZ6fKKf9u/KbUwRKy2U0zWJtMeXfexMDnU8K8XhNVkJ+jfsqONz+cByagXJxAx3fBq
	 EmUizrPOOXYv0tikhnpTAhKaMLe7onCkt1wt/2akvZ41uddtCVwlbMKjrWjyY7bb3xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rk7ACYiv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7E6606A9C6;
	Sat,  7 Nov 2026 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rk7ACYiv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E481F0089F;
	Sat,  7 Nov 2026 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064249;
	bh=gGwqy+HH9GcvoZ0pOlVGw37jIEzuR15ExGH5t19+vXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rk7ACYivisQObMlIG9ggZythuajbrjIt0PHiVa6slTKqB6W+TP8dG7AsilON2qJ+I
	 a+UmeEu5tM5GjmJzEPGkmmPg0thkkxabm30EqjxMh3jOyFKBctIquWKmN0A5rcxOKK
	 4naBW3xGrgoEm18R6FomdiqqFDaI9ZBWYXtj5j30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0352/1257] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Sat,  7 Nov 2026 08:44:08 -0500
Message-ID: <20261107134949.114427413@linuxfoundation.org>
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
index 45bdb8c7670f0..35260b3993903 100644
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



