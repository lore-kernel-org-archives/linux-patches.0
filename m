Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030783;
	b=DsQrCtDY81f0oaWm5HtMfuG8/GXFOhYubFL9ad661TJb2uBSSxPJAW9qqZn4LgEYErOX
	 qEYh32RXrblpUaqyGNmljYKtlWv/sYMGmgBwBTBHzbF/FJlL2++K3JyVUkggciRGSxN3R
	 DJRPpYGK3EgLtDt6djB4v7rput6wJOyYjaLLjxmLMHfk5wBRscb/s4icmM5b0UwTPzMge
	 WYjYB6lWm4caAYdX3OqeCYBs6yAQeXaDy2hJU9ZZPLeKrpE4UkP2xEugDEY0HVo+PFJoN
	 yX4MQjfLYQi5RzqgNfpYbsoUaM/5Gycv68rtWkPVPc809UWToldfuamPJ2ZxcrN4GCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PRw/FuabzjZTWXhTAXSrzkAF5nIQFV66FWoY+PAMqbU=;
	b=svjYfx8W4JMNcY952Zo2ttdIdko2hlmlM0tSMhoYbumJ/RpwV1qsz7N7DvgOvpHERWmC
	 Vv0oiYZYUBKeYBI3mvx0EZKWv2GR2jxaIxb7qwEKn0/diWVBtdoguxPmBeTKemFylBLgH
	 O+NXSmyfaEn9KUBPn3eZWglE8U/kh11dxtTEaoKiPi3jzwJXvCCjEydbGcngE2oTtMYHZ
	 721H08kkjq9SFVaSVlBfcnLUEX+8VSV4LsyCjtxL5Am12KiTUuKLbArDMrjSeTPiMo2Jg
	 nDaXL+sXp/OO7Du7l4MLfT41rRRu1X8VxQHCrkOHKdpUkQJSw5NjjZ+bJkLWcWkSMGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQfQZceq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D9F606A93A;
	Wed, 18 Nov 2026 19:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JQfQZceq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077681F000C4;
	Wed, 18 Nov 2026 19:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030783;
	bh=PRw/FuabzjZTWXhTAXSrzkAF5nIQFV66FWoY+PAMqbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQfQZceqvht6MZvjQ1v4cfjmsiWIO6cGTsniMUu1BfIs9VjRdWC9RtxSDkzrtE95K
	 XGvF6h+lKPRWtYVHxLfJ9jHie7IU986eu0F/am5QC1Qs6ImHpyVeHDRf9tVxry6jd2
	 pGJV1XlXzpYFZ8/s+NY/Ac89WGzGlgALSeSfMpZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0826/1756] spi: fsl: unmap immr_spi_cs on remove
Date: Wed, 18 Nov 2026 15:49:13 +0100
Message-ID: <20261118150042.411198219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 94d81f6163bea..42dc40242b9b4 100644
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



