Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1420125F;
	Mon, 13 Oct 2025 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367522; cv=none; b=vF49Q7H5kiFIMOsIQ1aT65ehIRc5kBy3YmcJFyc/07DE1X6I2d2oDeMJ05iGApTHtuHQmW9P7/KV6r0UpGNA1yytEpbDMY6welfmKtkIo+7I1FHbaPDnNy2wvLvced+J8U08pukxqhUYgRhVL3/pCbAEP6Mpq4BNKLV+cUzA8DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367522; c=relaxed/simple;
	bh=Nq/JbD0vUWFSStDuIONBq8zWdtZZT6uykw4K836VInk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHGvdfF6wT20Stz1Qn/8edmagXfDfpw5MkmWIMwuYts+6hrZ9Iw0T/7JtxNNo9C4CAhxRnKTS+Cz6C7XdhQBe5Le8Izor1Lw9CmzuLlu0vueOgC57K3wHEI83B66Dha2vdJ/qDXW/3Ho4yi1AlRglIFKZvYuyvVEvTk98DRvA1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vo16G7Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vo16G7Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66831C4CEE7;
	Mon, 13 Oct 2025 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367522;
	bh=Nq/JbD0vUWFSStDuIONBq8zWdtZZT6uykw4K836VInk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vo16G7DcDeQ6L1iDTKWjC8w/dulZy/RkHeZ7bQXgd0pqcZbqj6selJwdNM2FY7htP
	 4664xc5eFjxIwtqfVzb1OTyvkX34sF1mwdps6R6Mnvr3JGaByflACr5l9KTqMCdqPy
	 55xAF/Gi0TOz4uy46zWRW8uAFXZF2/M5wS78dv/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/196] arm64: dts: mediatek: mt6331: Fix pmic, regulators, rtc, keys node names
Date: Mon, 13 Oct 2025 16:43:53 +0200
Message-ID: <20251013144316.724244728@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 98967109c9c0e2de4140827628c63f96314099ab ]

The node names for "pmic", "regulators", "rtc", and "keys" are
dictated by the PMIC MFD binding: change those to adhere to it.

Fixes: aef783f3e0ca ("arm64: dts: mediatek: Add MT6331 PMIC devicetree")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20250724083914.61351-17-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6331.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6331.dtsi b/arch/arm64/boot/dts/mediatek/mt6331.dtsi
index d89858c73ab1b..243afbffa21fd 100644
--- a/arch/arm64/boot/dts/mediatek/mt6331.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6331.dtsi
@@ -6,12 +6,12 @@
 #include <dt-bindings/input/input.h>
 
 &pwrap {
-	pmic: mt6331 {
+	pmic: pmic {
 		compatible = "mediatek,mt6331";
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		mt6331regulator: mt6331regulator {
+		mt6331regulator: regulators {
 			compatible = "mediatek,mt6331-regulator";
 
 			mt6331_vdvfs11_reg: buck-vdvfs11 {
@@ -258,7 +258,7 @@ mt6331_vrtc_reg: ldo-vrtc {
 			};
 
 			mt6331_vdig18_reg: ldo-vdig18 {
-				regulator-name = "dvdd18_dig";
+				regulator-name = "vdig18";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-ramp-delay = <0>;
@@ -266,11 +266,11 @@ mt6331_vdig18_reg: ldo-vdig18 {
 			};
 		};
 
-		mt6331rtc: mt6331rtc {
+		mt6331rtc: rtc {
 			compatible = "mediatek,mt6331-rtc";
 		};
 
-		mt6331keys: mt6331keys {
+		mt6331keys: keys {
 			compatible = "mediatek,mt6331-keys";
 			power {
 				linux,keycodes = <KEY_POWER>;
-- 
2.51.0



