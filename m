Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043705;
	b=Pibr75Ms38EKibChBi90nfrRpurgkAkGRDc/7FCNhbPEpKmzdFIyj13C39Yfk/upyJKb
	 MiCNJ7DHDDNXIx7B9t0TLEqJvvgfeQ8cNLKR0iLM70f2HxKFX2MBNNG4Y74b/+CeRYRvH
	 oVPU/t3f8iU3oL6ZjVaz+16VVs+3Bjn//tZtNe7Nmsf9eO/Nb+E51zvQjEDvP+7HTP1v8
	 CdDoNigUtYFtBzfSszdljWjP7h7jU8u9N/1aYUIRBpU3yzW3rUpesq0vc1GwGogZBN58W
	 JeRvXYp1TgHPyf3XjA4Jolh+TCNXYnp0x75pv+4TENh2oBvFZ1DphZl30aNudwEuYKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGJG52iWlpSQgVrOEFz7/iPLr34mVfyIEMur3UhqDho=;
	b=AIKZqTh+xyxCazR49DuEmDwwFBPEtY9UUKnNqsIM9dDQpQcOFxQJJFS9jXOpFJ3LXF3l
	 YkTF92Fr/UFl/DiF4/sSxYW9MRUuLhX3G59pAQNDy5sZI67FCYJrc44zqt8GJj9WVusNu
	 zunVCNU4HDTSCiOaKMKN0dh+VAzN6aootyu2WZgoLZwW+jiPGCCyDv398j8umCbhRcr38
	 /tPYafZcG9XzSJQegyTLqx3ViGuFjQwMTpGQZnDJvidZQI/YcKkYQU8yRQGeHIVg70bde
	 VhQGesFieVOl3g42NIM+teQq2KZTNfWn+qaT4CO4w2BRUgOHCj4GErOIyWVcu0ApyTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDNUcIQ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E6606A325;
	Wed, 18 Nov 2026 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDNUcIQ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B261F000C4;
	Wed, 18 Nov 2026 23:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043704;
	bh=oGJG52iWlpSQgVrOEFz7/iPLr34mVfyIEMur3UhqDho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDNUcIQ40zZlT0ioOheIRmLFMIuFNQOll6iw4vpOwdUsaEaYIq/1mW5p7M9Ys4yWL
	 r3tVNI+17tcDOCIUlSzBYVEgdhjCRam6a1J5tEJZZACuHz466jZ6b4vFZNb4/KWtcr
	 vCkNMjpiV6jThfph38hQEd6pT91nb/vVo8dRjahw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0278/2857] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Wed, 18 Nov 2026 15:21:52 +0100
Message-ID: <20261118150211.432483123@linuxfoundation.org>
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
index d0f66f6f19318..ced416ecd92c2 100644
--- a/drivers/char/tpm/tpm_tis_spi.h
+++ b/drivers/char/tpm/tpm_tis_spi.h
@@ -40,8 +40,12 @@ static inline int cr50_spi_probe(struct spi_device *spi)
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



