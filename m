Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8E2D46AC;
	Tue, 12 Aug 2025 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020952; cv=none; b=LY1t2yp/Sf0wziAvOHT/brMWAWx6nkTCzL1TC8HBzG8CWYVmYQbwL+AAH7zCXQbXvzQAc+m0OmJsCL63BHGRhZMTXkC75muo5941IyYajC7C6jt8HpRGUeQr+PQUEuQH+ALj4wPOCCkSWuwHzxG8rotbrOQAeDn2A4/v0WmX0+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020952; c=relaxed/simple;
	bh=2fYHmjjQoByqWcAif2I4o9Me25uFe/ImjvBEtNCUp30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0GRKJ7erg5LOJTKWy6CABXpoj5IFsvuHqRjAJ+kJMCaqEbHk3I80055nt9Oyf2QDKYHHS1BnbNAAKO20hTCxou8+bBj3J8Ed+b3VrXPW9w5oIvxnlBtP4ghyIREUxqMxUsEv55O+bdGT1h5pkpiSGdZFhAPKYLej+w3rXDfVZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMZIFDQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMZIFDQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BBFC4CEF0;
	Tue, 12 Aug 2025 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020951;
	bh=2fYHmjjQoByqWcAif2I4o9Me25uFe/ImjvBEtNCUp30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMZIFDQIp1tWdutTFnWGzJCWHNsKPhfsOqLmzylNUfBqlM9wxEMXpHxjGSsWxrea3
	 Y3kXItubHhx0b/hqdMCjY3d8mopTmoGbrVF4GlGVh1zD6UjdhTesEE450lHcTGSnOx
	 ATTZMRpcFQa+wC3PWcxlWJO2XBZlUSLp61L9YxEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/262] arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed
Date: Tue, 12 Aug 2025 19:27:04 +0200
Message-ID: <20250812172954.499565938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab0e45f2ad3..f93c2b604c57 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -284,6 +284,8 @@ &usdhc3 {
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



