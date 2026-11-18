Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037518;
	b=dVFDQIsykVrHC7uCVeQKdmpENH2PNa5ZLnQjpf6LOZAwKAOC8/oQ0ZSfpUIRieXbsim1
	 eGYWM88BUiFQkoO43+1PdVXZy86s8f0DUOD5oghcaeTk33gyk5PHPR/92tZGGtS521m67
	 Q0jUtIi6LNdLHC3qsDhPogXzJJWuERko8a0F6aHwB6QhrZ2oQQ7t6+++3PVGkwBOBnLJV
	 F7qc9Yb4r7cXy5Faz4JgHsFZu+41hVx7zeQv6Junaut7WzBEla9ve+o+ieTqvd3n5fvbN
	 B0OOFYue1nugdXxcHHQqLc9ZRtMrXSEnibqrdn9jXEgxySK++H8SH8IcuaFFQ4l1tIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPCsdaH37akpn0rDHQ+OSgDID/NNTbSojEQpWPqYyyc=;
	b=0/GzMgQGx3g+QkwIFt80cXpg+EXLB/P7jOUpxSyHLbz3D94hI3/9kwZRLoJJT2oQvaOz
	 4NUJYlAvryfX1gNC/sz+0pmOjp5bU8hlozrFURyYNw1SCeUMaMa5NeiSNwtZvQWLxqo5F
	 nHbtG2yoHD5H5dA8lVix+z9uZoLY0PpQF6UPBKNjVM71nU+h2MeCQvujiVAeLOqJ0Ark0
	 RB77ddo6UPguk6jU3gnmvclo4hLQY3aLmcywXpULm0robCMxP3Ll1SaSJFUvKAWBcpAiE
	 KrEv6dPJ8tn91vjOOYMQOTVTsX7nl+WR4YityTI8j+6+9ei7WfhsBLiWV8TeUrN7BSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioTlbMKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC38606A325;
	Wed, 18 Nov 2026 21:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioTlbMKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362591F000C5;
	Wed, 18 Nov 2026 21:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037518;
	bh=jPCsdaH37akpn0rDHQ+OSgDID/NNTbSojEQpWPqYyyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioTlbMKg9PKE3ri6x7LF7GEVdtE6XMhJVmFGpAB7pUOyDOELlQLkB2Tu64kTJrKCR
	 ropDsu9AITKR1YFb3xhA4CfCgovsLzXxHcr0XIp0A4VSHwvoBRuxhGMuli/X2Fd/0b
	 TuDFIteZ9Q2qXCJM7W/aiO8j9lsKi1hFi6OPcTB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1384/3318] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Wed, 18 Nov 2026 15:33:26 +0100
Message-ID: <20261118150402.069261711@linuxfoundation.org>
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
index 1ad7dc9070578..43de8fea59ad2 100644
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



