Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051514;
	b=mVh/2LKPjyfxa9ZrF8et83tvmPeT+QJEw8wQp5bJXaOmkKqIvFnS03YnuPR48syl6ASd
	 HtNPJy9a3mT5V25PmBFwXIIv6fBnQjZh6XZA+L8+UG+Crv41YJLSrkGbyhJ5LCiLQGsNs
	 qjtOshfOAmL71+x5ayU7XnibD9mWxNxpinnow/3MMPMNMFVR4vvY27sPqMoWIwI4hPQTP
	 1rq14Us2Tm2h7wZb3CEKHTVwy8zxWTlU9MDB5rHD2idmfZ18muGLTChZiGXRatVUVRoU5
	 rU3Q52HExWnjWBNkOq8XxKy4xpX4wx1Yx1Lf6mM6cgprwYe4alfRZw6O8otu0ugyMMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EumjInKuZa2ZVMBBb1BkAl3Nf1uRptCIx9VTH6f7xa0=;
	b=DD/K9jYVqPM+QB2gqvlk0WiYS8Y0/xbdxjYg510InS/FI/Okce9eddmlDwx5SxE9aSXb
	 Lk0mYvS2X+8berV9IrCukwV53omS1C4oAV/87lYgx79ue1DX7eH7OGB3R/HojvkQ3WUyO
	 xUdYraI/GtDye/W7xP+mXQKz5jC7MZx88gMvIEC/4HSEXXUuXEzWiOYM3CK/5+6cVGOJR
	 M719Lh/8YPIQ1kdD977th92XdXFREK8pCdwsyNUANovEkn/4HGe2brgBQakSEZVppb/u9
	 i84NTletQHtCVdHccFByVTODo1XfalqqlFEHprEXhFkTwg4y3I40rooVVE9OXVgMU1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQxD3dek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C12A606A31C;
	Thu, 19 Nov 2026 01:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQxD3dek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1981F000C4;
	Thu, 19 Nov 2026 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051514;
	bh=EumjInKuZa2ZVMBBb1BkAl3Nf1uRptCIx9VTH6f7xa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQxD3dekCKvLM/0i8W2klq/Mxz/EVXqmp0o7DqWrwPGIrW1ZYkTRRVfyw59Z0YcnR
	 RuktBLxTZ5XKqN2fkd7y2VYLhRpcBvMfDFGP/5Yyc194DpFLAYaSSylP99FEDgYouO
	 05E+BCMrFShuKdedHls5vwtM95FFXCXh+bwFnHNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0235/2214] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Wed, 18 Nov 2026 15:31:51 +0100
Message-ID: <20261118150019.611286319@linuxfoundation.org>
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

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit b4d1adc70471d0752bba674552d19971ed9fa869 ]

if no define CONFIG_TCG_TIS_SPI_CR50 in config,
the add of tpm_tis_spi_resume is null, this cause the tpm chip to
fail to resume.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://lore.kernel.org/r/20260812100914.3540149-1-lijun01@kylinos.cn
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_spi.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.h b/drivers/char/tpm/tpm_tis_spi.h
index bba73979c3687..87927f48beaf9 100644
--- a/drivers/char/tpm/tpm_tis_spi.h
+++ b/drivers/char/tpm/tpm_tis_spi.h
@@ -44,8 +44,12 @@ static inline int cr50_spi_probe(struct spi_device *spi)
 }
 #endif
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_TCG_TIS_SPI_CR50)
-extern int tpm_tis_spi_resume(struct device *dev);
+#if defined(CONFIG_PM_SLEEP)
+	#if defined(CONFIG_TCG_TIS_SPI_CR50)
+		extern int tpm_tis_spi_resume(struct device *dev);
+	#else
+		#define  tpm_tis_spi_resume tpm_tis_resume
+	#endif
 #else
 #define tpm_tis_spi_resume	NULL
 #endif
-- 
2.53.0



