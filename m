Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC2818800D;
	Tue, 30 Jul 2024 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355700; cv=none; b=dgaUMxxQXvNHFuds1754QFIVk9S+mlqJH0LJReeMb6Xn+jELZUJ3ge4sXLutGEIvoGvRrvxiogxAg00So04Fy9pvwAvawAc+Ixz7ox1wnXb1hJKr/+Y7v+op+S8uATiGu6JqN9VeZWqJ4pK2dvpJfg/Blv4m7+CtVFxO9yKJZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355700; c=relaxed/simple;
	bh=nKQ740NYFVFo3IfOPhC4c8CNCiGNhseulkTJCKy9m5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO2cyMPH5zdtbeuDFiORFIWFKsRYx320TTIaSg7g2sflYvC8xPrRB0y0Ti2CEQ/YcVKf9IMJznsy+Ripd+JecHWF7LAgt0ivrEqnUPSYdnB7Szuso0S5QrXKceP9598UFbuPI3+bjhqdFZd6Ej6sImYrh0l2qGBPLajPUIrRHBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywTBNR9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywTBNR9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B83C4AF0A;
	Tue, 30 Jul 2024 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355700;
	bh=nKQ740NYFVFo3IfOPhC4c8CNCiGNhseulkTJCKy9m5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywTBNR9pJDgQaC2Hy8pYNiwJtWuaFmstnkX+XptSGwKWSlo+ncdQKtbDZjtOy8AcQ
	 afr5RuEMYzPrhYgXmgJ41frgRrJJjsWxguYbjN8okpD9ySOcxlEvlzy3u+AxB4WwsF
	 YemoTvibsNOaoefOYyiDws7L7sJRwRHcLY71nRyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/568] arm64: dts: rockchip: Fix mic-in-differential usage on rk3568-evb1-v10
Date: Tue, 30 Jul 2024 17:43:09 +0200
Message-ID: <20240730151643.067753326@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ec03073888ad23223ebb986e62583c20a9ed3c07 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb

  rk3568-evb1-v10.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

Make use of the correct property name.

Fixes: 3e4c629ca680 ("arm64: dts: rockchip: enable rk809 audio codec on the rk3568 evb1-v10")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-5-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
index 19f8fc369b130..8c3ab07d38079 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
@@ -475,7 +475,7 @@ regulator-state-mem {
 		};
 
 		codec {
-			mic-in-differential;
+			rockchip,mic-in-differential;
 		};
 	};
 };
-- 
2.43.0



