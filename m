Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39633D16E6;
	Tue, 21 Jul 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658405; cv=none; b=KOjFLJMxYk/zOYtrJhjMfkygTKA5j5/HXRwQ6MSp9KH+hWfY5V/63yJHe8xAUVkKiJCcCv+BKz9CPPj/czE1I+DyJLPrgWxuYGYSEASyBFZOVAdaxcjjzo+0I0aYwwtpVh3BWE2ClkDWpG3ST36R2cZlQrlA+jbksfFxYKg1lXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658405; c=relaxed/simple;
	bh=FUFsRn0CNbsmzLXq9xYYR1nInZpJ5Xp/8nPfVWk6GZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhhyeH8TwhyznAXLVrFcq4v+vIid8jdkMqRLxkRgVE79a6UWxbMrnBXVprbxim1V2bAGMwaMQohRUCiGjVYN8en+CU8nnaYFwytangSIf4wgO0tBJhxuVS545qmZH42u2NnZgoSB3yLzlRsprgAx1DhPW2N6NL/UdtIHkt2ZArY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srOK1Ztn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srOK1Ztn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2487A1F000E9;
	Tue, 21 Jul 2026 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658404;
	bh=doFu/vToPwt72TS98Iz24v+oiiC45iW+HNSx02228g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srOK1ZtnByYO1fJ5azYHqv5J7Fzp/qq+PlifFmRzYscZ4joCNYgFn3G9m319FMwFH
	 SNm7vHtegrilFMAC+fDg3nzxkyp09ZD0KLfoL7R4QhaIMob7UVlp3Tkd/nqkM/8z0M
	 0zcetqGV7l3LvDEZK7pfupfFcps7iVM1JKh5y6Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 1114/1611] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix ADC sampling times
Date: Tue, 21 Jul 2026 17:20:30 +0200
Message-ID: <20260721152540.476124473@linuxfoundation.org>
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
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |   32 +++++++++++--------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -104,80 +104,79 @@
 
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
@@ -187,14 +186,13 @@
 
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


