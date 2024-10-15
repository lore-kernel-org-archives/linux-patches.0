Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D6E1D89F5;
	Tue, 15 Oct 2024 11:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992170; cv=none; b=Joqxz6OBMHvklRPdo57Hfghb49pyCqPpp0+JbhX3gMEczM5pC+3nYLyLnpwDgSi4cMSq/AnrC9eYllzliAAjB9UVgwDJICls/W4ghDDvLRnvyUHOJWfk3o9opQO/AhtHZ6ijJOxIGNP+e+c2AdA2MNMYSngwgMz0vQ8dOAIvBrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992170; c=relaxed/simple;
	bh=mj8LeAALDMP2WXbaWJlVtoUJ/VHr6o2ap/n8QRmUXXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCpvp5C8Myd7dNmK2oN9YN5bblzImQZCQAabSd1io/+/uUJbc2Gp+UujxVx1cYHCQ9StOHOC59bOIVUk2MgtsjBD7aU2bMhWvcBcgYLoBSvrEUXeZcyKzccBUJn81Ku9RiKa4urwxFe1CWNpcZh7//SarIgGsOC17f+gUzAQOTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iuO1kax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iuO1kax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0E5C4CEC6;
	Tue, 15 Oct 2024 11:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992169;
	bh=mj8LeAALDMP2WXbaWJlVtoUJ/VHr6o2ap/n8QRmUXXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iuO1kaxk5eK9UXMlYzlv+I/Ha0Mu5wTgUVbvScd/gXzjl06WTdtRoa0lPRcepnBG
	 WC0o+wGoy5A9x+7MTrdjalcaoNjm6OfsO+N1KmpuqL/82A7+pXykVd2L/OJB3gsABv
	 hFYuMT6QPikLRnMxWxCerJH3UNQ6E9jNi5yaMiqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/691] arm64: dts: rockchip: fix PMIC interrupt pin in pinctrl for ROCK Pi E
Date: Tue, 15 Oct 2024 13:19:45 +0200
Message-ID: <20241015112441.810887318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



