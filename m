Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79FC187332;
	Sun, 26 Oct 2025 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490240; cv=none; b=M51iKAy9+Nl4qIkb2RZlcHfYmIiJqzJeM9dtCY7cpKWwBBTxGLJKHXAuwK7h+0yclMuSV/bZZuWqvITFDIOz/6Cfg6SCc3m5/2pMC10+GbCcWhvBLsAvCYlN8V5h4Mx2htCpoy8elH9cn/MGxKKQ5oFDsH+Yunw3U02LDFulVmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490240; c=relaxed/simple;
	bh=2MBAaFZNwmraGivu2UIRCGodtNSsXBGb3gZYEGmCiYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALpAdq5gvkxxvhgWKRnZYh/ITmi1x/hoxsx6HVMC4YNFiMCobClYFmG3GdRyrsa5PSDz0l9Z032z5VYR8kAWcRL80Sx0ojw/7U3KvCdjTcZs4bs7NCDp28xFn5aRNh0jkYLfvfcAykSeoWCiQRnRNZsMBMX55MQJEU/8ZQ1ooMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2WPcYy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2WPcYy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2BDC4CEE7;
	Sun, 26 Oct 2025 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490239;
	bh=2MBAaFZNwmraGivu2UIRCGodtNSsXBGb3gZYEGmCiYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2WPcYy0IU+y5WtiDCDdDhP2g/J3s2WRZfLM6iCl0P2QB/lIRMBmPFF/YhheYfJVw
	 hNl7ukqKEXRSNgnv4a8qn9UbIPVOXnsqchgf6IRRL1WDGOS7AbUwWwRBKkWuJJwbkj
	 k12QKP98Nmdtx1a38Zm/cvkAKkhkpfVXyapZsX6R2oBr+mSQWJfYfuKayzJiZ1Gqz9
	 kaUPaR3Ov7DnUMI75K8oto6jpnUNgXvbJd89GMrOewsMk+PucvVMtTmmYVV6czDBgg
	 7REmqQQj9p2VoBdRcKsIaJWA8CE/+z8zxHfCrOiHQbI+taIu99Ib/o3rl1jL4tI2mk
	 3nlBQVPlggo2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jacky Bai <ping.bai@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mturquette@baylibre.com,
	arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] clk: scmi: Add duty cycle ops only when duty cycle is supported
Date: Sun, 26 Oct 2025 10:48:54 -0400
Message-ID: <20251026144958.26750-16-sashal@kernel.org>
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

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit 18db1ff2dea0f97dedaeadd18b0cb0a0d76154df ]

For some of the SCMI based platforms, the oem extended config may be
supported, but not for duty cycle purpose. Skip the duty cycle ops if
err return when trying to get duty cycle info.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this is a low-risk bug fix that prevents the driver from
advertising duty-cycle support on firmware that actually rejects the
operation, avoiding real user-visible failures.

- `scmi_clk_ops_alloc()` wires up `get_duty_cycle`/`set_duty_cycle`
  whenever the duty-cycle feature bit is set (`drivers/clk/clk-
  scmi.c:311`). Before this patch any clock with `extended_config =
  true` populated that bit, so consumers believed the duty-cycle API
  worked even when firmware returned `-EOPNOTSUPP`.
- In practice, a refused call bubbles up to drivers that rely on the
  feature. For example, `clk_set_duty_cycle()` in the AXG TDM interface
  aborts audio setup if the clock op fails (`sound/soc/meson/axg-tdm-
  interface.c:249`), so misreporting support breaks real hardware.
- The commit now probes firmware once at registration time and only sets
  `SCMI_CLK_DUTY_CYCLE_SUPPORTED` when
  `config_oem_get(...SCMI_CLOCK_CFG_DUTY_CYCLE...)` succeeds
  (`drivers/clk/clk-scmi.c:349` and `drivers/clk/clk-scmi.c:372-377`).
  This simply reuses the existing accessor (`drivers/clk/clk-
  scmi.c:187`) and has no side effects beyond skipping the bogus ops.
- Change is tiny, localized to the SCMI clock driver, and introduces no
  ABI or architectural churn; the new call is already required whenever
  the duty-cycle helpers are invoked, so risk is minimal.
- Stable branches need to carry the duty-cycle support addition (`clk:
  scmi: Add support for get/set duty_cycle operations`, commit
  87af9481af53) beforehand; with that prerequisite satisfied,
  backporting this fix prevents firmware that only supports other OEM
  configs from breaking consumers.

Given it fixes a regression introduced with duty-cycle support and keeps
the driver from lying about capabilities, it fits stable backport
criteria.

 drivers/clk/clk-scmi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index 78dd2d9c7cabd..6b286ea6f1218 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -346,6 +346,8 @@ scmi_clk_ops_select(struct scmi_clk *sclk, bool atomic_capable,
 		    unsigned int atomic_threshold_us,
 		    const struct clk_ops **clk_ops_db, size_t db_size)
 {
+	int ret;
+	u32 val;
 	const struct scmi_clock_info *ci = sclk->info;
 	unsigned int feats_key = 0;
 	const struct clk_ops *ops;
@@ -367,8 +369,13 @@ scmi_clk_ops_select(struct scmi_clk *sclk, bool atomic_capable,
 	if (!ci->parent_ctrl_forbidden)
 		feats_key |= BIT(SCMI_CLK_PARENT_CTRL_SUPPORTED);
 
-	if (ci->extended_config)
-		feats_key |= BIT(SCMI_CLK_DUTY_CYCLE_SUPPORTED);
+	if (ci->extended_config) {
+		ret = scmi_proto_clk_ops->config_oem_get(sclk->ph, sclk->id,
+						 SCMI_CLOCK_CFG_DUTY_CYCLE,
+						 &val, NULL, false);
+		if (!ret)
+			feats_key |= BIT(SCMI_CLK_DUTY_CYCLE_SUPPORTED);
+	}
 
 	if (WARN_ON(feats_key >= db_size))
 		return NULL;
-- 
2.51.0

