Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5640119D084;
	Mon, 23 Jun 2025 21:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714836; cv=none; b=R6mWbxSuv39MAFSKAeM0wsuu9UEnkpnC6tjzdOd8m+bGy6DJZY4UV2OIf1t+/eNTjconQY9KIxsBJv+sfM/TnAA7QXajUJ+tgem4GgUjrbeYeF4JV9trJ70X+sYWj6lBOeFoL2PMxg03G1iwYWgBdmYzxk9rFgZpgGGG4YMk50M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714836; c=relaxed/simple;
	bh=qzMO5E9TVye+2JU70wnoTbSXMRP/B4Fqtf7IlxUbJhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEjvxU5J8mXM88WoMTvxPtUb2Q1G84s3pJMGMNz1JowONTHx/bwu3RZKJen8g2vYTpOj3U5FHkUzB/dePxo9wHa+yg6pRjq0lI4QZvnFfLtOqvm3znCyrGHAmCvFkOVH0k53ePRzvE1vOlEhPiMAmMZBZ91RDDLA2RjyG2rGkqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWZNc36g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWZNc36g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E17C4CEEA;
	Mon, 23 Jun 2025 21:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714836;
	bh=qzMO5E9TVye+2JU70wnoTbSXMRP/B4Fqtf7IlxUbJhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWZNc36gaoOHDttRrKdZgw5S58gFg0VJqMYjITrB1Dy8aj3dp0+Y0uMrIIgmSFGWo
	 CBLb4tpYXDT8LxlAXrSKj8ulQUAacMfAoDNvUfvPDRO4ghcUsmdMoMZemVNZ+S9A6T
	 QvLH7EyQxmqI0DXQrnJn31nsRy7fXkRrRPAZZz68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/508] arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0
Date: Mon, 23 Jun 2025 15:04:24 +0200
Message-ID: <20250623130650.650868350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit f55c9f087cc2e2252d44ffd9d58def2066fc176e ]

For am65x, add missing ITAPDLYSEL values for Default Speed and High
Speed SDR modes to sdhci0 node according to the device datasheet [0].

[0] https://www.ti.com/lit/gpn/am6548

Fixes: eac99d38f861 ("arm64: dts: ti: k3-am654-main: Update otap-del-sel values")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://lore.kernel.org/r/20250429173009.33994-1-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index c09457fef2db0..ebd8434c6b60b 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -274,6 +274,8 @@ sdhci0: mmc@4f80000 {
 		ti,otap-del-sel-ddr50 = <0x5>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x5>;
+		ti,itap-del-sel-legacy = <0xa>;
+		ti,itap-del-sel-mmc-hs = <0x1>;
 		ti,itap-del-sel-ddr52 = <0x0>;
 		dma-coherent;
 	};
-- 
2.39.5



