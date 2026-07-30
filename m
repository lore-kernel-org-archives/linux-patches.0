Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E2C43E9F9;
	Thu, 30 Jul 2026 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421172; cv=none; b=CxWCmq0HhdjrGznnqQCnS88i9dQrv2PWQ9xxxhgPgFjiFYHNyYBwR71TQWT81HbvlihdH6vWm+ro7qytC8VcqpArA1Tx49LwbZwglWJa6UbGpmIRV7CfhFgoqf97kimCWdsq9+7LbMCr0hU9MGMiN+Xf5ofx+NeR/PPZXEqhHo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421172; c=relaxed/simple;
	bh=DGAKmOVLMPBaC2bV+nM36ozETKIubBkGdKO9w/BxGds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0ZfyVBrAACZhffHVwMhMnggfxupHG8Kvq/Gc8S7KbS40d/yDZKvnzVGXOkBvDVmex/LW9yHeTFa8bBUFyv7RWDylD7oaASASV2PyrdIi0Ati51z9aOpoZfTnmQTatQcQW3sq8sKn2WEeT0kcWwUBGHB9yZ0g52WRBudJgBNmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5kB0v5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5kB0v5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB061F00A3D;
	Thu, 30 Jul 2026 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421170;
	bh=qlR8QR7HFJiecCo7Z+6+MjJaY66+sVsTHKa3zSqykFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5kB0v5wWJAJ9pulZdWH+osFmQhhwM2T0iZfJQnTAPbrrn2Wo8J8glANwTQ/0K70V
	 TZYtkwbPMW9TwYeokr0u7COrVSJ36+krCpeWkLPZGUHt2eKf6cP71/hpMVnoeOXA14
	 s8QbdcKNfMR/bFjBCNF+lYk+fQ4hKimKUiBefwDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 015/744] arm64: tegra: Fix CPU compatible string to cortex-a78ae on Tegra234
Date: Thu, 30 Jul 2026 16:04:48 +0200
Message-ID: <20260730141444.606922274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 0dfa1e960f86e032007882b032c5cc7d14ebe73e ]

The Tegra234 SoC uses Cortex-A78AE cores, not Cortex-A78. Update the
compatible string for all CPU nodes to match the actual hardware.

Tegra234 hardware reports:
  # head /proc/cpuinfo | egrep 'implementer|part'
  CPU implementer : 0x41
  CPU part        : 0xd42

Which maps to (from arch/arm64/include/asm/cputype.h):
  #define ARM_CPU_IMP_ARM              0x41
  #define ARM_CPU_PART_CORTEX_A78AE    0xD42

Fixes: a12cf5c339b08 ("arm64: tegra: Describe Tegra234 CPU hierarchy")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 18220cdac9f9bb..eda23431ed05ea 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5339,7 +5339,7 @@ cpus {
 		#size-cells = <0>;
 
 		cpu0_0: cpu@0 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00000>;
 
@@ -5358,7 +5358,7 @@ cpu0_0: cpu@0 {
 		};
 
 		cpu0_1: cpu@100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00100>;
 
@@ -5377,7 +5377,7 @@ cpu0_1: cpu@100 {
 		};
 
 		cpu0_2: cpu@200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00200>;
 
@@ -5396,7 +5396,7 @@ cpu0_2: cpu@200 {
 		};
 
 		cpu0_3: cpu@300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00300>;
 
@@ -5415,7 +5415,7 @@ cpu0_3: cpu@300 {
 		};
 
 		cpu1_0: cpu@10000 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10000>;
 
@@ -5434,7 +5434,7 @@ cpu1_0: cpu@10000 {
 		};
 
 		cpu1_1: cpu@10100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10100>;
 
@@ -5453,7 +5453,7 @@ cpu1_1: cpu@10100 {
 		};
 
 		cpu1_2: cpu@10200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10200>;
 
@@ -5472,7 +5472,7 @@ cpu1_2: cpu@10200 {
 		};
 
 		cpu1_3: cpu@10300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10300>;
 
@@ -5491,7 +5491,7 @@ cpu1_3: cpu@10300 {
 		};
 
 		cpu2_0: cpu@20000 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20000>;
 
@@ -5510,7 +5510,7 @@ cpu2_0: cpu@20000 {
 		};
 
 		cpu2_1: cpu@20100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20100>;
 
@@ -5529,7 +5529,7 @@ cpu2_1: cpu@20100 {
 		};
 
 		cpu2_2: cpu@20200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20200>;
 
@@ -5548,7 +5548,7 @@ cpu2_2: cpu@20200 {
 		};
 
 		cpu2_3: cpu@20300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20300>;
 
-- 
2.53.0



