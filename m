Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC7120ED;
	Thu, 13 Jun 2024 12:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282681; cv=none; b=UZymYzDs4PuIFleFz0eLYZ2mTeHLq0OdAhbXEqV4jYz6RDlvCmG4wUrnMkucrNounxNC97JR8r0Jo7H9pZWRaQ6XePdBdYlmg8CUWr/N7T/9lzv3wem+pn2UHJ7qR/5Hd9BlJyjLOZEyHgFmmoFRPqQmx8yEnfCVX5ohYaXeELg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282681; c=relaxed/simple;
	bh=2jdWp2zf4EXvcTYj4mMViyRfPDluZOLCLN7NkPSBowc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsmgOEkS1ru1v5KUtWLSHRHQzQALm4jBuy7sGU+1yGigavH6qbFiTOh/e/x4dR+KsRnG24ZfnMqJ8PoPHzxyKhEiTlAsBrS2AC0jQo0D2Ib/tVDhpMdBxNWzDDb94Ea9ITsaHoRQ3cFFtbecbdl900NuODuvZXmtnSSt1rcgjaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkUHJdNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkUHJdNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00402C4AF1A;
	Thu, 13 Jun 2024 12:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282681;
	bh=2jdWp2zf4EXvcTYj4mMViyRfPDluZOLCLN7NkPSBowc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkUHJdNXCSyioBAAV4IGdSn1mcZ6brG4y4BdO69YeQIN6MfKIeem+DGHXQ3BCgBE3
	 +p4ia2Z9dw4SODsWUBGWYTKpsskgmZXHhzMzESF9U0v+wTn+YPWndf3+EbBsoBsmKM
	 EpsL7bwx8vVita1P3tpMpKhQoEXMGJ/ZKV+3iHZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 360/402] arm64: tegra: Correct Tegra132 I2C alias
Date: Thu, 13 Jun 2024 13:35:17 +0200
Message-ID: <20240613113316.179065176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


