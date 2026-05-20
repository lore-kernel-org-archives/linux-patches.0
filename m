Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF603DC4DA;
	Wed, 20 May 2026 18:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300781; cv=none; b=bDpUpl69B7ieiFP9Mdw0iyf1iOSd0TJpCWZeRH3WW1L7C2HfgXFSF8TjtJigqcLeqj8vAyBzwv2Zf5+dpvjHPtSHQb4z1oHwrpbHwdMrEBmsHnhbDpgz4hsgRuyL/4EtyIlVI/UJNqn9PhsVXTjIv6pn3Ej28gOm2l2diYVp/J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300781; c=relaxed/simple;
	bh=33ddhXSqs/FW2rbSy5xGH0IEOqhwXoJY8jjNlDmEt2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0TKJc+jJsd9UiatsQYF6x054c8WjG0QpbkIW2MAu2CI+/nw0BimKCNqDARdJVEA9Miu0zh6f5K44RjDXsxmzZoTVTiGmrf40A8UArxrDDFRA6n+DgEv27KcYDvYTNAdIgmnWHko2BB62gATNo0XVAWkkufce8at8IzsTRSn26c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk++BAFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk++BAFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1138F1F000E9;
	Wed, 20 May 2026 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300780;
	bh=oU/iEFag4dMSsdZlIAbUEYbhYv1OkZ4Q6fJshkoBFeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tk++BAFyLlGi9oH8QxdrRn82Lv3aEaZ9/0eM+DKZtFuUqXt3Yrg/VsSXJJBW9tw7o
	 GYe6wZJSqXIHgt2fbfUVI59fhJCJduim2WWpDdl6BLa+BuWRvOFsn5/eVnNBw1H2Jj
	 AV+pmYOCa/UmDzSVNJGONjpmt+I3dSb7N91Rl65I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/666] arm64: dts: lx2160a: remove duplicate pinmux nodes
Date: Wed, 20 May 2026 18:18:29 +0200
Message-ID: <20260520162117.675049601@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 325ca511ca3dda936207ce737e0afe837d45a674 ]

LX2160A pinmux is done in groups by various length bitfields within
configuration registers.

The pinmux nodes i2c7-scl-pins and i2c7-scl-gpio-pins are duplicates of
i2c6-scl-gpio and i2c6-scl-gpio-pins, writing to the same register and
bits.

These two i2c buses i2c6/i2c7 (IIC7/IIC8) are configured together in
register RCWSR13 bits 3-0.

Drop the duplicate node name and change references to the i2c6 node.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index e2c32f5b6a521..599d7d4a4c573 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -862,8 +862,8 @@ i2c7: i2c@2070000 {
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>;
 			pinctrl-names = "default", "gpio";
-			pinctrl-0 = <&i2c7_scl>;
-			pinctrl-1 = <&i2c7_scl_gpio>;
+			pinctrl-0 = <&i2c6_scl>;
+			pinctrl-1 = <&i2c6_scl_gpio>;
 			scl-gpios = <&gpio1 18 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
@@ -1781,14 +1781,6 @@ i2c6_scl_gpio: i2c6-scl-gpio-pins {
 				pinctrl-single,bits = <0x4 0x1 0x7>;
 			};
 
-			i2c7_scl: i2c7-scl-pins {
-				pinctrl-single,bits = <0x4 0x2 0x7>;
-			};
-
-			i2c7_scl_gpio: i2c7-scl-gpio-pins {
-				pinctrl-single,bits = <0x4 0x1 0x7>;
-			};
-
 			i2c0_scl: i2c0-scl-pins {
 				pinctrl-single,bits = <0x8 0x0 (0x1 << 10)>;
 			};
-- 
2.53.0



