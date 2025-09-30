Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1CB1FC7C5;
	Tue, 30 Sep 2025 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244794; cv=none; b=UkSrfmdbBr7rOgfklOPABj3ezicPx71xWZODHBJDTt/z3x//gjquS0LS+eqEmvSgiKMv+rdNiAAvoMuaE9oYAIcqfwvEMZZFP5NCB2SJe0XkzjdCOQZ9KACize+/rTUs+Yj7qyPu3xwKavDHKoOfa1YERIxOy6A+F2yciXno0aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244794; c=relaxed/simple;
	bh=e5FFKuUC1YHm/GsR4Fll/+keDJKFCCzorA9hWQJyjrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd6ACC/N1jWfiEjX5+p02KCtcskPdI9a/ggvXO5EqLV3gEJN+fd8wMEJeGcKIKEn0aiaCFf8pzMiTWsWHMpIGcLuA8bSEXEs2VC46byHZrXZlDcADDlP9YnylcgvnLmvGS4KC0dj/V0Er6mky/21Kom36MupJwgCH3zYcXpZumk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsR2noiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsR2noiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C87FC4CEF0;
	Tue, 30 Sep 2025 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244793;
	bh=e5FFKuUC1YHm/GsR4Fll/+keDJKFCCzorA9hWQJyjrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsR2noiJAL65v0f/IvGGUI97/tTvYiRMbpWpLVGNZ4CwciW7nliolYkyKJP2KEdMS
	 FUccCGdJw5yT1LDHbKAkPNZPv4RdSZqq9FIsHzbp669wYDcY5jeheShwID7pw7z1Jt
	 dFHA4Jz60k6eeWFvZ3123+omSZKgqpyjeLNL8tio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.16 115/143] arm64: dts: marvell: cn913x-solidrun: fix sata ports status
Date: Tue, 30 Sep 2025 16:47:19 +0200
Message-ID: <20250930143835.817174646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

commit d3021e6aa11fecdafa85038a037c04d5bfeda9d5 upstream.

Commit "arm64: dts: marvell: only enable complete sata nodes" changed
armada-cp11x.dtsi disabling all sata ports status by default.

The author missed some dts which relied on the dtsi enabling all ports,
and just disabled unused ones instead.

Update dts for SolidRun cn913x based boards to enable the available
ports, rather than disabling the unvavailable one.

Further according to dt bindings the serdes phys are to be specified in
the port node, not the controller node.
Move those phys properties accordingly in clearfog base/pro/solidwan.

Fixes: 30023876aef4 ("arm64: dts: marvell: only enable complete sata nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/cn9130-cf.dtsi         | 7 ++++---
 arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts | 6 ++++--
 arch/arm64/boot/dts/marvell/cn9132-clearfog.dts    | 6 ++----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9130-cf.dtsi b/arch/arm64/boot/dts/marvell/cn9130-cf.dtsi
index ad0ab34b6602..bd42bfbe408b 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-cf.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-cf.dtsi
@@ -152,11 +152,12 @@ expander0_pins: cp0-expander0-pins {
 
 /* SRDS #0 - SATA on M.2 connector */
 &cp0_sata0 {
-	phys = <&cp0_comphy0 1>;
 	status = "okay";
 
-	/* only port 1 is available */
-	/delete-node/ sata-port@0;
+	sata-port@1 {
+		phys = <&cp0_comphy0 1>;
+		status = "okay";
+	};
 };
 
 /* microSD */
diff --git a/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts b/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
index 47234d0858dd..338853d3b179 100644
--- a/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
+++ b/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
@@ -563,11 +563,13 @@ &cp1_rtc {
 
 /* SRDS #1 - SATA on M.2 (J44) */
 &cp1_sata0 {
-	phys = <&cp1_comphy1 0>;
 	status = "okay";
 
 	/* only port 0 is available */
-	/delete-node/ sata-port@1;
+	sata-port@0 {
+		phys = <&cp1_comphy1 0>;
+		status = "okay";
+	};
 };
 
 &cp1_syscon0 {
diff --git a/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts b/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
index 0f53745a6fa0..115c55d73786 100644
--- a/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
+++ b/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
@@ -512,10 +512,9 @@ &cp1_sata0 {
 	status = "okay";
 
 	/* only port 1 is available */
-	/delete-node/ sata-port@0;
-
 	sata-port@1 {
 		phys = <&cp1_comphy3 1>;
+		status = "okay";
 	};
 };
 
@@ -631,9 +630,8 @@ &cp2_sata0 {
 	status = "okay";
 
 	/* only port 1 is available */
-	/delete-node/ sata-port@0;
-
 	sata-port@1 {
+		status = "okay";
 		phys = <&cp2_comphy3 1>;
 	};
 };
-- 
2.51.0



