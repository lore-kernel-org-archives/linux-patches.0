Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F115F40587A;
	Tue, 21 Jul 2026 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658437; cv=none; b=rr4mHYjKjsF2iuOxii/jI5WRWUNUp7y87jdl465r4Hdedwr1BBS62IkNU4WeVysPv5uqMJ3PeKhHqIsMwCdAvzij2nXr5Pw+fwU/57VHXsf3peKjl2K/ZiQO5/joM9paTvVd0A8uBIE8wg1AaZYAVF0OYpBuQb52RNXBySpV7hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658437; c=relaxed/simple;
	bh=2aVPhwUNzrjGSKOiAKx7YUDPMxDJI9eErk/x4zylXNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFtJ0Oq/T0/b4xSbGp/rg0XLY/pzf+r0k2HYBHQ+WDCoqlg1oqHlLst2QIhyFvdzvyuhd36xFW8Y8DOCAmFzEnHVqjVNU1OWC2s7x1iINQgiXevLb+EuXzVxSm5sFW+ILfOhPizzSxr7s5ydP3iNv8B/bXRBm4c0IiCmEQ7vIcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FC3nZ46H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FC3nZ46H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A321F000E9;
	Tue, 21 Jul 2026 18:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658433;
	bh=f5EoACfLCO8qd5bi9XobXL55iOsNQj5ufSVD3qxXoy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FC3nZ46H4T0ttfzsWqy1CFYDgrfEFjGVy7X7RyQy8DYBpqAkxyv6Px4XPcDTsZNEg
	 VVIb2BEMqwqrbNSSmUa7WdUAhSW0HuSd24NJnTIbDs4bDNJQjkYi5wclX6vjwrUnvX
	 8hj2l2X8Oi6RbZA18ez6MAQe7k6KaLR9KZjlS7/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 1115/1611] ARM: dts: stm32: stm32mp15x-mecio1-io: Move divergent mecio1 ADC channels to board files
Date: Tue, 21 Jul 2026 17:20:31 +0200
Message-ID: <20260721152540.497718474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


