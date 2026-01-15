Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B76842049;
	Thu, 15 Jan 2026 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495949; cv=none; b=pb72dYaAReyCbj0n9VAqmIesoVpD9pas1Ko0uPB8B8+ENj9KBLXNYFZIhe6PXdyRNDHP7uBsU5tyNVUjQGNwGHY3S+EabgxaAdVoyA0sRlJkMbF7AHFx0C8tpkF43I3nDv2jKpAylLjKLcCknJSJnipALyH70/fIx9iGMogP2QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495949; c=relaxed/simple;
	bh=UHOwqSZ+/nrNU1eU/5BL0A+fZrfdfX4XjfWXoEi4WCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbSMCBsklh4yKh/ZzSJOtXDYOp4WMNOKyqdgH8w9QkgMJNyp1GpvONyOxedcSqh436Y+6kDEqP6WrBaFI5ypOKrFTNcoqUm8AjYU7Mt/VxrArv+AgW1/9YOehhyQw9Mf1I0VRzZuu3sVVrnuyVDBZUCkzPlUg16BFdcjuMkuBuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMrkcDSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMrkcDSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB67C116D0;
	Thu, 15 Jan 2026 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495949;
	bh=UHOwqSZ+/nrNU1eU/5BL0A+fZrfdfX4XjfWXoEi4WCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMrkcDSYc9ZXtOQP0B0/VdLmFdB84bdqNhZtX1fNxKE2KWtxzlc9fJd/fMyZYOZYV
	 Lty+0ejv5V32gqQSwA+U3vRY4wZRuQrFL41qtMYyn20z4B+JpyeZAxThKRck5tOwZH
	 4hNA4KUvreFDbTXE3oRnPP6TKQLAvRIFWzKOp0g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.18 024/181] arm64: dts: imx95: correct I3C2 pclk to IMX95_CLK_BUSWAKEUP
Date: Thu, 15 Jan 2026 17:46:01 +0100
Message-ID: <20260115164203.199243241@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Song <carlos.song@nxp.com>

commit cd0caaf2005547eaef8170356939aaabfcad4837 upstream.

I3C2 is in WAKEUP domain. Its pclk should be IMX95_CLK_BUSWAKEUP.

Fixes: 969497ebefcf ("arm64: dts: imx95: Add i3c1 and i3c2")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx95.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -806,7 +806,7 @@
 				interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
 				#address-cells = <3>;
 				#size-cells = <0>;
-				clocks = <&scmi_clk IMX95_CLK_BUSAON>,
+				clocks = <&scmi_clk IMX95_CLK_BUSWAKEUP>,
 					 <&scmi_clk IMX95_CLK_I3C2SLOW>;
 				clock-names = "pclk", "fast_clk";
 				status = "disabled";


