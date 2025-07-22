Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8ED22CBE9;
	Tue, 22 Jul 2025 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192741; cv=none; b=YF6ZXUxybe6AMV/ryPlFULskkjHXHGJgDPBv2GgBt5DSCsBeS3lbkeQ7CoCr1/VsMKLowM3OaqMraEJRzP0JzFcN0IAPJ29s1P056GmtHVQWoF9ZBCEMdz54Ozwgp38lJ6MIxDamGucAWq+6FgjQ3L8qckb1XyGnZgH99xhGPQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192741; c=relaxed/simple;
	bh=oHRxizxfwYizJGNRYgeFhGw0N4msBtAciVJlPDUnmvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLHqGLMz0jGX159rnVs/qAhEzEXovqbB+8Z/fyJe6GeQ1uq8eQfV56/oFK0Cz+Dsps1WyAAzJeX91cei8z2gaCbHZB07WE2dAkBMwZHEEQa7Qx4z/fhQwRPKLkpn52e8c2SypNhrhwiNkmjfaVftuLxnN6MWVPbvfHXAKSnSSv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFsV4r6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFsV4r6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CB8C4CEEB;
	Tue, 22 Jul 2025 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192741;
	bh=oHRxizxfwYizJGNRYgeFhGw0N4msBtAciVJlPDUnmvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFsV4r6Dqg/gAo7Ohnc1ZSUPYYoyIPBv/apbmZhojVL3IJDhOzwLjC85jXH3p2TZ3
	 G74sAehiWjEYQqSSpDxo+uf1klLZdboCwvHWhss4J245dVjcJnV3lw6INvhiIlH2as
	 MGdeGFl7textkCIT1CPOD9f/pUBUSytXL5dPDYG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 044/158] arm64: dts: imx8mp-venice-gw71xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:48 +0200
Message-ID: <20250722134342.385110787@linuxfoundation.org>
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

commit 528e2d3125ad8d783e922033a0a8e2adb17b400e upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 1a8f6ff6a291 ("arm64: dts: imx8mp-venice-gw71xx: add TPM device")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Link: https://lore.kernel.org/stable/20250523173723.4167474-1-tharvey%40gateworks.com
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw71xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw71xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw71xx.dtsi
@@ -70,7 +70,7 @@
 	tpm@1 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x1>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


