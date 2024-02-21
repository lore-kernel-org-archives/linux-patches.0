Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503EB7C093;
	Wed, 21 Feb 2024 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525239; cv=none; b=NDbTcz0BxFuH7A2uf+uY1A32FC3XJNRl4vL/TO3oPAlnYTu5oSLKJwHkp9posm8GfclZEfdkspOPm5FMgIZct8l5onygioSfYnvId1fs5gApajDoEoVqWQK4LT4e017WiDYUzi7BRQHV0HE1RHoQpu+7hgppAghXlG7dqpODDBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525239; c=relaxed/simple;
	bh=VZu+q89BWDI0gJv5x2sGSZFGRWxIq+BC+ScTxbldzMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFrSih8G3S0b/NByyok2uOaPlYVbwmR7iACSAWk5WlDusNL2or3Yf6zprqrWuGvLUQypgrA7VTZGRXjga1LSoQoyXq8ZYvGeLDOOsGnKOo3TLiqNVgwvrqfX7Zo1jSpEHtVtgYqoi8MXAAjQ2MUz9mP8MmMmzRT9mU7k/sfSPS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hn66/eJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hn66/eJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E67C433F1;
	Wed, 21 Feb 2024 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525238;
	bh=VZu+q89BWDI0gJv5x2sGSZFGRWxIq+BC+ScTxbldzMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hn66/eJnlzdu2dnecvhuGInCFp5YJCPkLc1uWknvahvZRZ7E1B0+Tt4TYUPv3B3Is
	 Mu69xC65NDYp1/ioThGra2VZm/MTS+VUuIkuKzzOy7T+H55oAuaUa2jc3sEa/nKcnz
	 pXF3MCV5wPLl3NV4ocpKGm0heIhefvRPI6/ERWiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/267] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Wed, 21 Feb 2024 14:07:20 +0100
Message-ID: <20240221125943.053506128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 4aadb841ed49bada1415c48c44d21f5b69e01299 ]

nand-controller.yaml bindings says #size-cells shall be set to 0.
Fixes the dtbs_check warning:
arch/arm/boot/dts/nxp/imx/imx7s-mba7.dtb: nand-controller@33002000:
 #size-cells:0:0: 0 was expected
  from schema $id: http://devicetree.org/schemas/mtd/gpmi-nand.yaml#

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index a7ed880b12fc..8e86841ef4e6 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1217,7 +1217,7 @@
 		gpmi: gpmi-nand@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.43.0



