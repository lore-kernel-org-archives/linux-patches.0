Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0678323EA94;
	Mon, 13 Apr 2026 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096339; cv=none; b=Dmm0AoWOKBFWQis4lEnVAqFZ+EenVRvDeLNFCeLJcgd0qjV/Vp/LGmz8vbjmuYXrYO+qH00RQJkCZaORybrb6xm9l4JbYJzuKiuDLX7wr/9aRQmMe3sZWVtf1vmEG8dxwre6MbHthkKKs9kOOqdnhaOxjXIfrudjUPM14bU6Vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096339; c=relaxed/simple;
	bh=A2hy1uuajh0vsPeO4unk7+E1aBgjuG0eRjxbMiLK1gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7cRgvAicJTMH97W60PSfWcpwyXdffpSoEDoVjbZoIe/57foKfbR3NMI11mGEXX6jN8+zF4brC9TXOlhN3D3qk6LArPbH1OcORrdjSbtQ0UmmhzIZdSOZA7QYRVTUh0kZCaQezVHM7r89CAJdymju5uqLXnvtFhtlm9pZ7svjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpGXrXd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpGXrXd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8884CC2BCAF;
	Mon, 13 Apr 2026 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096338;
	bh=A2hy1uuajh0vsPeO4unk7+E1aBgjuG0eRjxbMiLK1gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpGXrXd1XDpsn9tsb4BpQ7I9AQSYpr9IEwofItXnVTJAL4ja0tPLMlJOeVRrTKNZZ
	 RftmF0I6qELFFx2+Hwb3JXJP+cN2BhWAQiTlzMZYhc3tFEcYvB3805zNhcaZVaBv4k
	 FQwF3wFujmWeFiL3hUVKrH6CZtWvgjlcfueZcjOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.19 32/86] Revert "arm64: dts: imx8mq-librem5: Set the DVS voltages lower"
Date: Mon, 13 Apr 2026 17:59:39 +0200
Message-ID: <20260413155732.771576876@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


