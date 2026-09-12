Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37E19D074;
	Sat, 12 Sep 2026 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243280; cv=none; b=nVwXkFaSUiSxL0jvjrqQSoet4aLIpZ/w2NPPcfvLCsptoCK27do4CouA39Io+B6nW3WVaGfehYOXYhrqcQpPXzbgdbmRU1+AlF3+fX1dkUAlMi9ItkkrAvSLG2ee0Ip2IoNvh1nGvdrR4Q4/TPJ1/LI8g4Ai7BnvpLz2ITfZxGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243280; c=relaxed/simple;
	bh=O/PpsILUZI3e/oaXv7CwTloo4w7rVUtg9Hq57BI2RJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxX95/qptdfAE1v0KhkFpIxpq7g+yDySk+Nhm7GaPYA3YoKZNuNjWt9rJY3DIRZhzaHP4UzlJ2DRjO83AkaVXwKW+FV4xCZhwjgUHbpLlsUCucfyy+lGtWJ4ylVFktpQAmEEXjmNtvdRcy7x5YbS+QIUDBdfVkjxu6oyITnZrY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyHnK2Uq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyHnK2Uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C311F000FF;
	Sat, 12 Sep 2026 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243279;
	bh=SOQisBJBV+ZN5np7kXA/4pEU/qbWuSuWkACf05XJ3vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyHnK2Uqd8Sph8pJk4DKSMCnEiwFCNEpw+0wATskBMCKjXCaVdzRsb7Rp9h//Jg6o
	 NzLUwQLu6UmfsmkMW953Nc6cAgEPfIYgaCSYzU4cT0xchmaND+NTg5r1ji8m9l3GTk
	 G5O51okOBoTK61o2UXgRT/E5f+b9ec2yp/7lrif4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 657/798] ARM: dts: helios4: add SATA regulator supplies
Date: Sat, 12 Sep 2026 09:04:45 +0200
Message-ID: <20260912065532.170779561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a018de69da83a..1ba824f6fb206 100644
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



