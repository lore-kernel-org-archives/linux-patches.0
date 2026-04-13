Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20052D877D;
	Mon, 13 Apr 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096491; cv=none; b=cNGEJZga1V1K9bQ+vheTptEIx0zlBAPfKZht5HtuXbJtsk6rEcE4fqnB4BCBSmCIGPIW8UOLYxL2wPtmYSoMz9NI/eFvdXILqQd2urH9J/08PwAmB/9vHG9jsR2r91vwaFTjDhG66IgVAO5GvsKhi1l56SJl1gjQoDn9UuLihfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096491; c=relaxed/simple;
	bh=RuBQXvgJeMlDttSRGmOuP+UI0Lqorklal6TD6J3M58k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOVSBX8S17WJJUO1pplz6lKlNFjcKwM+l7q+RJwL8kyeYcfF6pglHhwqfQkaywqwAOXsQLxx8XdJeJTAR4xfBCZwvRyLZ/2lfTa59yYCIB1X7UgsEEzW8kJ5MH5Fzfem6vtFkVBhyX4TKYIGUKtIJgeFnGnedUpy7CbihlhUpL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dz/4lNj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dz/4lNj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C1BC2BCAF;
	Mon, 13 Apr 2026 16:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096490;
	bh=RuBQXvgJeMlDttSRGmOuP+UI0Lqorklal6TD6J3M58k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dz/4lNj9itqfAuYNw+yw+0W396iOpH4B72XQIyC9nTFtcBAh72cqcyV9zYBJcuEee
	 VJ7vqrsM2rsNYRzCZBYYy8mCKMAaTAx6UgI3du42Zv6YhI/9bATcbd1f4Y9Srxv4eA
	 XkY5r6DIGoxBs0/17o2xuPmbdo9dm2hDWXuFgLVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 31/83] Revert "arm64: dts: imx8mq-librem5: Set the DVS voltages lower"
Date: Mon, 13 Apr 2026 17:59:59 +0200
Message-ID: <20260413155732.184504110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -844,8 +844,8 @@
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
@@ -856,8 +856,8 @@
 				regulator-max-microvolt = <1300000>;
 				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
-				rohm,dvs-run-voltage = <950000>;
-				rohm,dvs-idle-voltage = <850000>;
+				rohm,dvs-run-voltage = <1000000>;
+				rohm,dvs-idle-voltage = <900000>;
 				regulator-always-on;
 			};
 
@@ -866,14 +866,14 @@
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
@@ -1407,13 +1407,3 @@
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


