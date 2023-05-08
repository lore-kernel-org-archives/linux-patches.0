Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E29311C8F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C76C433D2;
	Mon,  8 May 2023 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543708;
	bh=LVOjEFI63TDCa+H6RehajV3mSb3+qUqefeYeby0skB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nO6N89AUusIGkWTZ8AkD7pbDT7wySW88wsocqbch0/qx9A1oal787KAkX0o3+mqAI
	 2yPZK3YYraaqH6Vedsi4wyCt7yWFk/9Fj9LLrEcHDXJxPAp/ohur2QEyeLccT2HL1L
	 LM3ObQnzXTAypeNlKKRGqMWyOodFhIbG+Cbf5yD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 174/694] arm64: dts: ti: k3-j784s4-*: Add ti,sci-dev-id for NAVSS nodes
Date: Mon,  8 May 2023 11:40:09 +0200
Message-Id: <20230508094438.052511308@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 436b288687176bf4d2c1cd25b86173e5a1649a60 ]

TISCI device ID for main_navss and mcu_navss nodes are missing in
the device tree. Add them.

Fixes: 4664ebd8346a ("arm64: dts: ti: Add initial support for J784S4 SoC")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>
Link: https://lore.kernel.org/r/20230314152611.140969-2-j-choudhary@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi       | 1 +
 arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
index 7edf324ac159b..80a1b08c51a84 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
@@ -398,6 +398,7 @@
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges = <0x00 0x30000000 0x00 0x30000000 0x00 0x0c400000>;
+		ti,sci-dev-id = <280>;
 		dma-coherent;
 		dma-ranges;
 
diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi
index 93952af618f65..64bd3dee14aa6 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-mcu-wakeup.dtsi
@@ -209,6 +209,7 @@
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges = <0x00 0x28380000 0x00 0x28380000 0x00 0x03880000>;
+		ti,sci-dev-id = <323>;
 		dma-coherent;
 		dma-ranges;
 
-- 
2.39.2



