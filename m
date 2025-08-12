Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB9A1EBFE0;
	Tue, 12 Aug 2025 18:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022097; cv=none; b=XoPilZ8p1IlDkjUV1ocRjjZngMaWuppeUph5Kqppa6cfAnWsnSCUAoT0YRlyvdX+jwHAL8g65TScQycoczubMzM7Bn+8hRJLByLYI4CimVHwZb+aRpOMo33Ae6M7bKow5ATUTpvlp/yBbeC4otMrULaRNeTn4F88dLx9X7Qideg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022097; c=relaxed/simple;
	bh=Dei7Ao4yY8laWqZIlK5eO1uJGK7pSImdlghZFTJbVPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDIriuVqU2EhdEy0JvYunNlpNMckx5h7GsfbUeI2ixrWewskWFmv1Ezcvgs8xGamfYNm3tannGIccmiEbon9Hb9CkM7SnMM2Rh1SuSFQSfkbsJMtT1Ptb65gM+KBtt4tYBfMDPxB5uKHlG366HS8hew/2WOmbVmE9BYulXMtHuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgbvJ+mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgbvJ+mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C761C4CEF6;
	Tue, 12 Aug 2025 18:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022096;
	bh=Dei7Ao4yY8laWqZIlK5eO1uJGK7pSImdlghZFTJbVPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgbvJ+mtcGf1sgWbGjZOTF1D7D5JQCb5vUcJVGSbbt17sa/e+uWc/egGCYmVeIesN
	 f6608tzc94H+57zXEOxsGny1UV27EbAxQCOKYLwe3X15y+ZHkxdvR4jKn322ioTdQp
	 R2ZMuZCGqkdOJpuuP+T4kMwjNjP3DSgeboKUMEWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/369] arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed
Date: Tue, 12 Aug 2025 19:25:51 +0200
Message-ID: <20250812173016.797581829@linuxfoundation.org>
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

[ Upstream commit e16ad6c79906bba5e2ac499492b6a5b29ab19d6c ]

The reference manual for the i.MX8MN states the clock rate in
MMC mode is 1/2 of the input clock, therefore to properly run
at HS400 rates, the input clock must be 400MHz to operate at
200MHz.  Currently the clock is set to 200MHz which is half the
rate it should be, so the throughput is half of what it should be
for HS400 operation.

Fixes: 36ca3c8ccb53 ("arm64: dts: imx: Add Beacon i.MX8M Nano development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index bb11590473a4..353d0c9ff35c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -297,6 +297,8 @@ &usdhc3 {
 	pinctrl-0 = <&pinctrl_usdhc3>;
 	pinctrl-1 = <&pinctrl_usdhc3_100mhz>;
 	pinctrl-2 = <&pinctrl_usdhc3_200mhz>;
+	assigned-clocks = <&clk IMX8MN_CLK_USDHC3>;
+	assigned-clock-rates = <400000000>;
 	bus-width = <8>;
 	non-removable;
 	status = "okay";
-- 
2.39.5



