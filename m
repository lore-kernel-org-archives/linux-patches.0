Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F2C11C83;
	Sat,  3 Feb 2024 04:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933567; cv=none; b=K7s+jwEVi9f0g1yICRukCRakvb1BzQFRFOVYmmnhkUW8JIwTI2kbGd6Hxw0hr60+Q6HNDqrgcgbyoy7ifxsVFQVblq62ktnNiMxZNjAb8XHtYO/S7VpOU2/3rbj93o6iqZK20qBjW/fapVs1MWmAdHwj1A+4QcTKcVu8JD4WSw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933567; c=relaxed/simple;
	bh=gtRM2V0vwI4WagPTLYHyy9MGVUlqLaNm27A6pLSUOyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNwdK8w7rXgQVSYJf9cIklpE63iV2h35OmU7iaGhraLdwM2izCrCwpVRW1XP2Rl+Wc2Wnh4cNRZG07DAMpllVQc93U3LLW4WkRJ/giXLxSBxX4qSLI1XQ5LrA0gwvizhFTq/nkWCBeo11KtpO4bidmIyA2czM5QNZdcz7GL31ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ure6MvIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ure6MvIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75B6C433F1;
	Sat,  3 Feb 2024 04:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933567;
	bh=gtRM2V0vwI4WagPTLYHyy9MGVUlqLaNm27A6pLSUOyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ure6MvIb3FCSqNY7Wp4i9A8fRP6ZAR8yaduVbKkF6TKFey242vL3vpGEhlFcu6ZoD
	 tXjrKOZMd2L5pnhjVj34NaV4yemFFWYMev2KIvtzuXPz6Pd2wB3KeA58txTDqDJNa6
	 hU+rFBJdLmpMlJd24UHoKar+17z6ptpWnKcR5FW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/322] ARM: dts: imx25: Fix the iim compatible string
Date: Fri,  2 Feb 2024 20:03:39 -0800
Message-ID: <20240203035403.088374123@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f0b929f58719fc57a4926ab4fc972f185453d6a5 ]

Per imx-iim.yaml, the compatible string should only contain a single
entry.

Use it as "fsl,imx25-iim" to fix the following dt-schema warning:

imx25-karo-tx25.dtb: efuse@53ff0000: compatible: ['fsl,imx25-iim', 'fsl,imx27-iim'] is too long
	from schema $id: http://devicetree.org/schemas/nvmem/imx-iim.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx25.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx25.dtsi b/arch/arm/boot/dts/nxp/imx/imx25.dtsi
index 5f90d72b840b..5ac4549286bd 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx25.dtsi
@@ -543,7 +543,7 @@
 			};
 
 			iim: efuse@53ff0000 {
-				compatible = "fsl,imx25-iim", "fsl,imx27-iim";
+				compatible = "fsl,imx25-iim";
 				reg = <0x53ff0000 0x4000>;
 				interrupts = <19>;
 				clocks = <&clks 99>;
-- 
2.43.0



