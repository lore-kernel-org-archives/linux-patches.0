Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D98C43DA23;
	Tue, 10 Mar 2026 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133321; cv=none; b=KGmVgpl6/Avxq3SsAHt/RsDOqrNiQGn+SYH84mTwjPNMnKCO+SaFyBJDOdmqh8tL+qEc2ZnjRR2Us/s0MkFBN31PdCJ+eJuNjRb4bFr7Z5boRsLma/9/YCJsf3+eayJLFVXLe9jhbcmq1YqXSATD2OF1ohJNRBmGo6y3Gh//lgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133321; c=relaxed/simple;
	bh=hIiKjgB64+bYm08DmkXcfVhwblnyoTwHXHdIw19+yGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s4YdFziKYKS2QxRtyQLqXCnw3NrPm/4t6Sgqer1q+LFkrakT0qrvEJkZH5geqIzYwrO4H/5ljc4No+ZWsC3vL5smglu7KMYniEyYyTU64721ckLN3KW2kZ+X6aKpdkGcr46zW5u4P1UsIHn1tjYY+QQozu5BdwGqoAF0I+V2+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BceI+gHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BceI+gHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48912C2BCAF;
	Tue, 10 Mar 2026 09:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133321;
	bh=hIiKjgB64+bYm08DmkXcfVhwblnyoTwHXHdIw19+yGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BceI+gHwUVuG6aypgwH/CVIKlMI66ETymTPCufomDvpyc7ZNBQfBrj2r1WxyrRmRB
	 zxeqWzFV/NqS/cFCLXwfeH9iQcW0xRuEvd0B/Vyonsap6Y9lLG5gJHfQf/jcY6K0hJ
	 BtpkP8B1ffif5OAhET6hr5P5MuVumGIV/WrAoKGhP4UgiftfDkWbDB6waRUFSZDiXk
	 oCvELLVuo9lg/oPDr1w/lIwUA6gU1GrvBy5YrMNExgWMmVxi1y3sWQhps+xQlkbNlL
	 pxZS/wZC3qLvHc1+wiW2ir/SEXcXlvXoeGWmlDsyJtuqFdRFXuRp4Hh+5nQDqIBl4t
	 oEU8z7UOFfUZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	derekjohn.clark@gmail.com,
	samsagax@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] platform/x86: oxpec: Add support for OneXPlayer X1z
Date: Tue, 10 Mar 2026 05:01:10 -0400
Message-ID: <20260310090145.2709021-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 4049c46edb5d44c0de045f6f504371705dd603dd ]

X1z is a variant of OneXPlayer X1 A with 8840U. It seems that only one
user has this one. Add a quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-3-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does
This commit adds a single DMI match entry for the "OneXPlayer X1z"
handheld gaming device to the `oxpec` driver's DMI table. The X1z is
described as a variant of the existing X1 A with an 8840U CPU. It reuses
the existing `oxp_x1` driver_data, identical to the already-supported X1
A and X1 i variants.

### Classification: Hardware Quirk / Device ID Addition

This is a textbook **device ID addition** to an existing driver — one of
the explicitly allowed exception categories for stable backports. The
change:

- Adds 7 lines: a new `dmi_system_id` struct entry in the `dmi_table[]`
  array
- Uses entirely existing infrastructure (`oxp_x1` enum value already
  defined)
- Matches the exact same pattern as every other entry in the table
- Zero new code paths, functions, or logic introduced

### Risk Assessment

**Risk: Extremely low**
- The DMI match is specific to one exact board name ("ONEXPLAYER X1z"
  from vendor "ONE-NETBOOK")
- It can only affect users with that exact hardware
- It reuses the same driver_data as sibling variants (X1 A, X1 i)
- No behavioral changes for any other hardware

### Benefit Assessment

**Benefit: Enables hardware support**
- Without this entry, the oxpec driver won't bind on the X1z, meaning
  the user cannot control fan speed or other EC-managed features on
  their device
- The commit message notes "only one user has this one" — low population
  but a real user with a real need

### Stable Criteria Check
1. **Obviously correct and tested**: Yes — trivial DMI table addition,
   reviewed by maintainer (Ilpo Järvinen)
2. **Fixes a real bug**: Enables missing hardware support (device not
   recognized by existing driver)
3. **Small and contained**: 7 lines, single file, single table entry
4. **No new features or APIs**: Reuses existing `oxp_x1` path entirely
5. **No new code paths**: Just a match table entry

### Verification

- Verified the diff adds only a DMI table entry with no logic changes
- Verified `oxp_x1` driver_data is already used by X1 A and X1 i entries
  visible in the same diff context
- Verified the commit is reviewed by the subsystem maintainer (Ilpo
  Järvinen, Intel)
- The driver file `drivers/platform/x86/oxpec.c` is an existing upstream
  driver; the change only adds a device match

### Concerns

- The oxpec driver may be relatively new — if it was added after the
  stable branch point for older LTS trees, the backport wouldn't apply
  there. But for any stable tree that already contains the oxpec driver
  with `oxp_x1` support, this is a clean, trivial addition.
- No dependencies on other patches needed.

This is a minimal, zero-risk hardware quirk addition that enables an
existing driver to recognize a new device variant. It is the classic
example of what the stable kernel exception rules were designed to
accommodate.

**YES**

 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 59d6f9d9a9052..623d9a452c469 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -219,6 +219,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_mini_amd_pro,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1z"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0

