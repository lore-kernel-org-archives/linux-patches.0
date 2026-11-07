Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061066;
	b=1xCeRm5wyEBC9evPn486z9B+BiuBc9zEI9gycmbAhVMqclbohWlB82K7fxkyoHKGiaGG
	 +ur+K+x3AkxW6WNJ7+UzlDL6mD704H1YXcpcmzlMjYnbKVtnOQoGeaWBQ1m5bxg+uRU8a
	 73bKLZQONduXaqMKVGLO3yeVZmEFxDHWteONAecjrSYV8/poz7JBDro/A+lwhK2zRJVSv
	 oxPdHR1yBRQl/7udL/iLf4+Rj+2JlHMm9ZSsI8uVkjIFmjE6stG8kwOcUDgQYD4Z2bb4q
	 shDIcKiGkmPuYf8aUDmtURuvr1wpvlptuP8Frq/Uc8SHW49UJg7DebiXgsiXiwM8wdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kxzs/vjxkvaonCOGc1JGwPbZMM7+s9kKdrVp5i1PPB8=;
	b=X7NFfp0UkmnLrWqT7erxQe2ZfBqsrG16tzHhM+vTfriGwghkpn2e+7RLGlL+0tWN/c/D
	 vWSBst6UDO2E9R5uwKpeyDc2iVTqvXtsxvDe0nlGL/GjtRe0gRIzPJ3zUtKO7K9qZBL8K
	 vOcPbLyKTKzemDlGsFFMTfeydf9i5xidtx23Aex3koTAlJusqcocgbFf5+d6JxvyUf5Ue
	 bBvaVmHUPPXp/yOtYhEGjAyIsTQxjN/D/bkN9biBJiYrBwDu+vRf48teSmy3JGsVRqp9G
	 ZN8X0uk7bk5wm5599amph+1WNC3Lfi+N9ri1TQvM6LsNZks1Itwq4xxIbxil/AaRKxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDMK8wAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10AE606A336;
	Sat,  7 Nov 2026 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDMK8wAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD031F0089F;
	Sat,  7 Nov 2026 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061066;
	bh=kxzs/vjxkvaonCOGc1JGwPbZMM7+s9kKdrVp5i1PPB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDMK8wAfPO0h5AWS9mDHPyAFj417hFYXGYck3RYWL35fKltJL8Wf9DEm63ZS6gM/v
	 BG19BaGT2XSYDXrZvEzIg9VbM0/QXBdD476mDmsuTClkD0LT60uZ7BuJwt5ALhqHpu
	 3Pb7f0PEXpvfBGAb4syjLWW6O9OrEEvWF5SVmKts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0394/1536] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Sat,  7 Nov 2026 08:40:10 -0500
Message-ID: <20261107135008.664063859@linuxfoundation.org>
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



