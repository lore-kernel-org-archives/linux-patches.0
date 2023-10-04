Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112861D55D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZ9W0VYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2662BC433C8;
	Wed,  4 Oct 2023 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443381;
	bh=g4DvDbTybZzgVKZQigorLzKVBQCNsO8xQAS1XYVR/4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZ9W0VYdsjY+5mw8AhUQP2UmEOAypHBAIITSJoE1rh174lnOTJ9JBzLKfUTWP2kUC
	 mOoEPyZDVZsNCPeYblb5BSBYet9cLbUbHxqsZ+dk6HlYuc+cK308/ae4G4Xs6+BFYb
	 QdMv/egqB098tvSt8NGs2VIucD5X9uwq5S4p69OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/259] arm64: dts: imx: Add imx8mm-prt8mm.dtb to build
Date: Wed,  4 Oct 2023 19:55:10 +0200
Message-ID: <20231004175223.626193823@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit f09752eaf0e8f8befc26b44c4d3e15633e56d16a ]

imx8mm-prt8mm.dts was not getting built. Add it to the build.

Fixes: 58497d7a13ed ("arm64: dts: imx: add Protonic PRT8MM board")
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index 3ea9edc87909a..ac6f780dc1914 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -62,6 +62,7 @@ dtb-$(CONFIG_ARCH_MXC) += imx8mm-kontron-bl-osm-s.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-mx8menlo.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-nitrogen-r2.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-phyboard-polis-rdk.dtb
+dtb-$(CONFIG_ARCH_MXC) += imx8mm-prt8mm.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-tqma8mqml-mba8mx.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-var-som-symphony.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-venice-gw71xx-0x.dtb
-- 
2.40.1



