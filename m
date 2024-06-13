Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313A14884B;
	Thu, 13 Jun 2024 12:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280204; cv=none; b=a1I4fWZ9zNdl9qmdNjstUJF7rcp9eyt3tGkVlpYyzxN8hmpaX4NW3NOFpAepNa1D3425Ov1/b3VhCPBQPGaa9ev6fLcNFsCmyTfptrRC71mOfCwwIOet4OgNxWH/XJD+1aFmuh+Fs2L18Zl7Kx8eBNl0hcwzZM1Fk85Mq6bd0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280204; c=relaxed/simple;
	bh=VjHUoFxe6y1EOeXAbLTvFJgDgKBQM+qfKBBcN7QyxSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R37Qb7pn1YoWyu3YRUGwb26HXQNA+6x0l4ZNfuBo6uhSjP/uUsDXwRBevuxeDcwRFpNSY6xvhV/RKxhq95F/HBv/qUDBNIEegEthIy7zh3kH7blUqo4rvUQpgtVzZyCh85wbTjLuJIatgIy7roKI4qFNY9V6IS+JyspZ7YENhzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIKreNs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIKreNs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFBCC2BBFC;
	Thu, 13 Jun 2024 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280203;
	bh=VjHUoFxe6y1EOeXAbLTvFJgDgKBQM+qfKBBcN7QyxSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIKreNs06icNBYnyXsV0SBu/DYnmO4u1haamECARZxU6aNcpj21DNySuwghXbuKL8
	 g8kiAgH11TdDneuO2lCbT0MFFFg4F6EFwXqldh6gMCymHr+KzKnlknW/0vbrITRlGY
	 K5riS7SvTPQqM2gUL6womCKGCjpTsX5dCY2Gdbr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 177/202] arm64: tegra: Correct Tegra132 I2C alias
Date: Thu, 13 Jun 2024 13:34:35 +0200
Message-ID: <20240613113234.569935674@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -569,7 +569,7 @@
 		status = "disabled";
 	};
 
-	rtc@7000e000 {
+	tegra_rtc: rtc@7000e000 {
 		compatible = "nvidia,tegra124-rtc", "nvidia,tegra20-rtc";
 		reg = <0x0 0x7000e000 0x0 0x100>;
 		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;


