Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6843515218A;
	Tue,  2 Jul 2024 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941203; cv=none; b=dOszlwh6IwajKaSgIfPbZInUWPdL9FAuXhJnINW+h9mSihFHVbziBCIdslUMvOGeOre21Srdxmy+dErEWy6SR0G2+4OzXtceteE5zUvuACo6Y7vbPPR4+c31sOcGrzo50aTCmiqk8ZHEaTTYQI3EJpgRamv+vINNjaIiFTVPiOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941203; c=relaxed/simple;
	bh=AGGuJdjdHTLRqRHx7HG1ox4B5OVA7S+2CjL3u41zKl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/KMbbG9WpopOZLjqfPJNN96IZCjR8Yqw5+U0ICMuK0TukVMrE41qFaF2jahvKW9Yd4yGr3uKRyRTFWwEjCVhpd9QI+pK6Qu/kzUU29CNlR7/n8hDoigAHay8JlepwY1bNRh51bypEZkAP7TFZK4Y6gck8QIgkT66VdryR8YOP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Af7P3uG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Af7P3uG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12A1C116B1;
	Tue,  2 Jul 2024 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941203;
	bh=AGGuJdjdHTLRqRHx7HG1ox4B5OVA7S+2CjL3u41zKl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Af7P3uG67K7NbnYxe1ZdRfro85xjJyItkmPaH1+LdPN+1sAIwuKqekz5NBhOP2ILs
	 dplLDRgjv2SuHPnFWihQ6YB7olfhRl/1V+dnT1bau9/HltwerNFafcepBA0VwlFKFP
	 Cm4bNRmpGYC2Q9ZanLSluHp5eeB70U8wrjciKseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/163] arm64: dts: rockchip: make poweroff(8) work on Radxa ROCK 5A
Date: Tue,  2 Jul 2024 19:04:32 +0200
Message-ID: <20240702170239.041180989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 8347adcbd0030..68763714f7f7b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -390,6 +390,7 @@
 		pinctrl-0 = <&pmic_pins>, <&rk806_dvs1_null>,
 			    <&rk806_dvs2_null>, <&rk806_dvs3_null>;
 		spi-max-frequency = <1000000>;
+		system-power-controller;
 
 		vcc1-supply = <&vcc5v0_sys>;
 		vcc2-supply = <&vcc5v0_sys>;
-- 
2.43.0



