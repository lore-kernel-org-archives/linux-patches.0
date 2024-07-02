Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384BB1B5814;
	Tue,  2 Jul 2024 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940665; cv=none; b=rPD0Asx/XoHtEFUSKyDjtent3fBXVaeS4+R+EvNVRM8ols6unKTnM0xKkr4Ofv80kBg9erg8wKH3DIt6qwCbbWJvTvYhJEPggHCbSUP8kBYaYqiAqYUmHQgLxfDzLT39tYeQOjbwxaAoVhNMamFbXzcNMV3hTtvudD5aFOdSyeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940665; c=relaxed/simple;
	bh=Hexyp1Jpax5OUyVIv0MXHJeRRS2sEtE70yrLsAZ6NKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQ12v34t9UdOqlcQIX6o7kiLB30K8s2kphTRMntIFYU8EAiJ1e/jHBuzteFHXXpdEqjFDCciJssemREtTIASlTBORJ5GwlC0iLxa06bJaXEsqHvULCWj4NHVyBrJzbkbVXRKRXXDSz8IpH3Undz3wF9NPW+aYm2e9KXtHltATEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgK+riQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgK+riQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921FFC116B1;
	Tue,  2 Jul 2024 17:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940665;
	bh=Hexyp1Jpax5OUyVIv0MXHJeRRS2sEtE70yrLsAZ6NKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgK+riQDAnSlIku4P5JFIe96lvUToiSWhzWfZYXsHXTNTJf6kOCMtNDMUh+7BVeQH
	 G0/6RpOj7HibQ2iXAKqTsBKT6Wl4TgXTx7+Mn2JExxG0hXMiIJbZWm3ivUbjnQJD3Y
	 quAYszhUKg1nMHiK6oH7Y87dWSC34F/DnvJKknDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 216/222] arm64: dts: rockchip: Fix the i2c address of es8316 on Cool Pi 4B
Date: Tue,  2 Jul 2024 19:04:14 +0200
Message-ID: <20240702170252.243618381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 5d101df8fc3261607bd946a222248dd193956a0a ]

According to the hardware design, the i2c address of audio codec es8316
on Cool Pi 4B is 0x10.

This fix the read/write error like bellow:
es8316 7-0011: ASoC: error at soc_component_write_no_lock on es8316.7-0011 for register: [0x0000000c] -6
es8316 7-0011: ASoC: error at soc_component_write_no_lock on es8316.7-0011 for register: [0x00000003] -6
es8316 7-0011: ASoC: error at soc_component_read_no_lock on es8316.7-0011 for register: [0x00000016] -6
es8316 7-0011: ASoC: error at soc_component_read_no_lock on es8316.7-0011 for register: [0x00000016] -6

Fixes: 3f5d336d64d6 ("arm64: dts: rockchip: Add support for rk3588s based board Cool Pi 4B")
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20240623115526.2154645-1-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
index e037bf9db75af..adba82c6e2e1e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
@@ -283,9 +283,9 @@
 	pinctrl-0 = <&i2c7m0_xfer>;
 	status = "okay";
 
-	es8316: audio-codec@11 {
+	es8316: audio-codec@10 {
 		compatible = "everest,es8316";
-		reg = <0x11>;
+		reg = <0x10>;
 		assigned-clocks = <&cru I2S0_8CH_MCLKOUT>;
 		assigned-clock-rates = <12288000>;
 		clocks = <&cru I2S0_8CH_MCLKOUT>;
-- 
2.43.0



