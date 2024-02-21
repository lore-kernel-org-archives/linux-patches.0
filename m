Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E769953;
	Wed, 21 Feb 2024 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522626; cv=none; b=OBN7W+KvdsT5glGq0QPWbHHCEjDZMXHroXg27sBptUEyUdJQP6LFV9oUJbsG50kIzpOl4BNRIR81Tk6WU8ltCzngsBgUtjvKKTTINZty4K1ighPQnVzRuP4u9jlsjb9Lmn3wKMMbDRL/4jg+zwIowRmDdqWwdh+tFwq80iw77zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522626; c=relaxed/simple;
	bh=OJKfBr3iYZod7TKPppYEqIPW4hsaJZv/4Ux4e9+++PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbHzKTU11gjSue+PdcNDiq2vfubrRklp2aooAoFpEItgt7i+Vknxt/Z73luyYst7gcxSIq5juTUvA+1jKk3tBOV/ncDPOOpxG5YQWnSQ3F3mVoKFfGlv0EkfLtyTxEz/kpSnv2LqjWZcStlr6LV53yy1eCn6lW5dGIzO05sFxU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8Pc4vLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8Pc4vLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719EAC433F1;
	Wed, 21 Feb 2024 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522625;
	bh=OJKfBr3iYZod7TKPppYEqIPW4hsaJZv/4Ux4e9+++PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8Pc4vLN9pOWgQRLRHfb+iHSWMxD9HrJf0/8GBq57wAVwwnUV+TmhDf0HnbZHkw9i
	 9OojyGUVt32pVkr2thWUopiLEZzJB1HbFgNLBVMbVd3fHJ8WbxQU0l5n8kkq5v4S+Z
	 MUGBvRMb1Otj6PvWO8dj1r6wkmbeIPeHP+tNJ4L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/476] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Wed, 21 Feb 2024 14:03:46 +0100
Message-ID: <20240221130014.372170164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35ee179e5ae3..5b960849c3ab 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1264,7 +1264,7 @@
 		gpmi: nand-controller@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.43.0



