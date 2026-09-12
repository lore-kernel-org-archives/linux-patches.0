Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7990D34CFDA;
	Sat, 12 Sep 2026 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217765; cv=none; b=jpfzydxA6yVwJtNG8yHTTfPMPMGKdrBhbMWWTv258/AWPI3R9herZa7DZE+kheWgutZdg66O4e2EbtyyykCq7IKn/1HZMaF+KpLZxXmCygs1lj7haYJcaDk4OdkbznCpevKQdosgLCMjSjeWFWrqdrV4GVtFUaFQHZr2h6zTrSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217765; c=relaxed/simple;
	bh=KuxlbLQ9d7SZfpdZ4Fk2Qh/zpAL9pRJCxUX+k7LE7Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhEJoJ+vDTX8OjnUIcv4Ld85XqBWUyZZn9/UXkKdA6YxEHPTvQI0g01kLX+qi8Qc7/3ou8Yt6EwkgOcfwa3GYWBCW4GfQHrQdf6gpwd8RoBV1YzgGOKH0nf/lYtxtDPUtWEEztwV4k7wIY6noRX5GtvJV1wMeei0xjwTTaQK6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQnyoIQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQnyoIQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E64F1F000FF;
	Sat, 12 Sep 2026 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217764;
	bh=2nPQnPvwfv2WHxDALj9Lgsg4DYZFpqxqouenYxgCIYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQnyoIQYHGraxw1rEwTNFd71doZ88BKdUWMiGpcZ5CLreKse82fYyO9XGFpo5QxAe
	 +QzMlh/7huUMzDUC3RwNE8xYzXcQyS7VLsvowbfatpbkdiS1fR++XR+8jQ9A9j/4E7
	 sh4kDMzzjg9bVIMsDBmxQUYPxPBmFZpt4Vv3Dq8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1005/1376] ARM: dts: helios4: add SATA regulator supplies
Date: Sat, 12 Sep 2026 08:57:11 +0200
Message-ID: <20260912065629.963650683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 21df1b9e3900f..003b0708e9656 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
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



