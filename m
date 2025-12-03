Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F7039A27A;
	Wed,  3 Dec 2025 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780829; cv=none; b=CdzUDo04kHCjTKcovuixxr2W0GD9criCI5x24J6vT95U5tqtg/bo60rz8sXEDb2bHcsg2oh8+M7Ji36FEGEJ6S9dAoZlvyxhA8L64cJuy4NeqtJEdIImOius4lfaaiVLjCwTQjefGnBiWrdOejKGlUzyrULoFE2Op+NRY/8dFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780829; c=relaxed/simple;
	bh=VTqSk3y3WYV0+UTF+MHhdwklMDVMAVJUQU1ZxSQckoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9+0hWb9TI9Fjne5eLTMUcwlRjyssLJps7yYsdX9nVT9vmh044Xwg1h4pKqqsYhmvJXIKahCqLoilrNkPOBNSGFBmBHaU36Otb1arImbfaGXi6pbI+NhKxhc6IdZ/EutNhX8ngDq3YTomijbmpXyFmWzwwwJdPy3dzErdsECz7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4Y3qsDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4Y3qsDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D860CC4CEF5;
	Wed,  3 Dec 2025 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780829;
	bh=VTqSk3y3WYV0+UTF+MHhdwklMDVMAVJUQU1ZxSQckoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4Y3qsDs44eQ2FWbtF6ut8dNDUgn13Om+osRN6jKsvR9SeSRXebDTIbOAjpj2R9s/
	 +wrcs43UcXzgFXTZZ27kbFFUPazUJv8YbzxOPb97fVtauyjo6yhOuomgFu1lDzq9DY
	 OAA1cMLyPxHr25yRaA6/0DJIiw1CSxmRdm3Bfsvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Zanders <maarten@zanders.be>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 069/132] ARM: dts: nxp: imx6ul: correct SAI3 interrupt line
Date: Wed,  3 Dec 2025 16:29:08 +0100
Message-ID: <20251203152345.853270480@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Zanders <maarten@zanders.be>

commit 1b03346314b791ad966d3c6d59253328226a2b2d upstream.

The i.MX6UL reference manual lists two possible interrupt lines for
SAI3 (56 and 57, offset +32). The current device tree entry uses
the first one (24), which prevents IRQs from being handled properly.

Use the second interrupt line (25), which does allow interrupts
to work as expected.

Fixes: 36e2edf6ac07 ("ARM: dts: imx6ul: add sai support")
Signed-off-by: Maarten Zanders <maarten@zanders.be>
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx6ul.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/nxp/imx/imx6ul.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ul.dtsi
@@ -333,7 +333,7 @@
 					#sound-dai-cells = <0>;
 					compatible = "fsl,imx6ul-sai", "fsl,imx6sx-sai";
 					reg = <0x02030000 0x4000>;
-					interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+					interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 					clocks = <&clks IMX6UL_CLK_SAI3_IPG>,
 						 <&clks IMX6UL_CLK_SAI3>,
 						 <&clks IMX6UL_CLK_DUMMY>, <&clks IMX6UL_CLK_DUMMY>;


