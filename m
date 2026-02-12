Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D911F3BAC;
	Thu, 12 Feb 2026 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858621; cv=none; b=tcqUVc4TF+7u4VqATMBM2rey5GlcGmXHFqXBMp+AT/hrk/Y+PUVO8o4kAMIhnWKvf4jym8ZxUQKRkGZehbW7h2hj4xgRgUuXUcpZC0Ksh4Xcnp2yjjU22yHm4khLpCUzKksgv8GP1g27JmxTaL8zttRdlmESv0h/oFupKnXQXbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858621; c=relaxed/simple;
	bh=+lGniL+OxbcFxoAlMxETmX7mmGnwfdS+rLkMfIkKd28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RiaUaTWQgOSQzINi4z7igFoL6q6rOuoaIoxIF9aG2YqhowjieD+J/oElYLEqwGayPDwRdWAxfgoWdtw9AIm2WdS1U+qGhvLVqQxb7o4SEPko0usfe8Gyxa7IifDeGEg4DXj+c7mrCYFDioxbfYz6aqM32H2xup0C7JgQUxbLPDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXnwlXDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXnwlXDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC25CC19425;
	Thu, 12 Feb 2026 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858621;
	bh=+lGniL+OxbcFxoAlMxETmX7mmGnwfdS+rLkMfIkKd28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXnwlXDyqO9OVFGgYsHen9VbpkzDcoywnj9St8ViuT8HZf+60qPGTBbLDiDFasI4l
	 tOuWOP/hB4lwkuZyRCmgXhWDhIedAJ3yEIi9Q4wREuRE+VsAoNfX/L88coBT5Bn8XR
	 yaMdUV/Qqc1kX2AJnlAHOzBpp4Zg+qQiVI8yWZfprJ+01gq+uVBgPTsNfndVP5+EEc
	 Q8wzm4tHgXhMF8JlKuyOCfe5U/mn4MHnUesb2uTmzLsObh5C6yUoKjJLWhGVLqgEtW
	 vdgmVMnpMxWc9P7ukKQvFzlYwo0C2jIJdn/5oWXjqR9OKnPwr5nZW0kj1Py+gpanlS
	 wzarBnlWSLyVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] clocksource/drivers/timer-integrator-ap: Add missing Kconfig dependency on OF
Date: Wed, 11 Feb 2026 20:09:38 -0500
Message-ID: <20260212010955.3480391-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 2246464821e2820572e6feefca2029f17629cc50 ]

This driver accesses the of_aliases global variable declared in
linux/of.h and defined in drivers/base/of.c. It requires OF support or
will cause a link failure. Add the missing Kconfig dependency.

Closes: https://lore.kernel.org/oe-kbuild-all/202601152233.og6LdeUo-lkp@intel.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20260116111723.10585-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The key observation is that the `extern` declarations for `of_root`,
`of_chosen`, `of_aliases`, `of_stdout` at lines 141-144 are **outside
any `#ifdef CONFIG_OF`** guard. They are visible regardless of
CONFIG_OF. But the actual definition of `of_aliases` only exists in
`drivers/of/base.c` which is only compiled when `CONFIG_OF=y`.

This means:
1. When `CONFIG_OF=n` and `CONFIG_COMPILE_TEST=y`, the
   `INTEGRATOR_AP_TIMER` config can be enabled
2. The driver compiles fine (the extern declaration is visible)
3. But at link time, there is no definition for `of_aliases` → **linker
   error**

## Summary of Analysis

**Commit:** Adds `depends on OF` to `INTEGRATOR_AP_TIMER` Kconfig
option.

### 1. What Problem Does It Fix?

This is a **build fix** — it prevents a **link failure** when
`CONFIG_INTEGRATOR_AP_TIMER=y` with `CONFIG_COMPILE_TEST=y` but
`CONFIG_OF=n`. The driver `timer-integrator-ap.c` directly references
the global variable `of_aliases` (at lines 181 and 201), which is
defined in `drivers/of/base.c`. That file is only compiled when
`CONFIG_OF=y` (per `drivers/Makefile`: `obj-$(CONFIG_OF) += of/`).
Without `depends on OF`, the Kconfig allows enabling the driver in
configurations where OF is disabled, causing an unresolved symbol at
link time.

This was reported by Intel's kbuild test robot (automated build
testing), confirming it's a real, reproducible build failure.

### 2. Stable Kernel Rules Assessment

- **Obviously correct and tested**: Yes. It's a one-line Kconfig
  dependency addition. The driver uses `of_aliases` and multiple OF APIs
  (`of_io_request_and_map`, `of_clk_get`, `of_property_read_string`,
  `of_find_node_by_path`, `of_node_put`, `irq_of_parse_and_map`,
  `TIMER_OF_DECLARE`). It clearly requires `CONFIG_OF`.
- **Fixes a real bug**: Yes — a link failure preventing kernel
  compilation in certain configurations.
- **Fixes an important issue**: Build fixes are explicitly listed as
  backport-worthy in the stable rules. A link error prevents anyone from
  building the kernel with that configuration.
- **Small and contained**: Yes — single line addition to a Kconfig file.
  Zero risk of runtime regression.
- **No new features**: Correct — this only adds a constraint on when the
  driver can be selected.

### 3. Risk vs Benefit

- **Risk**: Essentially zero. Adding a Kconfig `depends on OF` only
  narrows the set of configurations where this driver can be enabled.
  Since the driver fundamentally requires OF to work (it uses OF APIs
  throughout), this is purely corrective. No runtime behavior changes.
- **Benefit**: Fixes a real build failure that prevents kernel
  compilation.

### 4. Scope

- **One line changed** in `drivers/clocksource/Kconfig`
- **One file affected**
- No code logic changes, no runtime impact

### 5. Affected Versions

The bug has existed since commit `568c0342e494` (June 2016, v4.8 cycle)
when `COMPILE_TEST` was added to `INTEGRATOR_AP_TIMER`. All current
stable trees (5.4.y through 6.12.y) are affected and the patch applies
cleanly since the surrounding Kconfig hasn't changed.

### 6. Dependencies

None. This is completely self-contained.

### 7. Classification

This is a **build fix** — one of the explicitly listed categories for
stable backporting. Build fixes are critical because they affect anyone
who needs to compile the kernel with a particular configuration. Even
though this specific configuration (COMPILE_TEST=y, OF=n) may not be
common for production kernels (since the Integrator/AP platform always
has OF), it matters for:
- Automated build testing infrastructure (like Intel's kbuild)
- Distributions running `make allmodconfig` / `make allyesconfig`
  testing
- Developers using COMPILE_TEST for coverage

The fix is small, surgical, zero-risk, and meets all stable kernel
criteria perfectly.

**YES**

 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index aa59e5b133510..fd91127065454 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -254,6 +254,7 @@ config KEYSTONE_TIMER
 
 config INTEGRATOR_AP_TIMER
 	bool "Integrator-AP timer driver" if COMPILE_TEST
+	depends on OF
 	select CLKSRC_MMIO
 	help
 	  Enables support for the Integrator-AP timer.
-- 
2.51.0

