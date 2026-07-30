Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AA043C7A2;
	Thu, 30 Jul 2026 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425349; cv=none; b=ecGoO1fYnNPeHCCw/zmO0ZLA+uxEHXPXHWDLH9JO+rVRqASDhYODG9ARb21hjOUB9Wdx+ZPreb4iwBJGhrvMdHYgKlG2j6pBfd1KJQQJIn7EfbrBOU9rlcPHV2eZDM1ntrtmDXW7K04zey5uCJ9V4tLLZPI7/PD0vwZbKj+P6CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425349; c=relaxed/simple;
	bh=SmiOGsXY6454fKfZbRGWSJumFTiAdNzOoeNSiECmoWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+sr2GJv5s5x47WxanlzOavMF6eVRJk+ZfA/19UIeezGNxw73894PJAQXCKfcysmCWadOhHaACA12cUhtt44THp6kuxrqXSDGbKxGFk9hHpEpgr2BGxO2mFTJD2QtEgU2VmvRuk7dcXEInavtkNv7sWr4rZR+JmQ+DNuoJeU2Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhvGrF7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhvGrF7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2001F000E9;
	Thu, 30 Jul 2026 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425347;
	bh=7iH9FrAgTTKEqnhQHoBX6Ei6r3bHaocG3GZ5Qrkt0CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhvGrF7CJhoW2/vce0WqU+ibVgjsq7R8ajh0nuXcAHFVRkczAhogDLE0XDYc1RhHA
	 5j4RXxpoNEnCeh3a5UYGAYf1aoxmCznD3F7waxoYVl4T+trYONQq13Nt8wAGkAO8pH
	 kqVyEuxdg+2Wdowlc4B9L4FnaxYlLVxAmUaSK2mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/602] arm64: tegra: Fix CPU compatible string to cortex-a78ae on Tegra234
Date: Thu, 30 Jul 2026 16:07:08 +0200
Message-ID: <20260730141436.767107572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 75428e70a69252..c1d2d91975057a 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5262,7 +5262,7 @@ cpus {
 		#size-cells = <0>;
 
 		cpu0_0: cpu@0 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00000>;
 
@@ -5281,7 +5281,7 @@ cpu0_0: cpu@0 {
 		};
 
 		cpu0_1: cpu@100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00100>;
 
@@ -5300,7 +5300,7 @@ cpu0_1: cpu@100 {
 		};
 
 		cpu0_2: cpu@200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00200>;
 
@@ -5319,7 +5319,7 @@ cpu0_2: cpu@200 {
 		};
 
 		cpu0_3: cpu@300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x00300>;
 
@@ -5338,7 +5338,7 @@ cpu0_3: cpu@300 {
 		};
 
 		cpu1_0: cpu@10000 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10000>;
 
@@ -5357,7 +5357,7 @@ cpu1_0: cpu@10000 {
 		};
 
 		cpu1_1: cpu@10100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10100>;
 
@@ -5376,7 +5376,7 @@ cpu1_1: cpu@10100 {
 		};
 
 		cpu1_2: cpu@10200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10200>;
 
@@ -5395,7 +5395,7 @@ cpu1_2: cpu@10200 {
 		};
 
 		cpu1_3: cpu@10300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x10300>;
 
@@ -5414,7 +5414,7 @@ cpu1_3: cpu@10300 {
 		};
 
 		cpu2_0: cpu@20000 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20000>;
 
@@ -5433,7 +5433,7 @@ cpu2_0: cpu@20000 {
 		};
 
 		cpu2_1: cpu@20100 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20100>;
 
@@ -5452,7 +5452,7 @@ cpu2_1: cpu@20100 {
 		};
 
 		cpu2_2: cpu@20200 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20200>;
 
@@ -5471,7 +5471,7 @@ cpu2_2: cpu@20200 {
 		};
 
 		cpu2_3: cpu@20300 {
-			compatible = "arm,cortex-a78";
+			compatible = "arm,cortex-a78ae";
 			device_type = "cpu";
 			reg = <0x20300>;
 
-- 
2.53.0



