Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEDC128819;
	Tue,  8 Jul 2025 00:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932959; cv=none; b=dK0V3y4oHC5fPE1w+BIp/amz4ADRDur2QwkUDCulH3BicRYNUhCQ5K88u8POIj5XNKe4n80E0bW01siYsVoEtMZcbG4ipWBtw5rd5CYTXGNKUBmS6yCmEyHCIixRk8nnBIi4rQZNvd3E01GTqWUGDvblLBijnlmGtSpKmfiXfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932959; c=relaxed/simple;
	bh=aMR2jpdIJSO4u4M6pTvRRlOr7CGzPhsxrkuJNcWvNCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q57o5RIH5CZJ4hbq65exVcV1gFWxNauPgeiU+VzW0coA20M5fyOcE2OkbwePMPEy8f2ae5GCxxXZ/tDg0SL1JYQLoIBrDYlZJdPWJL9/DSkzwT/wSiVJp+EMfsesuo80WTeXgizPcpyZEV9GgPVmbfGJpDqvmgOFMoxoejUQVo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuynXBSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuynXBSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487E2C4CEE3;
	Tue,  8 Jul 2025 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932959;
	bh=aMR2jpdIJSO4u4M6pTvRRlOr7CGzPhsxrkuJNcWvNCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuynXBSI1dLyXu0S2aqWMiAsnu5NVJeQIoEa2NUKqpAm3box4Sqk7905v5hph0YBG
	 zXv5iOGFpTN/LR7LSiJdNMu3B9A7DeL1zAjDGfCgjCgXKirORMS2zH1W8rgoATAOWa
	 Sw423Of3nL520y81i/qjewUmEYPZZcXpQQHiT4LaCy0VvQ1EOJxprkUzuB/mtAJNB5
	 /l6M9STyi3Wja8PGSEuYTBdjVV6pLaKljnWksCzvD8i6DURiuA52H1PdZY3LfK3GwN
	 AlCJ/YzaAxpN7xSq4+t8TTiLpMgbsVlhZpYY7Pz8x1Gkg0PqF7Tn5YWW6bnzc3+6pV
	 A0URxRGtspFmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rahul Chandra <rahul@chandra.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corentin.chary@gmail.com,
	hdegoede@redhat.com,
	markgross@kernel.org,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 5/6] platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8406CA
Date: Mon,  7 Jul 2025 20:02:29 -0400
Message-Id: <20250708000230.793347-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000230.793347-1-sashal@kernel.org>
References: <20250708000230.793347-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.36
Content-Transfer-Encoding: 8bit

From: Rahul Chandra <rahul@chandra.net>

[ Upstream commit 7dc6b2d3b5503bcafebbeaf9818112bf367107b4 ]

Add a DMI quirk entry for the ASUS Zenbook Duo UX8406CA 2025 model to use
the existing zenbook duo keyboard quirk.

Signed-off-by: Rahul Chandra <rahul@chandra.net>
Link: https://lore.kernel.org/r/20250624073301.602070-1-rahul@chandra.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's the
extensive explanation:

## Analysis of the Code Changes

The commit adds a simple DMI quirk entry for the ASUS Zenbook Duo
UX8406CA:

```c
+       {
+               .callback = dmi_matched,
+               .ident = "ASUS Zenbook Duo UX8406CA",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER
INC."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "UX8406CA"),
+               },
+               .driver_data = &quirk_asus_zenbook_duo_kbd,
+       },
```

This applies the existing `quirk_asus_zenbook_duo_kbd` to the UX8406CA
model.

## Why This Is a Bug Fix, Not Just Hardware Enablement

Based on my analysis of the kernel repository, the
`quirk_asus_zenbook_duo_kbd` was introduced to fix a specific hardware
issue where:

1. **The keyboard emits spurious wireless disable keypresses** when
   placed on the laptop's secondary display
2. **This causes unexpected WiFi disconnections** via the rfkill system
3. **The keyboard doesn't actually have wireless toggle functionality**,
   so these events are always spurious

## Evidence Supporting Backporting

1. **Fixes User-Impacting Bug**: Without this quirk, users experience
   unexpected WiFi disconnections when using their keyboard normally,
   which significantly impacts usability.

2. **Follows Established Pattern**: The commit follows the exact pattern
   of the previous UX8406MA support (commit 9286dfd5735b), which
   addressed the same issue for a similar model.

3. **Minimal Risk**: The change is:
   - Only 9 lines of code
   - Isolated to specific hardware (only affects UX8406CA)
   - Uses existing, tested infrastructure
   - Cannot affect other systems due to DMI matching

4. **Similar to Other Backported Commits**: Looking at the reference
   commits:
   - Commit 2b1cb70 (adding support for ALS on UX430UQ) was backported
   - Commit ac16dfa (reverting GA401/GA502 quirks) was backported
   - Commit 82a7228 (adding tablet mode quirk for ROG Flow X13) was
     backported

5. **Clear Bug Fix Nature**: Unlike commit 79493de (making use of
   dmi->ident) which was NOT backported because it was just a code
   improvement, this commit actually fixes broken functionality.

## Comparison with Reference Commits

This commit is most similar to:
- **Commit 2b1cb70** (YES): Added device-specific quirk to fix
  functionality
- **Commit 82a7228** (YES): Added quirk to fix hardware-specific issue
- **Commit 25390f8** (YES): Added device support to fix existing
  hardware

And dissimilar to:
- **Commit 79493de** (NO): Code refactoring without functional impact

## Conclusion

This commit meets all criteria for stable backporting:
- Fixes a real bug affecting users
- Small, contained change
- Low risk of regression
- Follows established patterns
- Only affects specific hardware

The commit should be backported to stable kernels that contain the
`quirk_asus_zenbook_duo_kbd` infrastructure (6.11+).

 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a5933980ade3d..90ad0045fec5f 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -529,6 +529,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_zenbook_duo_kbd,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS Zenbook Duo UX8406CA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX8406CA"),
+		},
+		.driver_data = &quirk_asus_zenbook_duo_kbd,
+	},
 	{},
 };
 
-- 
2.39.5

