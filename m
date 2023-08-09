Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B27A14A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12EBC433C8;
	Wed,  9 Aug 2023 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578385;
	bh=HvXaFb1ByrxGH+j6LLM7qtitH8IOBsVxUzRSJ4Ed2aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjNejNlA/QdbWuj2sLwGmhTI8MHSXd7xB8INbJzg8dUq8b1zcfO+Q2z5jsxRvuoCv
	 EekmNrq75wOg5S8EJIYJAnDMHqYospBhxEqK6qRqf2LVJUfvVjYciIJVeus6L3f//t
	 YObYmnz8qm5gWhNZ+fqjbM7I2nzazZ1KvTXKhlxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yashwanth Varakala <y.varakala@phytec.de>,
	Cem Tenruh <c.tenruh@phytec.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/127] arm64: dts: phycore-imx8mm: Label typo-fix of VPU
Date: Wed,  9 Aug 2023 12:39:58 +0200
Message-ID: <20230809103637.011856636@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yashwanth Varakala <y.varakala@phytec.de>

[ Upstream commit cddeefc1663294fb74b31ff5029a83c0e819ff3a ]

Corrected the label of the VPU regulator node (buck 3)
from reg_vdd_gpu to reg_vdd_vpu.

Fixes: ae6847f26ac9 ("arm64: dts: freescale: Add phyBOARD-Polis-i.MX8MM support")
Signed-off-by: Yashwanth Varakala <y.varakala@phytec.de>
Signed-off-by: Cem Tenruh <c.tenruh@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi
index 995b44efb1b65..3e5e7d861882f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-phycore-som.dtsi
@@ -210,7 +210,7 @@
 				};
 			};
 
-			reg_vdd_gpu: buck3 {
+			reg_vdd_vpu: buck3 {
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-max-microvolt = <1000000>;
-- 
2.40.1



