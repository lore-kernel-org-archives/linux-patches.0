Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E1930B538;
	Sat, 14 Feb 2026 21:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104444; cv=none; b=rjYpj8n/scayZpAMIqq+yfmvAdAC8+ZUYwd5dfUWQIevh+6WNLfA7HfryFzoPnPQJNLAFfodOVUxdO1uKP1A6ini+gR93QbU+cbEdtN8Fwc6BB2A55b2fxQQfWn7CQ4qpTqUZAf9mBun47rjVagGqYrKsoyRwu84IpvxqAMIZ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104444; c=relaxed/simple;
	bh=2Sb6YVj2l1Ok2Mmg0zsL+12yGub/lIm0PQt6q4Zz3I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzFbX/GnRn8o86+O4AAIaP/J3kX9T/ENbn36DG/iAe0ylifjIh9qjf6zgAy5ENkHl5M6B6/5MW4cVBhxGf4qIIJAFFDegSs53nzLvmuUcD4kgNwuYd5qsO/xkjetXkESmjWF8igmpcQGQrIt1kaqJ5nzn+6pgD/y7mVAp+Ymrwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhhUwZ5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhhUwZ5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A03C19423;
	Sat, 14 Feb 2026 21:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104444;
	bh=2Sb6YVj2l1Ok2Mmg0zsL+12yGub/lIm0PQt6q4Zz3I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhhUwZ5tW3s2UEWpMPNXYf/fF8kh0MH5TjH1uc1rWoK0Wy+sVY6KA5gq2tNsTIggF
	 4clcOhmCbi1LAEAD8GI5TtS+zJTne928NVip559MUkvRRMfxOJ76HcHA4ZxbTCSwsc
	 stoWCucP5AggKh0lfpgSLx05Wt0sP+HQ8qw4/zLa/0VYq59Tdww2amEakonatA+wBf
	 abl6fSkBBiEKPYkgqqh539zdGLg2ck3To0Rt1hZZUEAak7TmLSV35PyzMFJZuE3M+0
	 B+is1JzXQjQMVpFMSd5SBtVqJiSZqbnI20mexklBB59AP/SDcNrP7txAClPIkIQ3qz
	 wB1VX5OZE/lTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] net: sfp: add quirk for Lantech 8330-265D
Date: Sat, 14 Feb 2026 16:23:53 -0500
Message-ID: <20260214212452.782265-88-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 86a8e8e0ddbc3d14c799536eb888180b84d002f3 ]

Similar to Lantech 8330-262D-E, the Lantech 8330-265D also reports
2500MBd instead of 3125MBd.

Also, all 8330-265D report normal RX_LOS in EEPROM, but some signal
inverted RX_LOS. We therefore need to ignore RX_LOS on these modules.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260128170044.15576-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of SFP Quirk Addition for Lantech 8330-265D

### Commit Message Analysis

The commit adds a hardware quirk for the Lantech 8330-265D SFP module.
It addresses two specific hardware issues:

1. **Incorrect speed reporting**: The module reports 2500MBd instead of
   the correct 3125MBd in its EEPROM, preventing it from being
   recognized as a 2500base-X capable module.
2. **Inverted RX_LOS signal**: Some units of this module report inverted
   Loss-of-Signal, while the EEPROM claims normal LOS behavior. Since
   the behavior is inconsistent across units, the fix ignores LOS
   entirely.

The commit explicitly references similarity to an existing quirk
(Lantech 8330-262D-E), establishing a pattern.

### Code Change Analysis

The change is minimal and contained:
- **2 lines added**: A new `SFP_QUIRK()` entry for "Lantech" /
  "8330-265D" with `sfp_quirk_2500basex` and `sfp_fixup_ignore_los`
- **Comment updated**: The existing comment for the 8330-262D-E is
  expanded to cover the 8330-265D as well, and explains the LOS issue
- **No new functions or infrastructure**: Uses existing quirk macros
  (`SFP_QUIRK`) and existing fixup functions (`sfp_quirk_2500basex`,
  `sfp_fixup_ignore_los`)

### Classification: Hardware Quirk

This falls squarely into the **SFP/Network Quirks** exception category
explicitly mentioned in the stable backport guidelines. SFP quirks for
optical modules with broken behavior are specifically called out as
appropriate for stable trees.

### Risk Assessment

- **Risk: Extremely Low** — The quirk only triggers for modules with
  vendor string "Lantech" and product string "8330-265D". It cannot
  affect any other hardware.
- **Scope: Minimal** — Two lines of data-driven code in an existing
  quirk table. No logic changes.
- **Dependencies: None** — The `SFP_QUIRK` macro, `sfp_quirk_2500basex`,
  and `sfp_fixup_ignore_los` all already exist in the codebase. This
  commit is fully self-contained.

### User Impact

Without this quirk:
- The Lantech 8330-265D SFP module **cannot operate at 2500base-X**
  because the kernel misinterprets its EEPROM data
- Some units exhibit **random link drops or failure to establish link**
  due to inverted RX_LOS being treated as actual signal loss

These are real, user-impacting hardware issues that make the SFP module
non-functional or unreliable.

### Stability Indicators

- Author is **Marek Behún**, the SFP subsystem maintainer — he deeply
  understands this code
- Reviewed and merged by **Jakub Kicinski**, the networking subsystem
  maintainer
- Follows an established pattern (identical approach to existing
  8330-262D-E quirk)
- The fixup functions used (`sfp_quirk_2500basex`,
  `sfp_fixup_ignore_los`) are well-tested and used by other quirk
  entries

### Conclusion

This is a textbook example of a hardware quirk that belongs in stable
trees. It's a tiny, self-contained, zero-risk addition to an existing
quirk table that makes specific hardware work correctly. It uses only
pre-existing infrastructure, was authored and reviewed by the relevant
maintainers, and fixes real hardware issues (incorrect speed negotiation
and unreliable link due to inverted LOS).

**YES**

 drivers/net/phy/sfp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 3e023723887c4..43aefdd8b70f7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -532,9 +532,13 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault),
 
-	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
-	// 2500MBd NRZ in their EEPROM
+	// Lantech 8330-262D-E and 8330-265D can operate at 2500base-X, but
+	// incorrectly report 2500MBd NRZ in their EEPROM.
+	// Some 8330-265D modules have inverted LOS, while all of them report
+	// normal LOS in EEPROM. Therefore we need to ignore LOS entirely.
 	SFP_QUIRK_S("Lantech", "8330-262D-E", sfp_quirk_2500basex),
+	SFP_QUIRK("Lantech", "8330-265D", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_los),
 
 	SFP_QUIRK_S("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
-- 
2.51.0

