Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B0350D65;
	Tue, 16 Dec 2025 11:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885753; cv=none; b=Th8MxuQzcIL/Pyjpa4CjT3Gg5x5LZd0b/GmtLrrrks8w03algFKIwQl5PUtOoiVRoDMKFnB+Ppi0LY7inFsCZ/kclRdQ1So55/1zJW09K+VS7eOWTjBOAzzMVu8lQBO19j3p9iTURqNedzvLGIU0VsHyXD2iXqvaGrbKZv7EAXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885753; c=relaxed/simple;
	bh=ry2mr99gsat+cWJBp5jTy6Mu+0gwTBBYYGkDb2LUX20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT+Bz8vzM0vJXVBD2qn/q++0NeGFKsrRtVfB2Z4LGMkcMDmJRqwGSsGY/k7Kaa3RPcQseEEnaqT3ThkTwfzr5AFZB1aNY1uk8Swn6qq9PSLV72R4eOGLVbWNhjDsn8BT1ODkkPz+olqBjbcyIixyUaFCOz6KJwaSEDWBq0SzIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tTifjcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tTifjcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017DCC4CEF1;
	Tue, 16 Dec 2025 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885753;
	bh=ry2mr99gsat+cWJBp5jTy6Mu+0gwTBBYYGkDb2LUX20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tTifjcK5NrRLDoFXwblVPgY+1JYSNV7bDq77WfbaUDXkyP+gOh2/lSDmiPp4XuAF
	 OrVTiVxmw2noDcdgBvvRJksEVjviriz29cqpdUz4KVeuU+tqNgsV/hwj4L2BEPAEG5
	 n18KyiNGkQ4TMGKDKDf+GqbhP1S+tqefwpL2iSZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 234/507] arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 5A
Date: Tue, 16 Dec 2025 12:11:15 +0100
Message-ID: <20251216111353.978911066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 3069ff1930aa71e125874c780ffaa6caeda5800a ]

The VCC supply for the BL24C16 EEPROM chip found on Radxa ROCK 5A is
vcc_3v3_pmu, which is routed to vcc_3v3_s3 via a zero-ohm resistor. [1]
Describe this supply.

[1] https://dl.radxa.com/rock5/5a/docs/hw/radxa_rock5a_V1.1_sch.pdf p.4, p.19

Fixes: 89c880808cff8 ("arm64: dts: rockchip: add I2C EEPROM to rock-5a")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251112035133.28753-3-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
index 53df90b0eed16..6ed8b15e6cdfd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -226,6 +226,7 @@ eeprom: eeprom@50 {
 		compatible = "belling,bl24c16a", "atmel,24c16";
 		reg = <0x50>;
 		pagesize = <16>;
+		vcc-supply = <&vcc_3v3_pmu>;
 	};
 };
 
@@ -593,7 +594,7 @@ regulator-state-mem {
 				};
 			};
 
-			vcc_3v3_s3: dcdc-reg8 {
+			vcc_3v3_pmu: vcc_3v3_s3: dcdc-reg8 {
 				regulator-name = "vcc_3v3_s3";
 				regulator-always-on;
 				regulator-boot-on;
-- 
2.51.0



