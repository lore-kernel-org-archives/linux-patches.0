Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC81898FB;
	Tue, 30 Jul 2024 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355826; cv=none; b=odY1/8+yBZFzNGEAnp2vHHeC2jrae2wQuo4sllF/BKPJtOIipzHBx6Q/bQigTm3PGYDgN128nYt5TU5YPB52ERNcgPWo66MMICM68XtQbU050rJZcNNIKxD2Zp0ieeO75vFkU5cnP2gvYa+IJpLbmGYcgWLYyXYDTENp1eB7SVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355826; c=relaxed/simple;
	bh=nATbWaakCyp+NlmFb44A0BF+qxqdwaVoBrqS8+gMzXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEpOMxC3WmxJ5J4ViPw1kHqbuHFjCdU9sjPVi2rgwKfFIf09gK1Gxk0F7FI8grNxAsBn1B1crMdhL+1ASpw5LoVm9G1b0YKKEbwOAauydnpSltamNA8zBtZdr806mbEPqf2agJmQUX/v0WfmUUErHTqF3vgSOelVnFX4xAQURIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2niGnfMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2niGnfMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8D9C32782;
	Tue, 30 Jul 2024 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355826;
	bh=nATbWaakCyp+NlmFb44A0BF+qxqdwaVoBrqS8+gMzXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2niGnfMe6C7ATVVbRkmGRIaT/yzgYe7MRahDeemJS2IsnpZlVTxSuScDp5Htc9Knc
	 ZizjW5wsaq+zQ/TbiIO1HywnDNOpZQOPmBSxihExipsj8Y9G9j2C9OgvyeYzbhO4yt
	 0PxIORk+CrKGGdcXWBzqAIpES0wbY4mtPXDeot9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 092/809] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Tue, 30 Jul 2024 17:39:28 +0200
Message-ID: <20240730151728.272713348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 07dcc949b8997..b01efd6d042c8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -850,8 +850,8 @@ cru: clock-controller@ff440000 {
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



