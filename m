Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1BE17592;
	Tue, 30 Apr 2024 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476512; cv=none; b=cQWeeDesXcnzobB9PJl+vkz38pODXlARa5poINGqvs/LMVWs1N41otGquyh4ExjVo2oIBks6q2ducF2+aLX6CdEs4kTttS7HU/iYr8NRw5BieThsGoNTnBI+q3qICtfs9p6zqAp9zmqntKDN7g4i86rdlRO7ioAFp11PrlvsU84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476512; c=relaxed/simple;
	bh=eJU/4urAqHnOyOYGSw/SSiSiqcnevNQbY5NsGcLmhnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unih0jCKzObZYzcHJJPbpOb5we/a4t2Z6ytM49b5IVTYZ5zzl4Pzh9/FGSX5Px6//SU7uuBundThOkhGNdjZ/cDToYcgMJNC5C9fDh7FQuYvqey4a36XwGLq8uFxYwEFceFKYxvWRahM5SXubROqmB8SfN0imIldjp5NoDjh4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tm/KowOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tm/KowOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9730DC2BBFC;
	Tue, 30 Apr 2024 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476512;
	bh=eJU/4urAqHnOyOYGSw/SSiSiqcnevNQbY5NsGcLmhnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tm/KowOWWcITzwy+WwI3fdLbYey2/i1bee3ec2o+lY6/yLeZNzrrML4wXgwJVsA8J
	 y1e7t1kef0jFGZSMsJKgx/aJbUavbdw3V+7VdlomGksHeIuC4jPruxeS6alyC4G4Sd
	 wIgPZ7dfoWlo4OKGW6ecNC2HKK/hXf1JneiVcAUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/110] arm64: dts: mediatek: mt7622: fix clock controllers
Date: Tue, 30 Apr 2024 12:39:45 +0200
Message-ID: <20240430103048.050662362@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3ba5a61594347ab46e7c2cff6cd63ea0f1282efb ]

1. Drop unneeded "syscon"s (bindings were updated recently)
2. Use "clock-controller" in nodenames
3. Add missing "#clock-cells"

Fixes: d7167881e03e ("arm64: dts: mt7622: add clock controller device nodes")
Fixes: e9b65ecb7c30 ("arm64: dts: mediatek: mt7622: introduce nodes for Wireless Ethernet Dispatch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-2-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 27 +++++++++++-------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 7bb316922a3a9..c1747483350ef 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -282,16 +282,14 @@
 		};
 	};
 
-	apmixedsys: apmixedsys@10209000 {
-		compatible = "mediatek,mt7622-apmixedsys",
-			     "syscon";
+	apmixedsys: clock-controller@10209000 {
+		compatible = "mediatek,mt7622-apmixedsys";
 		reg = <0 0x10209000 0 0x1000>;
 		#clock-cells = <1>;
 	};
 
-	topckgen: topckgen@10210000 {
-		compatible = "mediatek,mt7622-topckgen",
-			     "syscon";
+	topckgen: clock-controller@10210000 {
+		compatible = "mediatek,mt7622-topckgen";
 		reg = <0 0x10210000 0 0x1000>;
 		#clock-cells = <1>;
 	};
@@ -734,9 +732,8 @@
 		power-domains = <&scpsys MT7622_POWER_DOMAIN_WB>;
 	};
 
-	ssusbsys: ssusbsys@1a000000 {
-		compatible = "mediatek,mt7622-ssusbsys",
-			     "syscon";
+	ssusbsys: clock-controller@1a000000 {
+		compatible = "mediatek,mt7622-ssusbsys";
 		reg = <0 0x1a000000 0 0x1000>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
@@ -793,9 +790,8 @@
 		};
 	};
 
-	pciesys: pciesys@1a100800 {
-		compatible = "mediatek,mt7622-pciesys",
-			     "syscon";
+	pciesys: clock-controller@1a100800 {
+		compatible = "mediatek,mt7622-pciesys";
 		reg = <0 0x1a100800 0 0x1000>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
@@ -921,12 +917,13 @@
 		};
 	};
 
-	hifsys: syscon@1af00000 {
-		compatible = "mediatek,mt7622-hifsys", "syscon";
+	hifsys: clock-controller@1af00000 {
+		compatible = "mediatek,mt7622-hifsys";
 		reg = <0 0x1af00000 0 0x70>;
+		#clock-cells = <1>;
 	};
 
-	ethsys: syscon@1b000000 {
+	ethsys: clock-controller@1b000000 {
 		compatible = "mediatek,mt7622-ethsys",
 			     "syscon";
 		reg = <0 0x1b000000 0 0x1000>;
-- 
2.43.0



