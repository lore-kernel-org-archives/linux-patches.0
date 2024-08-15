Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B26019DF60;
	Thu, 15 Aug 2024 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729341; cv=none; b=vF+VBaXQSp0fl8jnzcUGwn2dUZxp9KyL6tCgmAgqjJv8LnufnwQctfSiZDP4PzINhSI/HRfmw4U2TpIylzMc8pW6/wWIHIvBiJgv2/PYPfMAKOfZydln/9zHrM50mx+Uqv4zXCjwIJ1u8yMt4Jc9r0IF1Evr+u1JPWCaPWebfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729341; c=relaxed/simple;
	bh=DxhauyGkUMZ1madFYIE80xTOtum16NBkAoHvtxEv/RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGp82U3+QE+hwZfkVsQjqzmVfRonanRO2JVLyHPSnoZR81oxo4CU8sJM9QJkEMJ6gSwx+g42U+RrhcVNbB59Bp7DBsp7yHftrPsyWsaTNnaSe55Bbp3ALcxXsZAZdVqkjXHa14jy/YpUK0EFFtTbPUfdDZbefPJTR/FAlLtGFbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtRTDPJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtRTDPJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC0AC32786;
	Thu, 15 Aug 2024 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729341;
	bh=DxhauyGkUMZ1madFYIE80xTOtum16NBkAoHvtxEv/RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtRTDPJ0GwbX1b9T8eZGVZv+j6+VYLK6dMmwIAL2Ing38rNDjKoZSUyKJPgfe3fTZ
	 XgbSUY7YPIHIqMDRBblm+8tnlv7qeZ8e2IF52Ux8+sagA5uyYX8cKgZCJIhezbNpMB
	 vem6v2JBchGGwV4p9Ex5pFwHEJnOibyDEGgpM2j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/484] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Thu, 15 Aug 2024 15:18:04 +0200
Message-ID: <20240815131942.286274319@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 0f2ddb128fa20f8441d903285632f2c69e90fae1 ]

The VOP on RK3328 needs to run at a higher rate in order to produce a
proper 3840x2160 signal.

Change to use 300MHz for VIO clk and 400MHz for VOP clk, same rates used
by vendor 4.4 kernel.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240615170417.3134517-2-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 26f02cc70dc5d..21755dd5b4c45 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -807,8 +807,8 @@ cru: clock-controller@ff440000 {
 			<0>, <24000000>,
 			<24000000>, <24000000>,
 			<15000000>, <15000000>,
-			<100000000>, <100000000>,
-			<100000000>, <100000000>,
+			<300000000>, <100000000>,
+			<400000000>, <100000000>,
 			<50000000>, <100000000>,
 			<100000000>, <100000000>,
 			<50000000>, <50000000>,
-- 
2.43.0



