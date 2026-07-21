Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEECE46AA9C;
	Tue, 21 Jul 2026 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648319; cv=none; b=TYZOnqKDjecY3h0tsr+moaRQbt3rxYXbVCzReBeFrKVbpJzbBEqhrvownknsckNuLSkqCPE2wJc3TAPOi9f1pZQk98y1bR8zdl3LvHz4glCQmbLwcXuGGWlFOFVVz5Y7CAGj95/SwquH+gJQ6boBA58X2qKF984WtAD+QrYb1uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648319; c=relaxed/simple;
	bh=2VBb1+chxUzaRkFG3hysTOEltm3mWqsIXuwZvYD4IEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDs9PYgMkEzb3GuxeGtgOcw738OPuFnQCmZWNOfqsS0LjS0VEBl3jl8bl8FFdLYR9FJJ6TmrHdeTkfuZh+xyEr1ehVO1GQvG2HZzqKh+A+j5X6sk3aJHFwZvYZI0tg5s67OBRMYAuXZjLj8BUTzB5hO8Sy3Kjsp6Di5bT4L8uRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osmBx4Wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osmBx4Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513E31F000E9;
	Tue, 21 Jul 2026 15:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648317;
	bh=h922rgH76Ohtt5FX17WvR3MNnjLJg+4ObIuraObMi2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osmBx4WxaQYDl5BpRak8dDM7fL6NcRtLnHj8FsK/S7JKJrkPO9TbCTd7ieokxSIgp
	 Ng/Zfvg34iznOCjefihvbVIH9iG50VZELooHKriywCJQJ9OMUxq10ZLIO/masm+8r6
	 Y5jY0fPQCpTEtN8KjwmauTU/mbS+H7+q3fIWfiHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0154/2077] arm64: dts: imx8mp-ab2: Correct interrupt flags
Date: Tue, 21 Jul 2026 16:57:07 +0200
Message-ID: <20260721152556.314687323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit eb27f9b9a4b2965f8d497a3c565cfbc2473c184b ]

GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning:
1. GPIO_ACTIVE_HIGH = 0 => IRQ_TYPE_NONE
2. GPIO_ACTIVE_LOW  = 1 => IRQ_TYPE_EDGE_RISING

Correct the interrupt flags, assuming the author of the code wanted the
same logical behavior behind the name "ACTIVE_xxx", this is:
ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW

Fixes: bf68c18150ef ("arm64: dts: imx8mp-ab2: add support for NXP i.MX8MP audio board (version 2)")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-ab2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts b/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts
index dbbc0df0e3d1c7..443e4fd5b9bfc1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts
@@ -281,7 +281,7 @@ pca9450: pmic@25 {
 		compatible = "nxp,pca9450c";
 		reg = <0x25>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <3 GPIO_ACTIVE_LOW>;
+		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-0 = <&pinctrl_pmic>;
 
 		regulators {
-- 
2.53.0



