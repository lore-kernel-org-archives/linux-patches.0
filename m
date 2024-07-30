Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52BC19F467;
	Tue, 30 Jul 2024 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355167; cv=none; b=Vqojlhwq1+/lOiNOvutVcbgj3GvF5MM1HPZj41mRGyl6Qmtpv+TPbP8sefrNXrtVE1rqPkrawsTlTdy8HjuEgZG1cgJ5ZGhTK2fvl/mSBjfGQ0C3k6FklTrH2FlWK1LWOzp/TehaXwZXM0x5lXrS1b+GG6NgSUPUp/Pe/ZUTtwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355167; c=relaxed/simple;
	bh=n59/OwuGgk7L4WAw0NhWvmBMGrY1uYAWxj9XllhxDis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsjNs/6YqRMdQicOXK8hdqJTqAzgb3jv8+sP8Fu+QFF5tDloYfVTP9XBHUOqoTEWmNZyXVbeZBeT2DKlhqWlGWbBWijohKP2nZ/mRTqLF/69Ptz/1rAO42LEzinz+oVNfMZ85ypOP0gIIT6u7u5NujjxWXB+bFizcU22XT/ZVRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFmwHwRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFmwHwRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63886C32782;
	Tue, 30 Jul 2024 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355166;
	bh=n59/OwuGgk7L4WAw0NhWvmBMGrY1uYAWxj9XllhxDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFmwHwRj9nAJNERdA3vs5LjitbMcuxug9zK2vIkty3OlWzT4ZFmQ60xLfGE8vaCXR
	 SGPpAzNMUS7C1m22H7+4UCTHnNAkV3ehbm/tVeHi8dZjlKDWR78MSeKq2Nun0Fdj44
	 TWuEq67bJmk/LQBjkjQIPEp/crY7EYlwEavS6NNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/440] arm64: dts: renesas: r8a779g0: Add secondary CA76 CPU cores
Date: Tue, 30 Jul 2024 17:44:57 +0200
Message-ID: <20240730151618.264294548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 68c9c53d45fa9c48a89d8a9a4d1555b9e91add69 ]

Complete the description of the Cortex-A76 CPU cores and L3 cache
controllers on the Renesas R-Car V4H (R8A779G0) SoC, including CPU
topology and PSCI support for enabling CPU cores.

R-Car V4H has 4 Cortex-A76 cores, grouped in 2 clusters.

Based on a patch in the BSP by Takeshi Kihara.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/ccb55458bd87f8ba70d28c61bcc254f22184824c.1668429870.git.geert+renesas@glider.be
Stable-dep-of: 6fca24a07e1d ("arm64: dts: renesas: r8a779a0: Add missing hypervisor virtual timer IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi | 70 +++++++++++++++++++++--
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
index 9f6a30cf315f2..8aa3ea645668c 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
@@ -18,12 +18,60 @@ cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
 
+		cpu-map {
+			cluster0 {
+				core0 {
+					cpu = <&a76_0>;
+				};
+				core1 {
+					cpu = <&a76_1>;
+				};
+			};
+
+			cluster1 {
+				core0 {
+					cpu = <&a76_2>;
+				};
+				core1 {
+					cpu = <&a76_3>;
+				};
+			};
+		};
+
 		a76_0: cpu@0 {
 			compatible = "arm,cortex-a76";
 			reg = <0>;
 			device_type = "cpu";
 			power-domains = <&sysc R8A779G0_PD_A1E0D0C0>;
 			next-level-cache = <&L3_CA76_0>;
+			enable-method = "psci";
+		};
+
+		a76_1: cpu@100 {
+			compatible = "arm,cortex-a76";
+			reg = <0x100>;
+			device_type = "cpu";
+			power-domains = <&sysc R8A779G0_PD_A1E0D0C1>;
+			next-level-cache = <&L3_CA76_0>;
+			enable-method = "psci";
+		};
+
+		a76_2: cpu@10000 {
+			compatible = "arm,cortex-a76";
+			reg = <0x10000>;
+			device_type = "cpu";
+			power-domains = <&sysc R8A779G0_PD_A1E0D1C0>;
+			next-level-cache = <&L3_CA76_1>;
+			enable-method = "psci";
+		};
+
+		a76_3: cpu@10100 {
+			compatible = "arm,cortex-a76";
+			reg = <0x10100>;
+			device_type = "cpu";
+			power-domains = <&sysc R8A779G0_PD_A1E0D1C1>;
+			next-level-cache = <&L3_CA76_1>;
+			enable-method = "psci";
 		};
 
 		L3_CA76_0: cache-controller-0 {
@@ -32,6 +80,18 @@ L3_CA76_0: cache-controller-0 {
 			cache-unified;
 			cache-level = <3>;
 		};
+
+		L3_CA76_1: cache-controller-1 {
+			compatible = "cache";
+			power-domains = <&sysc R8A779G0_PD_A2E0D1>;
+			cache-unified;
+			cache-level = <3>;
+		};
+	};
+
+	psci {
+		compatible = "arm,psci-1.0", "arm,psci-0.2";
+		method = "smc";
 	};
 
 	extal_clk: extal {
@@ -491,7 +551,7 @@ gic: interrupt-controller@f1000000 {
 			reg = <0x0 0xf1000000 0 0x20000>,
 			      <0x0 0xf1060000 0 0x110000>;
 			interrupts = <GIC_PPI 9
-				      (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_HIGH)>;
+				      (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		};
 
 		prr: chipid@fff00044 {
@@ -502,9 +562,9 @@ prr: chipid@fff00044 {
 
 	timer {
 		compatible = "arm,armv8-timer";
-		interrupts-extended = <&gic GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
-				      <&gic GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
-				      <&gic GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
-				      <&gic GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>;
+		interrupts-extended = <&gic GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+				      <&gic GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+				      <&gic GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+				      <&gic GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 };
-- 
2.43.0



