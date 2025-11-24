Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BB32EB85E;
	Mon, 24 Nov 2025 08:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971611; cv=none; b=lpCIrcxVbFKctvolfnXjAVdVfw4nSTfp5yNnImNiUa7sC0ybJCgZonQGj3kEM+I0nIrrOi7SIKCNjTRbkVCpubGDoiZtUHScFigGD35c0WfiudUS1R8NIIR79SxS83WigYp++jbAgGZYRijTDgVR8k3v4lJZ23HCp4b2otpzFQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971611; c=relaxed/simple;
	bh=65ZP82TqVoivAN7YNFb6fzZ2c4nt0HIvTJUTmuQYeuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1f6ShVtRG5odgt9HpI19fDq2o5eMbTidxW+IKabOqa9deEA5WG3D1w56ajyObm66Rds3neRkv5c6pEKVU26QtGUx4OCdOHO6d/cByV4m8Ey0+WGr75HqvNAjG70MA0KE6HiDAxxtgHKZGFRya+lfLFcesU0BI/156IiugHjDl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkL7nvp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkL7nvp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF97FC116D0;
	Mon, 24 Nov 2025 08:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971610;
	bh=65ZP82TqVoivAN7YNFb6fzZ2c4nt0HIvTJUTmuQYeuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkL7nvp+s4UQcYr/IiLZ0vyVbicCRcdOEFWscDGhFlvK0CNAgnOm1X8UdSWoxjoG3
	 dC3Lss6AroibgRsFnEG1VBzA2oq5vZAgP5MvzajYwROMphcjfO+YQyWDxVJZURQuEs
	 D290Ti5zpkmw/+sBwScLMGnXDzpsbz0SwDN7JxtALkPTzAHN5ORHKdAocvgMic7UKv
	 40kjB4DZeElm8OG0ulPaZMoHHdQ/GEX8f5rLsbeFy6wXZKgNURurPMbQyGN9dMsnc+
	 wWUqectgwYuyI4BH9IeLhZ2EXfzfeHeHQJPCR7S3XzENwf0GCISXDPtZQU33+gnlIy
	 H42t330nmDhAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	srinivas.pandruvada@linux.intel.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86: intel-uncore-freq: Add additional client processors
Date: Mon, 24 Nov 2025 03:06:18 -0500
Message-ID: <20251124080644.3871678-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit a229809c18926e79aeca232d5b502157beb0dec3 ]

Add Intel uncore frequency driver support for Pantherlake, Wildcatlake
and Novalake processors.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://patch.msgid.link/20251022211733.3565526-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 1. COMPREHENSIVE ANALYSIS

- **Commit Message Analysis:**
    - **Subject:** "platform/x86: intel-uncore-freq: Add additional
      client processors"
    - **Intent:** The commit explicitly adds support for Intel
      Pantherlake, Wildcatlake, and Novalake processors to the uncore
      frequency driver.
    - **Tags:** No "Fixes:" or "Cc: stable" tags are present. This is
      common for device ID additions, which are often picked up by
      stable maintainers automatically or upon request.

- **Code Inspection:**
    - **File:** `drivers/platform/x86/intel/uncore-frequency/uncore-
      frequency.c`
    - **Change:** Adds 4 entries to the `intel_uncore_cpu_ids[]` array
      using the `X86_MATCH_VFM` macro.
    - **Mechanism:** The driver uses this table to decide whether to
      load. Currently, on these new processors, the driver returns
      `-ENODEV`. This patch allows the driver to initialize
      successfully.
    - **Complexity:** Trivial. It is a data-only change with no logic
      modification.

- **Stable Rules & Exceptions:**
    - **General Rule:** "No new features."
    - **Exception:** "NEW DEVICE IDs (Very Common)". The rules
      explicitly allow adding IDs (PCI, USB, ACPI, etc.) to existing
      drivers to enable hardware support. In the context of x86 platform
      drivers, CPU Vendor-Family-Model (VFM) IDs serve the exact same
      purpose as PCI device IDs.
    - **Applicability:** This commit fits squarely within the Device ID
      exception. It enables an existing driver on new hardware variants
      without changing the driver's core behavior.

- **Risk Assessment:**
    - **Regression Risk:** Negligible. The change is confined to the
      device match table. It does not alter the code path for currently
      supported processors.
    - **Consequence of Failure:** If the IDs are incorrect, the driver
      simply fails to load on the new hardware, preserving the status
      quo.
    - **Dependencies:** The patch uses `X86_MATCH_VFM` and constants
      like `INTEL_NOVALAKE`.
        - *Critical Technical Note:* The `X86_MATCH_VFM` infrastructure
          was introduced to support CPU families beyond Family 6 (Nova
          Lake is Family 18). Target stable trees must have this
          infrastructure and the corresponding
          `arch/x86/include/asm/intel-family.h` definitions. For very
          old stable trees (pre-VFM infrastructure), backporting would
          be complex; for modern stable trees (like 6.6.y or the
          hypothetical 6.17.y), this is straightforward.

### 2. DETAILED EXPLANATION

This commit is a strong candidate for backporting based on the "New
Device IDs" exception in the stable kernel rules.

**Problem Solved:**
Users running stable kernels on newer Intel hardware (Pantherlake,
Wildcatlake, Novalake) currently have no access to uncore frequency
controls because the driver does not recognize their CPUs. This limits
power management and performance tuning capabilities that are standard
on older platforms.

**Stable Kernel Rules Compliance:**
1. **Exception Category:** This falls under **Exception 1: NEW DEVICE
   IDs**. While technically a "feature" (enablement), the stable rules
   explicitly permit adding IDs to existing drivers to support new
   hardware, provided the driver itself isn't being rewritten.
2. **Obviously Correct:** The change adds four lines of data to a match
   table. It is minimal and surgical.
3. **Low Risk:** There is zero risk to existing users. The code path for
   supported CPUs remains identical. The new entries only activate on
   the specific new CPU models.

**Caveats & Dependencies:**
- **VFM Infrastructure:** The patch relies on the `X86_MATCH_VFM` macro.
  Ensure the target stable tree supports this macro (introduced to
  handle non-Family-6 CPUs like Nova Lake).
- **Header Definitions:** The target tree must have the updated
  `arch/x86/include/asm/intel-family.h` containing
  `INTEL_PANTHERLAKE_L`, `INTEL_NOVALAKE`, etc. These are typically
  backported, but verify their existence before applying this patch.

**Conclusion:**
This is a standard, low-risk hardware enablement patch that provides
necessary functionality for users on new platforms without endangering
existing setups.

**YES**

 .../platform/x86/intel/uncore-frequency/uncore-frequency.c    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 2a6897035150c..0dfc552b28024 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -256,6 +256,10 @@ static const struct x86_cpu_id intel_uncore_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ARROWLAKE, NULL),
 	X86_MATCH_VFM(INTEL_ARROWLAKE_H, NULL),
 	X86_MATCH_VFM(INTEL_LUNARLAKE_M, NULL),
+	X86_MATCH_VFM(INTEL_PANTHERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_WILDCATLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_NOVALAKE, NULL),
+	X86_MATCH_VFM(INTEL_NOVALAKE_L, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_cpu_ids);
-- 
2.51.0

