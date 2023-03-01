Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6E1847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF8CC433D2;
	Wed,  1 Mar 2023 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694339;
	bh=lhAXS7hXbodllx8n7UqUkj4H6xj4JSId1r6/xza38kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgfyTtbNA4Dtk3QnaK9JWylPcFAnIpPl6IdniA9pGcJpdpgKVI0JkkfF8qTXya2n6
	 QwvjUPyBITc1kUmLMJLDCdXUvqOD3ovl+Dga7BcDR7q/E0LSc7yHJoBy7JPoNFktoc
	 6uoHrqb0vWuna0Itlmx3NBNP38vfkuu0m3HUEjDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jensen Huang <jensenhuang@friendlyarm.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/42] arm64: dts: rockchip: add missing #interrupt-cells to rk356x pcie2x1
Date: Wed,  1 Mar 2023 19:08:26 +0100
Message-Id: <20230301180657.264471701@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jensen Huang <jensenhuang@friendlyarm.com>

[ Upstream commit a323e6b5737bb6e3d3946369b97099abb7dde695 ]

This fixes the following issue:
  pcieport 0000:00:00.0: of_irq_parse_pci: failed with rc=-22

Signed-off-by: Jensen Huang <jensenhuang@friendlyarm.com>
Link: https://lore.kernel.org/r/20230113064457.7105-1-jensenhuang@friendlyarm.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 164708f1eb674..1d423daae971b 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -966,6 +966,7 @@ pcie2x1: pcie@fe260000 {
 		clock-names = "aclk_mst", "aclk_slv",
 			      "aclk_dbi", "pclk", "aux";
 		device_type = "pci";
+		#interrupt-cells = <1>;
 		interrupt-map-mask = <0 0 0 7>;
 		interrupt-map = <0 0 0 1 &pcie_intc 0>,
 				<0 0 0 2 &pcie_intc 1>,
-- 
2.39.0



