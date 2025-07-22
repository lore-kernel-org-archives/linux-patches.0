Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6516C2EA15B;
	Tue, 22 Jul 2025 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193309; cv=none; b=To77qfVojCxh+8PqObU9uM0C8FNoL5li0Bn9wVcvm5ondZkdAzzADBOhSLBerVvILeqcvDRFWK5KzePc4DXYBGLvTRWbzoYnWqDGpMj/JuTPtlX1UpLsOG9ue5KhTKrzu899EutX2ztDlJmEmT1EvOtIbY1LbHZ/jJRaClJrtv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193309; c=relaxed/simple;
	bh=xSfRnRqNk6eifYV7VuHca6JObd+O7ZuEqer4Td+zzrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBYcDLPNYq5RRqJFsQ7OxgtJFpqhZv/TbE+E/tXPJYKWF+7pXeKlfI0yZ/ro7PJDjp7hnicypIGyLIhInF6undr+UUbFLg36HqrbO/6/OnNlyF9rQmY2nsMV4xnWe1d2HvDlFzewOpSGmb9G0IMWmRo2j+JTb0JUUp1gS82K1MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3GHb80f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3GHb80f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C1C4CEEB;
	Tue, 22 Jul 2025 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193309;
	bh=xSfRnRqNk6eifYV7VuHca6JObd+O7ZuEqer4Td+zzrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3GHb80foAxZr3P1uSMMLanjEnZv7h5ITjdGt9Sn/S6kM3mJ2I/eCACY41TTVcqvF
	 SxDZqW92AHhgI2kVnN3VQGzLZyTWR/zpKsf220Gz96X8hzfoQXGAlLQhiaaJlqP8pd
	 qFU+rdWKMZzoqJ3oy0eUb9q38ScslgCwdnH0psIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.15 053/187] arm64: dts: imx8mp-venice-gw72xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:43 +0200
Message-ID: <20250722134347.736986098@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

commit b25344753c53a5524ba80280ce68f2046e559ce0 upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 5016f22028e4 ("arm64: dts: imx8mp-venice-gw72xx: add TPM device")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
@@ -110,7 +110,7 @@
 	tpm@1 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x1>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


