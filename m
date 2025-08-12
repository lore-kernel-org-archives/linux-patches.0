Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F81C84C7;
	Tue, 12 Aug 2025 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022093; cv=none; b=ttSquHfmGqzPbQCmImhquSJdwej/fEEj0fXYriC+HyvvfcUSNVMw3f9BJgdRb5yPGz0UDB7b/P+0oTZ7Aci6Ty5rI2rx+Iq3Bio1ItKYJ+R8qcBBy668nxts4VZFoLX0XM4ibQK+rfCZR2DZVu4kWRSLFczmj22v/DC/0neiodQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022093; c=relaxed/simple;
	bh=DhmLUVx3zjUpx9wgYZ+LbmHnku/iH3peti+YHpTXEgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1w2sc1U2RfJdHpv8daaqDwLQu/Ezo2Ztkwocv4EYn6bi9yohDVprg3xAT5u5RRwqcw5TX2PlGLUOvYd5Hy2wqNpRlSgWTjY9aZ7rX3/8XlbLifXoUmBil2jFLLF8Ns/fSLuTqhdvwdBf+0zF3HW1aMOtzH9aYBrxapyb0HIyGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf+6Qfe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf+6Qfe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD24C4CEF0;
	Tue, 12 Aug 2025 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022093;
	bh=DhmLUVx3zjUpx9wgYZ+LbmHnku/iH3peti+YHpTXEgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hf+6Qfe9bt5sD0xhXAfSraQQvJgRhGCYjux+0jHKc8yTg4sriZw+juTljnUnVT0X/
	 LeNEp7uYcA1RritdR3h5LHr2pQbrYMAN7qULgq0xZs38bf6c7gbpQkNtv9Si0ytcMZ
	 KihuK8feZslxhtKZUCxAC7Dc44n7dt2s9TBtalL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/369] arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed
Date: Tue, 12 Aug 2025 19:25:50 +0200
Message-ID: <20250812173016.759491702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit f83f69097a302ed2a2775975ddcf12e6a5ac6ec3 ]

The reference manual for the i.MX8MM states the clock rate in
MMC mode is 1/2 of the input clock, therefore to properly run
at HS400 rates, the input clock must be 400MHz to operate at
200MHz.  Currently the clock is set to 200MHz which is half the
rate it should be, so the throughput is half of what it should be
for HS400 operation.

Fixes: 593816fa2f35 ("arm64: dts: imx: Add Beacon i.MX8m-Mini development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index 9ba0cb89fa24..c0f00835e47d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -286,6 +286,8 @@ &usdhc3 {
 	pinctrl-0 = <&pinctrl_usdhc3>;
 	pinctrl-1 = <&pinctrl_usdhc3_100mhz>;
 	pinctrl-2 = <&pinctrl_usdhc3_200mhz>;
+	assigned-clocks = <&clk IMX8MM_CLK_USDHC3>;
+	assigned-clock-rates = <400000000>;
 	bus-width = <8>;
 	non-removable;
 	status = "okay";
-- 
2.39.5



