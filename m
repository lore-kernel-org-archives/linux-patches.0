Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C40E2C9D;
	Mon, 23 Jun 2025 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713585; cv=none; b=ThOkZvk85Dkl2R0cy87TtrHHCPLfjTnHsg9Y8eA2YZYoJzTe3jOjBsJILWD9Z1Jp4ljFn82YYnfW+le8dn/9AK57InCOaGNwyYldk1G1ThUjxu6zV1PaTMTKXIFvE0GTw5ctJissom8Xb/G8+3qZAs+j3Pvr+QqqYZtoSyVFYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713585; c=relaxed/simple;
	bh=+XkKr31Tv7sZD+tWLYFGNO/YN+h4MAhqU+u2s4L36wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nro3brOWhtn2Jg8UsBofF7jMuV31o1+sUmnIwAPgUywZe+LkhleC898ao2pdPnlaltES6PMa7zUVZZI5gRJevwL0ulrKkODup8QdPMc1KrI31SnVcq+8GaQfeWfwdHtuThSnpe9Kh/mNhzMIyTp9qdXanAekSgcBJvnpus4HvdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWRCTdDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWRCTdDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9230FC4CEEA;
	Mon, 23 Jun 2025 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713584;
	bh=+XkKr31Tv7sZD+tWLYFGNO/YN+h4MAhqU+u2s4L36wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWRCTdDBKfEcOvTYKik/Kbq8/aXWT7Lgg/SkoZDURup/wd6r+v0Y3zsDPySL7Qem3
	 hkISqWjK29J58gkJaSxpcVpnMgNlsI71KNkS2YloHSxN2JJarJq/epB9o3rS3roF7T
	 H24sPPzaf/oz66Mbnvj24BODJJ7Rfy7HxB5wV4zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/411] arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0
Date: Mon, 23 Jun 2025 15:04:39 +0200
Message-ID: <20250623130636.979771834@linuxfoundation.org>
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
index 1d43d1b529b39..ccd14a2e97a9c 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -273,6 +273,8 @@ sdhci0: mmc@4f80000 {
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



