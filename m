Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255414A0A8;
	Tue, 25 Jun 2024 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309257; cv=none; b=OREkHzpxNHByScGeYmjIANEuIFZkkx6jjw1scwbnHSrYng8qIgxDV2giSCGG3AURVHnEPw/uc17y/HeYlGRpcXRN6vVVWI+4A6brfmV+e6tiZwDqBbLvE4HQH27a3xtklcUBNBFEOXFwsvMQ5fOtEOF5IqGiJdFEb7KhA1oTI5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309257; c=relaxed/simple;
	bh=YEg/L7GVRXDeI5oVz2Q31U+jENe/fvGA1XCzHzmFzuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9ND/FW8/oemZTa/yPVmB5UqOsPtq7S9seNnp1aPKanMkKstA58rOdKVbf/IRhtXmwfTkVV7l/Vj6cPPk6z2EpPQI5Ojig6/uLnvmbiql7xUkBxwv7hDejCZCROEVaUNHYJ66NAnYkxFyTcgR8idDp0vBEvH/8J7SlB1Ns7g/8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sP7lJ/xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sP7lJ/xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6786EC32789;
	Tue, 25 Jun 2024 09:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309256;
	bh=YEg/L7GVRXDeI5oVz2Q31U+jENe/fvGA1XCzHzmFzuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sP7lJ/xsEDEd5Vl+m7UTP+1w80ZwI7C/9EN0oDS7aoWeVHWfaLprjxeDndUVbkPeS
	 R/JljD/Nm1PNvS4B1v/9PQdNWCpU2/+fvLDpNcDCpX3Rj59//xc19oCM9YGrxaIpCl
	 MZlfBjaeT1wixHJJ1lPqE49eXaXgipc9zlQ63Hig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/192] arm64: dts: imx8mp: Fix TC9595 input clock on DH i.MX8M Plus DHCOM SoM
Date: Tue, 25 Jun 2024 11:33:09 +0200
Message-ID: <20240625085541.663209133@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit c03984d43a9dd9282da54ccf275419f666029452 ]

The IMX8MP_CLK_CLKOUT2 supplies the TC9595 bridge with 13 MHz reference
clock. The IMX8MP_CLK_CLKOUT2 is supplied from IMX8MP_AUDIO_PLL2_OUT.
The IMX8MP_CLK_CLKOUT2 operates only as a power-of-two divider, and the
current 156 MHz is not power-of-two divisible to achieve 13 MHz.

To achieve 13 MHz output from IMX8MP_CLK_CLKOUT2, set IMX8MP_AUDIO_PLL2_OUT
to 208 MHz, because 208 MHz / 16 = 13 MHz.

Fixes: 20d0b83e712b ("arm64: dts: imx8mp: Add TC9595 bridge on DH electronics i.MX8M Plus DHCOM")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index eacf1da674778..eae39c1cb9856 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -251,7 +251,7 @@
 				  <&clk IMX8MP_CLK_CLKOUT2>,
 				  <&clk IMX8MP_AUDIO_PLL2_OUT>;
 		assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL2_OUT>;
-		assigned-clock-rates = <13000000>, <13000000>, <156000000>;
+		assigned-clock-rates = <13000000>, <13000000>, <208000000>;
 		reset-gpios = <&gpio4 1 GPIO_ACTIVE_HIGH>;
 		status = "disabled";
 
-- 
2.43.0



