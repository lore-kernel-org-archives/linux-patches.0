Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7ED30E0C0;
	Sat, 25 Oct 2025 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409429; cv=none; b=HGXOKibKTVZJdI2XCRLELy6RH9Fqpk8rgJXopCoO4IfforkgENfnTjpva8fTxqeDHqYB4qPXNrerxVBEy87rGw59WGp97J/sWAPrvnp+vXEoj89EHr3ADwMjhKfImvEzRGV7jBHI8NHQ3dpCQjxZIWak/gU/9eEvQjZxI5hJepQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409429; c=relaxed/simple;
	bh=HAtfav786qfTN4ra92Tf4OsGlerwhsllvxUx0UfRuuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P54JpWxdnXoX/sYvgELSJBv901cns6B62KSzRdSf2nSYpRIFu6fVSB70rV317uApwhZK9aiOzDMPy8giZvma6e5MonsDWxnHhB8jEBkjBMCeYyilX3jaw090Vl8PZ9zOBH385KwpSmx3O0SD7phMCfCNa/dSn6TTLS+sUH0xUnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=it0rmmut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="it0rmmut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391C4C4CEFB;
	Sat, 25 Oct 2025 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409429;
	bh=HAtfav786qfTN4ra92Tf4OsGlerwhsllvxUx0UfRuuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=it0rmmut8PvdNXSYLvb9RoNAbavNlzc42ZeMN/pTbDJ/lVPAP3/0n/or6DFIuv8Hf
	 i6Y+kL+Vg/bEoK16gGDgrdCHj3KEX+v9YiHeoXApxLDzusabnqtS+DGiNzALShEkdI
	 OD4Bu0M1JGr5hKID9dcDlH7dmXYmB8ESlkBxLTRtnImqp5RMW7WVCGkRAtiEljpK0S
	 JztCTURrGCblcKD/uf1pQAm5j79AuccqACaFjVMrzXSTb1IXLZ04CkX7bY1MHtV7rR
	 7zB5BkSTILJv5neprs2xPhaQb7l2tygrbzHe/LM7Gh3GS79spLrgRDlx02vuz6BjMo
	 mIJ0kAfghB3Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	ganglxie@amd.com,
	lijo.lazar@amd.com,
	candice.li@amd.com,
	victor.skvortsov@amd.com,
	alexandre.f.demers@gmail.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: add range check for RAS bad page address
Date: Sat, 25 Oct 2025 11:59:13 -0400
Message-ID: <20251025160905.3857885-322-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 2b17c240e8cd9ac61d3c82277fbed27edad7f002 ]

Exclude invalid bad pages.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Centralizes and strengthens address validation for RAS bad pages so
    invalid addresses are rejected early and consistently, and invalid
    EEPROM entries are excluded. Previously, validity checks were
    duplicated at some call sites and missing in others.
  - Prevents invalid “bad pages” from being considered/processed (e.g.,
    loaded from EEPROM or used in injection), which could lead to
    incorrect reservations or error injection behavior.

- Key code changes
  - Return type change and range check
    - Changes `amdgpu_ras_check_bad_page_unlock()` and
      `amdgpu_ras_check_bad_page()` from `bool` to `int` and adds an
      explicit address range check. Now returns:
      - `-EINVAL` for invalid addresses
      - `1` if the page is already bad
      - `0` otherwise
    - In your tree, the current declarations are `bool`
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:137,
      drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:139) and definitions are
      `bool` with no range check
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:2777,
      drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:2796).
    - The added range check uses `adev->gmc.mc_vram_size` and
      `RAS_UMC_INJECT_ADDR_LIMIT` (already defined in your tree at
      drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:110), so it is aligned
      with existing constraints elsewhere in the file.

  - Reserve page path
    - `amdgpu_reserve_page_direct()` currently performs its own invalid
      address check and separately checks whether the page was already
      marked bad (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:164–189). The
      patch replaces these ad hoc checks by calling the updated
      `amdgpu_ras_check_bad_page()` once and branching on its return
      value. Behaviorally equivalent for valid/invalid, but more robust
      and less error-prone.

  - Debugfs inject path
    - In `amdgpu_ras_debugfs_ctrl_write()` “case 2” (inject), your tree
      rejects invalid addresses for all blocks
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:508–518) and then
      prohibits UMC injection into already-bad pages
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:522–528).
    - The patch refines this:
      - Only UMC injections are gated by address range validity (via the
        updated `amdgpu_ras_check_bad_page()`), which is correct since
        the address field is meaningful for UMC but not necessarily used
        for other blocks.
      - If `amdgpu_ras_check_bad_page()` returns `-EINVAL`, warns about
        invalid input; if it returns `1`, warns about already-bad page.
        This prevents false “invalid address” rejections for non-UMC
        blocks and preserves correct UMC validations.

  - Excluding invalid entries when loading/saving bad pages
    - `amdgpu_ras_add_bad_pages()` uses
      `amdgpu_ras_check_bad_page_unlock()` to skip duplicates
      (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:2660–2704). With the new
      semantics, a return of `-EINVAL` is nonzero and thus treated as
      “skip,” effectively filtering out invalid entries sourced from
      EEPROM. This matches the commit message “Exclude invalid bad
      pages.”

- Why this is a good stable backport
  - Small, self-contained change in a single file (`amdgpu_ras.c`), with
    no architectural changes.
  - Fixes real-world correctness/safety issues:
    - Invalid addresses are consistently rejected, avoiding possible
      incorrect reservations or injections.
    - Invalid EEPROM-stored entries are ignored instead of processed.
    - Non-UMC injection no longer gets spuriously blocked by a VRAM
      address check that is irrelevant for those blocks.
  - All modified functions are `static` and localized, minimizing
    regression risk.
  - The semantics of debugfs (not a stable ABI) are improved in a way
    that reduces surprising failures, and core RAS boot-time behavior
    improves by excluding bad invalid entries.

- Dependencies and backport notes
  - The upstream context in your diff shows a newer signature for
    `amdgpu_ras_add_bad_pages()` (an extra boolean) than in your tree
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:2665). This commit itself
    does not depend on that signature change; it can be adapted
    trivially by:
    - Changing the two `bool` declarations/definitions to `int` and
      adding the range check in `amdgpu_ras_check_bad_page_unlock()`.
    - Updating the callers to handle `-EINVAL` vs `1` vs `0` as shown in
      the diff, while keeping your existing `amdgpu_ras_add_bad_pages()`
      signature.
  - No impact beyond AMDGPU RAS paths; no user ABI changes.

- Risk assessment
  - Low: Types change from `bool` to `int` on `static` functions;
    existing call sites in this file are updated; other uses that test
    in a boolean context will still treat `-EINVAL` as true (nonzero),
    which is intentionally leveraged to skip invalid entries when
    loading bad pages.
  - Improves robustness and reduces incorrect behavior; unlikely to
    cause regressions in supported stable trees.

Given the above, this is a clear bugfix with minimal risk and targeted
scope, and it improves correctness and safety. It meets stable criteria
and should be backported.

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 58 ++++++++++++-------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 540817e296da6..c88123302a071 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -136,9 +136,9 @@ enum amdgpu_ras_retire_page_reservation {
 
 atomic_t amdgpu_ras_in_intr = ATOMIC_INIT(0);
 
-static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
+static int amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
 				uint64_t addr);
-static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
+static int amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 				uint64_t addr);
 #ifdef CONFIG_X86_MCE_AMD
 static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev);
@@ -169,18 +169,16 @@ static int amdgpu_reserve_page_direct(struct amdgpu_device *adev, uint64_t addre
 	struct eeprom_table_record err_rec;
 	int ret;
 
-	if ((address >= adev->gmc.mc_vram_size) ||
-	    (address >= RAS_UMC_INJECT_ADDR_LIMIT)) {
+	ret = amdgpu_ras_check_bad_page(adev, address);
+	if (ret == -EINVAL) {
 		dev_warn(adev->dev,
-		         "RAS WARN: input address 0x%llx is invalid.\n",
-		         address);
+			"RAS WARN: input address 0x%llx is invalid.\n",
+			address);
 		return -EINVAL;
-	}
-
-	if (amdgpu_ras_check_bad_page(adev, address)) {
+	} else if (ret == 1) {
 		dev_warn(adev->dev,
-			 "RAS WARN: 0x%llx has already been marked as bad page!\n",
-			 address);
+			"RAS WARN: 0x%llx has already been marked as bad page!\n",
+			address);
 		return 0;
 	}
 
@@ -513,22 +511,16 @@ static ssize_t amdgpu_ras_debugfs_ctrl_write(struct file *f,
 		ret = amdgpu_ras_feature_enable(adev, &data.head, 1);
 		break;
 	case 2:
-		if ((data.inject.address >= adev->gmc.mc_vram_size &&
-		    adev->gmc.mc_vram_size) ||
-		    (data.inject.address >= RAS_UMC_INJECT_ADDR_LIMIT)) {
-			dev_warn(adev->dev, "RAS WARN: input address "
-					"0x%llx is invalid.",
+		/* umc ce/ue error injection for a bad page is not allowed */
+		if (data.head.block == AMDGPU_RAS_BLOCK__UMC)
+			ret = amdgpu_ras_check_bad_page(adev, data.inject.address);
+		if (ret == -EINVAL) {
+			dev_warn(adev->dev, "RAS WARN: input address 0x%llx is invalid.",
 					data.inject.address);
-			ret = -EINVAL;
 			break;
-		}
-
-		/* umc ce/ue error injection for a bad page is not allowed */
-		if ((data.head.block == AMDGPU_RAS_BLOCK__UMC) &&
-		    amdgpu_ras_check_bad_page(adev, data.inject.address)) {
-			dev_warn(adev->dev, "RAS WARN: inject: 0x%llx has "
-				 "already been marked as bad!\n",
-				 data.inject.address);
+		} else if (ret == 1) {
+			dev_warn(adev->dev, "RAS WARN: inject: 0x%llx has already been marked as bad!\n",
+					data.inject.address);
 			break;
 		}
 
@@ -3134,18 +3126,24 @@ static int amdgpu_ras_load_bad_pages(struct amdgpu_device *adev)
 	return ret;
 }
 
-static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
+static int amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
 				uint64_t addr)
 {
 	struct ras_err_handler_data *data = con->eh_data;
+	struct amdgpu_device *adev = con->adev;
 	int i;
 
+	if ((addr >= adev->gmc.mc_vram_size &&
+	    adev->gmc.mc_vram_size) ||
+	    (addr >= RAS_UMC_INJECT_ADDR_LIMIT))
+		return -EINVAL;
+
 	addr >>= AMDGPU_GPU_PAGE_SHIFT;
 	for (i = 0; i < data->count; i++)
 		if (addr == data->bps[i].retired_page)
-			return true;
+			return 1;
 
-	return false;
+	return 0;
 }
 
 /*
@@ -3153,11 +3151,11 @@ static bool amdgpu_ras_check_bad_page_unlock(struct amdgpu_ras *con,
  *
  * Note: this check is only for umc block
  */
-static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
+static int amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 				uint64_t addr)
 {
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
-	bool ret = false;
+	int ret = 0;
 
 	if (!con || !con->eh_data)
 		return ret;
-- 
2.51.0

