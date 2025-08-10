Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B00272E54;
	Sun, 10 Aug 2025 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844738; cv=none; b=IHn6TK+SYT8zlJGpVTmHKlBvitxrJc+OMp6nZjHsYKaUCMfqOC0fO5UxdnrqZFQVmhVayQl2qMPHkNF3T4V0+ygZG5M3Uls+SDHXwYlFJ3t+DEaWYui3fzhqbISOMIxYQ1o4Z5vckgMwYFznww1s2OpCfQPAuKftJEC05mrQZ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844738; c=relaxed/simple;
	bh=SOqAd6GSoq3jfNfyFntbJVMfeCR8Kes0pVVn6yUAE6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cPAKkx2TYbPOV7qpVQvCd+uY9N6q+pXOgE7P276xjygvFsZJFxZ6zFfapu/dXXf5QyNrjXFByle4btKZcWtuz1UmvJ4HM/RhaK91VRmdjxblQQctrM3Vv9DB+t5YarqkvPv1RArTsP4Ky6yX62GPj9HGrZahHkK6POX4bDFRIik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdUR/8ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdUR/8ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E12C4CEF7;
	Sun, 10 Aug 2025 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844735;
	bh=SOqAd6GSoq3jfNfyFntbJVMfeCR8Kes0pVVn6yUAE6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdUR/8adHusZ7znXZgEtaJgkw4VknIh4lE5q6Z6acZ0OSYpyoR8qLLizgpj98ZoPE
	 gly5Q3EsT5jsBYz8ucO+4Uj/uK9yAa0QulALQArzLZ1eJiKgRmXkROIRmc8yCth5Vj
	 7EmtkQqgPnJBKq54yYjjOj/wxhkE1dxeHBpscDaXlzSBgW7beWr1kQAIEAFbSKNqil
	 hJTzVOa+q1UAkPj36MpOOS7ySRfavWbhoYmSqTrY5rb66Otbfz4YrsnHC3hQu/hCUa
	 7JgShRfvOb711zmUgqtFVmZxItXQWjbkX15uXcmsr8w6G+roR43OSHHUWRb/Dv+KsN
	 Uj5//s/YBoKfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	liam.r.girdwood@linux.intel.com,
	phasta@kernel.org,
	tiwai@suse.de,
	sakari.ailus@linux.intel.com
Subject: [PATCH AUTOSEL 6.16-6.1] ASoC: Intel: avs: Fix uninitialized pointer error in probe()
Date: Sun, 10 Aug 2025 12:51:47 -0400
Message-Id: <20250810165158.1888206-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 11f74f48c14c1f4fe16541900ea5944c42e30ccf ]

If pcim_request_all_regions() fails, error path operates on
uninitialized 'bus' pointer. Found out by Coverity static analyzer.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250730124906.351798-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

## Extensive Analysis:

This commit is an excellent candidate for backporting to stable kernel
trees based on the following analysis:

### 1. **Clear Bug Fix for Uninitialized Pointer Access**
The commit fixes a serious bug where an uninitialized `bus` pointer
could be dereferenced in error paths. Looking at the original code flow:
- Line 427: `struct hdac_bus *bus;` declares the pointer without
  initialization
- Line 455-457: If `pcim_request_all_regions()` fails and returns an
  error, the function returns immediately
- **Critical Issue**: At this point, `bus` has never been initialized
  (line 459 `bus = &adev->base.core;` would not be reached)
- However, any error handling code that tries to use `bus` would crash
  with a null/uninitialized pointer dereference

### 2. **Minimal and Contained Fix**
The fix is extremely simple and surgical:
- Moves one line of code (`bus = &adev->base.core;`) from after the
  `pcim_request_all_regions()` call to immediately after `adev`
  allocation
- This ensures `bus` is properly initialized before any potential error
  path that might use it
- The change is only 2 lines (one deletion, one addition in a different
  location)

### 3. **No Functional Changes or Side Effects**
- The fix doesn't change any logic or behavior in the success path
- It merely ensures proper initialization order to prevent crashes
- No new features or architectural changes are introduced
- The initialization still happens at the same logical point in the flow
  (after `adev` is allocated and `avs_bus_init` succeeds)

### 4. **Found by Static Analysis**
The commit message explicitly states this was "Found out by Coverity
static analyzer", which indicates:
- This is a real potential crash/security issue identified by automated
  tooling
- Static analyzers are good at finding these initialization order bugs
- The bug might be difficult to trigger in practice but represents a
  real vulnerability

### 5. **Affects Critical Audio Subsystem**
This is in the Intel AVS (Audio Voice Speech) driver probe function,
which:
- Is part of system initialization for Intel audio hardware
- A crash here could prevent audio subsystem from initializing
- Could affect system stability on affected Intel platforms

### 6. **Clear Stable Tree Criteria Met**
This commit meets multiple stable kernel criteria:
- ✅ Fixes a real bug (uninitialized pointer dereference)
- ✅ Minimal change (2 lines moved)
- ✅ No new features
- ✅ Low risk of regression (initialization order fix)
- ✅ Could cause crashes/oops in error conditions
- ✅ Found by static analysis (indicates real issue)

### 7. **Error Path Vulnerability**
While the bug only manifests in error conditions (when
`pcim_request_all_regions()` fails), error path bugs are particularly
important to fix because:
- They can be triggered by resource exhaustion or hardware issues
- They can potentially be exploited for denial of service
- They make debugging other issues more difficult when the error handler
  itself crashes

This is a textbook example of a commit that should be backported to
stable trees - it fixes a clear bug with minimal risk and no functional
changes.

 sound/soc/intel/avs/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index ec1b3f55cb5c..d45e9279df27 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -446,6 +446,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	adev = devm_kzalloc(dev, sizeof(*adev), GFP_KERNEL);
 	if (!adev)
 		return -ENOMEM;
+	bus = &adev->base.core;
+
 	ret = avs_bus_init(adev, pci, id);
 	if (ret < 0) {
 		dev_err(dev, "failed to init avs bus: %d\n", ret);
@@ -456,7 +458,6 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret < 0)
 		return ret;
 
-	bus = &adev->base.core;
 	bus->addr = pci_resource_start(pci, 0);
 	bus->remap_addr = pci_ioremap_bar(pci, 0);
 	if (!bus->remap_addr) {
-- 
2.39.5

