Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254562EE60B;
	Tue, 17 Jun 2025 16:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177955; cv=none; b=Y6ASn/63s24aWj+FHHrSsdM5/vE+z6LMLyDkffquupFi5TvnwludKSTqj+ewAVVCRpZg1d6xNhMlGMfkNceNhwHZiNyiz0egzeqewMSozznSOk2GHpxEB/aZxkH2OLQobMXsVvaCp2EAdtoztAOqRBXd5OfptKyQyGODRihgYgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177955; c=relaxed/simple;
	bh=e3bOPzxv6t/kg3hLKK3CB5ZuyNb65Mn1cHNpvc6pe+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4c4Ofn5AbCcFtdqwMJWInVNyINdBIQJOP9/viTvAxZXzkHEmFKdHtU3YAaHnHWZaYmWhxLXMDX9i4J+JGz3fK0FyWYVYyZC4321rQieIC0OhDxLN/RKxxBEqdR3IHtzMxVbluIoK12nOrpX5gSWyBOtclSYhPr3drkuYDHk/+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvTFEvEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvTFEvEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B256C4CEE3;
	Tue, 17 Jun 2025 16:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177954;
	bh=e3bOPzxv6t/kg3hLKK3CB5ZuyNb65Mn1cHNpvc6pe+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvTFEvEdMjK5+5Weef4VO1V8M0SftO/3TbX5/aopDMywDAgh2kEdfoiGM6xmFqO/y
	 GxNDrAOZ7ihf57GW3qYgqD5JIZKxSR1i2ndpX5RxNObl8Udmar6zK6fqEN09g0o/N1
	 ww76D4n4EIuFgJuz+jQdzYdX1GAd3zvgYFy4olwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 388/780] arm64: tegra: Drop remaining serial clock-names and reset-names
Date: Tue, 17 Jun 2025 17:21:36 +0200
Message-ID: <20250617152507.259922267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 4cd763297c2203c6ba587d7d4a9105f96597b998 ]

The referenced commit only removed some of the names, missing all that
weren't in use at the time. The commit removes the rest.

Fixes: 71de0a054d0e ("arm64: tegra: Drop serial clock-names and reset-names")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://lore.kernel.org/r/20250428-tegra-serial-fixes-v1-1-4f47c5d85bf6@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra186.dtsi | 12 ------------
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 12 ------------
 2 files changed, 24 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index 2b3bb5d0af17b..f0b7949df92c0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -621,9 +621,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&bpmp TEGRA186_CLK_UARTB>;
-		clock-names = "serial";
 		resets = <&bpmp TEGRA186_RESET_UARTB>;
-		reset-names = "serial";
 		status = "disabled";
 	};
 
@@ -633,9 +631,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&bpmp TEGRA186_CLK_UARTD>;
-		clock-names = "serial";
 		resets = <&bpmp TEGRA186_RESET_UARTD>;
-		reset-names = "serial";
 		status = "disabled";
 	};
 
@@ -645,9 +641,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&bpmp TEGRA186_CLK_UARTE>;
-		clock-names = "serial";
 		resets = <&bpmp TEGRA186_RESET_UARTE>;
-		reset-names = "serial";
 		status = "disabled";
 	};
 
@@ -657,9 +651,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&bpmp TEGRA186_CLK_UARTF>;
-		clock-names = "serial";
 		resets = <&bpmp TEGRA186_RESET_UARTF>;
-		reset-names = "serial";
 		status = "disabled";
 	};
 
@@ -1236,9 +1228,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&bpmp TEGRA186_CLK_UARTC>;
-		clock-names = "serial";
 		resets = <&bpmp TEGRA186_RESET_UARTC>;
-		reset-names = "serial";
 		status = "disabled";
 	};
 
@@ -1248,9 +1238,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&bpmp TEGRA186_CLK_UARTG>;
-		clock-names = "serial";
 		resets = <&bpmp TEGRA186_RESET_UARTG>;
-		reset-names = "serial";
 		status = "disabled";
 	};
 
diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 33f92b77cd9d9..c369507747851 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -766,9 +766,7 @@
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTD>;
-			clock-names = "serial";
 			resets = <&bpmp TEGRA194_RESET_UARTD>;
-			reset-names = "serial";
 			status = "disabled";
 		};
 
@@ -778,9 +776,7 @@
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTE>;
-			clock-names = "serial";
 			resets = <&bpmp TEGRA194_RESET_UARTE>;
-			reset-names = "serial";
 			status = "disabled";
 		};
 
@@ -790,9 +786,7 @@
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTF>;
-			clock-names = "serial";
 			resets = <&bpmp TEGRA194_RESET_UARTF>;
-			reset-names = "serial";
 			status = "disabled";
 		};
 
@@ -817,9 +811,7 @@
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 207 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTH>;
-			clock-names = "serial";
 			resets = <&bpmp TEGRA194_RESET_UARTH>;
-			reset-names = "serial";
 			status = "disabled";
 		};
 
@@ -1616,9 +1608,7 @@
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTC>;
-			clock-names = "serial";
 			resets = <&bpmp TEGRA194_RESET_UARTC>;
-			reset-names = "serial";
 			status = "disabled";
 		};
 
@@ -1628,9 +1618,7 @@
 			reg-shift = <2>;
 			interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&bpmp TEGRA194_CLK_UARTG>;
-			clock-names = "serial";
 			resets = <&bpmp TEGRA194_RESET_UARTG>;
-			reset-names = "serial";
 			status = "disabled";
 		};
 
-- 
2.39.5



