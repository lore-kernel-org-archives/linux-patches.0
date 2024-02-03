Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEDA1C2BD;
	Sat,  3 Feb 2024 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933824; cv=none; b=dwPX+J39ZqGBU5afKhdVIkcCftdnPFVn1zEH5ku5UmvllTFs9YJJuF+IIRrrXAmMMv/0eBPWPFO1+kDXj8F4oJniWBQICBzE8phOs+Hw3GI5sQ+zHcbMm02qY6GqtBro6Vi+Grw2UXr7zDq6tiVNqpTYjyiAW6UT/WMzNjAijyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933824; c=relaxed/simple;
	bh=GZQD7oxdAUBL72alCUMzqPaIc1gvXqbWZOVZ1qf/HTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD1qDpj8v0B/SmPdPl96zj8yDH2VaMb6w040t0OgOX2cDpJfxnOcBrfeIySnLJfP30fHmwx4h0nqanfHRo3AqBBDF/xyVJMWn9mcB7qBFxSrtly79fv69FzA9JBui9WnjxrtzFXpoiwH9FYnNzXpxIUpuaIyZ28IBUOgRsrPXGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQtVojlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQtVojlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728A9C433C7;
	Sat,  3 Feb 2024 04:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933824;
	bh=GZQD7oxdAUBL72alCUMzqPaIc1gvXqbWZOVZ1qf/HTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQtVojlRRC1yKr9fWg9SDTEfqRb2SAMIiKL+aOJYvElm2oJyYffxDsb3P1ktPnwZA
	 5+My0QHrwUwvkMCnBWCSZrX+/iOywhO49m/2XyuwRpH46bgOh9F9iaM5Xn8/MWdA+q
	 0kpVaxGlkpuop16Ugg1uV+o3240c8lzRxNCh7xrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 121/353] ARM: dts: imx25: Fix the iim compatible string
Date: Fri,  2 Feb 2024 20:03:59 -0800
Message-ID: <20240203035407.572669907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f0b929f58719fc57a4926ab4fc972f185453d6a5 ]

Per imx-iim.yaml, the compatible string should only contain a single
entry.

Use it as "fsl,imx25-iim" to fix the following dt-schema warning:

imx25-karo-tx25.dtb: efuse@53ff0000: compatible: ['fsl,imx25-iim', 'fsl,imx27-iim'] is too long
	from schema $id: http://devicetree.org/schemas/nvmem/imx-iim.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx25.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx25.dtsi b/arch/arm/boot/dts/nxp/imx/imx25.dtsi
index 534c70b8d79d..f65c7234f9e7 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx25.dtsi
@@ -542,7 +542,7 @@
 			};
 
 			iim: efuse@53ff0000 {
-				compatible = "fsl,imx25-iim", "fsl,imx27-iim";
+				compatible = "fsl,imx25-iim";
 				reg = <0x53ff0000 0x4000>;
 				interrupts = <19>;
 				clocks = <&clks 99>;
-- 
2.43.0



