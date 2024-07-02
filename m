Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A461CD5CD;
	Tue,  2 Jul 2024 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941655; cv=none; b=bSHKD9ayujVJLPd/2Qo4tK14tQHIJ0KAG0UGrA35zLaGFBksExAHX/tiyk7J9HyeVgGlY55mcZZ21TPpsNrzNvgRw1hlqYmE3lr/tQ9gEaNPhFk0ndFJOEtbAUUIWt71fS5vW7gLeyAeToQHOpcuIrZwHjeJeWGyUbpM7dzyEcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941655; c=relaxed/simple;
	bh=/bF6TPtSvZEWrFaJibz02PsmEZzsAVxJcxVgBxpB1uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ut6OsMiYvyUcJMLoNdWdMhR2Y922SdO0DnnSwHQlsbfbitbPPqtOa/0CCcT3c9lfqMswupP22iRGuhCceDyE6ENI4Z0NHP96CCPAx+PrffAPdroaLlYGAfV5ZO5urjt0nO2ch8I7MRMIBlju0EIb3+VNXB6tbsz62Pm7nLK15sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RT3rvx39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RT3rvx39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDC9C4AF60;
	Tue,  2 Jul 2024 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941655;
	bh=/bF6TPtSvZEWrFaJibz02PsmEZzsAVxJcxVgBxpB1uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RT3rvx39eyuizMkelX/DWCgRxAYVRMFdg7TMt5/XDYmKtO9CCTF+seNfHTJps2W4V
	 Kpxtn+dkFMU0MQ1sKvUXWZOXSb5ZJ0bfFprJlX6TxhQPJ95zqwaTcsYVW2dxt+Qnuy
	 iW37WZ+8kr+5HxmGe9L61Gu0kDenOIupxUOzy89o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/128] arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E
Date: Tue,  2 Jul 2024 19:05:28 +0200
Message-ID: <20240702170231.023476301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 02afd3d5b9fa4ffed284c0f7e7bec609097804fc ]

use GPIO0_A2 as interrupt pin for PMIC. GPIO2_A6 was used for
pre-production board.

Fixes: b918e81f2145 ("arm64: dts: rockchip: rk3328: Add Radxa ROCK Pi E")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20240619050047.1217-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
index 018a3a5075c72..d9905a08c6ce8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
@@ -186,8 +186,8 @@
 	rk805: pmic@18 {
 		compatible = "rockchip,rk805";
 		reg = <0x18>;
-		interrupt-parent = <&gpio2>;
-		interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 		#clock-cells = <1>;
 		clock-output-names = "xin32k", "rk805-clkout2";
 		gpio-controller;
-- 
2.43.0



