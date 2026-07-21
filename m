Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0BC472525;
	Tue, 21 Jul 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663429; cv=none; b=Q0mDupjyPgSnxQ9vvELbwe5t9GlZ6UY2l6+jZPVl8ddpxsOTKzx21KDR/i7QbtPPqnpI0a58ZW254d4ZpIISakOhc1dZ6dHqUdwqwXtBPOQQMb2Ri8qoc8qaOKnMMlPVnO/ZDvzdz324kaUX+kg2CVe/BLGAMcdBed/a8zYUBA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663429; c=relaxed/simple;
	bh=abAkO2PH7Ak+yVZyPP0SE2Lo0EOVHzFhp8unGBQPkuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBY/kopN1fvugy909P8IBrnSQeQFKSSvsIXG7A+TtQmCCG63cYfItofFKLjCdbXrGhvwrdtVO5VIbEz1budZZodR/C1Z23GZoQbhd/cnQG3ppGAV4J1C67Thvd05kqA9Unn+0Sznky7+f+KQozBnOZlkVdjb6rkWBysxhR8sR8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDfe/MFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDfe/MFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17C31F000E9;
	Tue, 21 Jul 2026 19:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663427;
	bh=GaaOa0skSGbbrkAflu6k6w4y7eWh67vRjYDNS8AL3eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDfe/MFyWb7p45/QR3TKgvmIkVKirVnZT+OAQprpRmpK5mKI8ztubLp4J77aOPvA1
	 fVr7wdOX6OYKFjUWqQFoxMbOIVo064yQxmTqsQef6pGXmeaYXHpuaaGvH9K40AfcXg
	 sEQQGvZiQ1afQTMRNiEyqIlalw+602yhhtQlF+PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.12 0818/1276] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix ADC sampling times
Date: Tue, 21 Jul 2026 17:21:01 +0200
Message-ID: <20260721152504.369944645@linuxfoundation.org>
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

commit 8407e611faf80ce790a393addf7b44cc595742af upstream.

Increase the minimum ADC sample times for all configured channels on
ADC1 and ADC2 to ensure measurement accuracy meets specifications.

The default 5us sample time is insufficient for the internal sampling
capacitor to fully charge. Increase the default time to 20us to relax
the input impedance requirements.

Additionally, the phint0_ain and phint1_ain channels require a much
longer sampling period due to their specific circuit design. Increase
their sample times to 200us. Remove stale comments regarding clock
cycles that no longer match the updated timings.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260318105123.819807-3-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi | 32 +++++++++----------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
index 1ce01bac9814..1b1299770ca0 100644
--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -104,80 +104,79 @@ &adc1 {
 
 	channel@0 {
 		reg = <0>;
-		/* 16.5 ck_cycles sampling time */
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "p24v_stp";
 	};
 
 	channel@1 {
 		reg = <1>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "p24v_hpdcm";
 	};
 
 	channel@2 {
 		reg = <2>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "ain0";
 	};
 
 	channel@3 {
 		reg = <3>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "hpdcm1_i2";
 	};
 
 	channel@5 {
 		reg = <5>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "hpout1_i";
 	};
 
 	channel@6 {
 		reg = <6>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "ain1";
 	};
 
 	channel@9 {
 		reg = <9>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "hpout0_i";
 	};
 
 	channel@10 {
 		reg = <10>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <200000>;
 		label = "phint0_ain";
 	};
 
 	channel@13 {
 		reg = <13>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <200000>;
 		label = "phint1_ain";
 	};
 
 	channel@15 {
 		reg = <15>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "hpdcm0_i1";
 	};
 
 	channel@16 {
 		reg = <16>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "lsin";
 	};
 
 	channel@18 {
 		reg = <18>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "hpdcm0_i2";
 	};
 
 	channel@19 {
 		reg = <19>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "hpdcm1_i1";
 	};
 };
@@ -187,14 +186,13 @@ &adc2 {
 
 	channel@2 {
 		reg = <2>;
-		/* 16.5 ck_cycles sampling time */
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "ain2";
 	};
 
 	channel@6 {
 		reg = <6>;
-		st,min-sample-time-ns = <5000>;
+		st,min-sample-time-ns = <20000>;
 		label = "ain3";
 	};
 };
-- 
2.55.0



