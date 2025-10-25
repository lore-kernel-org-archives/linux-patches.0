Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D93064B8;
	Sat, 25 Oct 2025 16:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409091; cv=none; b=gO36Yrk1a7Gf9JPwCOzeuYoRf2RNLMkJS7ygu0cGTjRE1pRMyf4nQC+wLi8i0TTiFgnGBbdO3ZOPc+zZmcyoTm+YWJAGOqXBijTnDmPpptR81aU2GR3kv8k18TnWdVqpKeHASbsloU6tveAWBqVAEn7L9bqp8tUNk+6Lobhx7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409091; c=relaxed/simple;
	bh=bcy/FNX2nM3rn9uGT7sz0nsEClOAEsUqgREQBxMDHZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruQN+xGvXR7bQ7GyIetKa1zII3trz7wGQhWnZeN2Ij3ZSs+O4Fganh6Z/KMf+m4Ho5veEfb+3eJSx3e9jqkIQhvxsgODzwnELLUYHaSJrQMqIzHQ0doiWHZEIpLBgJZaqJahf6sb81E4iWOB31y1MO2SbsSmOHPn3hH3pZoNHMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO4OH+pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO4OH+pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFBFC4CEFF;
	Sat, 25 Oct 2025 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409089;
	bh=bcy/FNX2nM3rn9uGT7sz0nsEClOAEsUqgREQBxMDHZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UO4OH+ppx7Twhxgtd0pGwxlOBpCZPLs75312G5UHIbi4WYj9u/Burlf6IkqhHdzM1
	 r/SYdxKW6xxNC/qxgQRPUX3kfpT6ft8fV9tIN3KyzdHwqRY2MJHWmZWLdrOSQxcuhV
	 +BICj4T30/2hfVnxEZmVMP8RpmhOevTwoSfeg56GuDUDF5tAjRUAjFRVnuh8dIjWgY
	 FxZJr4QyQd8oLQxyy05EMdO0/9AbCtEQU+1wX37mU5RRmLsWoxH4HA3Qck2+KKmCzg
	 i/lzRat0uf1aG/UNgzG6VLeUgCLDT3kjTNUQvVED7r15Iam/oZSL1Tn3FTmbt7jzzo
	 XvBvOW4uw8xNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhanjun Dong <zhanjun.dong@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/xe/guc: Increase GuC crash dump buffer size
Date: Sat, 25 Oct 2025 11:57:10 -0400
Message-ID: <20251025160905.3857885-199-sashal@kernel.org>
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

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit ad83b1da5b786ee2d245e41ce55cb1c71fed7c22 ]

There are platforms already have a maximum dump size of 12KB, to avoid
data truncating, increase GuC crash dump buffer size to 16KB.

Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250829160427.1245732-1-zhanjun.dong@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - The non-debug GuC crash log buffer was doubled from 8 KB to 16 KB by
    changing `CRASH_BUFFER_SIZE` from `SZ_8K` to `SZ_16K` in
    drivers/gpu/drm/xe/xe_guc_log.h:20. Debug builds remain unchanged at
    1 MB (drivers/gpu/drm/xe/xe_guc_log.h:16).

- Why it matters (bugfix, not a feature)
  - Commit message states some platforms produce up to 12 KB crash
    dumps; with an 8 KB buffer this causes truncation. That’s a
    functional defect in diagnostics: incomplete crash logs hinder
    debugging and postmortem analysis. Increasing to 16 KB fixes this
    truncation.

- Containment and safety
  - The size is consumed by the GuC CTL log parameter field using 4 KB
    units unless the size is a multiple of 1 MB. With 16 KB, the unit
    remains 4 KB and the value is encoded via `FIELD_PREP(GUC_LOG_CRASH,
    CRASH_BUFFER_SIZE / LOG_UNIT - 1)` in
    drivers/gpu/drm/xe/xe_guc.c:128, with `LOG_UNIT` set to `SZ_4K` for
    this case (drivers/gpu/drm/xe/xe_guc.c:101-107).
  - The GuC register field for the crash buffer size is 2 bits
    (`GUC_LOG_CRASH` is `REG_GENMASK(5, 4)`,
    drivers/gpu/drm/xe/xe_guc_fwif.h:94), encoding sizes of 4 KB, 8 KB,
    12 KB, and 16 KB. Setting 16 KB is the maximum representable and
    safely covers platforms needing 12 KB without truncation.
  - Compile-time checks enforce correctness and alignment:
    `BUILD_BUG_ON(!IS_ALIGNED(CRASH_BUFFER_SIZE, LOG_UNIT));` in
    drivers/gpu/drm/xe/xe_guc.c:118. 16 KB is aligned to 4 KB, so it
    passes.
  - The total BO allocation for logs increases by only 8 KB via
    `guc_log_size()` (drivers/gpu/drm/xe/xe_guc_log.c:61), which is
    negligible and localized to this driver. No ABI/API changes.
  - The change does not affect debug builds (`CONFIG_DRM_XE_DEBUG_GUC`),
    which already use 1 MB (drivers/gpu/drm/xe/xe_guc_log.h:16).

- Impact scope
  - Only the Intel Xe driver’s GuC logging path is affected. No
    architectural changes, no critical core subsystems touched. Memory
    impact is minimal and bounded per GT/tile.

- Stable criteria assessment
  - Fixes a real user-facing issue (truncated GuC crash dumps) that
    impairs diagnostics.
  - Small, contained change to a single constant; low regression risk.
  - No new features; no behavioral change beyond preventing truncation.
  - Aligns with hardware encodings and existing compile-time guards.

Given the clear bugfix nature, minimal risk, and confined scope, this is
a good candidate for stable backporting.

 drivers/gpu/drm/xe/xe_guc_log.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_log.h b/drivers/gpu/drm/xe/xe_guc_log.h
index f1e2b0be90a9f..98a47ac42b08f 100644
--- a/drivers/gpu/drm/xe/xe_guc_log.h
+++ b/drivers/gpu/drm/xe/xe_guc_log.h
@@ -17,7 +17,7 @@ struct xe_device;
 #define DEBUG_BUFFER_SIZE       SZ_8M
 #define CAPTURE_BUFFER_SIZE     SZ_2M
 #else
-#define CRASH_BUFFER_SIZE	SZ_8K
+#define CRASH_BUFFER_SIZE	SZ_16K
 #define DEBUG_BUFFER_SIZE	SZ_64K
 #define CAPTURE_BUFFER_SIZE	SZ_1M
 #endif
-- 
2.51.0

