Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CC61FFE;
	Tue, 12 Aug 2025 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023632; cv=none; b=kJ1HkWHmPPweizQ0W0lY0XJTE9+vrQq6oH2mjMQ3N4qH40uARz6ZMZWmLzY3/WZa+i81J/zRyBCmvixhk0HLOfK2sM9klj6z1Nc3DzZPoMM+OxfSupn2dg8jyQ+FHY+RHm5OmyiMgMTjptkxjUrEokSyp8EflOtemfYBgJLYQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023632; c=relaxed/simple;
	bh=8WgV1UU30JQ0ZhzUZXwhwP5wQp+Ul5leQ0C0UidO/UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHghzJxFVdKD6ljpdkJajraw1LFXPilJxlteDlm2Y3LMSGYqDwDXE9pOz5Bdm197fSpdJee0FTyHA2UpwmoBRcnZhep1oFEIBRma/hzgFt+BpbwMLXpiAwdOLEnOSHAKwilpfgo4tmqpvFze5nCtq0iXrNyeYOBZH/TQ14KQLuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNmjH8/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNmjH8/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D28C4CEF0;
	Tue, 12 Aug 2025 18:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023632;
	bh=8WgV1UU30JQ0ZhzUZXwhwP5wQp+Ul5leQ0C0UidO/UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNmjH8/aSSaKrPEFS+Xpin6GBWO8Fv76BF3OgNP7nIf+JVGWNb91I2Hh6noQNDvFm
	 gUYwFlhKORM2W5tTAkbnuz5q13CksnXeBuTC1ee5aCe5+40p8sXcYkT11nYzGcWt45
	 Ql5ykJKDL463KBmQfvTjj9l+j6+AfNh/wALtJEIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 103/627] arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed
Date: Tue, 12 Aug 2025 19:26:38 +0200
Message-ID: <20250812173423.235812367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 67a99383a632..917b7d0007a7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -305,6 +305,8 @@ &usdhc3 {
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



