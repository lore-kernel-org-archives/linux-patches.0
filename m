Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F151A9B46;
	Mon, 13 Oct 2025 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369150; cv=none; b=gq0A5h2UxIucF6dmtj0Of8N0rXomPjnJuWzwBE+OZx5f8BF8N9DEqV0wi4+aH0K2xi4MwNMfXRORb3ixSbFzVsVrgp1NpJ5wSGE8l/0nLLI+FdChEMfOKA77/qzq0NiYM3P5LlxcGExdZ/19T/un0XLtgwpENTnHZOASLf5vOFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369150; c=relaxed/simple;
	bh=wizedKyOPueUY5OwKYjb6Gh2Zdnu/y6O4j0ce4eGqFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCtE6HVH07adLLbC0GTQ3M78ZVJcGp0npn3G7zEO+gh7Tk7/yl8t3lhbPksAwHQYrvSPJe5DNC7b/rqIPdzpX7VcDAxTwcIvI41rU3G9Y/une9u1l+kOGZGCn9Jsg+InOHodVJyOhWB/20bNOGL8gAJ6MP2A6u0R82ET3OdxuXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qysb+Jqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qysb+Jqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128C1C4CEE7;
	Mon, 13 Oct 2025 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369150;
	bh=wizedKyOPueUY5OwKYjb6Gh2Zdnu/y6O4j0ce4eGqFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qysb+JqvW/mLLixe8NPUxRdYZLq5Ki83AT+1m6vAlrzOYhJQcAOmsbxrHWYT/ZkVR
	 Imef01iKXkpuUI8vz6wRXTByMWLqyidzZzYdFnrNj5kPAZL4/EjCLabuMQpIJczUz6
	 0lsn/mqvrXU9SC/WCXKBM8tyInshfIxrBH/2IQ6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 145/563] arm64: dts: mediatek: mt6331: Fix pmic, regulators, rtc, keys node names
Date: Mon, 13 Oct 2025 16:40:06 +0200
Message-ID: <20251013144416.544017636@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



