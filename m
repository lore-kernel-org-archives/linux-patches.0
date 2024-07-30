Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E842818800D;
	Tue, 30 Jul 2024 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355677; cv=none; b=GRTxuQ8zQucFCq0M6FHldQr6WBRRoRL1twtExa03UObSPrMbpcf8ht6PY5/CkMQgzVnZ+u12cD6zwvgpM8Qra/QjTtQ21N9pw9tfPjiVkaOo3I3W54W9QKJQfomxJowtbLRky57HLTUn/wCxjNijU0Mw6IXzZ7IZfzD7S4sM9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355677; c=relaxed/simple;
	bh=u/HTmwz88KqBtf8jerL2w4LY4Rpsr7KvLwTeoVqTE6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moVvO2ropklmUTZIY2QfNUhX7/sv1bf2uaMKr5r9C9kGnK0pAd6igaOYXfBS3qL0GV3vXBI2RAqBM/Z3UJ2LCiiUmg767tdYY5YDq1gn4eq1dg3EyT2Exnb1bakOZ6zLf/Nmuk4iOo6bhoa3y9OCmsOpB+wO6lkCxTQD9g7wUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kxc6eqfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kxc6eqfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF18C32782;
	Tue, 30 Jul 2024 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355676;
	bh=u/HTmwz88KqBtf8jerL2w4LY4Rpsr7KvLwTeoVqTE6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kxc6eqfix9zEIiZkoPmnh/WP3SD7SnxYCUFN22edx6OynyvG5fO4cE6Ah7Mo99TV4
	 VhpoASKAubUG7ZyeaAJeiGjZCM9mls8czBMf1KHhMNJy6XxbPQnXQNR3imBCXhTfuN
	 D1P8vESlDdRvJftFpblZRTdqwslG2jRTlMTFRwS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/568] arm64: dts: rockchip: Drop invalid mic-in-differential on rk3568-rock-3a
Date: Tue, 30 Jul 2024 17:43:07 +0200
Message-ID: <20240730151642.987764921@linuxfoundation.org>
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
index e05ab11981f55..17830e8c9a59b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -530,10 +530,6 @@ regulator-state-mem {
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



