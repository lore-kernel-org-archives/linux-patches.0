Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726EF472537;
	Tue, 21 Jul 2026 19:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663431; cv=none; b=BMxPjt8bLnsXTTRJeNV4NbH947Fs1msPGqga3Lf32GEu8bgmbFHL8zOpeVYwkYPQKbO4QYjY+4ccPtu/kny26R5He0k+QbwcbYQPWWNnTHR2W8pTHEtw7gCMSAnkmXrk32aWxvYzomBEx4ICIYVGOCPlCGUgrC/1kpG53kQwAjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663431; c=relaxed/simple;
	bh=lfj2NWgssk5q7iDyYRr8QoHSrpXA3RONnnRiMZZhGWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf7ofZiHNSPibVD5qSvvWZQeBXwD3aTalBDjVv/cPy0MAjuD8fFJUGxZDZ01tW8mRQa0iaICof9BTwrWlJa7RCnMOSci7afN8Vph/rDgbS4JaFscPCYtkdt7BI5FfKqk9i3kY1AMja/xB42rIGuplbn55PSZOi2oUN1FRVZOZzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnpSqp7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnpSqp7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967F91F000E9;
	Tue, 21 Jul 2026 19:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663430;
	bh=Pu7WfHKzU8O8strBqKC9vhwfnutRYKIVQ1WZgrVinUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnpSqp7YfgL9ch1MfZUWxfAnqrMoKRjHMgMgqhKW2O3ij3wugML6QoumBmeDux9sa
	 RejNWk2TiLotfyHqxphbzKdcSYn9sEz4NBcprBnsn5Dn/Z0pUXweKkWkSoKhLbBdEx
	 aQcuXgKTHbQVzQvMu1QY/ycH/65tWS4HG8Uoo4/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.12 0819/1276] ARM: dts: stm32: stm32mp15x-mecio1-io: Move divergent mecio1 ADC channels to board files
Date: Tue, 21 Jul 2026 17:21:02 +0200
Message-ID: <20260721152504.393408981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: David Jander <david@protonic.nl>

commit 70f1d8fcbd121a40f51b6c846d41e8cbb38ba210 upstream.

Move the divergent adc1 channel definitions out of the common
mecio1-io.dtsi file and into the specific Revision 0 and Revision 1
board files.

The original common file contained incorrect schematic labels for the
Revision 0 hardware (e.g., labeling ana0 as p24v_hpdcm instead of
ain_aux0) and failed to account for physical signal routing changes
between the board revisions.

Retain only the strictly shared channels in the common include file. Map
the correct channels and schematic labels directly within
stm32mp151c-mecio1r0.dts and stm32mp153c-mecio1r1.dts.

Crucially, ensure that the required 200us sample time follows the
phint1_ain signal to its new physical location on channel 3 for the
Revision 1 hardware.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260318105123.819807-4-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts  |   50 +++++++++++++++++++++++++
 arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts  |   50 +++++++++++++++++++++++++
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |   50 -------------------------
 3 files changed, 101 insertions(+), 49 deletions(-)

--- a/arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts
+++ b/arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts
@@ -36,6 +36,56 @@
 	};
 };
 
+&adc1 {
+	channel@0 {
+		reg = <0>;
+		st,min-sample-time-ns = <20000>;
+		label = "ain_aux0";
+	};
+
+	channel@1 {
+		reg = <1>;
+		st,min-sample-time-ns = <20000>;
+		label = "ain_aux1";
+	};
+
+	channel@3 {
+		reg = <3>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpdcm1_i2";
+	};
+
+	channel@5 {
+		reg = <5>;
+		st,min-sample-time-ns = <20000>;
+		label = "pout1_i";
+	};
+
+	channel@9 {
+		reg = <9>;
+		st,min-sample-time-ns = <20000>;
+		label = "pout0_i";
+	};
+
+	channel@13 {
+		reg = <13>;
+		st,min-sample-time-ns = <200000>;
+		label = "phint1_ain";
+	};
+
+	channel@15 {
+		reg = <15>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpdcm0_i1";
+	};
+
+	channel@18 {
+		reg = <18>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpdcm0_i2";
+	};
+};
+
 &clk_hse {
 	clock-frequency = <25000000>;
 };
--- a/arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts
+++ b/arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts
@@ -36,6 +36,56 @@
 	};
 };
 
+&adc1 {
+	channel@0 {
+		reg = <0>;
+		st,min-sample-time-ns = <20000>;
+		label = "p24v_hpdcm";
+	};
+
+	channel@1 {
+		reg = <1>;
+		st,min-sample-time-ns = <20000>;
+		label = "p24v_stp";
+	};
+
+	channel@3 {
+		reg = <3>;
+		st,min-sample-time-ns = <200000>;
+		label = "phint1_ain";
+	};
+
+	channel@5 {
+		reg = <5>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpout1_i";
+	};
+
+	channel@9 {
+		reg = <9>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpout0_i";
+	};
+
+	channel@13 {
+		reg = <13>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpdcm0_i2";
+	};
+
+	channel@15 {
+		reg = <15>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpdcm1_i2";
+	};
+
+	channel@18 {
+		reg = <18>;
+		st,min-sample-time-ns = <20000>;
+		label = "hpdcm0_i1";
+	};
+};
+
 &clk_hse {
 	clock-frequency = <24000000>;
 };
--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -90,7 +90,7 @@
 };
 
 &adc {
-	/* ANA0, ANA1 are dedicated pins and don't need pinctrl: only in6. */
+	/* ANA0, ANA1 are dedicated pins and don't need pinctrl. */
 	pinctrl-0 = <&adc12_pins_mecsbc>;
 	pinctrl-names = "default";
 	vdd-supply = <&v3v3>;
@@ -102,78 +102,30 @@
 &adc1 {
 	status = "okay";
 
-	channel@0 {
-		reg = <0>;
-		st,min-sample-time-ns = <20000>;
-		label = "p24v_stp";
-	};
-
-	channel@1 {
-		reg = <1>;
-		st,min-sample-time-ns = <20000>;
-		label = "p24v_hpdcm";
-	};
-
 	channel@2 {
 		reg = <2>;
 		st,min-sample-time-ns = <20000>;
 		label = "ain0";
 	};
 
-	channel@3 {
-		reg = <3>;
-		st,min-sample-time-ns = <20000>;
-		label = "hpdcm1_i2";
-	};
-
-	channel@5 {
-		reg = <5>;
-		st,min-sample-time-ns = <20000>;
-		label = "hpout1_i";
-	};
-
 	channel@6 {
 		reg = <6>;
 		st,min-sample-time-ns = <20000>;
 		label = "ain1";
 	};
 
-	channel@9 {
-		reg = <9>;
-		st,min-sample-time-ns = <20000>;
-		label = "hpout0_i";
-	};
-
 	channel@10 {
 		reg = <10>;
 		st,min-sample-time-ns = <200000>;
 		label = "phint0_ain";
 	};
 
-	channel@13 {
-		reg = <13>;
-		st,min-sample-time-ns = <200000>;
-		label = "phint1_ain";
-	};
-
-	channel@15 {
-		reg = <15>;
-		st,min-sample-time-ns = <20000>;
-		label = "hpdcm0_i1";
-	};
-
 	channel@16 {
 		reg = <16>;
 		st,min-sample-time-ns = <20000>;
 		label = "lsin";
 	};
 
-	channel@18 {
-		reg = <18>;
-		st,min-sample-time-ns = <20000>;
-		label = "hpdcm0_i2";
-	};
-
 	channel@19 {
 		reg = <19>;
 		st,min-sample-time-ns = <20000>;


