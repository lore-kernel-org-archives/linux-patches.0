Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B891E5B94;
	Sun,  7 Sep 2025 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276893; cv=none; b=TPKVqLu8MHX2ypG9tvuiGxB9YuFw71cEjxy0R8IILEvuaJxZCAcKFGUJtwF62LiloTjsT/fZR33OmeEdp72Hjl7LS+/8SxrDFmCDqVOtFg6kz9iTdyKZ5Y/AGVwUdsOacrz/rd7PVL76MK1Mda/GIsCE5SOQuKakNXnmyaKAywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276893; c=relaxed/simple;
	bh=0/SgVu0fLXxx0j9Jz+X92PTp0xSImuKmlrJ8HQkxUUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIG34VzDiQOaz87QcK1UPL3HCxNX086rmZqSzDafK2ZnAptDXSJzMW+cna00UkEAm9I4WhG2fvi+2EjnddQRTj5pdY4myq/1vRIgbliRIo651aUhNCzEynvOWmV3MHf36STFkOvNhhsAogjkQPEVAaS+46LBYZ7gt2Cd+hMDxC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/Dio1g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/Dio1g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AB6C4CEF0;
	Sun,  7 Sep 2025 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276893;
	bh=0/SgVu0fLXxx0j9Jz+X92PTp0xSImuKmlrJ8HQkxUUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/Dio1g4zNliZEGMLKS18kjOwfieCSrd1uQjk5oFvgmCe7VZlUNx/m/5iU/1jYjXC
	 7SUg83YGxlNVPd4TbqCTVTj4IBWwaTnrbTgehyCyf+dgY59a9w0Yubs13R9IyD6kHs
	 YdTgySVEiwKOrHSLYB6Gbparm/hljUVwt/4cRtZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/175] arm64: dts: imx8mp: Fix missing microSD slot vqmmc on DH electronics i.MX8M Plus DHCOM
Date: Sun,  7 Sep 2025 21:56:56 +0200
Message-ID: <20250907195615.384370727@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit c53cf8ce3bfe1309cb4fd4d74c5be27c26a86e52 ]

Add missing microSD slot vqmmc-supply property, otherwise the kernel
might shut down LDO5 regulator and that would power off the microSD
card slot, possibly while it is in use. Add the property to make sure
the kernel is aware of the LDO5 regulator which supplies the microSD
slot and keeps the LDO5 enabled.

Fixes: 8d6712695bc8 ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index a90e28c07e3f1..6835f28c1e3c5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -609,6 +609,7 @@ &usdhc2 {
 	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&ldo5>;
 	bus-width = <4>;
 	status = "okay";
 };
-- 
2.50.1



