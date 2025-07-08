Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E485079DA;
	Tue,  8 Jul 2025 00:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932949; cv=none; b=iFbi1pz1NnDzwQrJD1zE/4+uuCHeWTl9a9co/fCNunmaNr8ivmin0SDTaPCX8fuKE/CKe8P8HQUrh5wjHGJ+qrnWKV0kLPhJSRE3j/cqmDN4WMV1VPI2G1xb4eUgKPYS3lL76jmTUnzT22Fg5sChNs2XgGFbeRXCdEA7kzfILfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932949; c=relaxed/simple;
	bh=vNaM/k+SL2ziJjMEPGwBUcTS6jl/bzY8vpECqk0Mtoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M/aiaT9zkexEmZsrM8Qshgq15BKSjNx3PtsFyT4QsSNWVyVN4ozgdJbGQs2DuETJ6AVl9Ip+6i5SlsGxn6O0LhFSdW3Clq4dXGCn7imZ8STSq3GifxnXUzk0OPmqbuaQb/xqx6nvx+zQeR83gqvBo6ZJIRzDncY5QCcpHkCBvFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTB7JcEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTB7JcEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D891C4AF09;
	Tue,  8 Jul 2025 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932948;
	bh=vNaM/k+SL2ziJjMEPGwBUcTS6jl/bzY8vpECqk0Mtoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTB7JcEgHFe87RTWmqtQFcTEdUN3046YKbYmmPhdPeXbz/AMIvg/QDrpemnqXWTWI
	 J9zYwxklnEz+ZRE9RZBH586X2dAC9DrXY1Yz8faIFfMwgCAx5qb8VDThiuS4GdtVFz
	 J1H904miO+37HwWiO1gHw/HNos5e/ZHD1opt7PNWvSaPtVQ/wosXjW+2vazE7ktJCK
	 SSaEk4i3k5GB4DtQ5KdWYpu+9qb90Dier7/sVOHDL+/LD+PysbQSPMOXU0lGMLmjlK
	 dGxMSRbl+3WTvxMYf0v7bBUcYwqB7IwvFUmuY5nW/PnvRFOJyPZViNljC46n+Z2Hw/
	 tPNICT0OP2JvQ==
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
Subject: [PATCH AUTOSEL 6.15 7/8] platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8406CA
Date: Mon,  7 Jul 2025 20:02:14 -0400
Message-Id: <20250708000215.793090-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000215.793090-1-sashal@kernel.org>
References: <20250708000215.793090-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.5
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
index 3f8b2a324efdf..f84c3d03c1de7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -530,6 +530,15 @@ static const struct dmi_system_id asus_quirks[] = {
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

