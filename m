Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2371AB53D;
	Thu, 15 Aug 2024 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731080; cv=none; b=h3dobPmiMVMdMGXk5z5ttY6EFJvf8W4BiLCdSqDaN74BQrVWHqMvcbxXFUGCX7ZYE4NRl2mXKa5Ku8fWJ0I9fVLJfaSx+9hFq2+eS3Mt8BiJHPBukSt/6ZTH2JloIeAHN6IKZ08IYTUyW+7CHVidEWoOy1TTbYN1sA13zwT8Z9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731080; c=relaxed/simple;
	bh=V8RmSmM62+2DWwxHpPJ/GE4oK72tK/8KJMvtBZUrMoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTExIQWrDgrdlkFQ610TfsaOEmizPseyxnUaGl9+iiSYF0gElGckBAz92wtNUaRk3m/WOzwDitdXG6NoJijhlpfCKHWdqPVOj8oDp8na7UyNAeMIXAzvzJ1cQNa4/q1pllgDU7B3MLwDeVlBszJFfdPVvNeLB9Q92ItPYR/Q+S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7j/WUys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7j/WUys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B425C32786;
	Thu, 15 Aug 2024 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731079;
	bh=V8RmSmM62+2DWwxHpPJ/GE4oK72tK/8KJMvtBZUrMoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7j/WUysrA/BcSRC5P8OEV1ABGeo0zCF9vNG+w9251s1jwAgdG5s8rEgTLXaUyF1p
	 LcLt/B1EohWDCqdvIAtV7zWzHK+++oQ1i2eBq9WhYLxRFpzHuz4m1/oPgPo5GGPQiP
	 g6u19SL0kCr5hvPASHshiZv0VnjxbEFBTD7UTp6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/259] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Thu, 15 Aug 2024 15:22:30 +0200
Message-ID: <20240815131903.462690782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ef45d5607ea1f..9f300719a8fd3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -763,8 +763,8 @@ cru: clock-controller@ff440000 {
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



