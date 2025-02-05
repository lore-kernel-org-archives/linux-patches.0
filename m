Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85331519A4;
	Wed,  5 Feb 2025 14:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764989; cv=none; b=SxI1oVV0q3CtA5q12Tv07dmKhOUXxBFyS8lfgjCZzMxdxnSGNv0eN2279oP/G5D4j4Ibpt8UD5t7ro9DLfFbROcSOKo8Erl0khAiLaJzau8jUyT4IBtWnR4g05KGz1bLWVt38ECzBd2J928U8Eq5y7rhEwb4+LJZFdcsh2JlEkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764989; c=relaxed/simple;
	bh=hH5t9IyHUvBLarZY8UV1S4t1e63v2iC+oIjKmhUJ7X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcL6QZ9+fwzW5ZOrmrZqQ//MhPhePeJO2kOanepG1w5xCXjNJPJrfaH0WFowJ7wOAICgQSCmlSh/0Iie+RkoOk0zapTGfQoCcWo0Qs3jFjFa7heDzRqfdEyh9/hc32A8EYebxxNB/oDdwGzUMQa8VPxGig39Gh9EQzeJ4J2+AFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0s5wgwYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0s5wgwYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088F0C4CED1;
	Wed,  5 Feb 2025 14:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764989;
	bh=hH5t9IyHUvBLarZY8UV1S4t1e63v2iC+oIjKmhUJ7X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0s5wgwYa1mG7lnyY3gNYZrDqhjdmaRWBGha1Arkce30vbS59lpCvD4s7kAmXZiGP4
	 b9LFvKlS64TzIe/Kj8krEtZPFZ6uN+8IiDxpfwYQncwyCDgFbnbbTMaOnMidhYVDt3
	 BeRS5Dwuy9F4xAl1I6bdI4nXEk94kcNTsutSvCWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 133/623] arm64: dts: imx93: Use IMX93_CLK_SPDIF_IPG as SPDIF IPG clock
Date: Wed,  5 Feb 2025 14:37:55 +0100
Message-ID: <20250205134501.318687555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 570b890e66334f283710af36feb2115f16c7a27c ]

IMX93_CLK_BUS_WAKEUP is not accurate IPG clock, which
missed the clock gate part.

IMX93_CLK_SPDIF_IPG is the correct clock.

Fixes: 1c4a4f7362fd ("arm64: dts: imx93: Add audio device nodes")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Shawn Guo <shawnguo@kernel.org>
Link: https://lore.kernel.org/r/20241119015805.3840606-4-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 688488de8cd28..56766fdb0b1e5 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -925,7 +925,7 @@
 				reg-names = "ram", "regs", "rxfifo", "txfifo";
 				interrupts = <GIC_SPI 203 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 204 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX93_CLK_BUS_WAKEUP>,
+				clocks = <&clk IMX93_CLK_SPDIF_IPG>,
 					 <&clk IMX93_CLK_SPDIF_GATE>,
 					 <&clk IMX93_CLK_DUMMY>,
 					 <&clk IMX93_CLK_AUD_XCVR_GATE>;
-- 
2.39.5



