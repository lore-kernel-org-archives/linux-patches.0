Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B1E2F069E;
	Thu,  9 Oct 2025 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025529; cv=none; b=fcbSXXB4rcAQfnTvDdp6/BoDzwh+a6wfhAl0wWLW4mvt9D+sM0NNbb8EG27DycgaSS1CvDBfZkLlZhvbb1bhuKVAYc7zA9iabR8BmVW3vpMJSmN41/98prsMF1J9aSLK8R2MMvjlUSJkzRWyedhIlehJuag1oRvkjCxPGAFj8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025529; c=relaxed/simple;
	bh=ZZIxBFUcwOaK5MRt4WZlCsfrNjmgd3wlboFkVO2mY9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnmCn9LbLA3TqQea545pJ/RT6HoF5avxBfWgFe29q507GasJDc7sQNbCG1GHpuGRRWCpbuuPitZ8QNWoPx9xhix3E6d8dtq3QdHa49pOj6o3lnOEzZuyCo2lsaLxle1xo6feRJ/+/0nAln3AfFb54O4Nm4kgUTkOsVhlEyBv6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsaPI34R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsaPI34R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52E7C4CEE7;
	Thu,  9 Oct 2025 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025529;
	bh=ZZIxBFUcwOaK5MRt4WZlCsfrNjmgd3wlboFkVO2mY9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsaPI34RbiTERwpZkaONtoptYt1RA0gXMurCUAz7nkoKG7av1EQxvOOX0TlOnpbdh
	 x86k/Y1EKtg9uEMSlgaa+DOUqP4in1AXufjGC8J5g+B4UFD6AoaLaLw679GsliPj3Q
	 nXY2lx80UiKKkruVgLgWjA/r7nsfspoTJpGALMYIZrGUqa315b/LJganL196nBBdZ9
	 bM4q/AYcd1u12SpT8ORrONoAupn5QpAxSrIMR7D329+L7nkDWWIZAAWkEr/3heyOwJ
	 HmAECfOfYhpKl9G3o/rPmtt1KGnXTcHqEB+CxcwTof9mgYUX7tvWbcBbHgWcMPN6yE
	 fE1Jj6X/7VXPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	kkartik@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups
Date: Thu,  9 Oct 2025 11:54:57 -0400
Message-ID: <20251009155752.773732-31-sashal@kernel.org>
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

[ Upstream commit b9c01adedf38c69abb725a60a05305ef70dbce03 ]

Add missing Tegra114 nvmem cells and fuse lookups which were added for
Tegra124+ but omitted for Tegra114.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES - Restores the Tegra114 nvmem coverage that regressed when the
driver switched to SoC-specific cell tables.
- `drivers/soc/tegra/fuse/fuse-tegra30.c:120-236` now defines the
  Tegra114 fuse cells and lookup table, re-exposing the TSENSOR and XUSB
  calibration words that lived in the old global list before commit
  bea06d776d8b2 (“Use SoC specific nvmem cells”). Without these entries
  the Tegra114 nvmem provider registers with zero cells, so every
  `nvmem_cell_get()` for legacy device-trees (the whole reason for
  `nvmem_add_cell_lookups()` in 9f94fadd75d34) falls back to `-ENOENT`,
  breaking thermal/xusb calibration access that previously worked.
- `drivers/soc/tegra/fuse/fuse-tegra30.c:244-252` wires those tables
  into `tegra114_fuse_soc`, so early boot (`tegra_init_fuse()`) and the
  runtime probe both repopulate the lookups; the offsets match what
  existing Tegra114 code already reads directly (e.g. speedo data at
  0x12c/0x134), so the fix is consistent with the silicon layout.
- Change is data-only for `CONFIG_ARCH_TEGRA_114_SOC`, touching no other
  SoCs, so the regression fix is low risk and backports cleanly to any
  stable branch that already has bea06d776d8b2.

This is a straight bug fix with clear user impact (loss of nvmem cells
on Tegra114) and should be backported.

 drivers/soc/tegra/fuse/fuse-tegra30.c | 122 ++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra30.c b/drivers/soc/tegra/fuse/fuse-tegra30.c
index e24ab5f7d2bf1..524fa1b0cd3d6 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -117,6 +117,124 @@ const struct tegra_fuse_soc tegra30_fuse_soc = {
 #endif
 
 #ifdef CONFIG_ARCH_TEGRA_114_SOC
+static const struct nvmem_cell_info tegra114_fuse_cells[] = {
+	{
+		.name = "tsensor-cpu1",
+		.offset = 0x084,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-cpu2",
+		.offset = 0x088,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-common",
+		.offset = 0x08c,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-cpu0",
+		.offset = 0x098,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "xusb-pad-calibration",
+		.offset = 0x0f0,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-cpu3",
+		.offset = 0x12c,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-gpu",
+		.offset = 0x154,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-mem0",
+		.offset = 0x158,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-mem1",
+		.offset = 0x15c,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	}, {
+		.name = "tsensor-pllx",
+		.offset = 0x160,
+		.bytes = 4,
+		.bit_offset = 0,
+		.nbits = 32,
+	},
+};
+
+static const struct nvmem_cell_lookup tegra114_fuse_lookups[] = {
+	{
+		.nvmem_name = "fuse",
+		.cell_name = "xusb-pad-calibration",
+		.dev_id = "7009f000.padctl",
+		.con_id = "calibration",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-common",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "common",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu0",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu0",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu1",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu1",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu2",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu2",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-cpu3",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "cpu3",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-mem0",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "mem0",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-mem1",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "mem1",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-gpu",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "gpu",
+	}, {
+		.nvmem_name = "fuse",
+		.cell_name = "tsensor-pllx",
+		.dev_id = "700e2000.thermal-sensor",
+		.con_id = "pllx",
+	},
+};
+
 static const struct tegra_fuse_info tegra114_fuse_info = {
 	.read = tegra30_fuse_read,
 	.size = 0x2a0,
@@ -127,6 +245,10 @@ const struct tegra_fuse_soc tegra114_fuse_soc = {
 	.init = tegra30_fuse_init,
 	.speedo_init = tegra114_init_speedo_data,
 	.info = &tegra114_fuse_info,
+	.lookups = tegra114_fuse_lookups,
+	.num_lookups = ARRAY_SIZE(tegra114_fuse_lookups),
+	.cells = tegra114_fuse_cells,
+	.num_cells = ARRAY_SIZE(tegra114_fuse_cells),
 	.soc_attr_group = &tegra_soc_attr_group,
 	.clk_suspend_on = false,
 };
-- 
2.51.0

