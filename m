Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A991411C5;
	Thu, 13 Jun 2024 12:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281510; cv=none; b=V7bRJ9umXiAB4lfVAYwYXVYQjLe60XnyudY4/isxvSZUCz8p4eMfCOXGcRjHEhRMzD2I7Apt9DKBs58VZbszi9fb+7ZCz6dX3B0u7S9sQrY8oAtdaeN8mpnAVvQm9+X2K4yvuw2x8VO1JKR4kY4uWsKv/JmuluBmNPGJ6Hu7id8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281510; c=relaxed/simple;
	bh=Zl3g4Gl+9Max8veYXrL2TJcw8GTfzNt0D5g3C6q2IZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJ500+tIS7W3+e/8BCCQwfup0rZxtT/AMqwM4T+xrN6gUbVqOunKsjRdbtud++ZmS5VAklLAPhRSY1dxv9owVUkFrmxzTrFqPzWz2sRGyK6hGFcS1dvEBmjxafK1tnUBo26Mia4n5Igx3jZcx+VDKSO1GxvC9oNkbgxgAEJviSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH3i9TfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH3i9TfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EAAC2BBFC;
	Thu, 13 Jun 2024 12:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281510;
	bh=Zl3g4Gl+9Max8veYXrL2TJcw8GTfzNt0D5g3C6q2IZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH3i9TfPiGwqI1g9JbEj+3ThPHHCd60312gETqC+kgaMdhmWD/y2B+t6lPJFIlaYR
	 FeUYgs9X9xBMfxMfUPyvILfRpSC81ErI8DGfYIcn4CTjFmLUsljGCbGoKyIYoPha43
	 VeAYtLo8KNmFfgeNMe/mWI8qgSOanjUqnKZ96Ork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 280/317] arm64: tegra: Correct Tegra132 I2C alias
Date: Thu, 13 Jun 2024 13:34:58 +0200
Message-ID: <20240613113258.381309466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 2633c58e1354d7de2c8e7be8bdb6f68a0a01bad7 upstream.

There is no such device as "as3722@40", because its name is "pmic".  Use
phandles for aliases to fix relying on full node path.  This corrects
aliases for RTC devices and also fixes dtc W=1 warning:

  tegra132-norrin.dts:12.3-36: Warning (alias_paths): /aliases:rtc0: aliases property is not a valid node (/i2c@7000d000/as3722@40)

Fixes: 0f279ebdf3ce ("arm64: tegra: Add NVIDIA Tegra132 Norrin support")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts |    4 ++--
 arch/arm64/boot/dts/nvidia/tegra132.dtsi       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra132-norrin.dts
@@ -9,8 +9,8 @@
 	compatible = "nvidia,norrin", "nvidia,tegra132", "nvidia,tegra124";
 
 	aliases {
-		rtc0 = "/i2c@7000d000/as3722@40";
-		rtc1 = "/rtc@7000e000";
+		rtc0 = &as3722;
+		rtc1 = &tegra_rtc;
 		serial0 = &uarta;
 	};
 
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -573,7 +573,7 @@
 		status = "disabled";
 	};
 
-	rtc@7000e000 {
+	tegra_rtc: rtc@7000e000 {
 		compatible = "nvidia,tegra124-rtc", "nvidia,tegra20-rtc";
 		reg = <0x0 0x7000e000 0x0 0x100>;
 		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;


