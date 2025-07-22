Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C342EB5D7;
	Tue, 22 Jul 2025 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193305; cv=none; b=nwVrRmQfpZZ+PrJkG+DwFw5f7nloUwLEpzBzobFSvso+PKPnpr5H/pNfucb0gB/s38DOK5W0qrwuTCfNX4P4OoCbRQ37szA9fDYpv+kkzs7QzxO+zeLC4nntEILVAVb2IjtpMhQSjnwEL1sWkI/aj3WZiHR3KUGHgzWCZy2ONh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193305; c=relaxed/simple;
	bh=MrCCoF+UDcRaDC6qgz//axv9hp8SZm0mr183RY9rJwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSeEeF0jEJ+lo+d3aDtWgavA7yc/5dt1ageDk5z4O4N45kz9AbIm++rvUt7lYviCqeXtu5pbJMgRFlDvsi/mHBkRV5a2h6vXMDkCH3P33bGpfLkQ5z0nM2QyCzft0RFWfIoIIKGN5w9UH1BBS4MSmDgIcnRNPX+cbaiZ9fjBnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdNCQxUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdNCQxUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C1CC4CEEB;
	Tue, 22 Jul 2025 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193305;
	bh=MrCCoF+UDcRaDC6qgz//axv9hp8SZm0mr183RY9rJwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdNCQxULhfLdFLUeGDv85KPUwa1UbHIvdC3/61iLW939G9fo0zStyhCFLpFtM6NiU
	 r/HCSBpKU74CmLYPlz9f4ND1WrpZxfE1qI2dChT55cg9vcG9HptyHCT2vAXYMHNjPy
	 SZllWddflTua01eouyrwXOHpyP07EXO5uHA3hpSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.15 052/187] arm64: dts: imx8mp-venice-gw71xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:42 +0200
Message-ID: <20250722134347.695407662@linuxfoundation.org>
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
 


