Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2546548E0F5;
	Sat, 12 Sep 2026 19:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239926; cv=none; b=X8R4h0Iz0S5bhAqdjXyrr7LNqUYqsEt3uP1M2DOMtGMu7kItB7pOn1eM1/XaWwoWFNx2vgpGIylaywrMvo60kOIsvD2v7ET5duvnemxpVt0Rl4i9RsqLXwkIkNwRVVZd75AERzbX+i/6PfFTz4oy/pNXGH+3DBaIB8Fa9jKugF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239926; c=relaxed/simple;
	bh=/hM/knC5wACXisvO7luiWuUybe5jKoDZcnmN/QrRvLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AROjyjS8+2N7quOrwJqJmTWqhtY+KdIXQdowqgF1/oiCPGvx8AvzlGu6OXaxl/VgIPrjJZDvnhV6vT+fkwggcHhIij/naoP3j+VhrNM8/HxE350J6aRnPGaxo7vx1zJsNvyDiR399P0I7xbmzMjxGb7CwNlZ3fXy0f5mIR1j/rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2tEuKoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2tEuKoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED761F000FF;
	Sat, 12 Sep 2026 19:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239923;
	bh=WiZA5WX8QXy3n8zpex1/07G2Fqt5CBgp2MHz4Rr7MoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2tEuKoZ+92wf/Ez+/FFv3sIpS9w9Q+2T78//sHtXVm9TlDiH39kLezNEGfYa+10t
	 vIYCOFGoCDayX08Ka8ohEeyvv9RpoXW7T3wIm7oWdiSTT3rx39OOCKmqWcQTM07tht
	 Hux+zCD9kWScCuc94Lr8IBxZ6x3Bwc/K7yrXoJiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 761/935] ARM: dts: helios4: add SATA regulator supplies
Date: Sat, 12 Sep 2026 09:03:11 +0200
Message-ID: <20260912065544.287352283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7a90520e8c9a8f48fe6f3e741cf34d8c2b6dbc61 ]

The ahci-mvebu driver and libahci_platform request three supplies
on SATA controller and port nodes:
  - ahci-supply  (controller power)
  - phy-supply   (PHY power)
  - target-supply (disk power per port)

Without them the regulator core prints notices at boot, e.g.:
  supply ahci not found, using dummy regulator
  supply phy not found, using dummy regulator
  supply target not found, using dummy regulator

The SATA controller and PHY inside the Armada 388 SoC are powered
by the 3.3V I/O rail; the four disk bays are powered by the 5V HDD
rail.  Wire the existing fixed regulators accordingly.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 21df1b9e3900f..003b0708e9656 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -222,13 +222,17 @@ sata@a8000 {
 				status = "okay";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				ahci-supply = <&reg_3p3v>;
+				phy-supply = <&reg_3p3v>;
 
 				sata0: sata-port@0 {
 					reg = <0>;
+					target-supply = <&reg_5p0v_hdd>;
 				};
 
 				sata1: sata-port@1 {
 					reg = <1>;
+					target-supply = <&reg_5p0v_hdd>;
 				};
 			};
 
@@ -236,13 +240,17 @@ sata@e0000 {
 				status = "okay";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				ahci-supply = <&reg_3p3v>;
+				phy-supply = <&reg_3p3v>;
 
 				sata2: sata-port@0 {
 					reg = <0>;
+					target-supply = <&reg_5p0v_hdd>;
 				};
 
 				sata3: sata-port@1 {
 					reg = <1>;
+					target-supply = <&reg_5p0v_hdd>;
 				};
 			};
 
-- 
2.53.0



