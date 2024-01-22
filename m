Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B77605A2;
	Tue, 23 Jan 2024 00:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970823; cv=none; b=uyEBt6YJS5TY0iYhi1ULKrAd0JS58MI4ust4TsGSLKLkZ/hO8Jb3ER9E8xUG324CJXxcjYeRKUvaWHUJWC7L4JifLGDBaVuDBmrl7Kmy5uDhK/9SW0vQgD28HyE+7x1itKwk95PTZmuSQKrjAtR2Ufc9LfEfDg99jasVurLhXYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970823; c=relaxed/simple;
	bh=SLpLVDeIncqqsxhbD7O/0miOySjojGcH5uDz1idnTB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0TviojM9B7WWbYrU4xMZ1udhn7Ou311GL84YJko6SXvpTrKU5Mpq0yWhjbL6Iwi/E+TbOHN9nsJw0Pmwz3BuyFFFfm/fLHK/fIw5CgJlWlzdAWyL4dOqsq5DUpzCcWe2jLd39S+mByULjWucj1PbUXV4I3SyVMQHtv3EiJRYh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRmk+iT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRmk+iT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05853C433F1;
	Tue, 23 Jan 2024 00:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970823;
	bh=SLpLVDeIncqqsxhbD7O/0miOySjojGcH5uDz1idnTB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRmk+iT9oJ1Xc1m8e/niy3a1RwI1nCwKxxNo33k13NJNw/tjYQDWuekcvsEr6lnbC
	 PjjuPtCmGYZNrfoJKrIXak1IBNo8FBUBIkBYSVX7zo/i+l8NdH9DvR9sbcCOSfl600
	 0HaEFcGe2foNvp194CRiG2juGUtBnecBgeDXUKWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/417] arm64: dts: qcom: sc7280: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:54:15 -0800
Message-ID: <20240122235754.713717000@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6897fac411db7b43243f67d4fd4d3f95abf7f656 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 0e51f883daa9 ("arm64: dts: qcom: sc7280: Add APSS watchdog node")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.2.I11f77956d2492c88aca0ef5462123f225caf4fb4@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 4b8777eb96f1..b1016ccdf032 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -5195,7 +5195,7 @@ watchdog: watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc7280", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 			status = "reserved"; /* Owned by Gunyah hyp */
 		};
 
-- 
2.43.0



