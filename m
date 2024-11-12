Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9412123F5;
	Tue, 12 Nov 2024 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407996; cv=none; b=BMLY0XnnUHXhCw+pQcj/MuRTUesnWt69SApF8/t7PQFvgxUSjocP10SQjVWn16NUOlsif+rm0XWy9xSyWEu/d1G38gY2SuJUHvd+hF8/iWI6wcWJ5+ehBQXi0Ob6e611KUsqq8RlHOS4OfHaZiRB07HNFe2nJ1f5slUiZ/B9RXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407996; c=relaxed/simple;
	bh=LiGdhCOaunIWvxyzbIjkAHuUyGnK8Qem+2TNKRaqME4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP5v3iOet+VGcVZEqLlkA7s+JBjLl2dkTl+jcUYzFVY0/58TunVM+q1bfVdl8m/USgpoQj/DfOhtdI+91GjtBWU52cL08c+yo25BuaO9zNDbzDJbWB9NXk1Bc+jpx8OkBn9XycilC6X9JJ71hhqLp1WofjkrJcM2QRppVcV22Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9BjFjP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9BjFjP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06C6C4CED4;
	Tue, 12 Nov 2024 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407996;
	bh=LiGdhCOaunIWvxyzbIjkAHuUyGnK8Qem+2TNKRaqME4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9BjFjP2lb+rR7h8bo371geaByD5Ggwr8WtqLwJ8CuImasGvV2UpS6cfeRAGEDXRU
	 McdN/sdaTIQotQPCvxN+7r5l1yoICSdSC+e+MpDU/C2QQdBW6v0dMVOXWaUAno5Wj0
	 cF1xlP+26J9YxGRfO+C0W5/qiSuSjXRqqQ58mG/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 005/184] arm64: dts: rockchip: Designate Turing RK1s system power controller
Date: Tue, 12 Nov 2024 11:19:23 +0100
Message-ID: <20241112101901.076476595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit 875ea82c75f56697fa500f30fabaa49f82f9b229 ]

Currently, the Turing RK1 board reboots when told to power off.

Resolve this by designating the RK806 as the system power controller, so
that the relevant driver can handle system shutdown requests.

Fixes: 2806a69f3fef ("arm64: dts: rockchip: Add Turing RK1 SoM support")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Link: https://lore.kernel.org/r/20240912180148.205957-1-CFSworks@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
index dbaa94ca69f47..432133251e318 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi
@@ -296,6 +296,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pmic_pins>, <&rk806_dvs1_null>,
 			    <&rk806_dvs2_null>, <&rk806_dvs3_null>;
+		system-power-controller;
 
 		vcc1-supply = <&vcc5v0_sys>;
 		vcc2-supply = <&vcc5v0_sys>;
-- 
2.43.0



