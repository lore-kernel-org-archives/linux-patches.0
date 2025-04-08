Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3725374C4;
	Tue,  8 Apr 2025 11:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110825; cv=none; b=M+tFheS+JOkULSEHXbmb7es0uDT/gHgGudFm3uiQ7/Llh1/rt/0MHLiF6YRQpdqNroqzHWTlHEVqQ4MLWxwrMefT9CbqX3WSH8ZvHu+jqoILB2PJMdzCqY5GEDlSfibzt2B1ZhgTkDv4imByVI9jPWTjji3j+cBm/aDB7qUacYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110825; c=relaxed/simple;
	bh=ZvP1RfnM4BTWKEcZYiw+EOGAxwq7NgHoNyBctC6LViM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4F43fdKq8MKrhks8EehkH3TLHfpJ7n7mFFThGlE5BhlEj6fiCr4Mt4XV3duC9AhyDdyoEPHeZHkThonRQnNpPqUis3BJEajnHqa9xb6nkDko1JQM1xfBGGgnH0ygUVFS5p8wVjWU42Z3iKsvOJJaQcqueUiIC7yQtYVljsx1/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJNcwnsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJNcwnsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43129C4CEE5;
	Tue,  8 Apr 2025 11:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110825;
	bh=ZvP1RfnM4BTWKEcZYiw+EOGAxwq7NgHoNyBctC6LViM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJNcwnsasjxyx3hH9FmnOwVyJ3qiBKJPMNZTRTSVelQ0zCmT+bJVU/K4w14LKql2L
	 t2W11eUWhgHwcSQ6HU5U5F4PM42mSJyRWBYO1CA/SymERL158eKrnJ1N114Rmc31YA
	 n8vdEb1lrRsn7YEJ0YvWSucHMqcLqrEvWS0+ZkOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 171/731] arm64: dts: imx8mp: add AUDIO_AXI_CLK_ROOT to AUDIOMIX block
Date: Tue,  8 Apr 2025 12:41:08 +0200
Message-ID: <20250408104918.254223974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>

[ Upstream commit cfe47a3d3f7440cd1bdf2a169b325257eba01534 ]

Needed because the DSP and OCRAM_A components from AUDIOMIX are clocked
by AUDIO_AXI_CLK_ROOT instead of AUDIO_AHB_CLK_ROOT.

Fixes: b86c3afabb4f ("arm64: dts: imx8mp: Add SAI, SDMA, AudioMIX")
Signed-off-by: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index e0d3b8cba221e..86c3055789ba7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -1619,10 +1619,11 @@
 					 <&clk IMX8MP_CLK_SAI3>,
 					 <&clk IMX8MP_CLK_SAI5>,
 					 <&clk IMX8MP_CLK_SAI6>,
-					 <&clk IMX8MP_CLK_SAI7>;
+					 <&clk IMX8MP_CLK_SAI7>,
+					 <&clk IMX8MP_CLK_AUDIO_AXI_ROOT>;
 				clock-names = "ahb",
 					      "sai1", "sai2", "sai3",
-					      "sai5", "sai6", "sai7";
+					      "sai5", "sai6", "sai7", "axi";
 				power-domains = <&pgc_audio>;
 				assigned-clocks = <&clk IMX8MP_AUDIO_PLL1>,
 						  <&clk IMX8MP_AUDIO_PLL2>;
-- 
2.39.5



