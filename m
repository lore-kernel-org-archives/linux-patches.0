Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58383502B1;
	Tue, 23 Dec 2025 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484330; cv=none; b=A5LOjh323wZGdktE3tAYDEhiAl0BtAANDETUOvFNRon1XxVb5mWAi2U4+oTw6YMZZvkxLSkv154Kq0OuDh0DnTC1vHZewk9gRyXQJlLpteD5H+s4lNua81jlUmnz6gO2G6oL08r3wKOAbZshSxWWt/2+ryzifjVfgjmvCIE8mKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484330; c=relaxed/simple;
	bh=GoeiD/mHRrqIqg/hkLQaH4vUQg2G/OVV8+NMR3PGQTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zx1ho2Ebr9NCGOL7qht9UMfXVfTfb65chggGji5B3/RDs75FEQKVuBPcRdqmki9Tf1E7KBhRNQMVgpIVSnjC/b1thwrwTDpy34V6auPzHXvLdOxDJW8QFrhHH/FiI8WxDqSQmp+DLK4lyroSaHc7M7sOsqRNY33i5DJHxGMeJt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmbnAPeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmbnAPeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822E7C116B1;
	Tue, 23 Dec 2025 10:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484330;
	bh=GoeiD/mHRrqIqg/hkLQaH4vUQg2G/OVV8+NMR3PGQTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmbnAPeRLWgq2CaBuXLE6gHCn1EmE28THYRjORDH7JEd/hFwiBAsjj7FLNIYV2w6p
	 IQWSE1Rz1SW3xhDLj00UNUGu9TDKuL3KegOBmGsVYeNM7LNpc/fE9CPuXVq9STCLSF
	 1zlaCLKqRCSBNy+IV0K3eGMoEASKB8QoHR+aOnG49sdmwjBjGzWkBHpMyV93DCY8Md
	 OZ9TCeCasGbUHHsQCqz/ZSZoXphqe99rgAVluVZ1Fzk8moJzkwZ1cUKT0AnHJHNFQn
	 W5uWpNRwTtYDw0TWBQsJ9vI2Obx7XkjfmzFYl/Al6gl06n+aEU1Fwhkgt4pkGwVgqZ
	 otIl+npiWbdcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Emerson Pinter <e@pinter.dev>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ata: libata-core: Disable LPM on ST2000DM008-2FR102
Date: Tue, 23 Dec 2025 05:05:12 -0500
Message-ID: <20251223100518.2383364-8-sashal@kernel.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit ba624ba88d9f5c3e2ace9bb6697dbeb05b2dbc44 ]

According to a user report, the ST2000DM008-2FR102 has problems with LPM.

Reported-by: Emerson Pinter <e@pinter.dev>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: Disable LPM on ST2000DM008-2FR102

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and provides essential information:
- **Purpose:** Disabling Link Power Management (LPM) for a specific
  Seagate hard drive model
- **Evidence of real issue:** Has `Reported-by:` tag and references
  kernel bugzilla #220693
- **Proper sign-offs:** Signed by both the patch author (Niklas Cassel)
  and the libata maintainer (Damien Le Moal)

### 2. CODE CHANGE ANALYSIS

The change adds exactly 3 lines to the `__ata_dev_quirks[]` array in
`drivers/ata/libata-core.c`:

```c
/* Seagate disks with LPM issues */
{ "ST2000DM008-2FR102", NULL,           ATA_QUIRK_NOLPM },
```

This follows the exact same pattern as existing quirks in the table.
Looking at the context, there's already another Seagate drive with
`ATA_QUIRK_NOLPM`:
```c
{ "ST1000LM024 HN-M101MBB", NULL,       ATA_QUIRK_BROKEN_FPDMA_AA |
                                        ATA_QUIRK_NOLPM },
```

The mechanism is well-understood: when this specific drive model is
detected, LPM is disabled to avoid the hardware-specific issues it
causes.

### 3. CLASSIFICATION

This is a **hardware quirk/workaround** - one of the explicit exceptions
allowed in stable:
- It's adding a device-specific workaround to an existing quirk table
- Identical pattern to dozens of other quirks already in the table
- Fixes real-world hardware issues even though it "adds code"

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 3 (minimal) |
| Files touched | 1 |
| Complexity | Trivial - data table addition |
| Risk to other users | Zero - only affects this specific drive model |
| Regression potential | None - well-established mechanism |

The risk is essentially zero. This is a data-only change to a static
array. The quirk mechanism has been stable for many years and is used
extensively for similar hardware workarounds.

### 5. USER IMPACT

- **Affected users:** Owners of ST2000DM008-2FR102 (2TB Seagate
  Barracuda) - a popular consumer HDD
- **Without the fix:** LPM-related issues typically cause drive
  disconnects, I/O errors, or system hangs
- **Severity:** Medium to High - LPM issues can cause data corruption or
  loss in severe cases
- **Real bug evidence:** Bugzilla report indicates actual users hitting
  this problem

### 6. STABILITY INDICATORS

- Approved by libata maintainer (Damien Le Moal)
- Proper bug tracking with Closes: tag
- Reported-by indicates real user testing/reporting

### 7. DEPENDENCY CHECK

- **Dependencies:** None - standalone quirk addition
- **Code exists in stable:** Yes - the quirk table and `ATA_QUIRK_NOLPM`
  exist in all maintained stable kernels
- **Backport complexity:** Trivial - should apply cleanly to any stable
  kernel

### FINAL ASSESSMENT

This commit is a textbook example of what SHOULD be backported to
stable:

**Meets all stable criteria:**
1. ✅ Obviously correct - identical pattern to existing quirks
2. ✅ Fixes a real bug - LPM issues reported by users
3. ✅ Small and contained - 3 lines, 1 file
4. ✅ No new features - just a hardware workaround
5. ✅ Falls into "quirks/workarounds" exception category

**Risk vs Benefit:**
- **Risk:** Essentially zero - only affects one specific drive model,
  cannot break anything else
- **Benefit:** Fixes LPM-related issues (drive disconnects, errors,
  potential data corruption) for users of this popular Seagate drive

This is exactly the type of low-risk, high-value hardware workaround
that stable trees are designed to include.

**YES**

 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f48fb63d7e85..1216b4f2eb90 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4132,6 +4132,9 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_QUIRK_NONCQ |
 						ATA_QUIRK_FIRMWARE_WARN },
 
+	/* Seagate disks with LPM issues */
+	{ "ST2000DM008-2FR102",	NULL,		ATA_QUIRK_NOLPM },
+
 	/* drives which fail FPDMA_AA activation (some may freeze afterwards)
 	   the ST disks also have LPM issues */
 	{ "ST1000LM024 HN-M101MBB", NULL,	ATA_QUIRK_BROKEN_FPDMA_AA |
-- 
2.51.0

