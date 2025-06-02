Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE617BBF;
	Mon,  2 Jun 2025 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876082; cv=none; b=um0tg+90dgZx22Lw9Q+P+8QK3YV5bRE7muQYX0RtSns1Dyoed+ebqd9/J7yNeTIBhPovnRO/werDefeGAtycb2ntW2nYOvU1zhNHSHV7QXPNYwQMO9zChOYEWUGE9qdWDNoCMsJ6LB9UeQG/vV2lYsp4/Dd2mTlYEgXYoTm410A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876082; c=relaxed/simple;
	bh=cU6IiZyKiTDepseXrZGdgGjKmaAdOBWUwWjpBvX5Odw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUN1gUn5Iznuk1ELSuhpd0YarectSEKvKzvz0z7OrMAIsA+c5N8gKLTmXwDGqm4bqicUlC2+cEtfaDQq7XNInQmVrN1F7iBsdXPvWr7JWvs2XeCL4VvGtODi1HWQ0bZv3mO/VtrXPZP8jgC7WSIA6kD36Kx3gqDmThUGKp5eghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMeSbft7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMeSbft7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75ED1C4CEEB;
	Mon,  2 Jun 2025 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876082;
	bh=cU6IiZyKiTDepseXrZGdgGjKmaAdOBWUwWjpBvX5Odw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMeSbft7lHSz8Zt9v6ImMmLyzPQ4dMXGIoduGzI6unsougiEvvxTH30mrRwvEq9QS
	 1mUjO8qNZl20mO+xZRPWYYSl5jxblzWu61IeIDxs9I+m9wS6BNKHtT4OYx4fcG5ohN
	 BhsHM9wQyv/1YavMe9JkkpzSjPehdY+XH7J3idoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/207] ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114
Date: Mon,  2 Jun 2025 15:47:18 +0200
Message-ID: <20250602134301.327793970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 2b3db788f2f614b875b257cdb079adadedc060f3 ]

PLLD is usually used as parent clock for internal video devices, like
DSI for example, while PLLD2 is used as parent for HDMI.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://lore.kernel.org/r/20250226105615.61087-3-clamor95@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra114.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index fb99b3e971c3b..c00097794dab1 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -126,7 +126,7 @@ dsi@54400000 {
 			reg = <0x54400000 0x00040000>;
 			clocks = <&tegra_car TEGRA114_CLK_DSIB>,
 				 <&tegra_car TEGRA114_CLK_DSIBLP>,
-				 <&tegra_car TEGRA114_CLK_PLL_D2_OUT0>;
+				 <&tegra_car TEGRA114_CLK_PLL_D_OUT0>;
 			clock-names = "dsi", "lp", "parent";
 			resets = <&tegra_car 82>;
 			reset-names = "dsi";
-- 
2.39.5



