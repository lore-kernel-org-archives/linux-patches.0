Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508442F5479;
	Thu,  9 Oct 2025 16:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025648; cv=none; b=LEGXQA9DkKuGpjQC2vszOPjDkQVm/CCU8HBq7vDUV9DRsgL4w9jiUPuw3bG/7cqyk7Uk1KWUIVgKRoTKyDvaEhV8M9cgJBrxjhgp7bnDlpX1vWHJtLuUeDml8vnCmk7HKlar/jqSPRTC7MHd3/7Gdx74brhLLcFkEZ3de45mQNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025648; c=relaxed/simple;
	bh=HEShrMOqQuzcaezpwui2FSYLHPIj5ZZv3nCIpidoQw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwCUA8aJKTQ1I3q+e2OaQQtURIFYVBEI1KD8QyYGB1ctww7oyFFjy7Z90Kdfvw4xEHi2Wb3XKUQPAC7XvtwyUM4o8f+SMXS18fWWU9XogRzIgKsQ+tP4ElhCKVD1iKr9Dy3gxMjw73BihI/NYcfWjcCZiabpb8snnERykbLpIMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIMNOL6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIMNOL6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1ADC113D0;
	Thu,  9 Oct 2025 16:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025648;
	bh=HEShrMOqQuzcaezpwui2FSYLHPIj5ZZv3nCIpidoQw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIMNOL6QaAQJm9OTBu6nKuIHxjIBlDPML996KU4a/ncyFG4DkdKXhxxeuwyPKl0sS
	 JRPXMCk0GZEeeDgAEUeCUh1hGUfFXEURrOjQS61puDGIU5UkSIDs1PGimoubaO79js
	 rH2rKMGpd/kLow3MxLHHz6CS9FGI+Vxl5KsidriQM8bs/yKbkFmw1/lGZWvCYFPJjt
	 1Q0A2wPhuU0YEb3qBlZJchEYzgwP2JaJr11whhODtEGAgQ4GgkyrpY0cfDvjTlXThz
	 5cT8BgGEn8on5GRjeZ3+4cjad2KhmshdLeDKiIqHGRrIbvhyjlMIDcOIl8IlVzsGwM
	 Y3W2Df6ha7BDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Heijligen, Thomas" <thomas.heijligen@secunet.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] mfd: kempld: Switch back to earlier ->init() behavior
Date: Thu,  9 Oct 2025 11:56:00 -0400
Message-ID: <20251009155752.773732-94-sashal@kernel.org>
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

From: "Heijligen, Thomas" <thomas.heijligen@secunet.com>

[ Upstream commit 309e65d151ab9be1e7b01d822880cd8c4e611dff ]

Commit 9e36775c22c7 ("mfd: kempld: Remove custom DMI matching code")
removes the ability to load the driver if no matching system DMI data
is found. Before this commit the driver could be loaded using
alternative methods such as ACPI or `force_device_id` in the absence
of a matching system DMI entry.

Restore this ability while keeping the refactored
`platform_device_info` table.

Signed-off-by: Thomas Heijligen <thomas.heijligen@secunet.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/7d2c7e92253d851194a781720051536cca2722b8.camel@secunet.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation and evidence
- Fixes a regression introduced by 9e36775c22c7: That commit removed the
  driver’s custom DMI logic, which had the unintended side-effect of
  preventing the driver from loading at all when there was no DMI match
  — even if the device could be enumerated via ACPI or by using the
  `force_device_id` module parameter. The new change restores the
  earlier init() behavior to re-enable those paths, while retaining the
  refactored platform_device_info usage.

What changed in init()
- Adds explicit handling for `force_device_id` which lets users force-
  load on systems without a DMI match:
  - New logic iterates the static table and, if `force_device_id`
    matches any `ident`, creates the platform device regardless of
    system DMI content; otherwise returns `-ENODEV` (forced but not
    recognized). See `drivers/mfd/kempld-core.c:788-795`.
- Allows driver registration even when no system DMI match exists:
  - If `force_device_id` is not set, it iterates DMI matches and
    attempts to create the platform device; if there are no DMI matches,
    it simply proceeds to `platform_driver_register(&kempld_driver)` so
    ACPI can enumerate and bind the device. See `drivers/mfd/kempld-
    core.c:796-800`.
- The comment in the new code explicitly documents the restored behavior
  for three init paths: `force_device_id`, DMI presence, and ACPI. See
  `drivers/mfd/kempld-core.c:781-787`.

Why this is needed and safe
- ACPI path is already supported in the driver:
  - The driver has an ACPI match table with IDs `KEM0000` and `KEM0001`,
    mapping to `kempld_platform_data_generic`. See `drivers/mfd/kempld-
    core.c:476-484`.
  - The probe path explicitly handles the “no DMI-created pdev” case by
    detecting `IS_ERR_OR_NULL(kempld_pdev)` and pulling platform data
    from ACPI via `device_get_match_data()`, then attaching it with
    `platform_device_add_data()`. See `drivers/mfd/kempld-
    core.c:414-426`.
- The change is minimal and contained:
  - Only `kempld_init()` changes; no hardware access paths or core MFD
    logic are modified. It simply restores prior init semantics while
    keeping the newer `platform_device_info` setup.
- No broad side effects:
  - The module still uses `MODULE_DEVICE_TABLE(dmi, ...)` and
    `MODULE_DEVICE_TABLE(acpi, ...)`, preserving automatic module
    loading under both DMI and ACPI.
  - Cleanup is safe: `platform_device_unregister(kempld_pdev)` remains
    unconditional in exit, and it is safe even if `kempld_pdev` is NULL
    or an ERR_PTR due to guards in the platform core
    (`platform_device_del()`/`platform_device_put()` both check
    `IS_ERR_OR_NULL`). See `drivers/base/platform.c:791-796`,
    `drivers/base/platform.c:746-765`, and
    `drivers/base/platform.c:520-560`.

Risk and regression assessment
- Scope is limited to init-time enumeration policy; no architectural
  changes.
- Restores previously supported user-visible behavior (loading via ACPI
  or `force_device_id`) that was inadvertently removed — i.e., a clear
  regression fix.
- Typical DMI matching will still create a single platform device; in
  the common case only one DMI entry matches, so the else-branch loop
  behavior is equivalent to break-on-success in practice.
- No impact on other subsystems; MFD-specific and self-contained.

Backport prerequisites
- This should be backported to stable trees that already contain commit
  9e36775c22c7 (the refactoring that removed custom DMI matching). Older
  trees that still have the original pre-9e36775 behavior do not need
  this change.

Conclusion
- This is an appropriate, low-risk regression fix that restores ACPI and
  `force_device_id` load paths, with contained changes and clear
  correctness. It fits stable policy well.

 drivers/mfd/kempld-core.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index c5bfb6440a930..77980c7fc31f9 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -779,22 +779,26 @@ MODULE_DEVICE_TABLE(dmi, kempld_dmi_table);
 static int __init kempld_init(void)
 {
 	const struct dmi_system_id *id;
-	int ret = -ENODEV;
 
-	for (id = dmi_first_match(kempld_dmi_table); id; id = dmi_first_match(id + 1)) {
-		/* Check, if user asked for the exact device ID match */
-		if (force_device_id[0] && !strstr(id->ident, force_device_id))
-			continue;
-
-		ret = kempld_create_platform_device(&kempld_platform_data_generic);
-		if (ret)
-			continue;
-
-		break;
+	/*
+	 * This custom DMI iteration allows the driver to be initialized in three ways:
+	 * - When a forced_device_id string matches any ident in the kempld_dmi_table,
+	 *   regardless of whether the DMI device is present in the system dmi table.
+	 * - When a matching entry is present in the DMI system tabe.
+	 * - Through alternative mechanisms like ACPI.
+	 */
+	if (force_device_id[0]) {
+		for (id = kempld_dmi_table; id->matches[0].slot != DMI_NONE; id++)
+			if (strstr(id->ident, force_device_id))
+				if (!kempld_create_platform_device(&kempld_platform_data_generic))
+					break;
+		if (id->matches[0].slot == DMI_NONE)
+			return -ENODEV;
+	} else {
+		for (id = dmi_first_match(kempld_dmi_table); id; id = dmi_first_match(id+1))
+			if (kempld_create_platform_device(&kempld_platform_data_generic))
+				break;
 	}
-	if (ret)
-		return ret;
-
 	return platform_driver_register(&kempld_driver);
 }
 
-- 
2.51.0

