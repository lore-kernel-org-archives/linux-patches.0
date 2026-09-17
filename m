Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79919547071;
	Thu, 17 Sep 2026 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667409; cv=none; b=AnXqQMdhnooGzyroYXS3SzQ9pbF3uM1k42NYrpkb9SiKeq648889LpzK6htC2GH5PuQtXgZgdNmLR3t2IWx+EyxbRHaMAqv3uAcQO9IB/7eXdxRteRcLXHPHsX4SH+3rLuZ+ryzoP25ZeSWkwoT6GQvvzvNlnnl3dacU76jldfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667409; c=relaxed/simple;
	bh=p5U1oSmZLRsfFOe+ZWyCAqyOPSdEYsZZPaSYV4Ls3iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmwDDOs9oIfimWJkax12Mo++XatJLXwwlykb6jyrYi2FA/aJ0BJnfqWcbDaUaZmnnLjlnbs/a9DawPoYctD8qjWWpI8PjVH/5F8Qxt8jWA0n9tdZzu3JK0DBBH80pfWbm7d0Nj/zNblaT+2A6cyEMyv30lDj35l49bJV6GZ/yVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Idjqoy3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Idjqoy3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4281F000FF;
	Thu, 17 Sep 2026 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667408;
	bh=iei2vDMo8J+zI6f2zd2ArAonoyvgtvmDlOxgVuXupRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Idjqoy3aUNTU9KdT7yxoXHgNHLmjNnpj/IGqv6kc/lYiI+kF0I8BG2R43rDhNJUDZ
	 aapEE+zfBZKLWICRdUdWzlzJNVpz8Sx3uSBgB1SntUEA2Hz8lqF7HWOXzGKVQzoM5C
	 rKElXSefwNHjCS+WPEs+3Zbzc4UEnRBlM+ba+VNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0082/1102] clk: samsung: exynos850: mark APM I3C clocks as critical
Date: Thu, 17 Sep 2026 16:00:25 +0100
Message-ID: <20260917151541.534164150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 44984aaf1aa727ff944dd4b72fcf069d08b0056d ]

The Exynos850 APM co-processor relies on the I3C bus to communicate with
the PMIC. Currently, there is no dedicated PMIC consumer driver managing
these clocks, so the clock subsystem automatically gates them during the
initialisation. Once gated, any subsequent ACPM communication with APM
results in timeouts.

As a temporary workaround (and let's hope it doesn't become permanent),
mark both `gout_i3c_pclk` and `gout_i3c_sclk` as CLK_IS_CRITICAL ones to
prevent the clock subsystem from disabling them. This makes the ACPM
communication functional. This workaround should be reverted once a
proper ACPM PMIC driver is implemented to manage these clocks.

Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260430-exynos850-i3c-criticalclocks-v1-1-6e1fd8dfa21b@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos850.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos850.c b/drivers/clk/samsung/clk-exynos850.c
index e2a63ea7d4cba..086cc90784843 100644
--- a/drivers/clk/samsung/clk-exynos850.c
+++ b/drivers/clk/samsung/clk-exynos850.c
@@ -684,10 +684,11 @@ static const struct samsung_gate_clock apm_gate_clks[] __initconst = {
 	     CLK_CON_GAT_GOUT_APM_APBIF_RTC_PCLK, 21, 0, 0),
 	GATE(CLK_GOUT_TOP_RTC_PCLK, "gout_top_rtc_pclk", "dout_apm_bus",
 	     CLK_CON_GAT_GOUT_APM_APBIF_TOP_RTC_PCLK, 21, 0, 0),
+	/* TODO: Should be dealt with or enabled in PMIC ACPM driver */
 	GATE(CLK_GOUT_I3C_PCLK, "gout_i3c_pclk", "dout_apm_bus",
-	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, 0, 0),
+	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, CLK_IS_CRITICAL, 0),
 	GATE(CLK_GOUT_I3C_SCLK, "gout_i3c_sclk", "mout_apm_i3c",
-	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, 0, 0),
+	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, CLK_IS_CRITICAL, 0),
 	GATE(CLK_GOUT_SPEEDY_PCLK, "gout_speedy_pclk", "dout_apm_bus",
 	     CLK_CON_GAT_GOUT_APM_SPEEDY_APM_PCLK, 21, 0, 0),
 	/* TODO: Should be enabled in GPIO driver (or made CLK_IS_CRITICAL) */
-- 
2.53.0



