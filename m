Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D362F5468;
	Thu,  9 Oct 2025 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025651; cv=none; b=dnALH4IL0EtQmtNP6j6v3LZfW9cG9WTxBEvC5W13CMOM6aEP9Zthw7MgAeHowDMVfBc8O7XQ8dPlkUFI7K+5MnIGO5YRmC7yRQSYcY7FaKI5dLzMMNpQib+VB1+Z+0c7D+ShK73WLADqIhNCKsQOFwsZAXGCa7ejUh/G89mwVEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025651; c=relaxed/simple;
	bh=egzDP3QBGzqV9GDz82HkQPHKLRF4naIRKYNiIzbx2nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jMxR3OQYLoxi+yXsU69Tx5NjNFgOexLVxf20vvpgnNNFlZ9cE5Zt1LQCVA6VUgUQTenYNQqtrNnDX6B7stagLWSgF+XYYfWOXtaDVFZoyUGiobHBPD0/6Yf+G1UGirxEBptD+N6n1FkTlNlRzbMQEVCb7vi27uKwFwuA4kQcSMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnjbgKqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnjbgKqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80908C4CEE7;
	Thu,  9 Oct 2025 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025650;
	bh=egzDP3QBGzqV9GDz82HkQPHKLRF4naIRKYNiIzbx2nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnjbgKqmzNNNZLDMhqb1oMRdscSRP48jA6juHScRm/2B/OHKRvCbwg+y/SGFOvGsn
	 ND5KzI45INZ+XoKYfpHcb7rMIADFM6Dezv8daXPumT9KdkT2L2IHQntHaciSyitFdn
	 YLpiaItAvUCWPSHZ+vn5BvmA0TeB76EgyT30KJfE4arJ2aRojsNgfiMRyrD0V69lLC
	 hmw1xew0tEBwBH3vhSxRQUQ0i0HqMumjeFK0tfrBnSjVGXK4Hg+zt03HxPsrG8US6a
	 n3I7/A67v9YijeMXewgbQz/SKuDR3JXAPezA1AnP0jDCWWGbwfXVN4JriBC7s/g+xs
	 VEVialaErl+6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] ARM: tegra: transformer-20: fix audio-codec interrupt
Date: Thu,  9 Oct 2025 11:56:01 -0400
Message-ID: <20251009155752.773732-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 3f973d78d176768fa7456def97f0b9824235024f ]

Correct audio-codec interrupt should be PX3 while PX1 is used for external
microphone detection.

Tested-by: Winona Schroeer-Smith <wolfizen@wolfizen.net> # ASUS SL101
Tested-by: Antoni Aloy Torrens <aaloytorrens@gmail.com> # ASUS TF101
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES - routing the WM8903 IRQ to PX3 fixes a long-standing wiring bug
without side effects.

- `arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts:518` currently binds
  the codec IRQ to `TEGRA_GPIO(X, 1)`, yet `nvidia,mic-det-gpios`
  already consumes that pin (`arch/arm/boot/dts/nvidia/tegra20-asus-
  tf101.dts:1210`), so the SoC sees mic-detect instead of codec
  interrupts and jack events fail.
- The Tegra audio machine driver requires a separate GPIO for mic detect
  (`sound/soc/tegra/tegra_asoc_machine.c:459`), while the WM8903 driver
  depends on its IRQ line for microphone/short detection
  (`sound/soc/codecs/wm8903.c:1604-1710`); misrouting the IRQ leaves
  these user-facing features broken.
- `git blame` traces the bad mapping back to the TF101 DTS introduction
  in commit `b405066bd3e04`, so every stable release that includes this
  board inherits the bug.
- Other Tegra20 WM8903 boards already wire the codec IRQ to PX3 (e.g.
  `arch/arm/boot/dts/nvidia/tegra20-acer-a500-picasso.dts:445`,
  `arch/arm/boot/dts/nvidia/tegra20-seaboard.dts:344`), matching the
  hardware layout described by the TF101 maintainers and the commit’s
  Tested-by reports.
- The fix is a single DTS line change with verified testers, no
  dependency on new infrastructure, and aligns with existing pinmux
  defaults, making it safe to backport while restoring microphone/jack
  functionality for users.

 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
index 39008816fe5ee..efd8838f9644f 100644
--- a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
@@ -518,7 +518,7 @@ wm8903: audio-codec@1a {
 			reg = <0x1a>;
 
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 1) IRQ_TYPE_EDGE_BOTH>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_EDGE_BOTH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
2.51.0

