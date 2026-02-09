Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66CA3019CB;
	Mon,  9 Feb 2026 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640053; cv=none; b=D/+KjX5eA3n1k/M6h2umKUG9IksszrMn2BNLvv7fnQ3EMtwKyeDPNKQ7Dvi5TLHFnmQ2e8CMMAKCcUrxY3ljgzl3FceJ6Y4/aaKqW9vSCJ0mhgSaa+8Bq7cCNtXlEpMnUpPI/3FN72IKpQtdDeNDc1T0DjvX1SlKx8FI0Miu9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640053; c=relaxed/simple;
	bh=WgqiWVoHlPsT7FIc5ByMzq7REt3FLkvnK/cYU1bi2ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfWV3HXM46dRujXmF/mMdO/rXRMqAguQ+rdK2jXD2Bqu04XtaQ7sia4uBcg6tN44sXDn0AVn24QpsHW1VGRxkzobWfCw/4EWp1Hkxcwu7R2NIDrG3S2ROeJ46PlZ0Fqev3N8biAlhNQpT1LfIebVjsGkUlYmh0gEAntQHy2f3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uuh1ROzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uuh1ROzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B735CC16AAE;
	Mon,  9 Feb 2026 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640053;
	bh=WgqiWVoHlPsT7FIc5ByMzq7REt3FLkvnK/cYU1bi2ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uuh1ROzGRhjFu/DtTNevjfcQTG7ztxPCh1nYFv6eQnfhlP23WhZM88SNX1u3IbLwR
	 rs2ftY8dNWGjlIcJMoo+a0yqduWhIfC12Kym8JTyMPLlQBksUwnwOntVxqQCJklanx
	 s+ftOJ+YxAsZVzQiZaqB9TXU0G4WxgRN25PnwoRo62F38nSotrvuSHUfxeHNZWBOUk
	 N9hPFk86drUz54TihgqcYUjSUOAgk4pSlembHJzeOiw6/290k5CYFTzLGdYv9+sANR
	 PFVoJOasZrF64wTJlMPpdonp6AUXVIDkzKMgWSBIM9dVGgafCF1Fe20EYwndHPZ5Vh
	 P5pcAh8+O693A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brahmajit Das <listout@listout.xyz>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	mperttunen@nvidia.com,
	jonathanh@nvidia.com,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] =?UTF-8?q?drm/tegra:=20hdmi:=20sor:=20F?= =?UTF-8?q?ix=20error:=20variable=20=E2=80=98j=E2=80=99=20set=20but=20not?= =?UTF-8?q?=20used?=
Date: Mon,  9 Feb 2026 07:26:49 -0500
Message-ID: <20260209122714.1037915-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 1beee8d0c263b3e239c8d6616e4f8bb700bed658 ]

The variable j is set, however never used in or outside the loop, thus
resulting in dead code.
Building with GCC 16 results in a build error due to
-Werror=unused-but-set-variable= enabled by default.
This patch clean up the dead code and fixes the build error.

Example build log:
drivers/gpu/drm/tegra/sor.c:1867:19: error: variable ‘j’ set but not used [-Werror=unused-but-set-variable=]
 1867 |         size_t i, j;
      |                   ^

Signed-off-by: Brahmajit Das <listout@listout.xyz>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250901212020.3757519-1-listout@listout.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: drm/tegra: hdmi: sor: Fix error: variable 'j' set
but not used

### 1. Commit Message Analysis

The commit message explicitly states this is a **build fix** for GCC 16,
which enables `-Werror=unused-but-set-variable=` by default. The commit
removes dead code (an unused variable `j`) to fix a compilation error.

Key indicators:
- "Fix error" - indicates a build failure
- "Building with GCC 16 results in a build error" - explicit mention of
  build breakage
- Provides concrete build log showing the error

### 2. Code Change Analysis

The changes are minimal and purely mechanical:

**In `drivers/gpu/drm/tegra/hdmi.c`:**
- Line 660: Changes `size_t i, j;` to `size_t i;`
- Line 693: Changes `for (i = 3, j = 0; i < size; i += 7, j += 8)` to
  `for (i = 3; i < size; i += 7)`

**In `drivers/gpu/drm/tegra/sor.c`:**
- Line 1866: Changes `size_t i, j;` to `size_t i;`
- Line 1899: Changes `for (i = 3, j = 0; i < size; i += 7, j += 8)` to
  `for (i = 3; i < size; i += 7)`

The variable `j` was:
1. Declared but never used anywhere
2. Incremented in the loop (`j += 8`) but the value was never read
3. Pure dead code that has no functional impact

### 3. Classification

This is a **build fix** - one of the explicit exception categories that
ARE allowed in stable:

> **BUILD FIXES:**
> - Fixes for compilation errors or warnings, Kconfig dependency fixes,
include file fixes
> - These are critical for users who need to build the kernel

### 4. Scope and Risk Assessment

- **Lines changed:** ~4 lines total (2 per file)
- **Files affected:** 2 files in the same subsystem (Tegra DRM driver)
- **Risk level:** Extremely low
- **Complexity:** None - purely removes unused code
- **Behavioral change:** None - the variable was never used

This is one of the lowest-risk changes possible:
- No logic changes
- No control flow changes
- No memory management changes
- Simply removing dead code that was never executed meaningfully

### 5. User Impact

**Who is affected:**
- Anyone trying to build the kernel with GCC 16
- Tegra (NVIDIA) platform users who need HDMI output

**Severity:**
- Without this fix, the kernel fails to compile with newer GCC versions
- This blocks users from building the kernel entirely

### 6. Stability Indicators

- Signed-off by the subsystem maintainer (Thierry Reding from NVIDIA)
- Link to the mailing list discussion provided
- The change is trivial and obviously correct

### 7. Dependency Check

- No dependencies on other commits
- The affected code (Tegra DRM HDMI/SOR drivers) exists in stable trees
- The fix is self-contained

### Conclusion

This commit meets all stable kernel criteria for a **build fix**:

1. **Obviously correct:** The variable `j` was declared, incremented,
   but never read - pure dead code
2. **Fixes a real bug:** Build failure with GCC 16
3. **Small and contained:** Only 4 lines changed across 2 related files
4. **No new features:** Removes unused code
5. **No risk of regression:** Cannot change behavior since the removed
   code was never used

Build fixes are explicitly allowed in stable trees because they are
critical for users who need to build the kernel. As GCC 16 becomes more
widely used (and is now the default compiler in some distributions),
this fix will become essential for anyone building the kernel.

The fix is trivial, obviously correct, and fixes a real build failure.
It has zero risk of causing runtime regressions since it only removes
dead code.

**YES**

 drivers/gpu/drm/tegra/hdmi.c | 4 ++--
 drivers/gpu/drm/tegra/sor.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 8cd2969e7d4bf..c4820f5e76581 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -658,7 +658,7 @@ static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi, const void *data,
 {
 	const u8 *ptr = data;
 	unsigned long offset;
-	size_t i, j;
+	size_t i;
 	u32 value;
 
 	switch (ptr[0]) {
@@ -691,7 +691,7 @@ static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi, const void *data,
 	 * - subpack_low: bytes 0 - 3
 	 * - subpack_high: bytes 4 - 6 (with byte 7 padded to 0x00)
 	 */
-	for (i = 3, j = 0; i < size; i += 7, j += 8) {
+	for (i = 3; i < size; i += 7) {
 		size_t rem = size - i, num = min_t(size_t, rem, 4);
 
 		value = tegra_hdmi_subpack(&ptr[i], num);
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 21f3dfdcc5c95..bc7dd562cf6b6 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1864,7 +1864,7 @@ static void tegra_sor_hdmi_write_infopack(struct tegra_sor *sor,
 {
 	const u8 *ptr = data;
 	unsigned long offset;
-	size_t i, j;
+	size_t i;
 	u32 value;
 
 	switch (ptr[0]) {
@@ -1897,7 +1897,7 @@ static void tegra_sor_hdmi_write_infopack(struct tegra_sor *sor,
 	 * - subpack_low: bytes 0 - 3
 	 * - subpack_high: bytes 4 - 6 (with byte 7 padded to 0x00)
 	 */
-	for (i = 3, j = 0; i < size; i += 7, j += 8) {
+	for (i = 3; i < size; i += 7) {
 		size_t rem = size - i, num = min_t(size_t, rem, 4);
 
 		value = tegra_sor_hdmi_subpack(&ptr[i], num);
-- 
2.51.0

