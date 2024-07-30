Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29709200118;
	Tue, 30 Jul 2024 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355271; cv=none; b=m+dEMpHnN3RxqlcPutCHgWrkg3Er02O0fbGDZBn/ZWQuV0nIxGpPYIbn2fxNVSoIJv8V84R92ySwefDEewLkTymOzXpVoQH4vDjVfx7qk9hNvsJDGc+Mi0lrwTBaTpsRtjw9F0h4zEwuLKI2j2MVlZLVXlP3snENhc0pC6l34TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355271; c=relaxed/simple;
	bh=VMrID1SNAAkgvxNjhKEF35mBLSX/q6DUMwyrAOCntmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9XOZqmDYLqaLeAn2RkBijXXElAT4Vh8ngsvLSGzIerKlioin9pbukPUOORLR9+Mb8VLtKruKcqa4CWgIOfTn41aM6XFf59tJcvUPIiiHD5iN/mA9arSgmfg4ltviHLbUoi5lCIEqaFGHlrfPPtjlQPkiMNSMmR+E1/L2JrAJLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeN4Hlm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeN4Hlm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6EAC4AF0E;
	Tue, 30 Jul 2024 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355270;
	bh=VMrID1SNAAkgvxNjhKEF35mBLSX/q6DUMwyrAOCntmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeN4Hlm0+xIYfeZR36vNAPh1bWd7+NzVs9WiqjyDxXih/CN7LEzLgdTrlZTWPiBgj
	 hUEMatJ1lQZPIhYEqlGWe49Xp1Hk0eLFledMS8rOPvbD9Lv1TEXL/BiWEZzsdsGfkZ
	 Tgu9sKUoK2jkHQeOmV8oQkfFroJuqsXd3Sxxb94c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/568] arm64: dts: rockchip: Add sdmmc related properties on rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:42:30 +0200
Message-ID: <20240730151641.525618093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit fc0daeccc384233eadfa9d5ddbd00159653c6bdc ]

Add cap-mmc-highspeed to allow use of high speed MMC mode using an eMMC
to uSD board. Use disable-wp to signal that no physical write-protect
line is present. Also add vcc_io used for card and IO line power as
vmmc-supply.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-5-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index 4f6541262ab84..f436284cb89c3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -210,7 +210,10 @@ &sdio {
 };
 
 &sdmmc {
+	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	disable-wp;
+	vmmc-supply = <&vcc_io>;
 	status = "okay";
 };
 
-- 
2.43.0



