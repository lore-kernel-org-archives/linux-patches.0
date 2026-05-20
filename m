Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F61356762;
	Wed, 20 May 2026 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295746; cv=none; b=FX5XWkWiLUZnIYfdqL76XB1l7uXIzmQ7k1Lj7Ni8TNrwMjctyZVVBxgVUDsUDcOEUFVILYeKAn6X3Hgorw/0g53qsU6mTKoB4PXcOUk3kM6MPlvPnGMVw97daQu3Plwj3dB8RCfHTX6gtdUHdoy4frzYX0EpoExyuHQZGcqt1E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295746; c=relaxed/simple;
	bh=DXV9cqYB5uEGYyDY0PUbq5MLWVZRHuxqhg8yDpRE86I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zgo4G0xBR23uv1/MuLWkXOMe33Bn5nB15lOIBM9W/ywN6rSIO+6F9WtJcJHwPIbznKRcN5Jn29ng7Len01PllP6kp0dwmH1W36kZ2qhH6qV8w5ttFXAGq1kSCamBjnzy1vh9gwQLrAeGRGX1cvvbwGcLNC4qlpqYmzKxwEFLLm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06UYSOoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06UYSOoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CF11F000E9;
	Wed, 20 May 2026 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295745;
	bh=yjze884ogqeEJNlrgd4p1AMFzYd3URBrHY331Bg2LS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06UYSOoTWYXwgRvzrcjoO0zhevKz3i2czjKUHSrC3xqtZEAz17zSRZ+EYfN8/Kea4
	 CUJyeFBylpss/6HzSBUFN9i8GxfNTfNkbsSlNBd5ARsI8iq+L6uuSak3rR5EYXgDRS
	 H27Y//Nmr8KkL9hwHuyW43we7Dus4iV1pqAnJh5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0536/1146] arm64: dts: freescale: imx8mp-tqma8mpql-mba8mp-ras314: fix UART1 RTS/CTS muxing
Date: Wed, 20 May 2026 18:13:06 +0200
Message-ID: <20260520162200.311768854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nora Schiffer <nora.schiffer@ew.tq-group.com>

[ Upstream commit b8d785a9f360abcd6a6f8f10a2adf222f8494d66 ]

UART1 operates in DCE mode, but the RTS/CTS pins were incorrectly
configured using the DTE pinmux setting.

Correct the pinmux to match DCE mode. Switching the RTS and CTS signals
is fine for this board, as UART1 is routed to a pin header. Existing
functionality is unaffected, as RTS/CTS could never have worked with
the incorrect pinmux.

Fixes: ddabb3ce3f90 ("arm64: dts: freescale: add TQMa8MPQL on MBa8MP-RAS314")
Signed-off-by: Nora Schiffer <nora.schiffer@ew.tq-group.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
index b7f69c92b7748..1665a5030b993 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
@@ -848,8 +848,8 @@ pinctrl_tlv320aic3x04: tlv320aic3x04grp {
 	pinctrl_uart1: uart1grp {
 		fsl,pins = <MX8MP_IOMUXC_SAI2_RXFS__UART1_DCE_TX	0x14>,
 			   <MX8MP_IOMUXC_SAI2_RXC__UART1_DCE_RX		0x14>,
-			   <MX8MP_IOMUXC_SAI2_RXD0__UART1_DTE_CTS	0x14>,
-			   <MX8MP_IOMUXC_SAI2_TXFS__UART1_DTE_RTS	0x14>;
+			   <MX8MP_IOMUXC_SAI2_RXD0__UART1_DCE_RTS	0x14>,
+			   <MX8MP_IOMUXC_SAI2_TXFS__UART1_DCE_CTS	0x14>;
 	};
 
 	pinctrl_uart1_gpio: uart1gpiogrp {
-- 
2.53.0



