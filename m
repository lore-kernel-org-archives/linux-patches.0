Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F22F8BDC;
	Tue,  2 Sep 2025 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819351; cv=none; b=lhSTlGNF1VvIavl6lMkcup29QaTmNCKkte2OTRvKTcas81KpELfdabzPUI8lmCEB9eCj4MTsqh+9O9d9M1PrJlbBVGggxb0nIRxgxX5T0jLkPaVfUJdrMJJuatZ+/XLyA3337J599aiNZJRLv+QQOpDW4KvlTRCGLu/4OVZxm7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819351; c=relaxed/simple;
	bh=+IQFTWN4++dPcti6CfDtBiybtUA+DOQOe6ohw3YCbF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WKRhI0xBPNHxvudUWrBs3KIJ4FDmgCoBNE7j5Ylk5MfaqEafX/U5+xQw4glg9qNapU+0T3G1dRs5O56cdRRY9rB81qg8XAv6N9JKyNnnV+6gBNpt3U4B5SC9BNPAIwxfZ3MET0iepq5Yn+YY60e1vcni3FG3hl9bxUY0qpuFMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=187eNmFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="187eNmFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34A4C4CEED;
	Tue,  2 Sep 2025 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819350;
	bh=+IQFTWN4++dPcti6CfDtBiybtUA+DOQOe6ohw3YCbF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=187eNmFuZGGdyiiDm8VebM2+oIMbqGYf9ssHckDHkRUBW9nVOTYSXHoaAPQLuND80
	 ar4Xe10KywT6r9EJpdV9BwJHpNZXvcQvxrYCNC2oJJr/uGy81wSyL0MOZKG6HlQKAC
	 wx44pHqLXR9SpGdcY9OKbs9f+UkEKfqWvWey209k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 010/142] mips: lantiq: xway: sysctrl: rename the etop node
Date: Tue,  2 Sep 2025 15:18:32 +0200
Message-ID: <20250902131948.552045430@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5a75283d17f10..6031a0272d874 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -497,7 +497,7 @@ void __init ltq_soc_init(void)
 		ifccr = CGU_IFCCR_VR9;
 		pcicr = CGU_PCICR_VR9;
 	} else {
-		clkdev_add_pmu("1e180000.etop", NULL, 1, 0, PMU_PPE);
+		clkdev_add_pmu("1e180000.ethernet", NULL, 1, 0, PMU_PPE);
 	}
 
 	if (!of_machine_is_compatible("lantiq,ase"))
@@ -531,9 +531,9 @@ void __init ltq_soc_init(void)
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
@@ -592,7 +592,7 @@ void __init ltq_soc_init(void)
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



