Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018605;
	b=xI2H6M/qWbZyjES8I4gPwI7TAD/+PXpQ93/boS5b/6ta5Hz5K/LJA9tcSgK2D0vqIplp
	 Iu/oXL0JrYUBgzSWOJg2glwIMnwtJeteDwtlPFCVDFan7Ls37P7tHEZMVv5v2qrf9Wozh
	 w96q5MHKECi0aaxfpE/PKiAEV9hJgUm+tGYfXsNwCWuU0IgA2eHkZQ7/xYCObZaVb1cWg
	 ILjqch4H8TyMV5HzF7tTIjgW6TgKeDDYdDmGVAQGP4z8m/babKcZO7D0vpA8Y4nmOXO4i
	 3m+hxv50gTRM5f8D+39B/uAl0+elGLrq2DbBJ0og33Cd3/nsatIrNxHjZnKRFu9pvJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lWMoXfHW0/Vy1YegnO9T03R92O0jlPxtCnbPeg9J5wg=;
	b=b/cwgq1BgSxa0rDwR8Uvt4eML94a32LurPVIMIKaohSHDKzFKYPOV8GjVMKHXII+6bP3
	 PPGkUtpcq3GjzdHYh8js8CIqEtOlJ7y9FmMzta4kqrikHDwV8VlIBea1hNgRLG38QAPCt
	 I1TEe+6WkVyw3wgyS6o0qHg6G4hosIZ89ofWrVpshSVComtfPSW/nFTWz8JwwdrgB/aiZ
	 qXIkMPD+2fIBUsucg628QarLYKbcG6ojljvPijq+dX0yF8Zt+ac+ttXgQxYb5ejHb2mFH
	 7s1WRWorbt3brVgzaFZxzLUKw9qJ1Ez7DLoFzlA/3rORcwt8ZyZ4DS/8mvU1Wvo1kmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pz4CTASQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0CC606A332;
	Wed, 18 Nov 2026 16:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pz4CTASQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409661F000C6;
	Wed, 18 Nov 2026 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018605;
	bh=lWMoXfHW0/Vy1YegnO9T03R92O0jlPxtCnbPeg9J5wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pz4CTASQGJQpLQNyATpz6CV/3wyz5unRPFxi/p/lJJcVlhNvOyh6n5xw4qTEGPN/f
	 DOInOYmhyIbTwvCAU7QDRx0ZdLNYYSXBRU0CVk5kXWZxRXS3UooM6PlGKVm9aRoUd2
	 i5HBXHaS8DeCG50x46PZcrA6WQRrvzmcHr0sezj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1263/2651] spi: fsl: unmap immr_spi_cs on remove
Date: Wed, 18 Nov 2026 15:41:43 +0100
Message-ID: <20261118150333.439166617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index e45816ef7b656..6659027039737 100644
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



