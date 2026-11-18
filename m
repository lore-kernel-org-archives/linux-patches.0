Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023573;
	b=O/JiPrOCTgJxEyvRXgncAU4I9IYkJ/IIRcspFVdpwpDAOJ/jCnsTPi8BtMBUs90UE+RJ
	 6jcDCbnQ8cPsLyNbyyCCjo7TLH6gw0n70mqjMRxf5ojeSaC2Jx4ygr4oo0umj8oT0WJt/
	 y5Mmcsp5GoFDDPpLwnONv5MAfQmjo6VTq2nyJJ0UqiCqTFjCLalkSfwkB5acKthH+hiYu
	 yD9ejp40SAYmEVak0ScYARISgkbwvgVVOTrmWSLKeeOtUdR2WakzD4xYFBJ0D8MVOVWG0
	 bXltC1NnkyLvmrzJ7QPX0OMADfVT7mnyP4T89wxlP/onS8IEMsYDPwDTgbHtMvf/WmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7R7NmA7tuaky60JFowTxPeU+EZMb1Mwb5ladfKBc7xU=;
	b=YEhC5O5eoTyxxqzZcSEHYwYVktFXkfJRcGd+CrVeEpaGQpJBwtxt7v6umqflag3woUKc
	 hWkHk4ZYbxzdL5/NSPvWA1hHuD59ktl2VUo5Iuyx4upXjRzBJsMawOjoLsf5fn/LWGmy5
	 vN3jSO6EZz3WHIVrtSlzrcf3a77agLD+LhgSW/uQZCDz7wXpucEeVrdSGry43o2E6QQCW
	 gbk/+Xl3f42GMohl2FK52bM31V75fhXEFaDa0rqAQi5zHdxjy8xMRW3zE3OWHCfmeW5iE
	 lHR7iIHJXF0NTaUC7Tibq6nncu/WTxziXTyiUVvUumfyTTyWwpuaE2bq56Jta3X3SQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbDS7WDv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B3360A260A;
	Wed, 18 Nov 2026 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbDS7WDv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5625E1F000CA;
	Wed, 18 Nov 2026 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023572;
	bh=7R7NmA7tuaky60JFowTxPeU+EZMb1Mwb5ladfKBc7xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbDS7WDvD9UMIKDmtcEqHTKl+f7DpFw2iQQkHC5qr6Jit7Q//ySwzgQ7G6biJTa0q
	 7cOf198DhJjQVX+6wzmyeJYEt1Ymnqd3kpeSGChvClZtK8PLrkHC/3s4w4tQHNXhW8
	 ufClN/L7PpaPFuNFQ9Y2j8yYfT92ZL5bl5DZ59LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0416/2151] spi: Fix the return value in spi_new_ancillary_device() kernel-doc
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118150137.208447387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3742867ce96539100ed5f4c754f04273d8aa00d7 ]

spi_new_ancillary_device() returns the new struct spi_device, or an
ERR_PTR() on failure, but its kernel-doc says "0 on success; negative
errno on failure", which was never true. Describe the pointer.

Fixes: 0c79378c0199 ("spi: add ancillary device support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260911230211.11755-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e103a003e6a65..b8db8f5fd285d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2551,7 +2551,7 @@ static void of_register_spi_devices(struct spi_controller *ctlr) { }
  *
  * This may only be called from main SPI device's probe routine.
  *
- * Return: 0 on success; negative errno on failure
+ * Return: the new device on success; an ERR_PTR() on failure
  */
 struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 					     u8 chip_select)
-- 
2.53.0



