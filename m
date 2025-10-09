Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0DB21C9E5;
	Thu,  9 Oct 2025 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025672; cv=none; b=JzGKuJZif19FcnlE3h/TTOE73BFqdriCvWbV9B3E3C3nLiqLHekFUTIZywTv72aelUKM8pctfRiLFkLd4xDfuTPSgzapNf1//oYgNI+civXtXbwUHZVyEaZUD9KC0G8UhJY5Fz5ZY20SeoEbbFVyZzRWNbORVywv0DPAlw3bxko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025672; c=relaxed/simple;
	bh=vgTvzbuaErSOmNKUcF02F+y/az0JKy9Pe3Vija2d2N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Crh4A7A+IPOFNGKjg6jNgIw1a4zHebujkllyLqhKYcCP+SIpJM5FtLKxA6YbwIowi/xb15ahYEKpIvyLToldrSCwkuPfbgJV1ysi41TrBwLp6sonCEZOelxgmVswIxJYBKt4IVEkyu8wRbXNnjH5DNqfDxsa89TIsVurmF8WzQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAEDLbeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAEDLbeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40515C4CEF8;
	Thu,  9 Oct 2025 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025672;
	bh=vgTvzbuaErSOmNKUcF02F+y/az0JKy9Pe3Vija2d2N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAEDLbebriCaMUmhik/TelHHejTzGDAdNwpxRtx381NgCRGipNVvleEJ35JopDfuf
	 xoaC6zb5nAPIXZhtjt7B+c4uaNSA5Jdr0444k50prVyr0twZk3FfDzUxTm0umnS/G7
	 KgXuvLQDWuwkJplyS001x18Fy4zodscy6cUDeYDSh01IsKdNiJTj+fQhPT3QV5LXG7
	 cIjLPmYBQ+sv8jFF8Q+NaNdUBcmEIu8gVjuUnIf/Tg7OOJzMa6vF3esDiIbWSphK32
	 y1+WIu7abDxQQV/EJMZ3y4SGNbYcgcwcHx5bP/ToHQ9UGCAnKoCofgAIFHaaUWa7lg
	 DskP3l//WnKkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.4] mfd: stmpe-i2c: Add missing MODULE_LICENSE
Date: Thu,  9 Oct 2025 11:56:12 -0400
Message-ID: <20251009155752.773732-106-sashal@kernel.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 00ea54f058cd4cb082302fe598cfe148e0aadf94 ]

This driver is licensed GPL-2.0-only, so add the corresponding module flag.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725071153.338912-3-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**What Changed**
- Adds missing module license declaration: `MODULE_LICENSE("GPL");` in
  drivers/mfd/stmpe-i2c.c:129.

**Why It Matters**
- Without a `MODULE_LICENSE`, modules are treated as non‑GPL compatible,
  which taints the kernel and blocks access to GPL‑only exports:
  - License compatibility check: include/linux/license.h:5 treats
    `"GPL"` as GPL‑compatible.
  - Taint on unknown/non‑GPL licenses: kernel/module/main.c:1742
    triggers `TAINT_PROPRIETARY_MODULE` when license isn’t
    GPL‑compatible.
- The driver carries the SPDX header `GPL-2.0-only`, so the module flag
  aligns metadata with the actual license.
- Avoids user‑visible nuisance: dmesg warning and kernel taint on load
  for this module when built as a module.

**Scope and Risk**
- One-line metadata-only change in a single file; no functional or
  architectural changes.
- Very low regression risk; does not modify probe/remove paths or data
  flows.

**Context and History**
- The driver is modular-capable: `config STMPE_I2C` is `tristate`
  (drivers/mfd/Kconfig:1600), so a module license tag is appropriate.
- Commit 9e646615df195 (2023) removed `MODULE_LICENSE` under the
  assumption the object was non‑modular, which was incorrect for this
  driver and led to the current regression (missing license).
- This commit corrects that regression.
- Affected stable series: In this tree, v6.6, v6.8, and v6.10 lack the
  license line (module taints if built as a module), while v6.1 still
  had `MODULE_LICENSE("GPL v2")`. Backport is beneficial to stable lines
  where the line is missing.

**Stable Criteria Fit**
- Fixes a real, user-visible regression (kernel taint and GPL‑only
  symbol ineligibility) with a minimal, contained change.
- No new features or API changes; confined to MFD stmpe I2C driver
  metadata.
- Clear alignment with stable rules for small, low-risk fixes.

 drivers/mfd/stmpe-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index fe018bedab983..7e2ca39758825 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -137,3 +137,4 @@ module_exit(stmpe_exit);
 
 MODULE_DESCRIPTION("STMPE MFD I2C Interface Driver");
 MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+MODULE_LICENSE("GPL");
-- 
2.51.0

