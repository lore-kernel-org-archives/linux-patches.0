Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D63304BAB;
	Sat, 25 Oct 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408954; cv=none; b=qeNRqD7J9uDi9o00relNQ4nAD0DFR1f2XAUDbcc6FdPHIB1QlxDhaGnGhD6LmdbYceihcBh2WFp2FP+dEPsLnJbzZQCW/rVI+bqmGwQb0QyNlOl9P6xiNlpOitMFpXrkUp96tWUI9huLus+DG+fjUFhWotUWji/kW0lOl1CIc2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408954; c=relaxed/simple;
	bh=KXhsnXvw3Sx+Qz3VLmdET5o+E32VLl8korQqFFqzJ+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DieSWvu+2o7Og6jCl2BYb6KAxYHJUDJIsDReC4oA3DT2lCMYX23lQm0ggEFzQ773yN6oS2AXnBTvM+cULLwdr90mY1/2rr1I4cGifXjLTgtPAa48GfYl8pps3abt3gDE4kraAvzG0cte90ve/pnZSlu91pYcOS4Bjb3yXnZtxTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIwvFc4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIwvFc4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCB9C4CEFF;
	Sat, 25 Oct 2025 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408953;
	bh=KXhsnXvw3Sx+Qz3VLmdET5o+E32VLl8korQqFFqzJ+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIwvFc4kxRlXMdkwXwTAXIIiiKyuFEAiIOglkXwmBezDvIT8EKNPjAVvMQUDM0Xei
	 cq1Xaq52szgXgKyJkBXaIDPhPHCq2EdlIRxCCS2/1i88WKw268+gLrld2KZqL6oUYT
	 /OHivVhuMIt4e0Iq0q8m9ow7j2rPFojsmN1Pxt99BrJprfok46OnU/NqpOxtlHRy/O
	 VWL6XgGDu3pvXe1L2J6UcJg3pcTf4kj608PktDbdG8pWa07NOhVk0mXPP04Eeb9/8g
	 2FslRd+5jpW7Rhj4vplYeNvVcZxrFgJgi+nuwt4r83PPThups0uJgMG6CG6LHXojkP
	 qtI9PCrGDo2bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	lumag@kernel.org,
	quic_abhinavk@quicinc.com,
	bmasney@redhat.com,
	konrad.dybcio@oss.qualcomm.com,
	quic_amakhija@quicinc.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.15] drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL
Date: Sat, 25 Oct 2025 11:56:19 -0400
Message-ID: <20251025160905.3857885-148-sashal@kernel.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b63f008f395ca5f6bc89123db97440bdc19981c4 ]

According to Hardware Programming Guide for DSI PHY, the retime buffer
resync should be done after PLL clock users (byte_clk and intf_byte_clk)
are enabled.  Downstream also does it as part of configuring the PLL.

Driver was only turning off the resync FIFO buffer, but never bringing it
on again.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/657823/
Link: https://lore.kernel.org/r/20250610-b4-sm8750-display-v6-6-ee633e3ddbff@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The 7nm DSI PHY driver turns off the retime/resync buffer early in
    bring-up but never turns it back on. See the existing “turn off
    resync FIFO” write in
    `drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:1105` where it writes
    `0x00` to `REG_DSI_7nm_PHY_CMN_RBUF_CTRL`. Without re-enabling, the
    data path can be misaligned after PLL enable, which can cause link
    bring-up glitches or unstable output. The commit aligns with the
    Hardware Programming Guide: resync must be toggled after enabling
    the PLL clock users.

- What the change does
  - Adds enabling of the resync buffer immediately after enabling the
    global clock in the VCO prepare path:
    - `drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:534` writes `0x1` to
      `REG_DSI_7nm_PHY_CMN_RBUF_CTRL` for the master PHY.
    - `drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:536` does the same for
      the bonded slave PHY.
  - This pairs correctly with:
    - The earlier “off” write in init
      (`drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:1105`) and
    - The disable path write to `0` in `dsi_pll_disable_sub()`
      (`drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:544`).
  - The enable occurs after global clock enable in
    `dsi_pll_7nm_vco_prepare()` where `dsi_pll_enable_global_clk()` is
    called (visible in the same function), matching the prescribed
    sequence “after PLL clock users are enabled.”

- Evidence of correctness and low risk
  - The 10nm PHY already follows this exact pattern: enable RBUF after
    enabling global clock, disable it on unprepare. See:
    - Enable: `drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c:373` and
      `:375`
    - Disable: `drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c:383`
    - This parity strongly suggests the 7nm omission was a bug rather
      than an intentional difference.
  - The change is minimal, localized to the 7nm PHY VCO prepare path. No
    API or architectural changes; only two writes added and perfectly
    mirrored by existing disable writes.
  - The sequence is safe: it enables the resync only after clocks are
    enabled, matching the hardware programming guide and downstream
    practice; it also handles bonded PHY (slave) consistently.

- Stable backport criteria
  - Fixes a real, user-visible bug (display instability or bring-up
    issues on affected Qualcomm 7nm DSI PHYs).
  - Small and contained change with minimal regression risk.
  - No new features or architectural churn; confined to the msm DRM DSI
    PHY subsystem.
  - Mirrors a proven sequence present in the 10nm driver, improving
    confidence.

Given the above, this is a solid bug fix with low risk and clear benefit
and should be backported to stable trees that include the 7nm DSI PHY
driver.

 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 8c98f91a5930c..6b765f3fd529a 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -491,6 +491,10 @@ static int dsi_pll_7nm_vco_prepare(struct clk_hw *hw)
 	if (pll_7nm->slave)
 		dsi_pll_enable_global_clk(pll_7nm->slave);
 
+	writel(0x1, pll_7nm->phy->base + REG_DSI_7nm_PHY_CMN_RBUF_CTRL);
+	if (pll_7nm->slave)
+		writel(0x1, pll_7nm->slave->phy->base + REG_DSI_7nm_PHY_CMN_RBUF_CTRL);
+
 error:
 	return rc;
 }
-- 
2.51.0

