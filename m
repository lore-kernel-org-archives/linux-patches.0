Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC7D18C92A;
	Tue, 30 Jul 2024 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356064; cv=none; b=Umxonphgs7P8SxBHl2EDxlPsZL2UWppoX+qHOMdXdBpDW0MJOEbX4XL3WrzfZmyaC34Msj0jUESC5WvbGH1+6z+FGUq4tjSMlp/GWLl4cWvELJfKW6DQ8+lUj03AcGMroMr1io1q4N1yMMfB0dHRPw9bN0rK4av7f84pY5VQotU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356064; c=relaxed/simple;
	bh=u1jsDr6FUFsPj2eV08rPItlBMRW+DF3LPQg6q+SE7Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw/XaUeF0QMza6aGGkWHkddDB7atABDfXT2CYf63DEhGA8cswO/vF3l8UrGpgZcmA6ZFkV2AqpyvKiuY7SxFrIaOEDlHCG8DJJ3xkADohSymm/J7Mpm0BTQmT/2CyUSrX8GCM+LxDsZ55cpHVrsy0n7GvyzFOjz4jGO53TcQSB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I26l/pf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I26l/pf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84D7C32782;
	Tue, 30 Jul 2024 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356064;
	bh=u1jsDr6FUFsPj2eV08rPItlBMRW+DF3LPQg6q+SE7Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I26l/pf7sm+s2dlaBpq/DVUdS2rs2R6pI/IIkrLOc2QkE0+6p1Xw6el2iPMENZSEH
	 azFeuKVCUI75KtqyRVQNA3Y3IrPszI3qVxlAiz4h6Nh2qo80z0MBk1Q5xNY1xnrUpw
	 PE43CAK9raPzxBBVoZGkfYiqmfaLkf8wGDE5JTOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 113/809] arm64: dts: rockchip: Drop invalid mic-in-differential on rk3568-rock-3a
Date: Tue, 30 Jul 2024 17:39:49 +0200
Message-ID: <20240730151729.086059714@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 406a554b382200abfabd1df423a425f6efee53e0 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb
  rk3568-rock-3a.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

However, the board doesn't make use of differential signaling, hence
drop the incorrect property and the now unnecessary 'codec' node.

Fixes: 22a442e6586c ("arm64: dts: rockchip: add basic dts for the radxa rock3 model a")
Reported-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-3-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index ebdedea15ad16..59f1403b4fa56 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -531,10 +531,6 @@ regulator-state-mem {
 				};
 			};
 		};
-
-		codec {
-			mic-in-differential;
-		};
 	};
 };
 
-- 
2.43.0



