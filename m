Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75169D1C;
	Wed, 21 Feb 2024 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521430; cv=none; b=CnWQCOpznc8dNHDk4xLj36GGC1byhlh7C3d8ON21gRKY96A6eu37tEU/eXAFmrmPz1WKLlOqaYJFr3V83Rz31PKgV4iYKVujwcqbd2W8bYpGhSp2KbkpgX6fhLsMtVjLRDMTyiTs77AOj7A1Fb1RhzghjgtUX+yUYIHbIXc9O+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521430; c=relaxed/simple;
	bh=sAM9e8SlZESgy3X0/nmteecihOGJU+GhUjy5ZeMYXVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgCVUxJuYfw3MYzbP8rLpPkD+XnRRwIDpaPyoSEr7+EtE4gU6Ab8Ei8hyLsvycM/adHfcrT4uqJjXHNDVL8GgTJtJisLnyUjOMXJtIMJFQKvsZEHDE6ihOcqlwezhxEFJDZ9TY0uELylY3OovEQvYfn8cn4kYSo0Px2MC/ILzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sx30A27r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sx30A27r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB78C433C7;
	Wed, 21 Feb 2024 13:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521429;
	bh=sAM9e8SlZESgy3X0/nmteecihOGJU+GhUjy5ZeMYXVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sx30A27rxmwL1euyDObKhwtBa74rhzY/lK4g4RFGiIYYGJxM7MYNHNhee69iSXeHa
	 M4PBzGv9m9hFsoSIG1B91ca4p6UkZmZiFOWvYFVwiAdVsQnXzuu/nWL1Ft6Vm5jx2x
	 GqA8j0lhafykauZJuXHqENkvc4mOVr4d2tArzsjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/202] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Wed, 21 Feb 2024 14:06:20 +0100
Message-ID: <20240221125934.360093835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ebe954f94e09..c62cf9fea481 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1094,7 +1094,7 @@
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



