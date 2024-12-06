Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC9E148832;
	Fri,  6 Dec 2024 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497059; cv=none; b=j/60gdEAKNRJhEUWss8B030TtzAghGgDrq7YcwNh6mQiCrBUsjCt2zN7W2SDeiTAfgWNUnSvaVq6XeK1eCLiqazwFrjfK9wlGJjgxZSk70hgFbyuCCQecwFmqRpjwwXlGrk24sxwNOsRC1X5n5RpAaPxlMhwrlWcBWmwBJ2pabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497059; c=relaxed/simple;
	bh=JjQfQXru1j4x+5QvWOPfuVKe7fbh2vLiLto3hGovUoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NI0wxp+rlTsx2ZrVlVox+1rQ9RZlYXNjilfAjZv95zs0vEAVOaoBifFyGtC8Zn+VzzpF+qGSgXC0o+MdpL8Pi3uGzEKLwQW0WapcLh9cjnoYU6QXUzrmQhIKZM1AitBBDqpQfAQnT15EMGcBk11xtzsyMEXbJyPT7dx/RznOwBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKBEI/hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKBEI/hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02FEC4CED1;
	Fri,  6 Dec 2024 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497059;
	bh=JjQfQXru1j4x+5QvWOPfuVKe7fbh2vLiLto3hGovUoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKBEI/hbUDWoT0mneW0tb3C4QajC03eRK0nUI8qnHJ3SFl3polOmtBPusWAB5SZ88
	 wHxLB4hC4RcIEuwpNH3xHx693rls8ucBW3Ruh8K2RgIrNWBgfK9MT19pCwo995Hrs2
	 rEL7Pyklvr0eSMieT8jdn0JkxLKvRi9GMszNe95A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/676] arm64: dts: ti: k3-j721e: Fix clock IDs for MCSPI instances
Date: Fri,  6 Dec 2024 15:29:20 +0100
Message-ID: <20241206143658.861934377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit ab09a68f3be04b2f9d1fc7cfc0e2225025cb9421 ]

The clock IDs for multiple MCSPI instances across wakeup domain
in J721e are incorrect when compared with documentation [1]. Fix
the clock ids to their appropriate values.

[1]https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721e/clocks.html

Fixes: 76aa309f9fa7 ("arm64: dts: ti: k3-j721e: Add MCSPI nodes")

Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Link: https://lore.kernel.org/r/20241023104532.3438851-3-a-dutta@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 05d6ef127ba78..1893d611b1735 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -637,7 +637,7 @@ mcu_spi0: spi@40300000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 274 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 274 0>;
+		clocks = <&k3_clks 274 1>;
 		status = "disabled";
 	};
 
@@ -648,7 +648,7 @@ mcu_spi1: spi@40310000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 275 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 275 0>;
+		clocks = <&k3_clks 275 1>;
 		status = "disabled";
 	};
 
@@ -659,7 +659,7 @@ mcu_spi2: spi@40320000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 276 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 276 0>;
+		clocks = <&k3_clks 276 1>;
 		status = "disabled";
 	};
 
-- 
2.43.0



