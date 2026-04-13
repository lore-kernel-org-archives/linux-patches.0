Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF52BE65F;
	Mon, 13 Apr 2026 16:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096723; cv=none; b=Gu2hcD/Y3048rbzwO7/uL3hIQrufXnVG4ElBSwCK0YmtPB1SWn/DWqtJ8sSy8zU1TUXwoE6WWExRMwXzQgp29Ld3n4ZIkJH6zYMuOk8abn+1MfwpJmIAEnFHkP1fBVTOb3xto+922zH+Sr9+Zi1tb9FI6UR0FBToK+gT6Q+GPVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096723; c=relaxed/simple;
	bh=apuaxXaHF4LSkV8dSLGxDWhND6Dvl1e1DoLmFZG1hkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB2ylscB2VOgCvbnZnZ91ArCLpaxKeoWiuvoecBHbRe1kk2/2c5Avbnu2QcqY9UWtJ5tTFG1zyyxx0HwteMstGChYGSh3G/UNzTcB6/PERziMjioipX26/AArT3zawOJ0kmg8KNNyfRTHYJpTRwb0e/IXX4WvNjBspVmdcwnpfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxHwY6JE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxHwY6JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC47C2BCAF;
	Mon, 13 Apr 2026 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096722;
	bh=apuaxXaHF4LSkV8dSLGxDWhND6Dvl1e1DoLmFZG1hkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxHwY6JEU2fGw6oMyld/To0WIz2X5tcZgc1GnKCSpO7IxiidLb1tPXUfD4m1L8yPO
	 Ua/yqR0qSa0dbh/WuCTYNp6b9UfjMEZbvKuaoIPlQfG6MbzPx9jNEssZI5UNFHdQk/
	 uW/hnzz3dyriVbSn0ZTqTYheCQ4LRuVl4Ph1nwjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 37/70] Revert "arm64: dts: imx8mq-librem5: Set the DVS voltages lower"
Date: Mon, 13 Apr 2026 18:00:32 +0200
Message-ID: <20260413155729.566970254@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

commit 4cd46ea0eb4504f7f4fea92cb4601c5c9a3e545e upstream.

This reverts commit c24a9b698fb02cd0723fa8375abab07f94b97b10.

It's been found that there's a significant per-unit variance in accepted
supply voltages and the current set still makes some units unstable.

Revert back to nominal values.

Cc: stable@vger.kernel.org
Fixes: c24a9b698fb0 ("arm64: dts: imx8mq-librem5: Set the DVS voltages lower")
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts |    2 -
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi   |   22 +++++---------------
 2 files changed, 7 insertions(+), 17 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
@@ -7,7 +7,7 @@
 
 &a53_opp_table {
 	opp-1000000000 {
-		opp-microvolt = <950000>;
+		opp-microvolt = <1000000>;
 	};
 };
 
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -845,8 +845,8 @@
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
-				rohm,dvs-run-voltage = <880000>;
-				rohm,dvs-idle-voltage = <820000>;
+				rohm,dvs-run-voltage = <900000>;
+				rohm,dvs-idle-voltage = <850000>;
 				rohm,dvs-suspend-voltage = <810000>;
 				regulator-always-on;
 			};
@@ -857,8 +857,8 @@
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
-				rohm,dvs-run-voltage = <950000>;
-				rohm,dvs-idle-voltage = <850000>;
+				rohm,dvs-run-voltage = <1000000>;
+				rohm,dvs-idle-voltage = <900000>;
 				regulator-always-on;
 			};
 
@@ -867,14 +867,14 @@
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
-				rohm,dvs-run-voltage = <850000>;
+				rohm,dvs-run-voltage = <900000>;
 			};
 
 			buck4_reg: BUCK4 {
 				regulator-name = "buck4";
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
-				rohm,dvs-run-voltage = <930000>;
+				rohm,dvs-run-voltage = <1000000>;
 			};
 
 			buck5_reg: BUCK5 {
@@ -1405,13 +1405,3 @@
 	fsl,ext-reset-output;
 	status = "okay";
 };
-
-&a53_opp_table {
-	opp-1000000000 {
-		opp-microvolt = <850000>;
-	};
-
-	opp-1500000000 {
-		opp-microvolt = <950000>;
-	};
-};


