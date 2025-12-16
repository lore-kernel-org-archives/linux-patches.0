Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFB732BF22;
	Tue, 16 Dec 2025 11:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884319; cv=none; b=k+waP3pcTOnsGMgLAEyd44bJNyu6UDou3UgyJnbD6cJrAaaZ8KKAbcGdi+fsIK8MfdTJvsiH0WrAIWgaxiAEUpqfjc8Ec5b25WiXuO3I2lVO042BhLyTq1BZdMBy9Y/IynvgwUxccYSC+5EdJV0vlWfoz5IuNDcds9Me/wrjCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884319; c=relaxed/simple;
	bh=NnT67Ls8N+b6FQeBFsKmzyzk4gzg48XynVeC5gYPjWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhokb93ZmWsN3h9CKOWcdjHwR/UDmRB8SHsML6aUheHY6iygdzlANa/VY112kx/sQ22L3XmfhJH6XZzdLIzTPfLlvwe0ILDQj5vG/ylMapo8X6f48cvnxGCTRhrJQRaNrrc9ux7tJ3Mr04Qv2R81s++wn1ZB/YULacdRe/I9ys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRZQWMCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRZQWMCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3BBC4CEF5;
	Tue, 16 Dec 2025 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884319;
	bh=NnT67Ls8N+b6FQeBFsKmzyzk4gzg48XynVeC5gYPjWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRZQWMCQ5Xh6qKu101HCCaBgMUe9yFUJiZUpQOF9455xbUY/qUXPCRO5TmbeGqcYe
	 DkibGWpjC88ZMmjXew1IIBPhp5Fx7hGZ9WgpX6YY9W+Y1ABA9pN1QAjTu6AUVQ0++A
	 EZL/531voHPQbSi7+eYcNEMV0n6U/yDb53EaMdgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/354] arm64: dts: rockchip: Move the EEPROM to correct I2C bus on Radxa ROCK 5A
Date: Tue, 16 Dec 2025 12:12:04 +0100
Message-ID: <20251216111326.602982644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 294b99dd50da2..7813984086b38 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -204,6 +204,12 @@ regulator-state-mem {
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
@@ -225,12 +231,6 @@ regulator-state-mem {
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



