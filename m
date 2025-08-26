Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DDF2248A5;
	Tue, 26 Aug 2025 11:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207106; cv=none; b=k3Yh4NGukgi2qKSbThYqggUUapx9V/giT0LB3xR7WDso5VAMlM/FLBNF07pjh3ataUkp6/t/opWep+Cr+6gm6Uqd1Une3u/uv9Bq6xfqhsjF7yiPFW8ad2IEbOQ6iukVCs10J432LeXDww9jVZch4Ri/XAEOs4o1m60luILUsyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207106; c=relaxed/simple;
	bh=4QEHNwvO1ndmzJIACCbtDEN7vc77KapDLaNBGbPG32M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKDr8fU1hmXZ9tj5zGyr3F8avB9avWYVRsl2Z1kggclA78rgd/srr0wI0YrFe1gFAWU80vKMqiAY04Ql0zdJ76Ip+rCIel3Ef3r/V9SH4PWaihGbwDVTLDG0A9XW4WBWHp1YF1bLkVB7dZpxF3BLLTx58rZwedE0lEDfa9AHrkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUNg+9Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUNg+9Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11416C4CEF1;
	Tue, 26 Aug 2025 11:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207106;
	bh=4QEHNwvO1ndmzJIACCbtDEN7vc77KapDLaNBGbPG32M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUNg+9Us76yijPq7ziPcy7tYu+LytBoVSJVmgl0ClndA5MRMfjjaYo8z5CXho+ezx
	 mnJuGCrnCeEbjDY0Iyp0a4tWe+dgq2R3zAmrKYQA6KTwrmq3CSE+tZw4tSY7i1r7DQ
	 lpqLs/RfJIffqJBvaavIFXj9yKdcMkWK2x5KfaBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.16 054/457] arm64: dts: rockchip: Enable HDMI PHY clk provider on rk3576
Date: Tue, 26 Aug 2025 13:05:38 +0200
Message-ID: <20250826110938.689725897@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit aba7987a536cee67fb0cb724099096fd8f8f5350 upstream.

As with the RK3588 SoC, the HDMI PHY PLL on RK3576 can be used as a more
accurate pixel clock source for VOP2, which is actually mandatory to
ensure proper support for display modes handling.

Add the missing #clock-cells property to allow using the clock provider
functionality of HDMI PHY.

Fixes: ad0ea230ab2a ("arm64: dts: rockchip: Add hdmi for rk3576")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://lore.kernel.org/r/20250612-rk3576-hdmitx-fix-v1-2-4b11007d8675@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -2393,6 +2393,7 @@
 			reg = <0x0 0x2b000000 0x0 0x2000>;
 			clocks = <&cru CLK_PHY_REF_SRC>, <&cru PCLK_HDPTX_APB>;
 			clock-names = "ref", "apb";
+			#clock-cells = <0>;
 			resets = <&cru SRST_P_HDPTX_APB>, <&cru SRST_HDPTX_INIT>,
 				 <&cru SRST_HDPTX_CMN>, <&cru SRST_HDPTX_LANE>;
 			reset-names = "apb", "init", "cmn", "lane";


