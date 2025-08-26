Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E54834166C;
	Tue, 26 Aug 2025 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217292; cv=none; b=GcW5SozJ6b24D+vn4BLyc57Tg0QivexeYOT8XY8bL2iyLUMzvCWWV+YEDmv9lewWG/69gJ7k7XlbsZpKaPqxzksWsibbeGtamTY4pssTQSL1MZFpC+d9gbFB4g5FKr++7HUuKQ+4p6cz/z/Gsa2xkKn07t8FLFMWZiHgI9Ik9Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217292; c=relaxed/simple;
	bh=8kZGdpjzPVk4n6W0fWvYpm0tdRmqYeyfB2mPH3aS35c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYIhVgd129Gl7XeQN9PuV3vCI9SrKVI0n1Shs0zsR/mkvSktMlSnx5IxZvvgKe3nOHfIpIq31EMbLbf7+iaBGmJFWy/WNBcp4YkIG1kVFNtf+PU1BvkUfjTmOyo8MfpIliMDz3qnVHQaE1jV6uoWK5GZc6fO7yvRQZGzcshxy0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpvMHmwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpvMHmwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20194C4CEF1;
	Tue, 26 Aug 2025 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217292;
	bh=8kZGdpjzPVk4n6W0fWvYpm0tdRmqYeyfB2mPH3aS35c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpvMHmwOeBX43FnqgteJiEPkjP1JmvuL2NhirCm5yDP4y3jXKpHNjLwGS2+B5hJbQ
	 QOetunkbZfm8zz5tg84IMUE1gp28O+P4AdQ8/Z5GPkGnH/E7urZXRvvGCIWjEGDCVo
	 6W50JSYkUDM1ssiTnPKJLiTShrzLTR8C2narg0bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/523] arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed
Date: Tue, 26 Aug 2025 13:04:58 +0200
Message-ID: <20250826110926.724050434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 34b2e862b708..f97e8a8fd16f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -246,6 +246,8 @@ &usdhc3 {
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



