Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B618314A0B8;
	Tue, 25 Jun 2024 09:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308556; cv=none; b=X2PItVqK4vcrSwa8uxl4tOqvRvzmNH5qXUc2G7MwX1IwlzHonqfPQg4GUpIZ5hFTjb+D189wzB1GZOYhppETg/rgr8t/yC3qd1NMQH8gSkW2DvZtsr9SxeBZc63U/zMK2XCYmjt9zscJo+r2mUcR+5xzcDZXax/9KaSQp87ixok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308556; c=relaxed/simple;
	bh=5peioEKuDdC9OYpptyA+Qi7mWqIO31/Xukc2TAVf/rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltG5kQt0mww+KUoDyDVxaHmAtpOKm0bLAaSU0IWFiRka+4uZz03Ni4JEKlq5ImmDaoMLljveFDsZMDPyLafp6zYlESXSYf9IcgF5Yg200Htwrv4g9qMDgypehOKt32rtfoltMDh5RINLhXeD072E77mb37gzkD89OVEylkjLNL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elkxBZwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elkxBZwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC24C32781;
	Tue, 25 Jun 2024 09:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308556;
	bh=5peioEKuDdC9OYpptyA+Qi7mWqIO31/Xukc2TAVf/rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elkxBZwAJnokJvO3LhYH7g+Vgtq9vwxSWgue9LjSWjUM7pfqQgHj0sclMznI4pn7L
	 +dDxwSrRNtHBxpeMAQlN9phaZHqrXNFX6sudVg94L/ZErLiR1kjiPDynlbBLS2Ve7I
	 /qVDZnI8krDzvnd1KH0R8EF3GWv1B93Nlh4CoB7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 160/250] arm64: dts: imx8mp: Fix TC9595 input clock on DH i.MX8M Plus DHCOM SoM
Date: Tue, 25 Jun 2024 11:31:58 +0200
Message-ID: <20240625085554.202128355@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit c03984d43a9dd9282da54ccf275419f666029452 ]

The IMX8MP_CLK_CLKOUT2 supplies the TC9595 bridge with 13 MHz reference
clock. The IMX8MP_CLK_CLKOUT2 is supplied from IMX8MP_AUDIO_PLL2_OUT.
The IMX8MP_CLK_CLKOUT2 operates only as a power-of-two divider, and the
current 156 MHz is not power-of-two divisible to achieve 13 MHz.

To achieve 13 MHz output from IMX8MP_CLK_CLKOUT2, set IMX8MP_AUDIO_PLL2_OUT
to 208 MHz, because 208 MHz / 16 = 13 MHz.

Fixes: 20d0b83e712b ("arm64: dts: imx8mp: Add TC9595 bridge on DH electronics i.MX8M Plus DHCOM")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index 43f1d45ccc96f..f5115f9e8c473 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -254,7 +254,7 @@
 				  <&clk IMX8MP_CLK_CLKOUT2>,
 				  <&clk IMX8MP_AUDIO_PLL2_OUT>;
 		assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL2_OUT>;
-		assigned-clock-rates = <13000000>, <13000000>, <156000000>;
+		assigned-clock-rates = <13000000>, <13000000>, <208000000>;
 		reset-gpios = <&gpio4 1 GPIO_ACTIVE_HIGH>;
 		status = "disabled";
 
-- 
2.43.0



