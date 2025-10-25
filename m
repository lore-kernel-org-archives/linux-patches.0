Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403FE304BB8;
	Sat, 25 Oct 2025 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409706; cv=none; b=MMr6MqjlSERo4wiXjrA7J1+Wq4HtJVhWuQjWiRW5wQ42lEULbbDJrsStZ0720ItbZtJqzlZwtiGbsgEwBBdUzw3WSAFdpPUg2op0Sakc/WsvxTBxxAx+dSn2ztmvTUHJ4IqLscJA0KyS8o9zkFqQpWw6aHFr0JC56UgiNAAs7uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409706; c=relaxed/simple;
	bh=puSyWICh4xZTWpltYje/LxrpNqBU11Q4+JjET8EzRII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4RapX0D6r70cUwvIowLJo9ghIOidQIZ+d1/VU4fiVWL/VKlgYoQo6AJ9XekqLjoPZucgVxTRnJhUOh7QZnLdiGxpKhq4dHSrEhGojiL0CYv1RcsIOZnUf2v7tqvCPvelyq3bt+aYigNhcLJNaqHONLX6otiXT+COezi1RCCubA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ts2A83G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ts2A83G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F57C4CEFF;
	Sat, 25 Oct 2025 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409706;
	bh=puSyWICh4xZTWpltYje/LxrpNqBU11Q4+JjET8EzRII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ts2A83G3VEwlR4wChInP31M2rhV+QAnVEk0rSB1xhBiW+1WkhI1iYUSPX60BgbsDo
	 N2Rdowtl9Nd4UkQ9Apv3INXcyqIF/AqV0zcUppzHQ/EWnbDnmHhccvP4WYGvxKXvan
	 rf0tTOR80fFiNsd1jQTxUxx9ZnhK+2tgMxtNoYzDiw4bvYAFFEJOvPCJ4UF/hFIizD
	 gYyxHOPjnR8BaPI1hjoUc08i/Ijl/qPaJx2Kxi4zT68wMdq9mRBL+R64sfQpUEdPka
	 pxVT11DBpisjlKAIr/tWAQnF9+zk8aED+tYy9yC3sz8ojSemdEL36sJXwJZ8MSkOdC
	 Zc40rmjkuu+9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Riesch <michael.riesch@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	heiko@sntech.de,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.15] phy: rockchip: phy-rockchip-inno-csidphy: allow writes to grf register 0
Date: Sat, 25 Oct 2025 12:01:00 -0400
Message-ID: <20251025160905.3857885-429-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
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

From: Michael Riesch <michael.riesch@collabora.com>

[ Upstream commit 8c7c19466c854fa86b82d2148eaa9bf0e6531423 ]

The driver for the Rockchip MIPI CSI-2 DPHY uses GRF register offset
value 0 to sort out undefined registers. However, the RK3588 CSIDPHY GRF
this offset is perfectly fine (in fact, register 0 is the only one in
this register file).
Introduce a boolean variable to indicate valid registers and allow writes
to register 0.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Michael Riesch <michael.riesch@collabora.com>
Link: https://lore.kernel.org/r/20250616-rk3588-csi-dphy-v4-4-a4f340a7f0cf@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: The driver previously used `offset == 0` as a sentinel
  for “no GRF register”, which silently blocks legitimate writes when a
  hardware register actually lives at offset 0. On RK3588 the CSIDPHY
  GRF uses register 0 as its only register, so the driver would skip
  required GRF writes and fail to properly bring up lanes.

- Exact changes:
  - Adds an explicit validity flag to describe whether an entry is a
    real GRF register:
    - `struct dphy_reg { ... u8 valid; }` in `drivers/phy/rockchip/phy-
      rockchip-inno-csidphy.c:90-95`.
  - Marks all defined register entries as valid via the helper macro:
    - `#define PHY_REG(...){ ... .valid = 1, }` in
      `drivers/phy/rockchip/phy-rockchip-inno-csidphy.c:97-99`.
  - Switches the write guard from “offset non-zero” to “valid is true”:
    - `if (reg->valid) regmap_write(...)` in `drivers/phy/rockchip/phy-
      rockchip-inno-csidphy.c:156-165`.
  - RK3588 explicitly defines its GRF at offset 0:
    - `#define RK3588_CSIDPHY_GRF_CON0 0x0000` in
      `drivers/phy/rockchip/phy-rockchip-inno-csidphy.c:33`.
    - The RK3588 register table uses that offset (and now writes are
      allowed because `.valid = 1`):
      - `rk3588_grf_dphy_regs[]` in `drivers/phy/rockchip/phy-rockchip-
        inno-csidphy.c:122-126`.

- Why it matters: The power-on sequence depends on these GRF writes to
  configure “forcerxmode”, clock-lane enable, and data-lane enable:
  - Calls at `drivers/phy/rockchip/phy-rockchip-inno-csidphy.c:287-309`
    go through `write_grf_reg(...)`. With the old “offset != 0” check,
    RK3588 would never program these bits, breaking CSIDPHY
    initialization.

- Scope and risk:
  - Small, contained change to one driver and its internal
    helper/struct. No API/ABI change outside the driver.
  - Backward-compatible: for entries not defined in a table, the new
    `valid` defaults to 0 (C zero-initialization), so writes remain
    skipped just like before; existing real entries are created via
    `PHY_REG(...)` which now sets `.valid = 1`.
  - Other SoCs (rk1808/rk3326/rk3368/rk3568) have non-zero offsets;
    behavior is unchanged because `.valid = 1` keeps writes enabled as
    before.
  - The only behavior change is to correctly allow writes to offset 0
    when that register is valid, which is the intended fix for RK3588.

- Stable criteria:
  - Fixes a real, user-visible bug (CSI-2 DPHY on RK3588 fails to
    configure), not a feature.
  - Minimal and low risk; no architectural changes; isolated to a PHY
    driver.
  - Clear side effects are positive (enables intended GRF writes) with
    no broader impact.

Recommendation: Backport to stable trees that include this driver and
RK3588 CSIDPHY support (harmless elsewhere, but especially necessary
where RK3588 is present).

 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
index 2ab99e1d47ebe..75533d0710250 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-csidphy.c
@@ -87,10 +87,11 @@ struct dphy_reg {
 	u32 offset;
 	u32 mask;
 	u32 shift;
+	u8 valid;
 };
 
 #define PHY_REG(_offset, _width, _shift) \
-	{ .offset = _offset, .mask = BIT(_width) - 1, .shift = _shift, }
+	{ .offset = _offset, .mask = BIT(_width) - 1, .shift = _shift, .valid = 1, }
 
 static const struct dphy_reg rk1808_grf_dphy_regs[] = {
 	[GRF_DPHY_CSIPHY_FORCERXMODE] = PHY_REG(RK1808_GRF_PD_VI_CON_OFFSET, 4, 0),
@@ -145,7 +146,7 @@ static inline void write_grf_reg(struct rockchip_inno_csidphy *priv,
 	const struct dphy_drv_data *drv_data = priv->drv_data;
 	const struct dphy_reg *reg = &drv_data->grf_regs[index];
 
-	if (reg->offset)
+	if (reg->valid)
 		regmap_write(priv->grf, reg->offset,
 			     HIWORD_UPDATE(value, reg->mask, reg->shift));
 }
-- 
2.51.0

