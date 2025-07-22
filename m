Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D703E22CBE9;
	Tue, 22 Jul 2025 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192748; cv=none; b=mlFMbmSVs6RC9ix/Iy0fHteS0XP19r/wM4JET1/o97bxkV3uTZhNZ95t/jzW4FqZ4PlVCQWzrrYUOFrb/hLF5EiMensVi3qWWZUJKNVx3ON0n0H+CyQBTgOnzpMTqL9njfFBFvBortGDnUmfUj8CxwiYGlK0hZmZFJulsn+DZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192748; c=relaxed/simple;
	bh=ja20C41F31KUmXNikW/Y1Mix4uV/HpSeqlAJnyX/jCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSYtOQQjaD9AfRIST8AeexcQCNjzjAziyd8hvJqxC+OpkDVFU5p9DuGBUiRkZiZV1s+9ygd7AW9aKW7mhS1tbRhOaTcMnDqr62Int/VZu5vCkFDjs93S7nMmBYVBMM3BHktIB9GqEWMMHrvC2ATmEWEWlhwEXEWsUmOwVSKhD6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m78upNLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m78upNLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB30CC4CEEB;
	Tue, 22 Jul 2025 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192748;
	bh=ja20C41F31KUmXNikW/Y1Mix4uV/HpSeqlAJnyX/jCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m78upNLyQSDZ+W9990Kfl7Ky1DDIgwkMG6nmqZv6vfClR5ako7jkYyoRyNjMSBqhY
	 F3w9CBh8beDpQKHzzDQHwpG6bgZNf5xLIDrxxtRFtQ6FI0wuxb/7Ig3dRNkK4vqiVL
	 hfqmE/3jjhpmsJyJ1E8574qu4pM2DxcK6qPwMRWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 046/158] arm64: dts: imx8mp-venice-gw73xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:50 +0200
Message-ID: <20250722134342.457407777@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

commit 1fc02c2086003c5fdaa99cde49a987992ff1aae4 upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 2b3ab9d81ab4 ("arm64: dts: imx8mp-venice-gw73xx: add TPM device")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
@@ -122,7 +122,7 @@
 	tpm@1 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x1>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


