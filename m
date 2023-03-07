Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319EABA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF6C433D2;
	Tue,  7 Mar 2023 17:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209141;
	bh=dcd1Fg7XxtMMgTmRmH/HqoWFp7pfGZM91tV0ZKayNEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jx5iyAjQKm5rYEDq2XGXF220GzpNJyyah2Jfo8q/t1/neWmzXZaVH1qaeIIFtrwfe
	 1ww0eIhZCaTCcHPZ3poRat/fSrAMTv83dYtFc5DG5Jm/gyWIN81Evb9n7O73hpw4/B
	 pS575jrVdP6Q/+h+PN3k5IlHBxTzcinZ1z82hOH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0094/1001] ARM: dts: imx7s: correct iomuxc gpr mux controller cells
Date: Tue,  7 Mar 2023 17:47:46 +0100
Message-Id: <20230307170026.251822369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 0e3e1946606a2919b1dda9967ab2e1c5af2fedd6 ]

Per binding doc reg-mux.yaml, the #mux-control-cells should be 1

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Fixes: 94a905a79f2c ("ARM: dts: imx7s: add multiplexer controls")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 0fc9e6b8b05dc..11b9321badc51 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -513,7 +513,7 @@ gpr: iomuxc-gpr@30340000 {
 
 				mux: mux-controller {
 					compatible = "mmio-mux";
-					#mux-control-cells = <0>;
+					#mux-control-cells = <1>;
 					mux-reg-masks = <0x14 0x00000010>;
 				};
 
-- 
2.39.2



