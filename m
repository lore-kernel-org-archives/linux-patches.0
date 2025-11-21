Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791F63F9D2;
	Fri, 21 Nov 2025 13:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731841; cv=none; b=WGRfBDj30aVJfn+dcLYux759Q+dBntnCgMwS/smi0oTmGryXHAior9gzS/AAKkrLLbbyA08m0Xnu5qDt01d/2ZLiDtoHdYa1Pl1D19qHUGs9XOa9KvTkCs55frfXlERYnj5PmEwDxBGOZc57g7n+ZXUZLRgboxZqJdekeYemNV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731841; c=relaxed/simple;
	bh=v5JmMLjMXfTpDZxDlvoBJkLOgqb6xvMoj/1OyXjm3zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLbcbsU3oI6PPinGzogRmPm3R5Ih+HWQrja+n7oOf4lo3WFscB6X0h7sUV15VuWnN9JHKrO+shw6lh7aLKeJRSZzK2l5BHZ+l+Aox1cj/VsJOJepSWjPawIde7FgV3YIOxRvKZxri1Hl5Q6umv1L/DpnQigiKc9SHTM3QwquCSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRrxww/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRrxww/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C89C116C6;
	Fri, 21 Nov 2025 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731841;
	bh=v5JmMLjMXfTpDZxDlvoBJkLOgqb6xvMoj/1OyXjm3zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRrxww/2b3N9ITahMVQYXzleNDFx8lSF44Waqqnc2HDlnGswq2464sOfgy9xvsBXm
	 8lepaNOkrhkOWdEpxu6YDSJEM2jYadcNi8l11fLYxj8TI2KzWsjAZPn5MrIcKtkTdF
	 3eCx2D8imlU4AjolDgs6DxuFJLBy2GxR911JzLD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/185] arm64: dts: rockchip: Make RK3588 GPU OPP table naming less generic
Date: Fri, 21 Nov 2025 14:12:07 +0100
Message-ID: <20251121130147.482150840@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3045cb3bd68c6..baa8b5b6bfe55 100644
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



