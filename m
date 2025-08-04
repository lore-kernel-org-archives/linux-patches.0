Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3577D1C84C6;
	Mon,  4 Aug 2025 00:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267720; cv=none; b=eI5Pkk3JW+K4nVeDdE84pBhVniI0AnRGOzduJDly0Z2VepXRf6jPAsCz385+V+Xl5W8ik7a0ZHZGNKSlqRbSW8Xi94Bta2L60IOoomGbmtK/VIHX4IvIDFnd7UtCc57bPMHOs1rhV/DV5870CAs61Aurg5ha4XVprPSgg02Tels=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267720; c=relaxed/simple;
	bh=c14/7h2BR8AnkqUWruedKzxdC1c/Vm1opCnop1/jvqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ChHJxnBGJXYlGlPoHLGRrquuV6xGj6dEoAgMBvPoKkNnrIwleXJOxxwrur5986UifYp1i+hUs5XszKEe2GTT8skRYPvyOzz7fE073XAr5p8u10xqQW9SdiUgQ0xdYsFwHGVJvti71B3m9tzsW8azRaQ4NNQhlwTxOZoiDotVJww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpU5+6qK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpU5+6qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79652C4CEEB;
	Mon,  4 Aug 2025 00:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267720;
	bh=c14/7h2BR8AnkqUWruedKzxdC1c/Vm1opCnop1/jvqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpU5+6qKLAqycUH78xfMvHx6Az4QqxDS5nQ5IMLdey557LkZLUXoiqAKf9aNv7o0E
	 sEondKgXl0nJfVOD7OZ0njwdpb6cnzIFlf8UHW7LcmAg4mRSeEBjkZyisdN1jnUi5F
	 bZIr8r1Z6kWJI2cVAc8rVtdj9AwMVFMgWPhOReOn78B7LUrj5yJvnJjxESyVu7BDq5
	 UsGt+hyni2g3p4g+QXDi1ZxNB0hfhXV4OAekbynq1HFO5I+g8B8fARM/JweUv9VAhR
	 1xgGpOaS9JDCY5pJJFDtP4A8pDfcNPYokQVIiPY6JPBuMMnGjrC1h+lGWyrSHPmSV2
	 5IiTn8jHG5U1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 27/59] firmware: tegra: Fix IVC dependency problems
Date: Sun,  3 Aug 2025 20:33:41 -0400
Message-Id: <20250804003413.3622950-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
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

