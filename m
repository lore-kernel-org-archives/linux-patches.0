Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4430C306D53;
	Tue,  2 Sep 2025 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820219; cv=none; b=KFB0UBb79ANu47/j1vIYzDl+YPgu6WjnKkqqdalQLrayAStLSgG+uicWTiP2PYufkg/rYYLjzttQHtGMKuoyCJnZceA7hc9QhoISLHDxY+QQWOW+RAx5eH+sQgZCH89fdNL/RKclgSBkYI0G5e1/QynjuPk0nnowIGv7/t+XE98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820219; c=relaxed/simple;
	bh=bIRlaCcbL8ye3cXKSBkXOOtY6D9xR8Ln9Lm7y89a3rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnlAriySf99UKVgKR69IZPfcsbLj/55D1NwVSRDxrZe2JzakRAeZrlvJzq6/qYI388eDgwxDlTQC10B3bzBcUHpakB8J9Tg4qlBM1sxMIDWUWoiMV/unR/lRoZ4X5oDx397eTiWzJya9+IiyoQNGKs4/PKtBdCn69D7xG0FlN9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1tHqaM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1tHqaM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8B2C4CEED;
	Tue,  2 Sep 2025 13:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820219;
	bh=bIRlaCcbL8ye3cXKSBkXOOtY6D9xR8Ln9Lm7y89a3rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1tHqaM/cOBlWsPKRTLDOs+PGcWyZttGpi+yxDv+Pc5+HGAaIsiCe4ymn+tuWEnCf
	 RDACjkt5+tqk9jckkKHpxTj844pRl32w83FQfAw9T0BlXLBOsIyzjKqBruz25YCLXW
	 qHa8p+Wni0yKBOJRlDVrbHoG2BfZpUib2zsd6jQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/75] mips: lantiq: xway: sysctrl: rename the etop node
Date: Tue,  2 Sep 2025 15:20:16 +0200
Message-ID: <20250902131935.285060002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ed0782252229..4c72b59fdf98c 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -478,7 +478,7 @@ void __init ltq_soc_init(void)
 		ifccr = CGU_IFCCR_VR9;
 		pcicr = CGU_PCICR_VR9;
 	} else {
-		clkdev_add_pmu("1e180000.etop", NULL, 1, 0, PMU_PPE);
+		clkdev_add_pmu("1e180000.ethernet", NULL, 1, 0, PMU_PPE);
 	}
 
 	if (!of_machine_is_compatible("lantiq,ase"))
@@ -512,9 +512,9 @@ void __init ltq_soc_init(void)
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
@@ -573,7 +573,7 @@ void __init ltq_soc_init(void)
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



