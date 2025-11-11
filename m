Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF15253951;
	Tue, 11 Nov 2025 01:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825186; cv=none; b=UIJjHayQb1RrtCh6qPGkos7XP9PGGVRThR1TDTG+I9ewY+msRGZH8tSzEHOxZTeRhFXUy/3ui0dwpXOT9ZPOmP/m4DCH46ydnHua0d5n812w1F99pQpcNHmrCqEHZnVpaXosdsAn+lRyva1daCs0BWT4pRF5b/gQmWV/nVzoLP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825186; c=relaxed/simple;
	bh=bRzzm0rCYS0TXclBVXBs05M1kRTf1cQYUEE2ACalUrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqnUokIgGK0m7hyfMHb7zfNGkqb05CBcwQPrh52Qv71yMUtUdg6hCOjuLzGGf/HVQJzOeleM1mbZIrmn3yW8BNCPgDxdx3yT7szGKrsaM7cO6MEzRNcQgRexCbYWGywNfYVquwF/YEsqmzKlI/oq9/Y4vTyYtqCYAYVRf8I4RXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J18cRzfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J18cRzfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF77DC4CEFB;
	Tue, 11 Nov 2025 01:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825186;
	bh=bRzzm0rCYS0TXclBVXBs05M1kRTf1cQYUEE2ACalUrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J18cRzfmu1NUNsMEQNYUMDau/jOLbKu3XmdVoP/mHWVHK9bToQNIzadihMz5eL5tG
	 lfeMXodMdJqyTlGcTKLXMAy/3ostutqRIYzQCIbPyDC12ZRFFkGei7M+crraFmOUD5
	 /JeKaxcz1HPxxuJyeY8Irjwm+O0AHfE1epr/H7m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denzeel Oliva <wachiturroxd150@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 696/849] clk: samsung: exynos990: Add missing USB clock registers to HSI0
Date: Tue, 11 Nov 2025 09:44:26 +0900
Message-ID: <20251111004553.258145530@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denzeel Oliva <wachiturroxd150@gmail.com>

[ Upstream commit f00a5dc81744250e7a3f843adfe12d7883282c56 ]

These registers are required for proper USB operation and were omitted
in the initial clock controller setup.

Signed-off-by: Denzeel Oliva <wachiturroxd150@gmail.com>
Link: https://lore.kernel.org/r/20250831-usb-v2-3-00b9c0559733@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos990.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos990.c b/drivers/clk/samsung/clk-exynos990.c
index 8571c225d0907..7cf5932e914c2 100644
--- a/drivers/clk/samsung/clk-exynos990.c
+++ b/drivers/clk/samsung/clk-exynos990.c
@@ -1198,6 +1198,8 @@ static const unsigned long hsi0_clk_regs[] __initconst = {
 	CLK_CON_GAT_GOUT_BLK_HSI0_UID_SYSMMU_USB_IPCLKPORT_CLK_S2,
 	CLK_CON_GAT_GOUT_BLK_HSI0_UID_SYSREG_HSI0_IPCLKPORT_PCLK,
 	CLK_CON_GAT_GOUT_BLK_HSI0_UID_USB31DRD_IPCLKPORT_ACLK_PHYCTRL,
+	CLK_CON_GAT_GOUT_BLK_HSI0_UID_USB31DRD_IPCLKPORT_I_USB31DRD_REF_CLK_40,
+	CLK_CON_GAT_GOUT_BLK_HSI0_UID_USB31DRD_IPCLKPORT_I_USBDPPHY_REF_SOC_PLL,
 	CLK_CON_GAT_GOUT_BLK_HSI0_UID_USB31DRD_IPCLKPORT_I_USBDPPHY_SCL_APB_PCLK,
 	CLK_CON_GAT_GOUT_BLK_HSI0_UID_USB31DRD_IPCLKPORT_I_USBPCS_APB_CLK,
 	CLK_CON_GAT_GOUT_BLK_HSI0_UID_USB31DRD_IPCLKPORT_BUS_CLK_EARLY,
-- 
2.51.0



