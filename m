Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601A315AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D428DC433C7;
	Wed,  9 Aug 2023 10:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578310;
	bh=m32v1OU2t/Sk7F7pAGVyC2uXdMNoNki8aX3j8pTj6hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg9sdhxKjAJybEfE8T70f0A4Y4v3DVgVziAkO/MhbiHlYrLlkLW1CdMfLVMFqksgB
	 J64OcoGxTboSaRsZIDMBq+mqVBX1fqM1pJMHH0aUSPZMOSoZyNwK6ekDP0SmfeZJ/Q
	 4zO6XKajKjOtXzAfCMGe4XhbRD4dxIdXCmmtPiUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/127] arm64: dts: freescale: Fix VPU G2 clock
Date: Wed,  9 Aug 2023 12:40:01 +0200
Message-ID: <20230809103637.108862719@linuxfoundation.org>
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

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit b27bfc5103c72f84859bd32731b6a09eafdeda05 ]

Set VPU G2 clock to 300MHz like described in documentation.
This fixes pixels error occurring with large resolution ( >= 2560x1600)
HEVC test stream when using the postprocessor to produce NV12.

Fixes: 4ac7e4a81272 ("arm64: dts: imx8mq: Enable both G1 and G2 VPU's with vpu-blk-ctrl")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 4724ed0cbff94..bf8f02c1535c1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -756,7 +756,7 @@
 									 <&clk IMX8MQ_SYS1_PLL_800M>,
 									 <&clk IMX8MQ_VPU_PLL>;
 						assigned-clock-rates = <600000000>,
-								       <600000000>,
+								       <300000000>,
 								       <800000000>,
 								       <0>;
 					};
-- 
2.40.1



