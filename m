Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39041BF30B;
	Tue,  2 Jul 2024 17:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940630; cv=none; b=afz/llGRrot7BStnwrs5kOvaci7TIlU70/bT72X6Zm1YUHrE603G7Ca/GBoIASFcaB9Gf3DMiLv3l1l41k6dMdqTtLgG7qrBeo9eB01X9t73V/biZMIW0NFySg7UcOVNbBtNAydzv6OOQtmTzIYl+hkrsBUvTMcjQ9HqwTNV8A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940630; c=relaxed/simple;
	bh=V96RXwO3iHO6AYqNOuV6Orkg/Rq89byydr/kMQ9MHGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lv49M21odBre9XF7NhzRZ60SxUPUoMvAEGd7D4a7r3sbT1Dbpu/h0KiHg3cNn7UAKmu6SJaB7Katg/t67okN9QOtMFRYVmaniPv7fysUHAp2eHhxZOAnaUqRxEgeGlyrOHUjUDFmKlKW8buNnvAmzSlGG+vKMLWscIaIudeUxvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJHZ+76L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJHZ+76L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A9FC116B1;
	Tue,  2 Jul 2024 17:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940629;
	bh=V96RXwO3iHO6AYqNOuV6Orkg/Rq89byydr/kMQ9MHGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJHZ+76LbU1jVqiRqdu9fCLAQrcdtnQm8X6CZGE7sPxFbiJJdP9U/xq/2rOIxACLg
	 aF5iP2A3VQ3UPOtUJFi7oFL2AX3G1dcZ9qTdUXRuYaOug0igInvTg5Ci1xtm/TlfrK
	 LYbLc9vHMGF7uogHHeZUdm71whftJkwR8nRBeFcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 211/222] arm64: dts: rockchip: make poweroff(8) work on Radxa ROCK 5A
Date: Tue,  2 Jul 2024 19:04:09 +0200
Message-ID: <20240702170252.051591426@linuxfoundation.org>
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

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit d05f7aff7ac23884ed9103a876325047ff9049aa ]

Designate the RK806 PMIC on the Radxa ROCK 5A as the system power
controller, so the board shuts down properly on poweroff(8).

Fixes: 75fdcbc8f4c1 ("arm64: dts: rockchip: add PMIC to rock-5a")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20240612033523.37166-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
index 2002fd0221fa3..ef776aec9d4b5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -394,6 +394,7 @@
 		pinctrl-0 = <&pmic_pins>, <&rk806_dvs1_null>,
 			    <&rk806_dvs2_null>, <&rk806_dvs3_null>;
 		spi-max-frequency = <1000000>;
+		system-power-controller;
 
 		vcc1-supply = <&vcc5v0_sys>;
 		vcc2-supply = <&vcc5v0_sys>;
-- 
2.43.0



