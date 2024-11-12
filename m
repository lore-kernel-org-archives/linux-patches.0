Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3165A217670;
	Tue, 12 Nov 2024 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408107; cv=none; b=TXrWIKJ3c47LcGRZRo2oPiXghypG/h8I2AtZjW4zdgP+1yAHFWfMXi/+og6JImRaiku8vhuMxIjjeL4gD8rTErCugnNFNK/Y1wLYnKYLS/Gsp81kIHIp2dDk5y6VC0mVKDrZRmwgKzyeZ6R75JOccayGiz5V/g/t0Rk1mzqoMco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408107; c=relaxed/simple;
	bh=HhzpQ0SyfioNyP/Ecwhp3WeEjY+0qYDbd9sXhZfQoD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZW/SItNPQuUmsbIP5Te3LMT1l0su9CpL6tPV8yCoza0S8yLs8RussaJj5co1PQ7GsabkojdGc3bPa9vkh0pqbU1rq/9HWtlUXwTX+K8sKL14S7NzmPrhKBOZlmsyk14z8E8l/ERWR5HCdfMH4/rvVz9XgyvfMTuZuUFclKhTHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2QvMUKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2QvMUKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE14C4CECD;
	Tue, 12 Nov 2024 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408107;
	bh=HhzpQ0SyfioNyP/Ecwhp3WeEjY+0qYDbd9sXhZfQoD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2QvMUKVrGNe3HUX3BIguizYW5KCtTYayOos59Wg5Etcge+xzAft//CjK/qObG2Md
	 iv6HbZHzs91Kgx0ufnK/VnfslgsWpd1wkIn5ohSS374hcT3kmDbGyqCAOyC067uKXh
	 DkGL0XHSHvihCGnugRAi7tu6juBqo9lU39TGH4c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 030/184] ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin
Date: Tue, 12 Nov 2024 11:19:48 +0100
Message-ID: <20241112101902.023824666@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 77a9a7f2d3b94d29d13d71b851114d593a2147cf ]

Both the node name as well as the compatible were not named
according to the binding expectations, fix that.

Fixes: 47bf3a5c9e2a ("ARM: dts: rockchip: add the sound setup for rk3036-kylin board")
Cc: Caesar Wang <wxt@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-15-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3036-kylin.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036-kylin.dts b/arch/arm/boot/dts/rockchip/rk3036-kylin.dts
index e32c73d32f0aa..2f84e28057121 100644
--- a/arch/arm/boot/dts/rockchip/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rockchip/rk3036-kylin.dts
@@ -325,8 +325,8 @@
 &i2c2 {
 	status = "okay";
 
-	rt5616: rt5616@1b {
-		compatible = "rt5616";
+	rt5616: audio-codec@1b {
+		compatible = "realtek,rt5616";
 		reg = <0x1b>;
 		clocks = <&cru SCLK_I2S_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



