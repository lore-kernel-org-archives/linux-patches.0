Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929383019CB;
	Mon,  9 Feb 2026 12:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640047; cv=none; b=loRmS0grojwCcr+HH4FiHBUtUOHbQ3RVRUG8qdfD/hdpPUELsZ2qL48rDOXQ2MH3+lTDuQEXLu+9lgloFa5RFQ13c6IsTlnNe9FYVzCIn4CjJlNsaYHwIFCK6dZONrFaN11ajYAqSvsS9v7dKiHJizqPXnT0hl1gV8sRyvFmGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640047; c=relaxed/simple;
	bh=CiN1MIiOEgUYdtezB5WqjxnU+1ePjyfmh6gOBazAXBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsy7w8WkEVIklz5Pv/QLtKilXTjWKbKKl76PThmZRAlVbOet9CZiWW/6a6ATPECby834KHnIC/saAD9deOh4x797N/NbW8RVsgckGnSm0pGjv9kVb+dAuyjL+GReLTdwcRffpYqiDqYkavWy72tVNeibhC9eXvdPvCchpfmdUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ivxa97Gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ivxa97Gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC82C16AAE;
	Mon,  9 Feb 2026 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640047;
	bh=CiN1MIiOEgUYdtezB5WqjxnU+1ePjyfmh6gOBazAXBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ivxa97Gs/jmB4QJMk1nIQM0ENQgNYGbmq57nHjFw8AdWwyizUuA5t/eWBnIgN8pHN
	 7BgKuzyp+raIK4w4+r2FHL/bp6U5DcEtFOSjj2SqRupJ0jP6g5TEicnuwL2GB9+cVt
	 aKiFXgKjmwOIQEC7UKdcsi/PZYocHkcGpG+o7G6yZinAWAHteAtxcGXn68uAMcAXBO
	 sfkoCFlbcpGRY+ei2+LLxb3UUZUMTWbhLxawAiCkuPDfmwY2dAw5BfcCLDv/OkYfOu
	 N5G1aufIox0KriX+gogYdyraxI94BwkeEvcseqYgnJ+Ha4T3LteEDksgRLJVHEIBfo
	 althkKg1aeCGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dirk Su <dirk.su@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alex.andries.aa@gmail.com,
	oliver.schramm97@gmail.com,
	zhangheng@kylinos.cn,
	elantsew.andrew@gmail.com,
	talhah.peerbhai@gmail.com,
	pipocavsobake@gmail.com,
	ravenblack@gmail.com,
	laodenbach@gmail.com,
	santesegabriel@gmail.com,
	keenplify@gmail.com
Subject: [PATCH AUTOSEL 6.18-6.6] ASoC: amd: yc: Add quirk for HP 200 G2a 16
Date: Mon,  9 Feb 2026 07:26:45 -0500
Message-ID: <20260209122714.1037915-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dirk Su <dirk.su@canonical.com>

[ Upstream commit 611c7d2262d5645118e0b3a9a88475d35a8366f2 ]

Fix the missing mic on HP 200 G2a 16 by adding quirk with the
board ID 8EE4

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Link: https://patch.msgid.link/20260129065038.39349-1-dirk.su@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
The commit explicitly states it fixes a missing microphone on the HP 200
G2a 16 laptop by adding a DMI quirk entry with board ID "8EE4". This is
a straightforward hardware quirk addition.

### Code Change Analysis
The change adds exactly one new DMI table entry to the
`yc_acp_quirk_table[]` array in `sound/soc/amd/yc/acp6x-mach.c`:

```c
{
    .driver_data = &acp6x_card,
    .matches = {
        DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
        DMI_MATCH(DMI_BOARD_NAME, "8EE4"),
    },
},
```

This is identical in structure to dozens of other entries already in the
table. It simply tells the AMD Yellow Carp audio driver to match this
specific HP board so the audio card is properly configured.

### Classification
This falls squarely into the **hardware quirk/workaround** exception
category. It:
- Adds a DMI match entry to an existing driver's quirk table
- Follows the exact same pattern as all other entries in the table
- Fixes a real hardware issue (non-functional microphone) for a specific
  laptop model
- Introduces zero risk of regression to any other hardware

### Scope and Risk Assessment
- **Lines changed**: ~7 lines (one table entry addition)
- **Files touched**: 1
- **Risk**: Essentially zero. The DMI match only triggers on the
  specific HP board with ID "8EE4". No other systems are affected.
- **Complexity**: Trivial — copy-paste of an existing pattern

### User Impact
Without this quirk, users of the HP 200 G2a 16 laptop have a non-
functional microphone. This is a real usability problem — the microphone
simply doesn't work. This is the kind of fix that stable users need:
their hardware doesn't work, and a tiny patch makes it work.

### Stability and Dependencies
- No dependencies on other commits
- The AMD YC audio driver and the quirk table infrastructure exist in
  all recent stable trees
- The patch applies cleanly as a simple table entry addition
- The author is from Canonical (Ubuntu), suggesting this was found and
  tested on real user hardware

### Precedent
This file (`acp6x-mach.c`) has had many similar quirk additions
backported to stable trees. This is routine stable material.

The fix is a trivial, zero-risk hardware quirk addition that fixes a
non-functional microphone on a specific HP laptop model. It perfectly
matches the stable kernel criteria for hardware quirks/workarounds.

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index c0a8afb42e165..3018e1a6f6f31 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -626,6 +626,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE4"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0

