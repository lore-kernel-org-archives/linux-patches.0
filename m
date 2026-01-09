Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F59033B97F;
	Fri,  9 Jan 2026 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959732; cv=none; b=j2RDbbQVxtfqYUEcfr+b6Bl7ds44wxas3f4xScms8IEjVzKZoh0fm2tJaoU0znmUXt7Cvfi6siUWEBLJ8eMtKuZItDdglxgdPolhXH1XH6iO4IxrtuK8EHalJOHnIzxGRBfGgekMGMla2OtJYE/b6pqx2n/j7ttsfTc2rnQsWwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959732; c=relaxed/simple;
	bh=+0uOFFiooQVyuS65PnGjdn0+q5RJo4XOq4tXrrONeqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGFRuVLGp4bve+sV7LwRIQgXYoYxMCy6EtTX9BSalKUIRKMKZLV93WoF1f7Um5sJ0FN86B11RDtrrLQDmWpQNvb2GAty+FGmpuOxkJP58QTwhNuFtnUWYFan0TRvzuSLw7ATMTMcrR5MyFCiCQk0xQO79jlNTNV0hJRUlXfZDdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF6Hc2U+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF6Hc2U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0398C4CEF1;
	Fri,  9 Jan 2026 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959732;
	bh=+0uOFFiooQVyuS65PnGjdn0+q5RJo4XOq4tXrrONeqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF6Hc2U+diXZybEAJ6hYEYSJSoHbqunrOpAd0AtZv9JMf5JG1/TmFpAmXa1FNN/nQ
	 G93zgp+8J28cPHsU32yicu30E2hE/S13jd8TI2WhUeRyq1TmRZVBsjZ5uQyONW13wb
	 kyqAiV+VpaPXCWwKGcpCPXXKCG0TSxVVurmgbuPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/737] arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 5A
Date: Fri,  9 Jan 2026 12:34:55 +0100
Message-ID: <20260109112139.864468103@linuxfoundation.org>
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
index f60243e2b3c39..cd8bd50b35778 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -189,6 +189,7 @@ eeprom: eeprom@50 {
 		compatible = "belling,bl24c16a", "atmel,24c16";
 		reg = <0x50>;
 		pagesize = <16>;
+		vcc-supply = <&vcc_3v3_pmu>;
 	};
 };
 
@@ -518,7 +519,7 @@ regulator-state-mem {
 				};
 			};
 
-			vcc_3v3_s3: dcdc-reg8 {
+			vcc_3v3_pmu: vcc_3v3_s3: dcdc-reg8 {
 				regulator-name = "vcc_3v3_s3";
 				regulator-always-on;
 				regulator-boot-on;
-- 
2.51.0



