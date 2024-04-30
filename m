Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA271E50A;
	Tue, 30 Apr 2024 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475836; cv=none; b=JnJyPU4zb2owdqaY4lKxzUhuN7FLaOLDL6nhrW/dqgn+qFIr6V8jFJ4CgsfJRt6ShYNZIro1e6Kmoi5gu5EgP874tN+bkfaAo4HuKaFirlc8xUaZNTGnW+6h4qRGt+ydaZ6sw8hII3E9+Fs+f0hzH4HPOYzDm0uuTfilQLYZRI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475836; c=relaxed/simple;
	bh=J+L5GHvDk54ZPsYbW9yBU0UCi5zae6vAGQqhX/Gye08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gmpki4Pb8137Tiibwt/g6DY4O4Kun/UZud91iczROL1Mn4I3i6O6cejk4BybH+3arPegSxMIWZyovTUmCWBJiKN6jURj6T5dbDsJBubOiBUV7McvG6FAbPQiwVaMuPCPYW7yrJpdR3/Sk/yRBSphJU4rFFvcnGS+OG7oLCTlHB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oedqhrAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oedqhrAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F48C2BBFC;
	Tue, 30 Apr 2024 11:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475836;
	bh=J+L5GHvDk54ZPsYbW9yBU0UCi5zae6vAGQqhX/Gye08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oedqhrApYs1X49ky+X9TP9cYHy1BT3HUznnIjZWSDZF/sF8w9OOhif5vUqWsSgUJO
	 dB1wNHtqMGTPbVlpLcYq89f6klA3s5xMMBaHN4VTpFSNqjgsV6bFcn3F4BpNwjpUz3
	 Xxq6J0u+J9kYOTUslYNknHPDU2EVLZr7CvG6QIEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/80] arm64: dts: rockchip: Remove unsupported node from the Pinebook Pro dts
Date: Tue, 30 Apr 2024 12:39:40 +0200
Message-ID: <20240430103043.654915861@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 43853e843aa6c3d47ff2b0cce898318839483d05 ]

Remove a redundant node from the Pine64 Pinebook Pro dts, which is intended
to provide a value for the delay in PCI Express enumeration, but that isn't
supported without additional out-of-tree kernel patches.

There were already efforts to upstream those kernel patches, because they
reportedly make some PCI Express cards (such as LSI SAS HBAs) usable in
Pine64 RockPro64 (which is also based on the RK3399);  otherwise, those PCI
Express cards fail to enumerate.  However, providing the required background
and explanations proved to be a tough nut to crack, which is the reason why
those patches remain outside of the kernel mainline for now.

If those out-of-tree patches eventually become upstreamed, the resulting
device-tree changes will almost surely belong to the RK3399 SoC dtsi.  Also,
the above-mentioned unusable-without-out-of-tree-patches PCI Express devices
are in all fairness not usable in a Pinebook Pro without some extensive
hardware modifications, which is another reason to delete this redundant
node.  When it comes to the Pinebook Pro, only M.2 NVMe SSDs can be installed
out of the box (using an additional passive adapter PCB sold separately by
Pine64), which reportedly works fine with no additional patches.

Fixes: 5a65505a6988 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/0f82c3f97cb798d012270d13b34d8d15305ef293.1711923520.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 9e5d07f5712e6..e5d057ef8160e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -790,7 +790,6 @@
 };
 
 &pcie0 {
-	bus-scan-delay-ms = <1000>;
 	ep-gpios = <&gpio2 RK_PD4 GPIO_ACTIVE_HIGH>;
 	num-lanes = <4>;
 	pinctrl-names = "default";
-- 
2.43.0



