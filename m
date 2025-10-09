Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7186B23183A;
	Thu,  9 Oct 2025 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025614; cv=none; b=fXlke1x91wvQV9L35Bd3jWS2ew8y7UvPlM4rHOIkNk36fI7qh5jxubOxHrU9ADtrNHQGMlZv1T9THg5jS+kZ3qYC/KQljqhHv6GSVvNAwXZldqe3OfwcOKOX3c8yUiE0qK2OCHumUyuPFahrW+2d7VVCDogylsxMSdKXyIH1waI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025614; c=relaxed/simple;
	bh=HFLLAvtd9FSIID8d9a2EEj/FAoRntAfuRU132G5VBIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEXbhmGNAVB8qSCIHFuKZkNTEFnUA+WKB22kWmWraCDFOdVUkdTBU3gvyUouasJ/QX891T5wUtuzeskEzSigUAUrvr7mLK/Sz0o3Z2PPwP5Kbu3/c8mwL8tMZ1uZ5pkMbtDIOVUAHktaXvR//meMPfeiRX2wuGcgBFw4SpIahek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBmBD1Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBmBD1Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2CC4CEE7;
	Thu,  9 Oct 2025 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025614;
	bh=HFLLAvtd9FSIID8d9a2EEj/FAoRntAfuRU132G5VBIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBmBD1SiQkZBlE6pAt4RxQ6U+5ZJL88UhH+T7MZrixoEp0fVI0fM4br7WerkpVhjW
	 lSoNAXl+sRf5lXCAXwOHGlGJgMxHE5C0TYU8JHrSksxm3F4DGKD2HDOsdQBGkcdDpr
	 PjBlDctlpwdUz8PyodNZ40nEVdQcaAH+VtU1Oih/dXSOJcZjJxQADIbwicTYc94raX
	 WmpfFChO5jBPrHv22ahRHDdYBcSXx31faaIhH1C95kYC8XX2xN55OfVP5CA/Q92Nxv
	 31UgnpH6BNBKGYbKfiqp0j20a992KjJfYSvfOVHEgGrUd8b/Iu9bsgdXrAnC1HwAx6
	 OROj1jY4NF+GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Quanyang Wang <quanyang.wang@windriver.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	tomi.valkeinen@ideasonboard.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.12] arm64: zynqmp: Disable coresight by default
Date: Thu,  9 Oct 2025 11:55:41 -0400
Message-ID: <20251009155752.773732-75-sashal@kernel.org>
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

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 0e3f9140ad04dca9a6a93dd6a6decdc53fd665ca ]

When secure-boot mode of bootloader is enabled, the registers of
coresight are not permitted to access that's why disable it by default.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/7e308b8efe977c4912079b4d1b1ab3d24908559e.1756799774.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – default‑disabling the ZynqMP CPU debug Coresight nodes is a
necessary regression fix for stable kernels that picked up the earlier
enablement.

- **Regression introduced**: Commit `fbce12d2899c4` (“arm64: zynqmp: Add
  coresight cpu debug support”) first added the `cpu[0-3]_debug` nodes
  without a `status` property, so they now probe by default; this change
  landed in v6.11 (`arch/arm64/boot/dts/xilinx/zynqmp.dtsi:548`, `:555`,
  `:562`, `:569`).
- **Failure mode**: On secure‑boot deployments the firmware prevents
  access to those debug registers, causing the `coresight-cpu-debug`
  driver to hit denied reads/writes during probe (see the unconditional
  register accesses in `drivers/hwtracing/coresight/coresight-cpu-
  debug.c:135` and :327). Because the driver auto-loads (module alias on
  the AMBA bus) with `CONFIG_CORESIGHT_CPU_DEBUG=m`
  (`arch/arm64/configs/defconfig`), this results in synchronous
  aborts/panics rather than a recoverable error.
- **What the patch does**: Adding `status = "disabled";` to each node
  (`arch/arm64/boot/dts/xilinx/zynqmp.dtsi:548`, `:555`, `:562`, `:569`)
  restores the pre‑v6.11 behavior: the coresight CPU debug blocks stay
  off unless a board DTS explicitly re-enables them. This mirrors how
  other SoCs handle similar hardware constraints (e.g.
  `arch/arm64/boot/dts/qcom/msm8916.dtsi` already defaults these nodes
  to `"disabled"`), and keeps the existing clock wiring in `zynqmp-clk-
  ccf.dtsi` harmless for boards that opt in.
- **Risk assessment**: The change is minimal, device-tree only, and
  reverts functionality that was never present before v6.11. Systems
  depending on the new default-on behavior can still override the status
  in board-specific DTS, while the patch prevents fatal boot failures on
  secure-booted systems. No additional dependencies are required for
  stable backports.

Given the severity of the regression and the contained nature of the
fix, this commit is a solid candidate for backporting to all stable
series that include `fbce12d2899c4`.

 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index e11d282462bd3..23d867c03263d 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -550,6 +550,7 @@ cpu0_debug: debug@fec10000 {
 			reg = <0x0 0xfec10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu0>;
+			status = "disabled";
 		};
 
 		cpu1_debug: debug@fed10000 {
@@ -557,6 +558,7 @@ cpu1_debug: debug@fed10000 {
 			reg = <0x0 0xfed10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu1>;
+			status = "disabled";
 		};
 
 		cpu2_debug: debug@fee10000 {
@@ -564,6 +566,7 @@ cpu2_debug: debug@fee10000 {
 			reg = <0x0 0xfee10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu2>;
+			status = "disabled";
 		};
 
 		cpu3_debug: debug@fef10000 {
@@ -571,6 +574,7 @@ cpu3_debug: debug@fef10000 {
 			reg = <0x0 0xfef10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu3>;
+			status = "disabled";
 		};
 
 		/* GDMA */
-- 
2.51.0

