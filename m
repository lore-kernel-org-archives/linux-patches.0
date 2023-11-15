Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6162EAEE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MBtiJiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2195BC433C9;
	Wed, 15 Nov 2023 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077442;
	bh=ivsrO8l6VrxlU3LbH80zt9xK0DnvHHvls1aCcKTQaI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MBtiJiIR5ZZucV2/98AwnD3OPUN2LgzdWbMU9Bg6v3vrdQonOwMK8FXv+PBmwodi
	 /YrI00qI5Xw5neBR+ex00/FTfa1Zi/qIitNPC3KW29oqjanC+BGyr5SwICtx4iE/mu
	 AfnEdScULzyd48Dih6BF/ix/UUtdl9zOGr6Ushzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/603] arm64: dts: ti: verdin-am62: disable MIPI DSI bridge
Date: Wed, 15 Nov 2023 14:14:11 -0500
Message-ID: <20231115191634.587665448@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 664e2852aa9142193c2e241327631f032b966742 ]

Keep the DPI to MIPI-DSI bridge disabled in the SoM dtsi file.

The display chain is not wholly described in the device tree file, on
Verdin product family the displays are additional accessories that are
configured/enabled using DT overlays.

With this enabled we have issues when a display is enabled on
TIDSS port1 (LVDS) and port0 (DSI) is not used.

Fixes: 9e77200356ba ("arm64: dts: ti: verdin-am62: Add DSI display support")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20230922123003.25002-1-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index 40992e7e4c308..5db52f2372534 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -1061,6 +1061,7 @@ dsi_bridge: dsi@e {
 		vddc-supply = <&reg_1v2_dsi>;
 		vddmipi-supply = <&reg_1v2_dsi>;
 		vddio-supply = <&reg_1v8_dsi>;
+		status = "disabled";
 
 		dsi_bridge_ports: ports {
 			#address-cells = <1>;
-- 
2.42.0



