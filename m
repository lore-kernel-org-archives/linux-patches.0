Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C75812C47A;
	Tue, 30 Apr 2024 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476374; cv=none; b=pwBtAZdBto+utDdH3ojV/Cft7Ceou1fx6SAFu7Wat8AU76QLqa19k1qWXsy/+jRnBFxWQiFJOVqUqH4cMxVtauYIGvuXrM1muICHCfSKu1GBa5ZYLFoDH3QjTQvq/u2iShrKizqIj1pXPv3cH0HMhUUModgHkLQpR2hCNb1yubM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476374; c=relaxed/simple;
	bh=Hdv0P8mEEWzHGMdQ21XpGusN25DBTCCawk9pqBdICJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvAMcYm9/Z0vY/Q/aGzculuu8OBAX5gYOhLnxMyYm470HYI9qF8m313X/WTKzFpPTIHHGXrEJgehpMNYK208K/8wSYZXtndTS+tKkATPY1i5Ezz8kBEQ/ieaiBMFfbTXW1NtHgek+oXk5kvle9Ba8qHvcds+RzbBQe1J+M5vDmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rx1zaizh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rx1zaizh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D230AC4AF1A;
	Tue, 30 Apr 2024 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476374;
	bh=Hdv0P8mEEWzHGMdQ21XpGusN25DBTCCawk9pqBdICJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx1zaizhhcV+PaP0r+G5SDO9eHXJ90+jvCkzeA+WMgZrmGZUFH9/78A+2Dahb4ufm
	 Oh9XNj3PnOT5Cn7sIeAI8YsHMJS7F5ci75m3Tyu944RPjcIXbKkhGDnw0xGOBUX+cu
	 TOnyCsgSlhSiScHd/corzT+b2Y7yX/0JeT1r1+a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/110] arm64: dts: rockchip: set PHY address of MT7531 switch to 0x1f
Date: Tue, 30 Apr 2024 12:39:34 +0200
Message-ID: <20240430103047.726998122@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit a2ac2a1b02590a22a236c43c455f421cdede45f5 ]

The MT7531 switch listens on PHY address 0x1f on an MDIO bus. I've got two
findings that support this. There's no bootstrapping option to change the
PHY address of the switch. The Linux driver hardcodes 0x1f as the PHY
address of the switch. So the reg property on the device tree is currently
ignored by the Linux driver.

Therefore, describe the correct PHY address on Banana Pi BPI-R2 Pro that
has this switch.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Fixes: c1804463e5c6 ("arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board")
Link: https://lore.kernel.org/r/20240314-for-rockchip-mt7531-phy-address-v1-1-743b5873358f@arinc9.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 26d7fda275edb..7952a14314360 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -521,9 +521,9 @@
 	#address-cells = <1>;
 	#size-cells = <0>;
 
-	switch@0 {
+	switch@1f {
 		compatible = "mediatek,mt7531";
-		reg = <0>;
+		reg = <0x1f>;
 
 		ports {
 			#address-cells = <1>;
-- 
2.43.0



