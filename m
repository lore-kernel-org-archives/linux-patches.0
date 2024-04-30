Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C7B17592;
	Tue, 30 Apr 2024 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476378; cv=none; b=Ard/6O8UWJSx6g2AWUdIj1EYNGiaN4NNThU1eN0u8DxwCB19CrHIYLCe9r5UqK2Im4A+arUHYt7mxfc8lt2MI8NAu832W3CgIQk50nLNxR3AeciEa//rD97nWfMarfnXrYV6fi+s9OcLG052+1rkcVRY6GuI4Vvze2t8qZ+2k18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476378; c=relaxed/simple;
	bh=dnIya9NE5YszuhsOyMbm7q8UZW9RX608jVYPSiKAQig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r87OTx6cocYSRq1Ex7LC+v5pPw34Q0LeQ8Ph8120KBz2tTdFUjIw4uWJOseJHUzyaSREU3dp/IKcS0h54dT9OKwM/0aQaijodZteC+rSjYoVEOqZo7ZBGn3+Y48IMpnh1FGZUM4pxYFuPS5SaUXEqVx7f2ycTWTEhtPvay8+P2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDz9nEIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDz9nEIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0158DC2BBFC;
	Tue, 30 Apr 2024 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476377;
	bh=dnIya9NE5YszuhsOyMbm7q8UZW9RX608jVYPSiKAQig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDz9nEIfXEzgDyenRziM6V0RBCGAy6547afZyvvbRfmg7ozGPg94GEe8MmPh6oSLB
	 Y0rHbBspQPrREdgbtR52AGD8V+a9VOVMsKdABvmU2t9P9q0pqQj2PtukiTcQrQO4I9
	 qliey1ES2abUyXmkzEjkv24taGmn1Z9p7SRk7vcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/110] arm64: dts: rockchip: enable internal pull-up on Q7_USB_ID for RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:35 +0200
Message-ID: <20240430103047.756623677@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit e6b1168f37e3f86d9966276c5a3fff9eb0df3e5f ]

The Q7_USB_ID has a diode used as a level-shifter, and is used as an
input pin. The SoC default for this pin is a pull-up, which is correct
but the pinconf in the introducing commit missed that, so let's fix this
oversight.

Fixes: ed2c66a95c0c ("arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-1-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index aa3e21bd6c8f4..fee2cc035613c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -443,7 +443,7 @@
 	usb3 {
 		usb3_id: usb3-id {
 			rockchip,pins =
-			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
+			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 };
-- 
2.43.0



