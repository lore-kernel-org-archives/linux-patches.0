Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10062DFF13;
	Tue, 17 Jun 2025 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175456; cv=none; b=JsqT5DZN1pBA4BEVbw7f6VNMaP1TrQeTmehJv/OzLCVJB99efVci+QpUZsDQfSTEKM8Q41wMeZOM2W9oDt5wcdGkwxlqxd4s47BjVBy5/EA3P/g2Sixw8FRuO9A+CC4V7mWV29RvDx521cQE97FuCjb5NN5UDBDvedo0v/KygVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175456; c=relaxed/simple;
	bh=LVfpwqjP7aidfssQhpWsO0MBMWRaO0uRiaEe2TkLAhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSSzlEyg0q9MyGQagD/JjTswQ/I1P6WbLAgoyg5gcDypkT7X5MRO+fyNaqW4PW4/EymuILP81xVON+3MeUIg4t9duhNmgKFA8NDlQ9N6e9PjY6ncdZRbkNQ373I7HarhZun/FDcoHChOhkywnhIFXbMF4Vi0zPaecaysZlJQfkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbQ3LPCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbQ3LPCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3043AC4CEE3;
	Tue, 17 Jun 2025 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175456;
	bh=LVfpwqjP7aidfssQhpWsO0MBMWRaO0uRiaEe2TkLAhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbQ3LPCCYKuvxVeoAveNsw/9xiZ+FC+PRMlO6sdf+vvXnzKh5G7RkacWfWebWtMBW
	 XhOrpP9SbQFInJvNgJC0ufZWGfjg+o8ni6BQjZpBwfMjcSuZYCJ0AMJwJrOnmueE2r
	 ZrMXWVWake65G6LTfZsrbTzaxQI2zEj09JdOHc6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/356] arm64: tegra: Drop remaining serial clock-names and reset-names
Date: Tue, 17 Jun 2025 17:24:53 +0200
Message-ID: <20250617152345.381782496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



