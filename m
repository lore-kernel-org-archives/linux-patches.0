Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65519248BDC;
	Wed, 15 Jan 2025 10:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938413; cv=none; b=WTpkqzmD/VYGO13/bmaBaYagVwFXUwYjH+gaTW/SLyX9IitYsdSDO2iMnqn7vU8t2n0JqqpQAw4QH3YoJueDt3KsSH4X4gCS6UGeKtCb6po1NtGJhO+RyOB+UVPAgxzAr8TLB/2nwycB9nYuigI9kETOC4VaMwdRW7PdrTzuyWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938413; c=relaxed/simple;
	bh=uE627QwAk6q/Hr+GQ1bsctU09aPJhJcRiQ6KWMmQ5D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtb6NJLiO7l8FNv4b2Y9xCKTd9aSaQ3o1tBPZHTReqASq9of5UE0BiRMCPHnLuKmGrJKHw8lnLEXR5BXmO/nV54drlShVJxRHTUb4XEdNU5IRBxJTYY2kUGQGGdKmOyYEvaQC2DQIhhN/v0gFGNAT37GoQ8wTDsoFR49A+coGWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbgU7B70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbgU7B70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F20C4CEDF;
	Wed, 15 Jan 2025 10:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938413;
	bh=uE627QwAk6q/Hr+GQ1bsctU09aPJhJcRiQ6KWMmQ5D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbgU7B70Jku+327PlTvl0x3qDi4vN5jbhfOI5NVOm76LL3nCCpl9UuZbvkW47y0Nr
	 K48JtyjjRMbMRB4kfl2/iueckXIX90CgA++WFOpi15tUF/iJIjXvluGKOalVWyLH1G
	 ncaCgwZErMgm+pgNgL+DvQmHoIvTEi+01o8zgYDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <Mr.Bossman075@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/189] ARM: dts: imxrt1050: Fix clocks for mmc
Date: Wed, 15 Jan 2025 11:37:52 +0100
Message-ID: <20250115103613.430477513@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jesse Taube <Mr.Bossman075@gmail.com>

[ Upstream commit 5f122030061db3e5d2bddd9cf5c583deaa6c54ff ]

One of the usdhc1 controller's clocks should be IMXRT1050_CLK_AHB_PODF not
IMXRT1050_CLK_OSC.

Fixes: 1c4f01be3490 ("ARM: dts: imx: Add i.MXRT1050-EVK support")
Signed-off-by: Jesse Taube <Mr.Bossman075@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi b/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi
index dd714d235d5f..b0bad0d1ba36 100644
--- a/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi
@@ -87,7 +87,7 @@
 			reg = <0x402c0000 0x4000>;
 			interrupts = <110>;
 			clocks = <&clks IMXRT1050_CLK_IPG_PDOF>,
-				<&clks IMXRT1050_CLK_OSC>,
+				<&clks IMXRT1050_CLK_AHB_PODF>,
 				<&clks IMXRT1050_CLK_USDHC1>;
 			clock-names = "ipg", "ahb", "per";
 			bus-width = <4>;
-- 
2.39.5



