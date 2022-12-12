Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2341F28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A826C433EF;
	Mon, 12 Dec 2022 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851614;
	bh=egiN1mWGfYP0QOxb6zPKogEfK4ZTmTPzqNPsVvsq6tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6NjaYbe9psP58P0EdzCVG4KCGG1loMsFcCYHoK43zA2e3zEojwMADtWw6Qfa8uV4
	 Y93MDel6YLFSu5zjc/HYPj7PEBpaES8KjPFCU5hG97hrNlOn4pvmP5yUwuD76DGAOF
	 QWkzm6zzTSKE8CpZ7lwY8/2/mB33NBny2KPZRNcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/123] ARM: dts: rockchip: rk3188: fix lcdc1-rgb24 node name
Date: Mon, 12 Dec 2022 14:16:15 +0100
Message-Id: <20221212130927.225791604@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

[ Upstream commit 11871e20bcb23c00966e785a124fb72bc8340af4 ]

The lcdc1-rgb24 node name is out of line with the rest
of the rk3188 lcdc1 node, so fix it.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/7b9c0a6f-626b-07e8-ae74-7e0f08b8d241@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 2c606494b78c..7c8c5c28dc2e 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -378,7 +378,7 @@
 				rockchip,pins = <2 RK_PD3 1 &pcfg_pull_none>;
 			};
 
-			lcdc1_rgb24: ldcd1-rgb24 {
+			lcdc1_rgb24: lcdc1-rgb24 {
 				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_none>,
 						<2 RK_PA1 1 &pcfg_pull_none>,
 						<2 RK_PA2 1 &pcfg_pull_none>,
-- 
2.35.1



