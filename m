Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2C6239E8B;
	Tue, 26 Aug 2025 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215731; cv=none; b=FWersWuo9hTaNn/5YbIiPS4KYfLjfS9oFQ8ffJXuZ780rnIn2dlPtdLX0wv6T4KX1WVPjGxvYPnaz6WRZmuaF330zAMcUgl+jQSbLGmXGoMFexLdSLJViWrF6oZvS5JTHRq597t6i/Wl9B+5PO0NLxNUWaDY4Em2n5HTOz0+VqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215731; c=relaxed/simple;
	bh=J4a12ptnIE2LlaQ73H6xcKtsmT94d7/6x7muTYrC6D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KirR0IRUqeUS0eEIv/8H4Wh+cYl8E+EiziOjMsTJYituI/6VzEmEt7PZmmp8MRbICz6bZ6gV9Aj2D6QNg2qEwRXFQj2i5MnGUuWAPdIwLUuiwkfCtr9pj1g5Rdk/GJq3Ma/+gk+DE26EyFFlDQLoshSxRfuGOeEOQJ4XAEs4rqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zy656NOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zy656NOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2829C116B1;
	Tue, 26 Aug 2025 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215731;
	bh=J4a12ptnIE2LlaQ73H6xcKtsmT94d7/6x7muTYrC6D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zy656NOpBe7jGPaAC4h7FdKVwbueSPpjnU4dWPL1605o9QnM0c3yGUPdp+DXdB24m
	 GxJoAx8CkPa13K+r8vUcN14h6VmiQ6KMsyb8s3ePDoIi5s/7OD3x4PCiebf7/PON/Y
	 7TjU+XbD8ZJuR+g9xJ2M4JcaJjDYz0DAtmu5b/Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/644] arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed
Date: Tue, 26 Aug 2025 13:03:38 +0200
Message-ID: <20250826110949.661013550@linuxfoundation.org>
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
index 4c339b06c87e..d197319e3b58 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -296,6 +296,8 @@ &usdhc3 {
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



