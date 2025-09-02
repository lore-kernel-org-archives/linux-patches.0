Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C921315761;
	Tue,  2 Sep 2025 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820442; cv=none; b=hozTzh+U35u1hpXpNtseiAHKsgsamu4Bnj0XYqDEowPikzZQRYBiFie1LDtx6TUXUGn54mZRmeKgEjeoaxfLRQi7C0P8kPSEAyixcpTRdDR7Kb8WYpO1ecFAQ3dVVxVpKRQVul1yHv73wGec8trFeiDN7uCogAiRYu34VT52y2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820442; c=relaxed/simple;
	bh=iHA8UKCeHGAUx98XNIUEFJ0JNYPyAq0z+YyarSYx/MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=joSzJ6lJ4O3N16NBu5pSmqnKNomf0JjJ2spI3zCOkh6ZONzL5UcBOjkYSIBskgebr9cWI58jfCvVuBKojo9wWAxMbPCmCdqU5LXF4NcN50P8PxHAqZ0zXvGyH8U0DSyX4TgVj7N61jw4F3tGs6QObEL33HRrK5qz5iwg1T1SCpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MScdJ4rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MScdJ4rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D38C4CEF4;
	Tue,  2 Sep 2025 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820442;
	bh=iHA8UKCeHGAUx98XNIUEFJ0JNYPyAq0z+YyarSYx/MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MScdJ4rB46RP0Nx7uGzrjHE+zMbpaObwkvxQ8pzRPM3+TCo/375BBcsiHv+6VPpJi
	 B6CKzRwQobQX0eGmerH/NNM7TJhGwwPWVrA3hOputkr79Z62s0fAfGb+PVPMnsTR7T
	 djpj4+mRXSxiSaWt5mIm5jCQNC4cNpr3wuQcqHow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/50] mips: lantiq: xway: sysctrl: rename the etop node
Date: Tue,  2 Sep 2025 15:20:54 +0200
Message-ID: <20250902131930.648401932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 8c431ea8f3f795c4b9cfa57a85bc4166b9cce0ac ]

Bindig requires a node name matching ‘^ethernet@[0-9a-f]+$’. This patch
changes the clock name from “etop” to “ethernet”.

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): $nodename:0: 'etop@e180000' does not match '^ethernet@[0-9a-f]+$'
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#

Fixes: dac0bad93741 ("dt-bindings: net: lantiq,etop-xway: Document Lantiq Xway ETOP bindings")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts |  2 +-
 arch/mips/lantiq/xway/sysctrl.c                | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index d8b3cd69eda3c..c4d7aa5753b04 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -82,7 +82,7 @@ conf_out {
 			};
 		};
 
-		etop@e180000 {
+		ethernet@e180000 {
 			compatible = "lantiq,etop-xway";
 			reg = <0xe180000 0x40000>;
 			interrupt-parent = <&icu0>;
diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index d444a1b98a724..edf914393ad96 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -479,7 +479,7 @@ void __init ltq_soc_init(void)
 		ifccr = CGU_IFCCR_VR9;
 		pcicr = CGU_PCICR_VR9;
 	} else {
-		clkdev_add_pmu("1e180000.etop", NULL, 1, 0, PMU_PPE);
+		clkdev_add_pmu("1e180000.ethernet", NULL, 1, 0, PMU_PPE);
 	}
 
 	if (!of_machine_is_compatible("lantiq,ase"))
@@ -513,9 +513,9 @@ void __init ltq_soc_init(void)
 						CLOCK_133M, CLOCK_133M);
 		clkdev_add_pmu("1e101000.usb", "otg", 1, 0, PMU_USB0);
 		clkdev_add_pmu("1f203018.usb2-phy", "phy", 1, 0, PMU_USB0_P);
-		clkdev_add_pmu("1e180000.etop", "ppe", 1, 0, PMU_PPE);
-		clkdev_add_cgu("1e180000.etop", "ephycgu", CGU_EPHY);
-		clkdev_add_pmu("1e180000.etop", "ephy", 1, 0, PMU_EPHY);
+		clkdev_add_pmu("1e180000.ethernet", "ppe", 1, 0, PMU_PPE);
+		clkdev_add_cgu("1e180000.ethernet", "ephycgu", CGU_EPHY);
+		clkdev_add_pmu("1e180000.ethernet", "ephy", 1, 0, PMU_EPHY);
 		clkdev_add_pmu("1e103000.sdio", NULL, 1, 0, PMU_ASE_SDIO);
 		clkdev_add_pmu("1e116000.mei", "dfe", 1, 0, PMU_DFE);
 	} else if (of_machine_is_compatible("lantiq,grx390")) {
@@ -574,7 +574,7 @@ void __init ltq_soc_init(void)
 		clkdev_add_pmu("1e101000.usb", "otg", 1, 0, PMU_USB0 | PMU_AHBM);
 		clkdev_add_pmu("1f203034.usb2-phy", "phy", 1, 0, PMU_USB1_P);
 		clkdev_add_pmu("1e106000.usb", "otg", 1, 0, PMU_USB1 | PMU_AHBM);
-		clkdev_add_pmu("1e180000.etop", "switch", 1, 0, PMU_SWITCH);
+		clkdev_add_pmu("1e180000.ethernet", "switch", 1, 0, PMU_SWITCH);
 		clkdev_add_pmu("1e103000.sdio", NULL, 1, 0, PMU_SDIO);
 		clkdev_add_pmu("1e103100.deu", NULL, 1, 0, PMU_DEU);
 		clkdev_add_pmu("1e116000.mei", "dfe", 1, 0, PMU_DFE);
-- 
2.50.1



