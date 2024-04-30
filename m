Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F8A12D762;
	Tue, 30 Apr 2024 11:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476387; cv=none; b=CsShuIgxgNdIrUv9vtd/UQPzrEgysTm6G4ulYJl3A9siGijxHGLtDLTgcIBD5rbAkby2hvLymuctq9reigc+Vr+8xW5/AnNWbL79ohMhiwud13/4DsFfFl54kDMRVRxjjnEwUmTW0giU5j5GdpQ5QFP5vjklqhdvtBSDM+pYHb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476387; c=relaxed/simple;
	bh=9qh8/fUZ7skMCrC8zvDnfOJRq6dNVI8gI9+TgjU7Ltg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnI3XQoAliyi8Y4Rwm3vfG6SKTAH6DJe6Un8lxiuwVaB8eC4qkDia6cWn8sXytxa9oGzz+29UMjW5GxVMKE4baxhR21sPEqesrDi7AD9B6TbB2iQtPQo9+oJ7zBf9TzIgaW1j8VDHAFXs3OvswAG63sl9T48rJj1xbPlcGZ3oC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBV97Po9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBV97Po9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A43EC2BBFC;
	Tue, 30 Apr 2024 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476387;
	bh=9qh8/fUZ7skMCrC8zvDnfOJRq6dNVI8gI9+TgjU7Ltg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBV97Po93WMrhRYpDEHPbndQ0KCFWfUseqpd7Q1UxctAl6iPrFPb8VDVK98VuqMss
	 91aRb5kkbekNBj0366/ojdh5OgYLqNpko8Gup7LjjnbctKbT1fJDLBthXWJK3zYMNI
	 ZFbBO8/IqEFg9kQYx8mbSTHb6JATAbR76A4dwxc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/110] arm64: dts: rockchip: Remove unsupported node from the Pinebook Pro dts
Date: Tue, 30 Apr 2024 12:39:38 +0200
Message-ID: <20240430103047.844884356@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index 194e48c755f6b..a51e8d0493cab 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -789,7 +789,6 @@
 };
 
 &pcie0 {
-	bus-scan-delay-ms = <1000>;
 	ep-gpios = <&gpio2 RK_PD4 GPIO_ACTIVE_HIGH>;
 	num-lanes = <4>;
 	pinctrl-names = "default";
-- 
2.43.0



