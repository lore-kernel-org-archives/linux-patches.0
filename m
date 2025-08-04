Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D3313BC3F;
	Mon,  4 Aug 2025 00:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267136; cv=none; b=Sv9AaXguSAe3Ms5gan/hrcWFpMZY6DLoyPgT0z+v699o98YxkXrniGCJXLl1xs0dQXwRuBpK1H+Za2NPYQffgqDkaLgn/5DFt97aTqaNYeCuDYc/H7CRm2UXXJCPHGDaS/LBRAPq9MOy+TVVhr4QlX8SE/fJ+b66QNX4rNn7e8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267136; c=relaxed/simple;
	bh=c14/7h2BR8AnkqUWruedKzxdC1c/Vm1opCnop1/jvqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g5B1ALwtgH/sajuuO+Aaw67ZPuQ+ZIH0cXm0631yG8yHdXcR5YY9e4BlgIH/7lWJ8vOfOkOqWejeB/QDxdN8doXOFxUjQc7xVnlEncxrLEru7elb/l4B4nEarLeZESXyYayn6pzS94wGFvrjHF5UVBtLFoADCFpibGDLSDOt/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EU5stPak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EU5stPak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A88C4CEEB;
	Mon,  4 Aug 2025 00:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267135;
	bh=c14/7h2BR8AnkqUWruedKzxdC1c/Vm1opCnop1/jvqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EU5stPakHxVoRSj6JOjzGC6JUMlbQUhkysW1LzbU8pRD67YPE06zxDW92i2xYgN+q
	 5zQzGdxGDVFEXryKlHf1vTCqKStOMTOjI2/BTJkZVgVDGs9+ipMP4YSjZofm2i6SKw
	 FIWf503B90oI8BG2EUn+oWNQv4yWHmwDGXH1Rs+FCwJp3StZqYqjnxW55HDWezH8tr
	 FKV/fTNmV+DxClwp+QAbuJq8etWTaHf1IkMyQtiM9cbr6wkZzkpR1mxRIDHgb8CEMy
	 0b0nGdhsuZXq3RHu0evjDnV6pKUmNJW0kmccIPs5L5LkpzSFiB44fubzt9HXIpxo+0
	 FJQLtSsFKi3PA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16 40/85] firmware: tegra: Fix IVC dependency problems
Date: Sun,  3 Aug 2025 20:22:49 -0400
Message-Id: <20250804002335.3613254-40-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 78eb18020a88a4eed15f5af7700ed570642ff8f1 ]

The IVC code is library code that other drivers need to select if they
need that library. However, if the symbol is user-selectable this can
lead to conflicts.

Fix this by making the symbol only selectable for COMPILE_TEST and add
a select TEGRA_IVC to TEGRA_BPMP, which is currently the only user.

Link: https://lore.kernel.org/r/20250506133118.1011777-10-thierry.reding@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is suitable for backporting to stable kernel trees. Here's
an extensive analysis based on the commit message and code changes:

## Analysis

### 1. Bug Fix Nature
The commit fixes a genuine Kconfig dependency problem where TEGRA_IVC
being user-selectable can lead to configuration conflicts. The commit
message explicitly states "The IVC code is library code that other
drivers need to select if they need that library. However, if the symbol
is user-selectable this can lead to conflicts."

### 2. Size and Scope
The fix is minimal and contained - only 4 lines changed in a single
Kconfig file:
- Line 5: Changed `bool "Tegra IVC protocol"` to `bool "Tegra IVC
  protocol" if COMPILE_TEST`
- Line 16: Removed `TEGRA_IVC` from the depends line
- Line 18: Added `select TEGRA_IVC`

### 3. No Major Side Effects
The change doesn't introduce any functional modifications to the code
itself. It only changes how the Kconfig symbol is selected:
- TEGRA_IVC becomes non-user-selectable (except for COMPILE_TEST)
- TEGRA_BPMP now explicitly selects TEGRA_IVC instead of depending on it

### 4. No Architectural Changes
This is purely a Kconfig dependency fix with no changes to the actual
driver implementation or kernel architecture.

### 5. Critical Subsystem Impact
While this touches firmware drivers, the change is limited to
configuration logic and doesn't modify any runtime behavior.

### 6. Stable Tree Considerations
Based on my investigation:
- TEGRA_IVC is indeed library code (as seen in
  drivers/firmware/tegra/ivc.c)
- Multiple SoC configs (ARCH_TEGRA_186_SOC, ARCH_TEGRA_194_SOC,
  ARCH_TEGRA_234_SOC) also select TEGRA_IVC
- Currently, TEGRA_BPMP appears to be the only driver module using the
  IVC library functions directly
- The library exports functions like `tegra_ivc_*` that are used by BPMP

### 7. Risk Assessment
The risk is minimal because:
- The change converts a user-visible dependency into an automatic
  selection
- This prevents users from creating invalid configurations
- The actual IVC and BPMP code remains unchanged
- The fix aligns with standard kernel practice for library code (should
  be selected, not user-configurable)

This is a classic example of a good stable backport candidate: it fixes
a real configuration issue that could cause build problems, the fix is
small and contained, and it doesn't introduce any functional changes or
risks to the kernel operation.

 drivers/firmware/tegra/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/tegra/Kconfig b/drivers/firmware/tegra/Kconfig
index cde1ab8bd9d1..91f2320c0d0f 100644
--- a/drivers/firmware/tegra/Kconfig
+++ b/drivers/firmware/tegra/Kconfig
@@ -2,7 +2,7 @@
 menu "Tegra firmware driver"
 
 config TEGRA_IVC
-	bool "Tegra IVC protocol"
+	bool "Tegra IVC protocol" if COMPILE_TEST
 	depends on ARCH_TEGRA
 	help
 	  IVC (Inter-VM Communication) protocol is part of the IPC
@@ -13,8 +13,9 @@ config TEGRA_IVC
 
 config TEGRA_BPMP
 	bool "Tegra BPMP driver"
-	depends on ARCH_TEGRA && TEGRA_HSP_MBOX && TEGRA_IVC
+	depends on ARCH_TEGRA && TEGRA_HSP_MBOX
 	depends on !CPU_BIG_ENDIAN
+	select TEGRA_IVC
 	help
 	  BPMP (Boot and Power Management Processor) is designed to off-loading
 	  the PM functions which include clock/DVFS/thermal/power from the CPU.
-- 
2.39.5

