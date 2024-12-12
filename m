Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8515E22B58A;
	Thu, 12 Dec 2024 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019041; cv=none; b=JjTr+3tRmjUd44XLGoM3v9OFux34GMJL95L8oK1+EtNgYuvlhMCpEam3luH/zGnucqQBsmMYO5qYsscWCH/ahpNHPQUKBW/yw2dPfKjrOoycV3qKQ/F0Zzil0KQe+sdPgMVqGYLh4xoNAG7lLocZIWt8h6lMgVK+TKPE14d0o2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019041; c=relaxed/simple;
	bh=tOksOBeCigUddFHUyBgMkv3wCvXtlsF84rrtQz9JCLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSVyDqTgUocjldTifDp+EbPN/KNN0Pe3p/HQDelUwdEoYACAsUFw8vPv5Tp5P+ADgw7Dq/ck36BQpeIzW/1I5creNgnCBK0CX+aLbiJmHVsQKyNqEgX9lNFPURaCcjMLUAhcspkHviFJIRWvApf2fwAHQwK2gEjizbYFzhvBfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzn7e5+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzn7e5+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E7CC4CECE;
	Thu, 12 Dec 2024 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019041;
	bh=tOksOBeCigUddFHUyBgMkv3wCvXtlsF84rrtQz9JCLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzn7e5+a/nLnOPNolb3fomSnQeBc7Z7YnOAguS5Zk6UjsobVPliThQsPYnQH5Hq9l
	 EhuWyMzrm4S9RBh8tI0Bx6Z43KAZte+ZteIt77a1GZ2z+HDOPRjlw/9Jt8k6T8e5As
	 votIqz8cz8YPaxtDse9hEhavve22KJds+SbnDNtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/772] arm64: dts: mt8183: kukui: Fix the address of eeprom at i2c4
Date: Thu, 12 Dec 2024 15:50:47 +0100
Message-ID: <20241212144354.156009463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit edbde4923f208aa83abb48d4b2463299e5fc2586 ]

The address of eeprom should be 50.

Fixes: ff33d889567e ("arm64: dts: mt8183: Add kukui kodama board")
Fixes: d1eaf77f2c66 ("arm64: dts: mt8183: Add kukui kakadu board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240909-eeprom-v1-2-1ed2bc5064f4@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi | 4 ++--
 arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
index 0d3c7b8162ff0..9eca1c80fe010 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kakadu.dtsi
@@ -105,9 +105,9 @@ &i2c4 {
 	clock-frequency = <400000>;
 	vbus-supply = <&mt6358_vcn18_reg>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c32";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 		vcc-supply = <&mt6358_vcn18_reg>;
 	};
diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
index e73113cb51f53..29216ebe4de84 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-kodama.dtsi
@@ -80,9 +80,9 @@ &i2c4 {
 	clock-frequency = <400000>;
 	vbus-supply = <&mt6358_vcn18_reg>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c64";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 		vcc-supply = <&mt6358_vcn18_reg>;
 	};
-- 
2.43.0



