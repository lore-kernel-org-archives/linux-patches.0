Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5722E1724;
	Tue, 22 Jul 2025 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193302; cv=none; b=cVl8rk9ZcncLCkaxLNmG5w0gKpoC67SGCw9hk/EbIKRcf+iF02IGggvEX0lXqmpB75zFTQULDG7I16wU8QKmkkVMMlsAqyGqSghYVsKq2Rq24boQyo1OAvnfZMjmK2d/DbAkwevrDaUNgIFUGS0wJKa3XDt+3c2LhXCFcg4XarM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193302; c=relaxed/simple;
	bh=cPKNXm8XnPreJ+rOGMPXM+ditlnMgTvgXk8jXeL0h0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9S51aqIunTSq2LP/W2hyClW0FyMrLYc+Eb6qp01HQRYKzhTj5w95a3d+XLlxqkGFsFxwUxP9KU1aer6ZHe7ecLB1nIow68d+YDmPQl0LCazq5tdHRisBI/F8KNv0uwuFRV8wViMCmSAAqyt9gOOYANaaCzqFWFH51R/rmtae0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5+mTzA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5+mTzA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3E7C4CEF1;
	Tue, 22 Jul 2025 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193302;
	bh=cPKNXm8XnPreJ+rOGMPXM+ditlnMgTvgXk8jXeL0h0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5+mTzA8umaCMOWmbVihhTPR5gxLSMjgi20cHZ2Kqd2IoB7J9hJTXIXaq1bMThlQV
	 8qNHRRTnH/sBJ8qaWvxWYzl64E6rPHs533XmJjrqe5IFrULcaeTlvtV2hULyc7rxez
	 9DC6+OfU1qugmSTEQBn8DaF5mQB+JzZxKYSYA25M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.15 051/187] arm64: dts: freescale: imx8mm-verdin: Keep LDO5 always on
Date: Tue, 22 Jul 2025 15:43:41 +0200
Message-ID: <20250722134347.660630963@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit fbe94be09fa81343d623a86ec64a742759b669b3 upstream.

LDO5 regulator is used to power the i.MX8MM NVCC_SD2 I/O supply, that is
used for the SD2 card interface and also for some GPIOs.

When the SD card interface is not enabled the regulator subsystem could
turn off this supply, since it is not used anywhere else, however this
will also remove the power to some other GPIOs, for example one I/O that
is used to power the ethernet phy, leading to a non working ethernet
interface.

[   31.820515] On-module +V3.3_1.8_SD (LDO5): disabling
[   31.821761] PMIC_USDHC_VSELECT: disabling
[   32.764949] fec 30be0000.ethernet end0: Link is Down

Fix this keeping the LDO5 supply always on.

Cc: stable@vger.kernel.org
Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Fixes: f5aab0438ef1 ("regulator: pca9450: Fix enable register for LDO5")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -464,6 +464,7 @@
 			};
 
 			reg_nvcc_sd: LDO5 {
+				regulator-always-on;
 				regulator-max-microvolt = <3300000>;
 				regulator-min-microvolt = <1800000>;
 				regulator-name = "On-module +V3.3_1.8_SD (LDO5)";


