Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E7A847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F25C433D2;
	Wed,  1 Mar 2023 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694337;
	bh=8J7t5UF5+5NksKzsY0+cwQgm8IdQtufSH5utrjhKLpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Euj8ftktUeJxWhKh0Fjw5EiNRK4AW/nMRgAD8nyh8s5a/Nmx5UXVsTN02wjlNMaeJ
	 /kKCTd0iF7afJ1Fsy4HmO+Bm1CmMLT2SDCDOzUByVog0c/fT3XiqMmwZI4NktTaGv0
	 JXjP5CqXGknBSoAxL7wUk8DldLx1EwdECX6X7sdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/42] ARM: dts: rockchip: add power-domains property to dp node on rk3288
Date: Wed,  1 Mar 2023 19:08:25 +0100
Message-Id: <20230301180657.214455030@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 80422339a75088322b4d3884bd12fa0fe5d11050 ]

The clocks in the Rockchip rk3288 DisplayPort node are
included in the power-domain@RK3288_PD_VIO logic, but the
power-domains property in the dp node is missing, so fix it.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/dab85bfb-9f55-86a1-5cd5-7388c43e0ec5@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 487b0e03d4b43..2ca76b69add78 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1181,6 +1181,7 @@ edp: dp@ff970000 {
 		clock-names = "dp", "pclk";
 		phys = <&edp_phy>;
 		phy-names = "dp";
+		power-domains = <&power RK3288_PD_VIO>;
 		resets = <&cru SRST_EDP>;
 		reset-names = "dp";
 		rockchip,grf = <&grf>;
-- 
2.39.0



