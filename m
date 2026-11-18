Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025354;
	b=mJffuvXDS0hnoWZq//U/cvNhrLTctaPbfzb3kS1yclUPDhQBJ3VqfogO06rNQe7khkmw
	 dMPJhm0MFbj612pTkpKKKlteaG2hjQWs7XBWz7WbC2C25bYZjlE69o/QCHgSbyykZ5+2b
	 lKlknvQOdJeuZSvDLxnnrwExISNo7CPizme0X7mSB5ENLV0Ftgtr2NnjeWQ/QulYowvly
	 x4HE4qJFCfccs+A3KaqRMGSN02uUMZaZYR5EKvCzo8ybRHwgMGyt3g6a5CBYqMrNUsVcG
	 XIN/C8nKe2Prbspe8+AWaE/hsm1s5Aus/Plm4HKtFcsODQEUFTlgOxWtYEbZuhOKZyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=laipBXjWd0OB/BX7kvTtEcuqyzP9DXRT/SdiCJHEhrE=;
	b=JdE3DIEYcdMeE2hcSNUzadPzU2WE25G4vbAFScjfOlRIuSnVjbMr0oB4zWpTvl8LkgoF
	 GrQAoNSNHS8qNu4H/YlyxDHwRHVj5Dd/lfkdKdaw27gSHGuao1YsewFlirdgowV+lV6vV
	 ULx/i/as7D9NjuOKjS+hfy21qFxg20IS5FR5KCYuFCVHWWL1PwQEI9z3YTjUfPgGFAcHt
	 hTAcaK28qx5/dE6ULz94LLYv84GFbexp9CrzIVuPXGwMGZ8QTodwHdSudci2FG/6FRzEX
	 Az1z4HK8VtQ8+jXodpiq1G++VcgFU5E0SuKx+8GHTnnNgS/0T/NZ/9jyteoLRyuEcJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSkS7aUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621960A2609;
	Wed, 18 Nov 2026 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSkS7aUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36121F000C4;
	Wed, 18 Nov 2026 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025354;
	bh=laipBXjWd0OB/BX7kvTtEcuqyzP9DXRT/SdiCJHEhrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSkS7aUGYG+Hk2GPdgQP7Nds/0Ix6rXoH4H8MP6OlHeLNOFovVkDMSczppOohrOIz
	 2TFEBjsqBTg80hX9IIg7WH1lHvbLYm9VQQcEVDZ1IfZ2UjPRvCbKF7e3MguOUXRXT5
	 HTRPBSkNbOzChH/6JCd5Mf8kVSnJQCWYt2TBVZdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1049/2151] spi: fsl: unmap immr_spi_cs on remove
Date: Wed, 18 Nov 2026 15:46:24 +0100
Message-ID: <20261118150200.534940500@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit af1d882d421de504a1e5fac92eb06947b6cbdd8f ]

of_fsl_spi_remove() does not unmap pinfo->immr_spi_cs after a
successful probe when CONFIG_FSL_SOC is enabled and fsl,spisel_boot
causes of_fsl_spi_probe() to map it with ioremap(). The probe error
path already performs the matching iounmap().

Retrieve pinfo from the platform data and call iounmap() when
pinfo->immr_spi_cs is present, pairing normal removal with the mapping
established by of_fsl_spi_probe().

Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924112329.1566051-2-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index dbe30664c1829..a81bc938e7b90 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -702,10 +702,18 @@ static void of_fsl_spi_remove(struct platform_device *ofdev)
 {
 	struct spi_controller *host = platform_get_drvdata(ofdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
+#if IS_ENABLED(CONFIG_FSL_SOC)
+	struct fsl_spi_platform_data *pdata = dev_get_platdata(&ofdev->dev);
+	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
+#endif
 
 	spi_unregister_controller(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
+#if IS_ENABLED(CONFIG_FSL_SOC)
+	if (pinfo->immr_spi_cs)
+		iounmap(pinfo->immr_spi_cs);
+#endif
 }
 
 static struct platform_driver of_fsl_spi_driver = {
-- 
2.53.0



