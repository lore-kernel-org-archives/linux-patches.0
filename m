Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5851B21255B;
	Sun, 26 Oct 2025 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490287; cv=none; b=ilZNFkJOrM5ztWPcRYGJmn/COu4IdFOSOhlEy8mfFMLNyPbcb19oIGaFuU625lvYiCIatZ9yqFZHKF/a0ERH5wXxIhLBVe5RU1/IAIJVSQyYhQ9YewRK8T2Umx6Wm3dzZf7Cm956y41GtIcTe8tOV1kFe0+ac5ZsQu2s1wkbx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490287; c=relaxed/simple;
	bh=8nsVpQVtNVpmV3fm9Jme7NuegNhWqMUpue44vydCMqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCyLktGfpDeRBSmbJHklgZo7pc/nRroE90aKgE4HUmlcmyHOllw+x2nDsEOGA1majw1rBOaR3YvyaH4rl1mzbQgKEAdaJ7NmXlckNNfEGVvxeyO6rL/UQHtT43fZ5Rt3VOXVgLN1I+rdTUWOMEmzLTcBt3CY6CgewpFv/OATpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2OW88Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2OW88Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06643C4CEF1;
	Sun, 26 Oct 2025 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490287;
	bh=8nsVpQVtNVpmV3fm9Jme7NuegNhWqMUpue44vydCMqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2OW88DcnU+tMFM74K3zFh6b2on5gymtS5srKNUfc1l0nacUa5zOrlqfAASi5S4qG
	 BjHcuqqbB5UaY6ICvq8ULZ/caS8IPBz01jqfYUYwQlBco+O9lfnT9tPcfJF1uFZ0ao
	 xMarniUHXdTOFnkFKkmfiCWa2jZIvOqT0CAZXl/8x1qroCrexMhZG9CAS2Q15shgmQ
	 0LCQL/vIhadPZBaEYbJyqOGMfyevTOKvM/A73Ci2QBAHz2CSubONXGs63BTzAmV2+l
	 hSdyzappLcXEc7eNm33dWQVZThSEHiS1I+ZrX4UVei5UiStuD0hMVIMlzqo3kdNIH6
	 Fglyi4sE8i+kA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	michal.simek@amd.com,
	anatoliy.klymenko@amd.com,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	bmasney@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.12] clk: clocking-wizard: Fix output clock register offset for Versal platforms
Date: Sun, 26 Oct 2025 10:49:18 -0400
Message-ID: <20251026144958.26750-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit 7c2e86f7b5af93d0e78c16e4359318fe7797671d ]

The output clock register offset used in clk_wzrd_register_output_clocks
was incorrectly referencing 0x3C instead of 0x38, which caused
misconfiguration of output dividers on Versal platforms.

Correcting the off-by-one error ensures proper configuration of output
clocks.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the change in `drivers/clk/xilinx/clk-xlnx-clock-wizard.c:1120`
moves the Versal per-output divider base from
`WZRD_CLK_CFG_REG(is_versal, 3)` to `... 2`, fixing the off-by-one that
pointed each divider at the wrong MMIO pair.

- With the old offset, `clk_wzrd_ver_register_divider()` handed
  `clk_wzrd_ver_dynamic_reconfig()` a base that skips the first 32-bit
  register. You can see in `clk_wzrd_ver_dynamic_reconfig()`
  (`drivers/clk/xilinx/clk-xlnx-clock-wizard.c:235-262`) that we expect
  `div_addr` to hold the low/high-time bits (`WZRD_CLKFBOUT_PREDIV2`,
  `WZRD_EDGE_SHIFT`, etc.) and we write the high-time value to `div_addr
  + 4`. Starting from `... + 3` caused us to read/write the wrong
  register pair—programming the high-time word first and then trampling
  the next output’s low-time register—so the dividers for every Versal
  output were misconfigured.
- The corrected offset now matches the register map already hard-coded
  elsewhere (e.g., the `DIV_ALL` path in
  `clk_wzrd_dynamic_ver_all_nolock()` uses `WZRD_CLK_CFG_REG(1,
  WZRD_CLKOUT0_1)` where `WZRD_CLKOUT0_1` is 2). That consistency makes
  the fix obviously right and keeps the non-Versal path untouched
  because the change sits under `if (is_versal)`.
- The regression was introduced with Versal support (`Fixes:
  3a96393a46e78`, first in v6.10), so every stable branch carrying that
  commit currently ships broken output clocks; the patch is a tiny,
  self-contained offset adjustment and does not depend on newer
  infrastructure, making it straightforward to backport.

Given the severity (Versal outputs can’t be programmed correctly) and
the minimal, well-scoped fix, this is a strong stable-candidate.
Suggested follow-up: once backported, validate on a Versal board to
confirm the dividers now lock to requested rates.

 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index 0295a13a811cf..f209a02e82725 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -1108,7 +1108,7 @@ static int clk_wzrd_register_output_clocks(struct device *dev, int nr_outputs)
 						(dev,
 						 clkout_name, clk_name, 0,
 						 clk_wzrd->base,
-						 (WZRD_CLK_CFG_REG(is_versal, 3) + i * 8),
+						 (WZRD_CLK_CFG_REG(is_versal, 2) + i * 8),
 						 WZRD_CLKOUT_DIVIDE_SHIFT,
 						 WZRD_CLKOUT_DIVIDE_WIDTH,
 						 CLK_DIVIDER_ONE_BASED |
-- 
2.51.0

