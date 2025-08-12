Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE96621C187;
	Tue, 12 Aug 2025 19:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025659; cv=none; b=CmGrWupWCD+Os2M1NMJ47DhkC5xqkudzqFWZLXCNTAvUdV6k5TC/CQ5m0Ddhhdc8ZxCbNux4rWunKjDu+zJ8Uze9zq4T3d4ZAxea6T9JehbIHoyAvnqsirQ+zxT0/XfDJnkyDi56rcmV4YlC66V35G89levfZvg4gWHBc1e+A/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025659; c=relaxed/simple;
	bh=lAXUEWMuYe2InyjfmbC0lCX86ENNTiVp6oN8r74hqFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr5UW3YDd18oVFT/N4HAeiWDCBIhDUdhUJBxRAPtEypAc4f0NgeuKfH1Zv+egQgW/K2yPFXO/Qnz0mu3qamjk0+Sr/D/vGE1yJKnxP94tMyDzIeElTKh3zHt4ueyogt5mUz+DndOvCWmUg9oJVpdB50NuYjOfMUkMRrXt9Vc41k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Coo++Xfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Coo++Xfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0F3C4CEF0;
	Tue, 12 Aug 2025 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025658;
	bh=lAXUEWMuYe2InyjfmbC0lCX86ENNTiVp6oN8r74hqFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Coo++XfyCJlpo0TRtPaO4uhOyh02umtJN9I+cadF2HBqmAMiEJdkFUz/dkqcBFnfB
	 DJU9J74a+VM8i1SOYVR226PkvrSPaChRET57Gku/vHIVwxcOmrt5ebmncb+NCRh7qq
	 IBjGWuZL2HTOfINvJMZJ6ogquLgy5tozP0YqR9IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 079/480] arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed
Date: Tue, 12 Aug 2025 19:44:47 +0200
Message-ID: <20250812174400.711208450@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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



