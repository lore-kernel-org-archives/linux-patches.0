Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B310357736;
	Tue, 23 Dec 2025 10:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484334; cv=none; b=JgAMDvL3R8/zJcyC4n4+cmYYIH00qkKvGuyst/JaorAcmBJtq2Q3GhT/OcU+kqqRe6Ua/DjcaavC5/4L6N+/LSkU1U5tlVYMEPNlYsd0jvbCeRm1fT8G7ZcyBfg6dSJk2LvbXXodFazgC4H0CJHwRCR0QfylhPZHq+3TiOybnwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484334; c=relaxed/simple;
	bh=ooUhopMYufXyAl/z2LDIuz1qbAKdAy+jWWrh58kah7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLJANotiSitrjsC4Yq+VfKV/h0R8p4QDcyl+jasFs9ik7dgxDvIbb12WFW6AC/ohA/ckfuM5TIQDGK+F0WU14ZY7HYrIwPVvdtgEsihnFucj5IU1MYs/6fQJtw4zonz66YlW3JtAZE/oLArkJ6uNcGu+lG2/8QdgdxoNZja/aUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgS9t4gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgS9t4gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AFBC19425;
	Tue, 23 Dec 2025 10:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484333;
	bh=ooUhopMYufXyAl/z2LDIuz1qbAKdAy+jWWrh58kah7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgS9t4glFL32JT6hXoJYPCGgS0xk4nWiOkYQ9aHEAbJtzHojprOCT+gAkoUsqddoZ
	 x7NmmX60JPBqYmKjpCmBKBO0x6V2401JiM7aCAAjIdUsRxS1DugQrW7HAaxPVJJqDq
	 OYqta96g0YrT0OKJEQv5/OzUNnvQb1CZyGVUBqIkkl5YwZ2u3TpcA0wYNL0SMXbdVD
	 W20RKpZUPCX5Q1ATpP2ffYDimfj8hD3DbC8dwAA/fMvELsLzC0Yeo014oVZetMay1C
	 1QqPnBIEXonP3C6g0u/iEwk1IL3KbooMmnqQUziLId9Vb1GsfmaoMN50WNzXR9Fjho
	 o6TNTTHi2sIzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marcus Hughes <marcus.hughes@betterinternet.ltd>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: sfp: extend Potron XGSPON quirk to cover additional EEPROM variant
Date: Tue, 23 Dec 2025 05:05:15 -0500
Message-ID: <20251223100518.2383364-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251223100518.2383364-1-sashal@kernel.org>
References: <20251223100518.2383364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcus Hughes <marcus.hughes@betterinternet.ltd>

[ Upstream commit 71cfa7c893a05d09e7dc14713b27a8309fd4a2db ]

Some Potron SFP+ XGSPON ONU sticks are shipped with different EEPROM
vendor ID and vendor name strings, but are otherwise functionally
identical to the existing "Potron SFP+ XGSPON ONU Stick" handled by
sfp_quirk_potron().

These modules, including units distributed under the "Better Internet"
branding, use the same UART pin assignment and require the same
TX_FAULT/LOS behaviour and boot delay. Re-use the existing Potron
quirk for this EEPROM variant.

Signed-off-by: Marcus Hughes <marcus.hughes@betterinternet.ltd>
Link: https://patch.msgid.link/20251207210355.333451-1-marcus.hughes@betterinternet.ltd
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## SUMMARY

**What the commit does**: Adds a single entry to the SFP quirks array
for hardware that has a different vendor/part ID ("BIDB"/"X-ONU-SFPP")
but requires identical handling to already-supported Potron modules.

**Does it meet stable kernel rules?**

1. ✅ **Obviously correct**: It's a one-line addition using existing,
   proven quirk infrastructure
2. ✅ **Fixes a real bug**: Without this quirk, the hardware doesn't work
   properly (TX_FAULT/LOS pins are misinterpreted)
3. ✅ **Important issue**: Hardware that users have purchased doesn't
   function
4. ✅ **Small and contained**: Single line addition to an array
5. ✅ **No new features**: Just extends existing quirk to another device
   ID

**Dependency check**: The `sfp_fixup_potron()` function was introduced
in commit `dfec1c14aece` (June 2025) and has already been backported to
stable trees (confirmed by seeing backport commit `34a890983183`). This
commit requires that parent commit to be present.

**Risk vs Benefit**:
- **Risk**: Near zero - only affects specific hardware identified by
  exact vendor/part match
- **Benefit**: High for affected users - enables hardware to work
  properly

## CONCLUSION

This commit is a textbook example of a hardware quirk addition that IS
appropriate for stable backporting. It:
- Uses existing, tested infrastructure
- Has minimal code change (1 line)
- Enables real hardware that users have in the field
- Has zero risk of regression for anyone else
- The parent quirk function is already in stable trees

The only caveat is that stable kernels must have the original Potron
quirk commit (`dfec1c14aece`) first, which based on the git history
appears to have already been backported.

**YES**

 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 0401fa6b24d2..6166e9196364 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -497,6 +497,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
 		  sfp_fixup_nokia),
 
+	SFP_QUIRK_F("BIDB", "X-ONU-SFPP", sfp_fixup_potron),
+
 	// FLYPRO SFP-10GT-CS-30M uses Rollball protocol to talk to the PHY.
 	SFP_QUIRK_F("FLYPRO", "SFP-10GT-CS-30M", sfp_fixup_rollball),
 
-- 
2.51.0

