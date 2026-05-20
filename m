Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41A53ED136;
	Wed, 20 May 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295762; cv=none; b=jifv/LTjqh1nggCJxXmEvM6+D5WWxDKhuW2K7PyApiCfwsAVupHicTn/kLCYToRgAZoyTZXMprgQlBWjSFFlSU1tdWRDpxmHmzTFv7Nty6Fb2smgMymOW2/m16IqA21yudwxsT4smJA3jSWnfc3WBk+4lRV+ND9FZB39bMbjtYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295762; c=relaxed/simple;
	bh=IuglcmGYyDjz6cNHbG5ZRpr6ARS93UAtUhi5VhCwPY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF8evtFcuSX59obPCzo/YYLvtYsn9W2GqlaCCzRJ3Ckv2rHk90EKMFcZO0dv+mCE/6W87h2YUX330An98vqRFkToDIcjUs4LuCLF28pKeGoFY6XhmOYOIIG1lXfa2VgG0XJkrahYYRNd3jj0yhsreUxOWo/Nb9LCvm0M4mkncDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPvy2I6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPvy2I6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3B51F00893;
	Wed, 20 May 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295761;
	bh=Y+KUHhQxU6IWO/m2Ou9Y/iQ74Z5y6vVz06QkX/qOGEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPvy2I6vrUQemBWYGjulbz/WG9l76t1wI5n0Zv+8PtLq2k6TAp+OiAqO2IYLpvi+N
	 /A49l9BkxKprYX/l+z3P+xgWfKxl1jIZk9+mMN8muE1dF4cbXwHW2ZlWKG01luzaTF
	 GbAIqYO28FPtb9fRZbalOmhadQ/niVmv4ORPPzi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0542/1146] arm64: dts: lx2160a: remove duplicate pinmux nodes
Date: Wed, 20 May 2026 18:13:12 +0200
Message-ID: <20260520162200.446965920@linuxfoundation.org>
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
index d5bb55df03216..41c9b4253f4a5 100644
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
@@ -1785,14 +1785,6 @@ i2c6_scl_gpio: i2c6-scl-gpio-pins {
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



