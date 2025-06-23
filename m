Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B74E70838;
	Mon, 23 Jun 2025 21:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712876; cv=none; b=Ugv1vOGSIOT3fcWghn/dIy9iSPo0ipz/8tx6WpWfKLyo0UzeNCmSEfLjPAgqjAu+HfuDL9f/w/fkHlUC7aKLuLJUlRmucrV7Tsp4/unhewG1+e/yWsriDHTd8Lw0oUVcSOzvgyDjvSe7y7KqaFQqxjPh2nujLl4x6pXRKDpf1bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712876; c=relaxed/simple;
	bh=/GfKXri61+go0QAyXUmUAtqi9gRr2ATPGROl/zJO1Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB+iVxMn28x00eBZRpjx2XW8fgX8U5aWJSHCMhrOCKssOenzj6DWodF7Y19l6cdUA7SyBVllyBmkPxYnq283tJzggZHGzZ5rOdIxEmW8G+p+3rNneC8Ave6gPLTVmb7h3TQZA7XOtfTkPSRC5I6viqRwQQ7Ygbj4rDFUzJZrNQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1YHHo1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1YHHo1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E996FC4CEF0;
	Mon, 23 Jun 2025 21:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712876;
	bh=/GfKXri61+go0QAyXUmUAtqi9gRr2ATPGROl/zJO1Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1YHHo1Fx6B0DVV8lopGhXgBeyLfT3oae5TweHkkJ23NVzrctd8jlq1gCB5UmZiVn
	 frNx98qF45uOf7UB5up3/AYIXBp/i8qule75zUzcJEsmD65/TMbuRCQQxSwr5NHaC/
	 j5mTiaPfwlQ+A4B+m7AfeoLp03H2tjcMOG9zTJ7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/355] arm64: dts: ti: k3-am65-main: Drop deprecated ti,otap-del-sel property
Date: Mon, 23 Jun 2025 15:05:11 +0200
Message-ID: <20250623130630.074464506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 2b9bb988742d1794e78d4297a99658f38477eedd ]

ti,otap-del-sel has been deprecated in favor of ti,otap-del-sel-legacy.

Drop the duplicate and misleading ti,otap-del-sel property.

Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20230607132043.3932726-3-nm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: f55c9f087cc2 ("arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index a3538279d7106..a4d35bc66f0b7 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -301,7 +301,6 @@ sdhci1: sdhci@4fa0000 {
 		ti,otap-del-sel-ddr52 = <0x4>;
 		ti,otap-del-sel-hs200 = <0x7>;
 		ti,clkbuf-sel = <0x7>;
-		ti,otap-del-sel = <0x2>;
 		ti,trm-icp = <0x8>;
 		dma-coherent;
 		no-1-8-v;
-- 
2.39.5



