Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08D32628C;
	Mon, 23 Jun 2025 21:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713555; cv=none; b=k06H3yKIxWUonWGCOCVTKw/0EG49gDGF2rJuNr0H5MIPDz5O3yjDhYsrpUNd5axuo/oOk3ZtUzqm/WMkvWutvl+a7KsknaCaXUOrF763yoV/egM04qN6fBPMo6Oy1DO6kA9kMrTHv6Hk4WQLLL6o6jLq41UfqRUG+SEk9+S/UXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713555; c=relaxed/simple;
	bh=DTE4dytttky+HqQgXPL7LJSGXm5KE5Nw6zy9t0p1g4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AylONfmWhMb/KykMrdOjgQxup3Dsm4WfnjPykW1lUYDPMJ5C4elrkNwcm9tpJW6AsWCNZd+OGEqLW8rmdbNeUmxZ88ZIvHLWhvzciJ8rHvbGMyxgJ9wMJXilQHc6CuhsPEGraAcjESJOKjCgmZ3s1SABwV0hHtRXzc37IoVIsZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6lem4sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6lem4sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E27C4CEEA;
	Mon, 23 Jun 2025 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713555;
	bh=DTE4dytttky+HqQgXPL7LJSGXm5KE5Nw6zy9t0p1g4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6lem4sH/XAWi8MFsCsWa8S74kpMoEF7Nuiuz0cRj0nGxoL9gjww8bTu34Ggxy9BA
	 p7P5TzqBwmKR4f4e860w1Pi9ORqvgP8eWJCP2eBRGT7UTgrBzq6/JH/5ECXjGTKAXD
	 4EH9sl1ruS1mTVXHV7EZCQGGSGxQtEZPR0Vlru28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/411] arm64: dts: ti: k3-am65-main: Drop deprecated ti,otap-del-sel property
Date: Mon, 23 Jun 2025 15:04:37 +0200
Message-ID: <20250623130636.924403445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b729d2dee209e..b81ee1f2aecd2 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -294,7 +294,6 @@ sdhci1: mmc@4fa0000 {
 		ti,otap-del-sel-ddr52 = <0x4>;
 		ti,otap-del-sel-hs200 = <0x7>;
 		ti,clkbuf-sel = <0x7>;
-		ti,otap-del-sel = <0x2>;
 		ti,trm-icp = <0x8>;
 		dma-coherent;
 	};
-- 
2.39.5



