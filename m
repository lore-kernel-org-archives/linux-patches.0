Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EDE3164D6;
	Mon,  2 Feb 2026 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068840; cv=none; b=uQnE32/TWPdu7gWXIP0s4xTgdr26RdgQKUUcl1LIFIDn+02KaCxj/Lm0NnD42eyKDBlP7JQP6XMcx9JFngP2fO7LtCjJqSTXhHQFUCw5wC6RmaUfZzHbJXMSTVO2TLOvhTsexP6xlvLa0gKxuVpOj/HDXSDJheuDvmcC3yiIMu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068840; c=relaxed/simple;
	bh=fegejkVL+lLJoLfhYf6xVkGHeRs3KVjJLWElAzTPWGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idK+82QcZP/YID2acTC2j3YxmrRH9YbkXRogXu0xDOXOcQOmpP4+2UByy7b6yVYWNAmz7dES1H7PINhZed3tHS4AG4YrYn6mme48D5UXtMRK/X/5w6fv2XkAwb7B3PnjajoSpdU2+NuvKH14jhDjtdta+5Iv10jr0324Q8JNNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qFav1RVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFav1RVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57308C19421;
	Mon,  2 Feb 2026 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068840;
	bh=fegejkVL+lLJoLfhYf6xVkGHeRs3KVjJLWElAzTPWGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFav1RVr94huZI2w0ReeYLORkxcA35dMioBH1mTjIMaKkZDqbX9D4rAaveX+iUPna
	 QgY5J0CcMVWbOl5EqbUgtwOp7qAV+OWRgO1Oa/JOHtGwRIykAoRnrWpGTKIc1riAdz
	 Bw4WsMn/qSBCCjdpH8y6hFWcoui5vmVMAH8BQjqSlhju8Ysy4G/vewhXiq8zaElRYo
	 Z35qtlEgUxE0iZv5w8bKGwPAvouTNzhB5J81xKsZ/+ca3iH5KlWEGVfcmIEbnb8JRP
	 sySmpgpI3qechey8bWNpW2d5RkT05LciThskH4yJDZtvaicOIPxo62hx8f0xSLYtFE
	 c6cvTdVz/vmEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: intel-pci: Add support for Nova Lake SPI serial flash
Date: Mon,  2 Feb 2026 16:46:12 -0500
Message-ID: <20260202214643.212290-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Transfer-Encoding: 8bit

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit caa329649259d0f90c0056c9860ca659d4ba3211 ]

Add Intel Nova Lake PCH-S SPI serial flash PCI ID to the list of
supported devices. This is the same controller found in previous
generations.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260115120305.10080-1-alan.borzeszkowski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Backport Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** "spi: intel-pci: Add support for Nova Lake SPI serial
flash"

**Key information from message:**
- Adds a new PCI ID for Intel Nova Lake PCH-S SPI serial flash
  controller
- Explicitly states: "This is the same controller found in previous
  generations"
- Has proper sign-offs from Intel developer and maintainer
  acknowledgment
- Link to patch message provided for traceability

**Notable:** No Fixes: tag or Cc: stable tag, but as noted in the
analysis guidelines, this is expected for commits requiring manual
review.

### 2. CODE CHANGE ANALYSIS

The diff shows a **single-line addition**:
```c
{ PCI_VDEVICE(INTEL, 0x6e24), (unsigned long)&cnl_info },
```

This adds PCI device ID `0x6e24` to the `intel_spi_pci_ids[]` table,
using the existing `cnl_info` configuration structure (Cannon Lake
info).

**Technical details:**
- The change adds one entry to the PCI device ID table
- Uses the well-established `PCI_VDEVICE()` macro
- References `cnl_info`, which already exists and is used by many other
  device IDs in this driver
- The insertion is alphabetically ordered (0x6e24 is placed between
  0x5825 and 0x7723)
- No new code paths, functions, or logic introduced

### 3. CLASSIFICATION

**This is a NEW DEVICE ID addition** - one of the explicitly listed
exceptions in the stable kernel rules.

From the guidelines:
> **NEW DEVICE IDs (Very Common):**
> - Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers
> - These are trivial one-line additions that enable hardware support
> - Rule: The driver must already exist in stable; only the ID is new

This commit fits this exception perfectly:
- The `spi-intel-pci` driver already exists in stable kernels
- Only the PCI ID is being added
- Uses existing configuration (`cnl_info`)

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- **Lines changed:** 1 line added
- **Files touched:** 1 file (`drivers/spi/spi-intel-pci.c`)
- **Complexity:** Minimal - just a table entry

**Risk assessment:**
- **Extremely LOW risk** - This is one of the safest possible changes
- The new ID only matches Nova Lake hardware
- Existing hardware continues to work exactly as before
- If the ID is somehow wrong, only Nova Lake devices would be affected
- The `cnl_info` structure is already well-tested with many other Intel
  platforms

### 5. USER IMPACT

**Who benefits:**
- Users with Intel Nova Lake PCH-S systems
- Enterprise customers deploying on newer Intel hardware
- Without this patch, SPI flash on Nova Lake systems won't be recognized

**Impact assessment:**
- **Positive impact:** Enables SPI flash access on new hardware
- **Negative impact potential:** None for existing users
- **Hardware scope:** This is a platform-level chipset, so all Nova Lake
  systems are affected

### 6. STABILITY INDICATORS

- **Acked-by:** Mika Westerberg (Intel kernel maintainer) - positive
  signal
- **Signed-off-by:** Mark Brown (SPI subsystem maintainer) - indicates
  proper review
- The commit message explicitly states this uses the "same controller
  found in previous generations" - this suggests the hardware is
  compatible and doesn't need new code

### 7. DEPENDENCY CHECK

**Dependencies:** None
- This commit is completely self-contained
- It only adds an entry to an existing table
- No prerequisites needed - the driver infrastructure is already in
  place

**Stable tree compatibility:**
- The `spi-intel-pci.c` driver has been in the kernel for years
- The `cnl_info` structure exists in all relevant stable trees
- This patch will apply cleanly to any stable kernel that has this
  driver

### 8. VERDICT REASONING

**Why this SHOULD be backported:**

1. **Explicitly allowed by stable rules:** New device IDs are a
   documented exception that IS appropriate for stable trees

2. **Zero regression risk:** Adding a new PCI ID to a table cannot
   possibly break existing functionality

3. **Minimal change:** Single line addition is as small and contained as
   possible

4. **Real user benefit:** Users with Nova Lake hardware need this to
   have functional SPI flash support

5. **Mature driver:** The intel-spi-pci driver is well-established and
   the cnl_info configuration is used by many other platforms

6. **Proper review:** Has maintainer acks from both Intel and SPI
   subsystem maintainers

**No concerns:**
- No dependencies
- No backport adjustments needed
- Will apply cleanly
- No new code paths or features

This is a textbook example of a commit that should be backported to
stable - it's a trivial device ID addition that enables hardware support
using existing, well-tested driver code.

**YES**

 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index b8c572394aac2..bce3d149bea18 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -81,6 +81,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x54a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x5794), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x5825), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0x6e24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7723), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7a24), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0x7aa4), (unsigned long)&cnl_info },
-- 
2.51.0

