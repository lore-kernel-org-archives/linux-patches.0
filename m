Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325C146A61A;
	Tue, 21 Jul 2026 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648541; cv=none; b=k+n5EcS50C6AYo3B4+caILGQD3BeJQp2FLiufKIYcYdjv6ZWNFQfGiidT1n27SGLTkHKYaAsMhkFavPCsV5tliHAi3iV354swzNFsaGqnsf4lPbJIkhvd2A6CepPXHeHFgb9BQZMYmGpsKkWbSx9zxNDo749qNay+jC2JX8Z9AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648541; c=relaxed/simple;
	bh=5MNIWuYynDftjgrQBSiDcfohWsN1uahyiXOt4ivwZC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv+ns/9FNljM9hCUfJtCbtYwe3Tuu3Ty0p5Gyq1Kvl3KaqWx73bXFGVQGdhBBC3fwNT0Yhk5KwMOclZ6tA1R7wKQv2XwDn19ohnVGa5/9XbQH/w4WIb0PN83sY9Fv+MHfNZeUX1ZyNtb3wwcQJl23kWiEFqXbiANk4JvDHlQZ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPlXTC4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPlXTC4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251201F01559;
	Tue, 21 Jul 2026 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648539;
	bh=Fhnsv8xMSQMoN4pTN+z8XwtmpMEwskB3KJZ1yVwo+Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPlXTC4fjBLeQfFC5gBCgd9+nZhNOCOG8uMXtalbptkJbDVW6wcuhvm07T6vrcSIc
	 oZEjHDDSLMFPSFwM5FJfYmYtOt6fCr+55xUHbwOLn2dfTO28CRMOWe3LYLEjKXoS9U
	 UsVnKG9BO71mecetsnQVEtKYv24P8UTFysUujsFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0239/2077] arm64: dts: imx8dxl-evk: Remove unnecessary PCIe EP properties
Date: Tue, 21 Jul 2026 16:58:32 +0200
Message-ID: <20260721152558.314336085@linuxfoundation.org>
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
index bc62ae5ca812dd..441e0090302994 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -686,8 +686,6 @@ &pcie0_ep {
 	phy-names = "pcie-phy";
 	pinctrl-0 = <&pinctrl_pcieb>;
 	pinctrl-names = "default";
-	reset-gpio = <&lsio_gpio4 0 GPIO_ACTIVE_LOW>;
-	vpcie-supply = <&reg_pcieb>;
 	status = "disabled";
 };
 
-- 
2.53.0



