Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C43912D1EA;
	Tue, 30 Apr 2024 11:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475239; cv=none; b=if99XwtzK+GQTXCL8YN/otoq4QPvtO5EKi7VDHtYfXehqL96Fmkj2qIXXlPezxd0ieY1OfgDYyAuiST4aNDP7rwcIRPjW1UnUXPfJxa5NozLwiepNVkiSk1unYXE85rnpTeIPtjpVr+R5hYX/aeeFjtaperebW8JN58vAT3nlRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475239; c=relaxed/simple;
	bh=UhqhduyvG3avcs9fr6najU86Hc9giwhk36EQrAAn4Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wfql2FguygN+uCcdhPX6XKTlcOIH3cZTLCgLWeQ4UxYxqGWemo0Uqfx8dlqdeuU2Ryik1MrnrsFY7+caYlHM0pCQISBQpX4ZQwt/r/toH95MFLjK9sH9y7CHdUUJreD7p718PorGBbEfLoUU8bTxqrQoMc9VoU5qrQvGvcqYLds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEXOAEdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEXOAEdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81925C2BBFC;
	Tue, 30 Apr 2024 11:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475238;
	bh=UhqhduyvG3avcs9fr6najU86Hc9giwhk36EQrAAn4Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEXOAEdPaadiyfSDQVbG7QyNs3UK+Ills+N3FuA2LGRoKWqiQIsWjjQ+f09KukPkN
	 UYcyEfkeHrNoXHyn2nSytkcEHCKRtcnfskqKBsmLjttOKu0CKbBHRNoPL7cgUkCStu
	 vvUztfJd8gvQjXOw/X8gKWZlEGTMGgp7EgHT/qS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/186] arm64: dts: rockchip: set PHY address of MT7531 switch to 0x1f
Date: Tue, 30 Apr 2024 12:37:38 +0200
Message-ID: <20240430103058.203106420@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f9127ddfbb7df..87c45d8be420f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -525,9 +525,9 @@
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



