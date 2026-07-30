Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579E0337699;
	Thu, 30 Jul 2026 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423530; cv=none; b=jefGcaHVx/e32pVccnJ4TRmtYQoBqSHmyqA6oUZt/o48tsC2gi1vrmoZM735kH+rJnncUEmcwosBGDrLPZ35prFsockiLokR10kIeqQJ8s08D3TzIQMBFhs6tECsRTQGi2sRW2BdEt08O/7TKnkX07FfAMFhhGNJguc1lFZ/Poc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423530; c=relaxed/simple;
	bh=7F/XuT2u0CRWnTyROuE/vgMWIa30rS4+9baHhb7cCLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opQpifr0wktJyJT6e4ipiTGo5ALiheOvdBsgAcC/8KZtFgjwZZPMTSWxt+VmxCTrk2wzK++oX2wWdIUL9c39FBIDtQtI2GTKGI2OqdqKKxSNNT/u5JOq/ChXOwYVBCtYlydXJGqCb5heiJzMH9Jv+cjzOa6NgUbDFW8qHgow9BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtM5xd1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtM5xd1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37601F000E9;
	Thu, 30 Jul 2026 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423529;
	bh=hg7x6yB6OGdZNkpv/yCPqcF/YmOCpRfwbsqRECkmZyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtM5xd1+5mNQRIaymnKNbvwJ+JLk2F1JfCCUav+Tmc5VSSKVGSxENQ7maeqpNG5G6
	 1UDjspMklShuIzc8SNPYP8uh2hYkobrPV+H8uDb9O3k1XoHEfGKGtD0KkOdblzU0S/
	 pP/kahPVpFSCB/Gz/bc3SFv6tPOZKlwiOnwhh79k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/675] arm64: tegra: Fix CPU compatible string to cortex-a78ae on Tegra234
Date: Thu, 30 Jul 2026 16:06:02 +0200
Message-ID: <20260730141445.802500981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 5b245977d6a037..345587fa1d9ad0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5345,7 +5345,7 @@ cpus {
 		#size-cells = <0>;
 
 		cpu0_0: cpu@0 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00000>;
 
@@ -5364,7 +5364,7 @@ cpu0_0: cpu@0 {
 		};
 
 		cpu0_1: cpu@100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00100>;
 
@@ -5383,7 +5383,7 @@ cpu0_1: cpu@100 {
 		};
 
 		cpu0_2: cpu@200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00200>;
 
@@ -5402,7 +5402,7 @@ cpu0_2: cpu@200 {
 		};
 
 		cpu0_3: cpu@300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00300>;
 
@@ -5421,7 +5421,7 @@ cpu0_3: cpu@300 {
 		};
 
 		cpu1_0: cpu@10000 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10000>;
 
@@ -5440,7 +5440,7 @@ cpu1_0: cpu@10000 {
 		};
 
 		cpu1_1: cpu@10100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10100>;
 
@@ -5459,7 +5459,7 @@ cpu1_1: cpu@10100 {
 		};
 
 		cpu1_2: cpu@10200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10200>;
 
@@ -5478,7 +5478,7 @@ cpu1_2: cpu@10200 {
 		};
 
 		cpu1_3: cpu@10300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10300>;
 
@@ -5497,7 +5497,7 @@ cpu1_3: cpu@10300 {
 		};
 
 		cpu2_0: cpu@20000 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20000>;
 
@@ -5516,7 +5516,7 @@ cpu2_0: cpu@20000 {
 		};
 
 		cpu2_1: cpu@20100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20100>;
 
@@ -5535,7 +5535,7 @@ cpu2_1: cpu@20100 {
 		};
 
 		cpu2_2: cpu@20200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20200>;
 
@@ -5554,7 +5554,7 @@ cpu2_2: cpu@20200 {
 		};
 
 		cpu2_3: cpu@20300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20300>;
 
-- 
2.53.0



