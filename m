Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D722139C9;
	Tue, 26 Aug 2025 13:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215702; cv=none; b=PQIiwjlhRF0A4gcBK8+E8+nE+WR5jm6QD62YbV3i45NayfRSE5Q8kJzfkN+C1G2l0m5XGGiamc1Ell+AcTbgTQNBQP5uR7x3c+6m0z8vdHf2qt99ZAOxKrBS6vqUJRLQRtBkigwxrPrsR/7wCVtlUfHI0N4iwtZEwebONlJDrLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215702; c=relaxed/simple;
	bh=DMI8fGjyp0P/NrFE2l7MhN7ev9YWtJKM3N+zmikD5NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/g6NKLdTRVyIRKd91VD9f4bcTI0F8nomBDk48PIMfQ0VXQcby6COawT3MfODs6nvEwQpxDmy+P66PyL+wH/QrqHaAFHyISPhoQU4bC3XYiFqs8mDln2cNgahfgFd1M7U/o0I+e9oaVsq6S0OkaeDo1YzueEw93CTQZrAClwwXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brR65uXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brR65uXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09488C113CF;
	Tue, 26 Aug 2025 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215702;
	bh=DMI8fGjyp0P/NrFE2l7MhN7ev9YWtJKM3N+zmikD5NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brR65uXeNG83v/te11o4QI722+VLCYUEHQ+hAAHGpQMaoaN2fq+hMF1P9TMHB4c4F
	 QB3OgTUnQc52SeTiXLdsOp9eaF1/KpMgM8GDhCu77ngZPkOpWp3DGllk6+3xF96NzP
	 M5zCiTuyyJhHyxBAr79eMfQ8FulIZDfx2jkrWVU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/644] arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed
Date: Tue, 26 Aug 2025 13:03:37 +0200
Message-ID: <20250826110949.637932484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7ed267bf9b8f..c4b97cbb55d6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -285,6 +285,8 @@ &usdhc3 {
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



