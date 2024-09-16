Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5AC1547F5;
	Mon, 16 Sep 2024 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488678; cv=none; b=gssJs8UTo3bg08s4yCSCF+TbYgnip3vib2ao6Bpq21bFitFjqvtXgzVKyFgkpvcW64lDuXFWVNlAvznGcSkmACPr5WAmpRVj40wSxd+a7l7XaYREt8rEIPGhuO7FPitj3MOsRaYILlOa1W7/71VU7ge7K4HhSCwo4QRrChl/lJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488678; c=relaxed/simple;
	bh=n17P9zxYxzjCmCgFvr+5WUgZh0bSdQmoCRuGhxOdJSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPt7QCvMaq04/icAJXlhK/yBNfCKsBkSqfWruicpq+TD0yScze/4xwgd0De/wMoVh8Gfkp7dED7kwBYVSyvmvzWYygts15DrKPozPUWMh7VmOW3jUfn2V6Rv5LNHGw1Zi00M7QUNWcH4BQNCnhhUvHFb0Wdfx2K91mqtEaTcIvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCGnGArk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCGnGArk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EC8C4CEC4;
	Mon, 16 Sep 2024 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488678;
	bh=n17P9zxYxzjCmCgFvr+5WUgZh0bSdQmoCRuGhxOdJSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCGnGArkr8k+bpZNLFTHT1sN4AZ//WMK7YUmFe150s8/yEsXBJ8lAuFGc840nP0Ox
	 fDvoqfKDlAhssAR5cJJkvK58vObOskwykke8YbzeqT0902O/pqtmPuEwywzHsFMHPX
	 xe55iWJ+Osm7V6b6tC6btecI8SNwBZdfsizifBro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 48/91] arm64: dts: rockchip: fix PMIC interrupt pin in pinctrl for ROCK Pi E
Date: Mon, 16 Sep 2024 13:44:24 +0200
Message-ID: <20240916114226.089835309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
index d9905a08c6ce..66443d52cd34 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts
@@ -332,7 +332,7 @@ led_pin: led-pin {
 
 	pmic {
 		pmic_int_l: pmic-int-l {
-			rockchip,pins = <2 RK_PA6 RK_FUNC_GPIO &pcfg_pull_up>;
+			rockchip,pins = <0 RK_PA2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 
-- 
2.43.0



