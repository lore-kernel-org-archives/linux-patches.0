Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7673E49EF;
	Tue, 21 Jul 2026 17:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655854; cv=none; b=W5+MI9+Wgu3bqD8JZPz0oLCC/0JCSxHRPwFk3SDXdyrR8Z8oND/F+y22ca7uGgxABTq2qzKZg+NJjMN32ARn8N2/e8VFHRhu6T6NDjevwWCMAYTTF71wGpuKjdkT/i7xSzVmXpCFcJKYOf21l3bLD/uLbZ7xt8tv0zRV0UP2zY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655854; c=relaxed/simple;
	bh=ZITHKuIRj1paZyHZyc8o+MRRXJRGkgZiVG0ZNCLgXt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCkQiYqVGglFWtiBwfA64Wb15ByAKwFFptSJ2+VwV3NyhYXpgrYj5Y3id1yx6iBP/5qQ2pSzG6cDYp4z44ilVTgaiAFDWU4FO7p77ttkrfBbsO8D95cNJnu6toT6LGy/Qr23N21Z2N/zO8tO8GxRHIgLncVMRcGNNNnIgFXb08I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKiF5Jsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKiF5Jsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9E71F000E9;
	Tue, 21 Jul 2026 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655853;
	bh=MC3Ei9ZxmItJdlhS31uhZVt6EgziWtnt910NyNQvWnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKiF5Jsb8xWRh+c5Y3OCwMrkDxPGv9bOJixJvmHkhsVfpfcrCXgXrCBRXsufsj2Sa
	 Sbz+hfaoHZgXjmmypppGR1QmJiTX4YZNL3t2CDpPsLK9rRS1tF+LSZ1Kh86n7JswJe
	 utudibztPEmaJ+yOMsiXAtqzaFn6BKjmq1NDzwiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0166/1611] arm64: dts: imx8dxl-evk: Remove unnecessary PCIe EP properties
Date: Tue, 21 Jul 2026 17:04:42 +0200
Message-ID: <20260721152518.620216709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 538525f34158deb21b782164bde23ec07a353e4a ]

For PCIe endpoint mode, only M.2 power supply needs to be ensured.
On imx8dxl-evk, the M.2 power is always on and cannot be controlled,
while reg_pcieb only controls the M.2 W_DISABLE1# signal. Remove the
unnecessary vpcie-supply property from pcie0_ep node.

Also remove reset-gpio as PCIe endpoint mode doesn't require reset
control.

Fixes: c1c4820b60d7 ("arm64: dts: imx8dxl-evk: Add pcie0-ep node and use unified pcie0 label")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index b75ab1e010f0c8..605a423a1b6685 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -681,8 +681,6 @@ &pcie0_ep {
 	phy-names = "pcie-phy";
 	pinctrl-0 = <&pinctrl_pcieb>;
 	pinctrl-names = "default";
-	reset-gpio = <&lsio_gpio4 0 GPIO_ACTIVE_LOW>;
-	vpcie-supply = <&reg_pcieb>;
 	status = "disabled";
 };
 
-- 
2.53.0



