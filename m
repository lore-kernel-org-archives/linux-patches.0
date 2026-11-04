Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831062;
	b=xs8WFQZTkkuHxD3U5/DOywi+NdanzYPZyva3xGnbqnUuMNbd6UMzWeYGuJr/+hTx9/kG
	 6M43q5mXGct54WZtJGA/RAILlOqVFWh0H2z25hAZgYKIIowsmO36zONVwrtD29mS3OEXD
	 xJiZxojHbMnUlajTbfJWxWsS2g5l5bwuttizZZKUHuTZdDObX4SpRUd8T5+OmsGvZL5ag
	 337ttzgOCG+P9B/k+CBrlf37FfJbR1FZ2xtT5zxF/AcFh4q0geVBE0jURBuGwttXDQX9G
	 wgbiTppeP0nvYroAiE9twk3mZ5KVgsAePiHhTZVoS8MN0n7Kuudw1042V3X+AE3PfOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1NpSJltrFrMMPuJczbTpvdMav/HUmSJ7opcLuIg5h9E=;
	b=PHSAAtT0sxBH9SmkJULnEudwQDq9UmLUS1TCyQnUwy0rRX1nE18/5JqreshXiPuTDp83
	 zDNfZuUUab4SGth5GfHEaqOIlAqh3rbdO4JYLFQJdU2dfp1g32YLUcGVeFFHJFAyXfOZm
	 qLrK2Og0frikWsuhN/xH5CxEYxI4oPxvcWmXuLGoNv/ugIXLr6CMbMySBAK8Yg8q2S0el
	 6urDS5A2LfLWgdDpNdIywZqkwNaFECGO+4gEXVPeOdKvM22WYeoHfYalHImU8bcMrvvPx
	 wc6NNWLmfJw1Bc7ulFPTNU46DKUtOYToKdDUXz9cZb+37EfevTZRo7kIo5kIeEmMWdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7NkrBv9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5739C606A32C;
	Wed,  4 Nov 2026 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7NkrBv9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A8B1F000C1;
	Wed,  4 Nov 2026 22:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831062;
	bh=1NpSJltrFrMMPuJczbTpvdMav/HUmSJ7opcLuIg5h9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7NkrBv9R5MXw6KOa9k9Ag5QNcjzAPxIqx88cM/WB865HsU+LpThdah9Rw4WiJEN2
	 /9TcpemQQu1VNlfB0R3KUqRyeQJZgf351DF2GrsIZdNB0h605T57uFpq3b3aa0YNmT
	 KnI5JIL1MplSE9TwKC0tleTaghOsfG6G1JFTwxO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0465/1005] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Wed,  4 Nov 2026 16:03:18 -0500
Message-ID: <20261104211057.046000425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



