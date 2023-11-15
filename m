Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5C143ACB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOgw1W35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04066C36AF1;
	Wed, 15 Nov 2023 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081389;
	bh=+d9sQsoRDKddKVdz9dDC2HN5StFG/SDvAUAy09LnrYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOgw1W35cip7BOgIILvQA7Q/bSQirCxRYBQEjZKxKueXpB/LlZg9jPZ4GednkLvDF
	 hcT+CWqlJMVtDBTwBQDO2+UknaUGV3hNtTqfxzTmZGTPMED4yLCvm+Ftnfbo2JjURQ
	 SuNelmPkQndO55YFSepl1jq9C0TKox1qfN38B+zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/244] arm64: dts: imx8mm: Add sound-dai-cells to micfil node
Date: Wed, 15 Nov 2023 15:35:16 -0500
Message-ID: <20231115203555.813383819@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 0e6cc2b8bb7d67733f4a47720787eff1ce2666f2 ]

Per the DT bindings, the micfil node should have a sound-dai-cells
entry.

Fixes: 3bd0788c43d9 ("arm64: dts: imx8mm: Add support for micfil")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 2a67122c5624c..86731850a6bd6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -366,6 +366,7 @@ micfil: audio-controller@30080000 {
 						      "pll8k", "pll11k", "clkext3";
 					dmas = <&sdma2 24 25 0x80000000>;
 					dma-names = "rx";
+					#sound-dai-cells = <0>;
 					status = "disabled";
 				};
 
-- 
2.42.0



