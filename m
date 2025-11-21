Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB28275B18;
	Fri, 21 Nov 2025 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731236; cv=none; b=rOMBs+yxHzRZHPgO21ArxlLl05sXm7SK7l7vfBzPXFwJDIfQHQt/znqlSIQVwffxVwJ+vs+UuqEXHFWRN/pkGtfi4UJGT0y8xFjV/1F0zb+ts2V9kyruATQzn982QNIz1PEwjOXpEGthqSN2TMXTCFSCvyexlnj64oYgN18Tljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731236; c=relaxed/simple;
	bh=e/RIjUqqWiZAr+1WfhQfOmp8fjDOEv/tG7BkSHCcx0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMIhaVY84g8LHLPp7OON27L37i63ijrCo5hiUtBi0l/3jM/CCHnD6bSr9e2DXXCFHaFbUVX9TtBUV5bN/F9D6zxt5n3X1+G5drD/LpObckDRLRS2S9rmxdKeJPzfI0DknS5jSSYRb0e06jSPFjPy++Ae0mXfaqIJ0LlXyyjcq1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjEw0nzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjEw0nzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB60C4CEF1;
	Fri, 21 Nov 2025 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731235;
	bh=e/RIjUqqWiZAr+1WfhQfOmp8fjDOEv/tG7BkSHCcx0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjEw0nzQv7Ry4m+bBUjrsf+br4z9dlxRMSlSk2ry18shOiqnhjCWRJ/UicgvByy9H
	 X1hPU0jRTtj0FGrD2QErUeXCMi4HzDLCVKuiRt21xtWZNuEE/4OI2VHpKveKVrkv6x
	 4lX2dAztBKug+Bwr9luCPyTVUg9e4sNwfaDPpYEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 137/247] arm64: dts: rockchip: Make RK3588 GPU OPP table naming less generic
Date: Fri, 21 Nov 2025 14:11:24 +0100
Message-ID: <20251121130159.645149229@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit b3fd04e23f6e4496f5a2279466a33fbdc83500f0 ]

Unify the naming of the existing GPU OPP table nodes found in the RK3588
and RK3588J SoC dtsi files with the other SoC's GPU OPP nodes, following
the more "modern" node naming scheme.

Fixes: a7b2070505a2 ("arm64: dts: rockchip: Split GPU OPPs of RK3588 and RK3588j")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
[opp-table also is way too generic on systems with like 4-5 opp-tables]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi | 2 +-
 arch/arm64/boot/dts/rockchip/rk3588j.dtsi    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi
index 0f1a776973516..b5d630d2c879f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi
@@ -115,7 +115,7 @@
 		};
 	};
 
-	gpu_opp_table: opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-300000000 {
diff --git a/arch/arm64/boot/dts/rockchip/rk3588j.dtsi b/arch/arm64/boot/dts/rockchip/rk3588j.dtsi
index 9884a5df47dfe..e1e0e3fc0ca70 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588j.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588j.dtsi
@@ -66,7 +66,7 @@
 		};
 	};
 
-	gpu_opp_table: opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-300000000 {
-- 
2.51.0



