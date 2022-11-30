Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456B779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8F6C433C1;
	Wed, 30 Nov 2022 18:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833933;
	bh=aIm2H0w0AbMFu6hd3E1qbf70hMRpHFCJC1b8eZ5JeOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7+BbnnZwkIbXNDKVBCLV1rtwQTYGkSiUxR/I1u3BIbYh4zt9eCg36JlLFNWDc4xZ
	 Dszov5xzZKcbfK2QTVOjwBX2V7n3tpLp9WI5jlWIGttDPKoyU3QGZjCBtEquFdb09T
	 FivY3usnUFhPCG95lUIO4KLVNJ7QR3f76v81au4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Haller <d.haller@phytec.de>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/289] ARM: dts: am335x-pcm-953: Define fixed regulators in root node
Date: Wed, 30 Nov 2022 19:20:35 +0100
Message-Id: <20221130180545.264086211@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dominik Haller <d.haller@phytec.de>

[ Upstream commit 8950f345a67d8046d2472dd6ea81fa18ef5b4844 ]

Remove the regulators node and define fixed regulators in the root node.
Prevents the sdhci-omap driver from waiting in probe deferral forever
because of the missing vmmc-supply and keeps am335x-pcm-953 consistent with
the other Phytec AM335 boards.

Fixes: bb07a829ec38 ("ARM: dts: Add support for phyCORE-AM335x PCM-953 carrier board")
Signed-off-by: Dominik Haller <d.haller@phytec.de>
Message-Id: <20221011143115.248003-1-d.haller@phytec.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-pcm-953.dtsi | 28 +++++++++++++--------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-pcm-953.dtsi b/arch/arm/boot/dts/am335x-pcm-953.dtsi
index dae448040a97..947497413977 100644
--- a/arch/arm/boot/dts/am335x-pcm-953.dtsi
+++ b/arch/arm/boot/dts/am335x-pcm-953.dtsi
@@ -12,22 +12,20 @@ / {
 	compatible = "phytec,am335x-pcm-953", "phytec,am335x-phycore-som", "ti,am33xx";
 
 	/* Power */
-	regulators {
-		vcc3v3: fixedregulator@1 {
-			compatible = "regulator-fixed";
-			regulator-name = "vcc3v3";
-			regulator-min-microvolt = <3300000>;
-			regulator-max-microvolt = <3300000>;
-			regulator-boot-on;
-		};
+	vcc3v3: fixedregulator1 {
+		compatible = "regulator-fixed";
+		regulator-name = "vcc3v3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+	};
 
-		vcc1v8: fixedregulator@2 {
-			compatible = "regulator-fixed";
-			regulator-name = "vcc1v8";
-			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <1800000>;
-			regulator-boot-on;
-		};
+	vcc1v8: fixedregulator2 {
+		compatible = "regulator-fixed";
+		regulator-name = "vcc1v8";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-boot-on;
 	};
 
 	/* User IO */
-- 
2.35.1



