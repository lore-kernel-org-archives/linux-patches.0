Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6FA2F12D4;
	Fri,  9 Jan 2026 11:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959729; cv=none; b=Bli+XmuUaU+kTZzpoStMXme3aH9TNmaPC1H98XXaoX3GEcyzfKtdKe2lSmRJsb0+IGvpWscHeK6z5HAK8VbPiX8Yr+ZwZfapiMmnEW7Gn4wqlT3VGrmA7O28pIt9k+8mhpeiebNXyOEPxHGNY7ZOBuQwZJL0onb/Q9cgbEujCRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959729; c=relaxed/simple;
	bh=PGHA01EH0BOs5pquGvrS+Gg5g5oLQkjhHWAyXvTtzwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q20u5DqKsg5BPYTpXWMnmZaekr57++A+bl5PLEwMRjSU2mWt+KvRTnMJamk/lyIpdJbeP34WKRjNwKwEAeRXIZENriudkxD0YLZtTyuNYxEV4OUmMZ9JQSCn/pttfd58Vq6sOIJk4YiJ96uuA4uuZo3QrXSU7VlHvgxTKqRkIxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVoV97hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVoV97hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16FDC4CEF1;
	Fri,  9 Jan 2026 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959729;
	bh=PGHA01EH0BOs5pquGvrS+Gg5g5oLQkjhHWAyXvTtzwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVoV97hDcwQFuaUoGiydqdpZWb0cEO5yBC3dAdpnfpUKWtDPVCy3k46NYU+WdQXMi
	 BDW4VHDHIuJFwq1isBgOHc7JsrRdS8FskrMvspFS9wWepgEgNeSEOFjE/gJ0oy3eZN
	 ug7rIEJbMWAq2giy6Q4RRzS09wIqhjNujq4PMgDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/737] arm64: dts: rockchip: Move the EEPROM to correct I2C bus on Radxa ROCK 5A
Date: Fri,  9 Jan 2026 12:34:54 +0100
Message-ID: <20260109112139.827623270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 92e6e0b0e595afdda6296c760551ad3ffe9d5231 ]

The BL24C16 EEPROM chip found on Radxa ROCK 5A is connected to the
i2c0 bus, [1] so move the eeprom node from the i2c2 bus to the i2c0
bus.

[1] Link: https://dl.radxa.com/rock5/5a/docs/hw/radxa_rock5a_V1.1_sch.pdf p.19

Fixes: 89c880808cff8 ("arm64: dts: rockchip: add I2C EEPROM to rock-5a")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251112035133.28753-2-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
index 68763714f7f7b..f60243e2b3c39 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -184,6 +184,12 @@ regulator-state-mem {
 			regulator-off-in-suspend;
 		};
 	};
+
+	eeprom: eeprom@50 {
+		compatible = "belling,bl24c16a", "atmel,24c16";
+		reg = <0x50>;
+		pagesize = <16>;
+	};
 };
 
 &i2c2 {
@@ -205,12 +211,6 @@ regulator-state-mem {
 			regulator-off-in-suspend;
 		};
 	};
-
-	eeprom: eeprom@50 {
-		compatible = "belling,bl24c16a", "atmel,24c16";
-		reg = <0x50>;
-		pagesize = <16>;
-	};
 };
 
 &i2c3 {
-- 
2.51.0



