Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABC329E11A;
	Sat, 30 May 2026 18:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165563; cv=none; b=WPo+BOt0/ELr/BnME1mUSwIOl0ZpeWTJNVtJSGUgAmFv78p7zU25m11Oz15DPXuAhgvH+//JZqazY/mEl8W/JhWvrNNSEP/vUo7yYqgpH34rpuuKoClo6/ii1ihhGyiNGv7nbmFPwR+Z0/LaZWf/HTyl3GNCrXYdh37r99hCQgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165563; c=relaxed/simple;
	bh=Mj6zo3iiZg/fziHAQctcUS5h/m9g3uXh0S6avFEnDYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jsrl7jdh4jkqPpjDlgOUO6t2SfDHLKMsqinP/gHHdoplZfmjE5snUN7rHQdD3zKMof6IXSLhyrGdKssjXv3pbGhtmpwaILg1le2arYcLJhabTNodgBJeaxYHWjN4+fvA0IzmRs4l+WBsrgPkbbQ0AD/l9l7nvswkh2+iPkvUzTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvLmPUoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvLmPUoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFEC1F00893;
	Sat, 30 May 2026 18:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165562;
	bh=psGq/5b6Mqla5BMzQMepy36DpscJzfmhImncnOF4tgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvLmPUoKWq+U/Z1AfYXpEUV0wajbOKsCW+5KaMviaMfMaDf9taeU7CaZlJNXzGCzb
	 aA9XLNPp9lJ/0I5+dbiWZzojoqk07jYYlvJ7EdM4EAEEqfOs7BpJSj2XBaleZqnsT2
	 Q+2FqMzAkunDU/hKWBp9RGOORUsmKD65tottL0Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/589] arm64: dts: imx8mq-librem5: set regulators boot-on
Date: Sat, 30 May 2026 17:59:56 +0200
Message-ID: <20260530160227.781482339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit a8bb83c8c7a17e83e04801d0678e93654f9bfaee ]

Expect all those regulators to be turned on initially.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 511f76bf1dce ("arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -649,6 +649,7 @@
 				regulator-name = "buck1";
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
+				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <900000>;
 				rohm,dvs-idle-voltage = <850000>;
@@ -660,6 +661,7 @@
 				regulator-name = "buck2";
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
+				regulator-boot-on;
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <1000000>;
 				rohm,dvs-idle-voltage = <900000>;
@@ -670,6 +672,7 @@
 				regulator-name = "buck3";
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1300000>;
+				regulator-boot-on;
 				rohm,dvs-run-voltage = <900000>;
 			};
 
@@ -684,6 +687,7 @@
 				regulator-name = "buck5";
 				regulator-min-microvolt = <700000>;
 				regulator-max-microvolt = <1350000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -691,6 +695,7 @@
 				regulator-name = "buck6";
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -698,6 +703,7 @@
 				regulator-name = "buck7";
 				regulator-min-microvolt = <1605000>;
 				regulator-max-microvolt = <1995000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -705,6 +711,7 @@
 				regulator-name = "buck8";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1400000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -712,6 +719,7 @@
 				regulator-name = "ldo1";
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
 				/* leave on for snvs power button */
 				regulator-always-on;
 			};
@@ -720,6 +728,7 @@
 				regulator-name = "ldo2";
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <900000>;
+				regulator-boot-on;
 				/* leave on for snvs power button */
 				regulator-always-on;
 			};
@@ -728,6 +737,7 @@
 				regulator-name = "ldo3";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -735,6 +745,7 @@
 				regulator-name = "ldo4";
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -751,6 +762,7 @@
 				regulator-name = "ldo6";
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 
@@ -759,6 +771,7 @@
 				regulator-name = "ldo7";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
 				regulator-always-on;
 			};
 		};


