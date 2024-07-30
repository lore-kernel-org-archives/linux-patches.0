Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF651BA88C;
	Tue, 30 Jul 2024 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355885; cv=none; b=jZ35dmOjXmniW1a6taLNLWhEmtWJCg9yo1A2lxvGdJgxrOxeppRQUKgatHO16tju1tjTSd7Rc6r8g0sid/imPTZccnLRMhuaVDQNMuNX2btYL2LTJzvh4SinWhWlRWTSEyEo2WNkm0cZP9I9OvwiBclpP26H80yilZjD/o/yRZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355885; c=relaxed/simple;
	bh=hoSv/QjRQTsn9LFWwvKHkaJutyLuXs5cQNglhUnE4rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjjPLzLHx3V/MnULxOGkI91W4wcQ+QmXEo3BWoC/Ri6fwndLdi6VixZUI3eHzDbRavv1QZpZ6qFkErByCyJ2g4z67iq68CFAi9nBfeyLqdKojYrxSCf2OxJ/qAJ+skUm+tiheQ+6c9ZxaugHOCXtaQ+iV0F9LzgsIIwpbWOibRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/kLZaRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/kLZaRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6E2C4AF0C;
	Tue, 30 Jul 2024 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355884;
	bh=hoSv/QjRQTsn9LFWwvKHkaJutyLuXs5cQNglhUnE4rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/kLZaRPBsFq/tIf0frlfZkHroJvbnGBvOUFwQiS9u90wLmGfNFz3RVOZWjgLWzda
	 xPidsnqeCgIcxvyByg3TPERk0ak7siMGrmsOY9KRVyh3WfnG4Jlx0bD6+M20YXawF1
	 L/BgZpwxyWnSqaXJ1Iw+spoeoTZNVApGyA5vhhss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/568] arm64: dts: rockchip: remove unused usb2 nodes for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:43:26 +0200
Message-ID: <20240730151643.745414514@linuxfoundation.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit cd77139a307fbabe75e6b5cb8a3753e3c700f394 ]

Fix the following error when booting:
[   15.851853] platform fd800000.usb: deferred probe pending
[   15.852384] platform fd840000.usb: deferred probe pending
[   15.852881] platform fd880000.usb: deferred probe pending

This is due to usb2phy1 is not enabled. There is no USB 2.0
port on the board, just remove it.

Fixes: c79dab407afd ("arm64: dts: rockchip: Add Lunzn Fastrhino R66S")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20240630150010.55729-5-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
index 82577eba31eb5..e08c9eab6f170 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
@@ -421,28 +421,12 @@ &uart2 {
 	status = "okay";
 };
 
-&usb_host0_ehci {
-	status = "okay";
-};
-
-&usb_host0_ohci {
-	status = "okay";
-};
-
 &usb_host0_xhci {
 	dr_mode = "host";
 	extcon = <&usb2phy0>;
 	status = "okay";
 };
 
-&usb_host1_ehci {
-	status = "okay";
-};
-
-&usb_host1_ohci {
-	status = "okay";
-};
-
 &usb_host1_xhci {
 	status = "okay";
 };
-- 
2.43.0



