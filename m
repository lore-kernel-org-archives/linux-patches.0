Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F2A326D45;
	Sat, 25 Oct 2025 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409758; cv=none; b=FDSSk06PBWXz6dWTLyPVGSV842/bOFEYUpx3CdDMxeJ/y/vm8zN6yND75Se2J0VC3/S69tFN5rzfk0YV3WmPdKJaqfLtgJ3dLstCL93UC4kWX7Gn+GORjmtq/bkrXGVtkEm/xRdit27ISyqMCYCBxR4EPOZ3VrMVorB6m0sY08M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409758; c=relaxed/simple;
	bh=P+UALtNY8Qm2WH/V0C5CDcS/eKnhg2eGmxdQ2yBXjxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8kKlKHafx0KSI98QmXJ6K5TS1fCydqtab1NgOft9jonoy6DsNQhO14h1xkAzkoRhpCyGwNb0riYsjVwKPb5aQxCG1lEm89wUSBvaowjSwghrQwuubHW2c5XRb0Ez6fSNyRGdXtqlAzbNyIR50kxBjlD0a62z+6VpWnJpYGu4MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WoZK44ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoZK44ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E57C4CEFB;
	Sat, 25 Oct 2025 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409757;
	bh=P+UALtNY8Qm2WH/V0C5CDcS/eKnhg2eGmxdQ2yBXjxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoZK44magWTK/mhSAAWligbWnJ+e4bX+I7UH1vV8Vo6uP33fInK+vX/cd/2Tf1y2c
	 Y8WI4B+9ABZcj4xUKhfCyD+w4rYalmkQmihwYK6tYUV7FFz9aHP000phCFANwX6JnP
	 8GniRKmRGBC3aKEQxuF+bJ2hzna+8oX5a4v2ddXfsm2X4mY5XPMsaeqbjFVbrvQa4C
	 Vy43zqU2LetPgUji4v+pUdUZocg06sVR8D/AfxKg4RIfJmSI7b6Ih5fJmvbIDhyGnq
	 g+EXpBemB3leipHYSzqCwDa0EsABeF9BiOpE0h5nPora/Y6BXDyAHV8OIYrIz/Jm16
	 mtFkTV+7PuadQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	kuba@kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] mips: lantiq: xway: sysctrl: rename stp clock
Date: Sat, 25 Oct 2025 12:01:22 -0400
Message-ID: <20251025160905.3857885-451-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit b0d04fe6a633ada2c7bc1b5ddd011cbd85961868 ]

Bindig requires a node name matching ‘^gpio@[0-9a-f]+$’. This patch
changes the clock name from “stp” to “gpio”.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: In `arch/mips/lantiq/xway/sysctrl.c:488`, the PMU clock
  lookup key was renamed from `\"1e100bb0.stp\"` to `\"1e100bb0.gpio\"`
  while keeping the same gating bits (`PMU_STP`). This aligns the clkdev
  `dev_id` with the DT-derived device name.
- Why it matters: The STP GPIO controller driver requests its clock via
  `devm_clk_get_enabled(&pdev->dev, NULL)` and fails if no clkdev
  mapping matches the platform device’s name. See `drivers/gpio/gpio-
  stp-xway.c:299-303` where it logs “Failed to get clock” and aborts
  probe on error.
- Binding and DT consistency: The binding requires a node name
  `^gpio@[0-9a-f]+$`. In-tree DTS already uses `gpio@e100bb0` for this
  block (e.g., `arch/mips/boot/dts/lantiq/danube_easy50712.dts:99`),
  which yields a platform device name akin to `\"1e100bb0.gpio\"`.
  Without this patch, the clkdev key `\"1e100bb0.stp\"` doesn’t match,
  causing clock lookup to fail and the driver to not probe.
- User-visible impact fixed: Without the clock, the STP GPIO (used for
  driving LED shift registers and similar) fails to initialize, breaking
  GPIO/LED functionality on affected Lantiq XWAY SoCs.
- Scope and risk: This is a one-line, self-contained rename that:
  - Leaves the actual gating (`PMU_STP`) unchanged.
  - Touches only the Lantiq XWAY sysctrl init path (`ltq_soc_init`).
  - Has no architectural changes and no side effects beyond fixing the
    name mismatch.
- Regression considerations: The only potential risk would be out-of-
  tree DTS using a legacy `stp@...` node name (contrary to the binding).
  In-tree DTS already uses `gpio@...`, so backporting aligns kernel and
  DT as per the binding and avoids breakage with current trees.
- Stable criteria fit:
  - Fixes a real bug affecting users (driver probe/clock enable
    failure).
  - Minimal, targeted change; no new features or ABI changes.
  - Confined to MIPS Lantiq subsystem; low regression risk.

Conclusion: Backporting is appropriate to restore correct clock lookup
and driver probe behavior on Lantiq XWAY platforms using DTs that follow
the binding.

 arch/mips/lantiq/xway/sysctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index 6031a0272d874..d9aa80afdf9d6 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -485,7 +485,7 @@ void __init ltq_soc_init(void)
 	/* add our generic xway clocks */
 	clkdev_add_pmu("10000000.fpi", NULL, 0, 0, PMU_FPI);
 	clkdev_add_pmu("1e100a00.gptu", NULL, 1, 0, PMU_GPT);
-	clkdev_add_pmu("1e100bb0.stp", NULL, 1, 0, PMU_STP);
+	clkdev_add_pmu("1e100bb0.gpio", NULL, 1, 0, PMU_STP);
 	clkdev_add_pmu("1e100c00.serial", NULL, 0, 0, PMU_ASC1);
 	clkdev_add_pmu("1e104100.dma", NULL, 1, 0, PMU_DMA);
 	clkdev_add_pmu("1e100800.spi", NULL, 1, 0, PMU_SPI);
-- 
2.51.0

