Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9724155CBA;
	Mon, 16 Sep 2024 12:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488284; cv=none; b=J9C/f/2Nkk6acCfr7Y78mEcc0Ni+mn1smni+y4I1HrJ4vxikY78yPpNp5FOUdFI+58bBkGscpNCInH2Et16TeYpCyoXQy5xKszpWhCQSJ8s7AyY9qAE3w7UmSuMEgg0jUeOViowsDuIIwt0hn1RDr19SVhnAfEj8EPzoPvmy45Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488284; c=relaxed/simple;
	bh=rca/pAyktM6aEVoVYTLqS/iwhmEda7x0KWJXeow381M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3TqY9bI5334xTIAofYLUw8jHMNWFevgA3o9kBgm2M1etJSH0K5XIEtFRYALcra0GQPyULT7ZoLeR6nACcYP9bhLfc1dPHcT4zn2L7+uyIJqrJf4Y7agTKFztdJKYHC0jcCJELvwEeL+Z86klJDeyMc13qA//RPZNJMviposQbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uv8bFGwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uv8bFGwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53460C4CEC4;
	Mon, 16 Sep 2024 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488284;
	bh=rca/pAyktM6aEVoVYTLqS/iwhmEda7x0KWJXeow381M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv8bFGwcPEFlDAlY0NyOH9/9hXQcdynU5RS8xVbKEl/7yH5HpZjdamdlZlbJHRRSj
	 plWjTMYJABUPY5FTPEV6DJYvONjgUuiIRKviwfGWxkmEfwt5amS/DtRNaEKr1TCp0v
	 UtpHmmhBbG2hLZHKN8OPu2LPrsQAuYqQKtVdT7fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 059/121] arm64: dts: rockchip: fix PMIC interrupt pin in pinctrl for ROCK Pi E
Date: Mon, 16 Sep 2024 13:43:53 +0200
Message-ID: <20240916114231.112955776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit c623e9daf60a0275d623ce054601550e54987f5b ]

use GPIO0_A2 as PMIC interrupt pin in pinctrl.
(I forgot to fix this part in previous commit.)

Fixes: 02afd3d5b9fa ("arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20240722095216.1656081-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
index a608a219543e..3e08e2fd0a78 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
@@ -387,7 +387,7 @@ led_pin: led-pin {
 
 	pmic {
 		pmic_int_l: pmic-int-l {
-			rockchip,pins = <2 RK_PA6 RK_FUNC_GPIO &pcfg_pull_up>;
+			rockchip,pins = <0 RK_PA2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 
-- 
2.43.0



