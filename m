Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E042ED16D;
	Thu,  9 Oct 2025 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025587; cv=none; b=E+0dRg4eFmjMJx7cJZX/GTvP1Fdp17mtadOOuFoIFhdyHqkNOIihXVNqEM4sy7NDKQOEa3x+25ZLViHZEFQUDg0EJIz4B3g8SZ4B2tXD5M5nyISlnp0PescJh8mHmKoQWF8L80Ov7y+ZX/Wq7WzfQvApF52UOa9PCCcHHHeNdlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025587; c=relaxed/simple;
	bh=MEC3UST187b5+bx6IM6CncKqE62YTc9pxgQ1X+WYYaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qz6lZoDbS/81UX08nQA2DLfwHXdfv1TCmTojJSBbgHi78sPTYevwu77IQ4xp3cLxlbXLp1KazhRY+MlnJJ+u7Crvu5YSKUS6iE2hXKAR9W57v7rjkGRX+37Tb7fKNVHw+a4LloZkcUJG0ZjyJ/7tUhoY0zwNxUB8c1SWnevZmB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSvwlzE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSvwlzE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE83C4CEE7;
	Thu,  9 Oct 2025 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025587;
	bh=MEC3UST187b5+bx6IM6CncKqE62YTc9pxgQ1X+WYYaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSvwlzE3oVvHFXA5p/h0ZvwoPSwqfBfOZguphR3GERcoW3WL4/25PEVrKVa8nyx4k
	 Gi/zaaIBbTwLeS77gmYYwiw7ZZtdpDdIqqWsJeHjUn5fLfUHR/zbVs3mkb96dYO+QO
	 EfHxwbvDcYhjQRqo+I9NeU5KuyY1aon5qiop6focwqLFmkJaZelNicmn84rjPEpM5S
	 axULNVW15hYqzW/TvLa3KxshUe4pUQJ5r19anmMS1xu2pd96VNFB1b0X70ZhfATe/r
	 mMdqUNr44B1mb6NEcYiBq6gbrd+kLAZD84bcUd1JX0+7hpvC/YUL2B6gGr1Mkpocp1
	 QHQHtyk1tqfUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ryan Chen <ryan_chen@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>,
	joel@jms.id.au,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.17-5.15] soc: aspeed: socinfo: Add AST27xx silicon IDs
Date: Thu,  9 Oct 2025 11:55:25 -0400
Message-ID: <20251009155752.773732-59-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Ryan Chen <ryan_chen@aspeedtech.com>

[ Upstream commit c30dcfd4b5a0f0e3fe7138bf287f6de6b1b00278 ]

Extend the ASPEED SoC info driver to support AST27XX silicon IDs.

Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Link: https://patch.msgid.link/20250807005208.3517283-1-ryan_chen@aspeedtech.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis: soc: aspeed: socinfo: Add AST27xx silicon IDs

**Backport Status: YES**

### Executive Summary
This commit **should be backported** to stable kernel trees and has
**already been selected** for backporting by the AUTOSEL process (commit
ae11b34ee41dc). The change is explicitly permitted by stable kernel
rules and follows established precedent.

### Detailed Analysis

#### 1. **Compliance with Stable Kernel Rules**
The stable kernel documentation (Documentation/process/stable-kernel-
rules.rst:15) explicitly states:
> "It must either fix a real bug that bothers people **or just add a
device ID**."

This commit adds silicon IDs (which are device IDs) for the AST2700
series SoCs. **This type of change is explicitly permitted by stable
kernel policy.**

#### 2. **Code Change Analysis**
The change in drivers/soc/aspeed/aspeed-socinfo.c:27-30 adds only 4
lines to a static lookup table:
```c
+       /* AST2700 */
+       { "AST2750", 0x06000003 },
+       { "AST2700", 0x06000103 },
+       { "AST2720", 0x06000203 },
```

**Risk Assessment:**
- **Size**: 4 lines (well under 100-line limit)
- **Complexity**: Pure data addition, no logic changes
- **Dependencies**: None
- **Regression risk**: Zero - only affects AST2700 hardware
  identification
- **Side effects**: None - if these IDs don't match, lookup returns
  "Unknown" as before

#### 3. **Silicon ID Pattern Validation**
The IDs follow ASPEED's established pattern:
- **0x06** = Generation 6 (AST2700 series)
- **0x00** = Model family
- **0x00/01/02** = Variant differentiation (2750/2700/2720)
- **0x03** = Revision A3

This is consistent with all previous ASPEED silicon IDs
(AST2400-AST2625).

#### 4. **Historical Precedent**
**Commit d0e72be77e799** (2021) added AST2605 support with a `Fixes:`
tag and was backported to stable 5.11.x by Sasha Levin. This establishes
clear precedent that adding missing silicon IDs is considered a fix, not
a new feature.

**Commit 8812dff6459dd** (2021) added AST2625 variant without stable
tags but was included in mainline 5.15-rc1.

#### 5. **Current Status**
- **Original commit**: c30dcfd4b5a0f (merged in aspeed-6.18-drivers-0
  tag)
- **AUTOSEL backport**: ae11b34ee41dc (signed by Sasha Levin)
- **Status**: Already selected for stable backporting
- **Fixes/Reverts**: None found since merge

#### 6. **AST2700 Context in v6.17**
Device tree bindings for AST2700 already exist in v6.17:
- `Documentation/devicetree/bindings/interrupt-
  controller/aspeed,ast2700-intc.yaml`
- `Documentation/devicetree/bindings/mailbox/aspeed,ast2700-
  mailbox.yaml`
- `Documentation/devicetree/bindings/mfd/aspeed,ast2x00-scu.yaml`
  (mentions AST2700)

This means v6.17 has partial AST2700 support. Adding silicon IDs enables
proper SoC identification for users with AST2700 hardware.

#### 7. **User Impact**
**Without this patch:** Users running stable kernels on AST2700 hardware
see:
```
ASPEED Unknown rev ?? (06000003)
```

**With this patch:** Users see proper identification:
```
ASPEED AST2750 rev A3 (06000003)
```

This matters for:
- Hardware identification and inventory
- Debugging and support
- Kernel boot logs and diagnostics
- System management tools

#### 8. **Why Backport Despite No "Fixes:" Tag?**
While the original commit lacks explicit stable tags, it qualifies
because:
1. **Stable rules explicitly permit device ID additions** (no Fixes tag
   required)
2. **AUTOSEL process selected it** (automated stable selection)
3. **Zero regression risk** with clear user benefit
4. **Completes existing AST2700 support** already present in v6.17

### Conclusion
**YES - This commit should be backported.** It meets all stable kernel
criteria, has already been selected by AUTOSEL, carries zero regression
risk, and provides tangible value to users with AST2700 hardware on
stable kernels. The stable kernel rules explicitly permit device ID
additions, making this an appropriate and safe backport candidate.

 drivers/soc/aspeed/aspeed-socinfo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/aspeed/aspeed-socinfo.c b/drivers/soc/aspeed/aspeed-socinfo.c
index 3f759121dc00a..67e9ac3d08ecc 100644
--- a/drivers/soc/aspeed/aspeed-socinfo.c
+++ b/drivers/soc/aspeed/aspeed-socinfo.c
@@ -27,6 +27,10 @@ static struct {
 	{ "AST2620", 0x05010203 },
 	{ "AST2605", 0x05030103 },
 	{ "AST2625", 0x05030403 },
+	/* AST2700 */
+	{ "AST2750", 0x06000003 },
+	{ "AST2700", 0x06000103 },
+	{ "AST2720", 0x06000203 },
 };
 
 static const char *siliconid_to_name(u32 siliconid)
-- 
2.51.0

