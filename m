Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20694352F8C;
	Tue, 16 Dec 2025 12:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887701; cv=none; b=eWEw4Z2UiQ5NFKnuhuJ+qGI9kthIuvURdKi6GohG1azyhakesHAwkqhwoKGbV37F0OM2jxSsvGcTXzc2LRQ3PXFtRL0BcbCckHK1Dg302ebbdiLI42IK12i/pMFZ/jsEN9TD3wA3ezAF0FGk8fVG4QqksGmlweMLnRBaa1rclG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887701; c=relaxed/simple;
	bh=QTpoUfkHvWK6VVzrgYmFSjMCCfjEPRzyVqR27fVpgf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOXVzVTr1hl3Jz8r00bwUxeRTWrfeAD4DBZZYJO4aecJ5UYfhLvQcAgLuO9jLZC07dh4ROeWzrAcl8QU4Dn5yXRgx2CMgQkNqnXyulZ/xWtmbQeYesE5CWJNhs+8pgUTAz9E4mbV8LwEKKSGJEv4q4fRrYj18sNq/KyRD4Ofd/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeMhMRim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeMhMRim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AF2C4CEF1;
	Tue, 16 Dec 2025 12:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887701;
	bh=QTpoUfkHvWK6VVzrgYmFSjMCCfjEPRzyVqR27fVpgf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeMhMRimgKWPcN8MeQ+82rnp/IcBnCH+axx1455JjBWyCV91eBv6H/QYVmWCYETbS
	 vI7cyjwF1yRlJRl9sy1XOy0LRoDHYSCSMlKvGWX9wQns2MTHKpExbglokCh2pjDIwI
	 rJTdopzZjaTpM9O4eMKr5EWRk2qGG2G4PyRb+PH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/614] arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 5A
Date: Tue, 16 Dec 2025 12:10:45 +0100
Message-ID: <20251216111411.447450831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 428c6f0232a34..041a0fff22ccb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -233,6 +233,7 @@ eeprom: eeprom@50 {
 		compatible = "belling,bl24c16a", "atmel,24c16";
 		reg = <0x50>;
 		pagesize = <16>;
+		vcc-supply = <&vcc_3v3_pmu>;
 	};
 };
 
@@ -600,7 +601,7 @@ regulator-state-mem {
 				};
 			};
 
-			vcc_3v3_s3: dcdc-reg8 {
+			vcc_3v3_pmu: vcc_3v3_s3: dcdc-reg8 {
 				regulator-name = "vcc_3v3_s3";
 				regulator-always-on;
 				regulator-boot-on;
-- 
2.51.0



