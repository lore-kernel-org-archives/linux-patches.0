Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B2B20EA35;
	Tue, 12 Nov 2024 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407993; cv=none; b=DaTG0cIIaEILiKonrZX3C7cF6wivQ1uOzfWaJt9yuuXqUKnXrFdTcQ1t/Ifg/FCrhSEe2hodXjYQWbZTHc+ro7fg2T9z1Y6Tc7EhIobyR6zw7OhsdkZ/wAe9kWn6XLZJQYl+l0g8MFcNjz0X4pfGMI1u6R4Sg/JqOyVw5Q5H7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407993; c=relaxed/simple;
	bh=n22ufafL3chpYc04NuqJb5WZZcRW+B5Y4JMral/SB98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqIQzdaqhr3sGLYQgHcSmfhw5sd1jZC12gjfmZiubsNvM4ikR0A4LQtszyz5SPuD+6OIgqg1IiyZVLJeA4+z3mmEhssFX6I5p1wxoc3747JE94bMsbmE1FIgVE8DuWC5j/38A959X/wNpGhbjidzhcj3XoVm3U8FkjVIrUes49U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FS6qYHsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FS6qYHsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C206C4CECD;
	Tue, 12 Nov 2024 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407992;
	bh=n22ufafL3chpYc04NuqJb5WZZcRW+B5Y4JMral/SB98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FS6qYHsLvnMW6U4ynIb1/WFuEVDKnoFFjhZw/NZoxL6mINesO61xtFnbqSWjMUJRB
	 0NjAVHBLokquXGYb0BxwHFXSB8YNPOzGaRvbY78yCIJBavp0Uq1Yi7rodsuyYTabrh
	 jWefTR7xXCegBFtfqjvQjAH8JLnMEXfpI8rTZ4jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 004/184] arm64: dts: rockchip: Start cooling maps numbering from zero on ROCK 5B
Date: Tue, 12 Nov 2024 11:19:22 +0100
Message-ID: <20241112101901.038982658@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 6be82067254cba14f7b9ca00613bdb7caac9501f ]

The package cooling maps for the Radxa ROCK 5B were mistakenly named map1
and map2.  Their numbering should start from zero instead, because there are
no package cooling maps defined in the parent RK3588 SoC dtsi file, so let's
rename these cooling maps to map0 and map1.

Fixes: 4a152231b050 ("arm64: dts: rockchip: enable automatic fan control on Rock 5B")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/335ecd5841ab55f333e17bb391d0e1264fac257b.1726954592.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
index 966bbc582d89b..6bd06e46a101d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
@@ -304,12 +304,12 @@
 	};
 
 	cooling-maps {
-		map1 {
+		map0 {
 			trip = <&package_fan0>;
 			cooling-device = <&fan THERMAL_NO_LIMIT 1>;
 		};
 
-		map2 {
+		map1 {
 			trip = <&package_fan1>;
 			cooling-device = <&fan 2 THERMAL_NO_LIMIT>;
 		};
-- 
2.43.0



