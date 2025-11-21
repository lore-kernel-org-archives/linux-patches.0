Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E63226E6F4;
	Fri, 21 Nov 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731233; cv=none; b=NtxvxFkJbIOUnepANumSq2XhbiDa5IlKNxSZgBhEICXzAT6I7HCeo2P+VEMzMtBM1P8LJw1oRHppCP3j8NhIzh3vwSWFUkXaG9KyUUSHrBYVsH1E2ZSQX9SdMGB5ZETMpvL9OlKthnku8p5n9wSw+jYbs1jsmW2yz3g7RUZXta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731233; c=relaxed/simple;
	bh=Fm+UVIC0ATupjHxyjatWzJqSI7mIY2KW8/5vYP/Xx1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf0JQoVHHQIKc3TkHl359oxFO++XG3vLClG9vNrqrrFjaO/WwhOfVseZ0d1PAlqGwSYL0MKOxoh3Yp++vbHT+FKGFmk65qMZ+s0nBIG0amJSDS3QE6lPqGyQ4+rUzTQweMTg29J+Js5F0F25TWTMxVgraMFOezfUa/2at5nREVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofg/B8pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofg/B8pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8398CC4CEF1;
	Fri, 21 Nov 2025 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731232;
	bh=Fm+UVIC0ATupjHxyjatWzJqSI7mIY2KW8/5vYP/Xx1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofg/B8pdMCpwBTpdCMVz28xBU2CWLVSeJbBU5VkxGOtuchDuZjej4sfsWC4N900Xt
	 xd+8Bf6QdZ6gHvXnsuTLTK9DTno0V7W7H0/pF515QJdNzbEHs3JIeX+YPBjfC7r3jy
	 MluADXL2aZVwAHXmzx/g8IGeEZLu6cCT/uVF3xQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Leonchikov <andreil499@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 136/247] arm64: dts: rockchip: Fix PCIe power enable pin for BigTreeTech CB2 and Pi2
Date: Fri, 21 Nov 2025 14:11:23 +0100
Message-ID: <20251121130159.609481957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Leonchikov <andreil499@gmail.com>

[ Upstream commit e179de737d13ad99bd19ea0fafab759d4074a425 ]

Fix typo into regulator GPIO definition. With current definition, PCIe
doesn't start up. Valid definition is already used in  "pinctrl" section,
"pcie_drv" (gpio4, RK_PB1).

Fixes: bfbc663d2733a ("arm64: dts: rockchip: Add BigTreeTech CB2 and Pi2")
Signed-off-by: Andrey Leonchikov <andreil499@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
index 7f578c50b4ad1..f74590af7e33f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
@@ -120,7 +120,7 @@
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v3_pcie";
 		enable-active-high;
-		gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpio4 RK_PB1 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pcie_drv>;
 		regulator-always-on;
-- 
2.51.0



