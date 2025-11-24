Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2032EB866;
	Mon, 24 Nov 2025 08:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971624; cv=none; b=WwtnmTG0S96GLF8KtR0OtGvOIqBceHj+TAi/iBkBP8LIMAs5CNB4+uYSQcoMZgHrAfqZOu2W33BCQO9MNPfzrN/WbML25F0ixIiqytIdm/7YOS1YiqNQo5Q84kOPnpRN989jTetl9umNG21eB0eeW7BY+Hn7+jb0ZC3viX/Rs+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971624; c=relaxed/simple;
	bh=HrWN0JULeZEjRCglAGQf/IgDCXBz5Qpz3RTgJZgULwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XU2cojqv+U/ZN69NbKmNcx4Exr2fUvIfKXYBhLbPuKlZWOiUSYPfcJEQe2Un+cCCOi6p076auWyiCaO8jsN7cLh5aiApGS1rIcMurlyrRC/DL+ZU4MwIRwPZ0NnG2RqZeGmUJzK/KOwrRSzb8MEa11ehkwQemQ+ulNV2SoabTes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSaQ66Xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSaQ66Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CA0C16AAE;
	Mon, 24 Nov 2025 08:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971624;
	bh=HrWN0JULeZEjRCglAGQf/IgDCXBz5Qpz3RTgJZgULwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSaQ66Xlxzt/ulwu3bBWKBFQ45LFEyO5HLl3vg4HVazXIt/wE8mmt2X96dwHPzu+I
	 CDFU2zpAHvSK9s3mG1IJj1GqYCMiU2ukHo//pazlQxfugWOJaRHG5L4z4NczJrXqFz
	 88LSREZuUQ29X7uI/G6bSilVfqybjqwKEIra6F9m93zKU0WEwa2lejxCbiqsaSoJ7g
	 Pz/+TFXMCeE5v3DNFumSrdZN+8ThaOGu6cIF8W9jZv2po930hq1hdrVDtk3Ndh2X1z
	 GgdNlE+m8vV1rTUQFT+62T+W1+W+0EDuS2KClgvV7jGDr2VnQs1AmW65mCFfzTmX05
	 Z1QUGRjd7G4xQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86/amd/pmc: Add support for Van Gogh SoC
Date: Mon, 24 Nov 2025 03:06:25 -0500
Message-ID: <20251124080644.3871678-11-sashal@kernel.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit db4a3f0fbedb0398f77b9047e8b8bb2b49f355bb ]

The ROG Xbox Ally (non-X) SoC features a similar architecture to the
Steam Deck. While the Steam Deck supports S3 (s2idle causes a crash),
this support was dropped by the Xbox Ally which only S0ix suspend.

Since the handler is missing here, this causes the device to not suspend
and the AMD GPU driver to crash while trying to resume afterwards due to
a power hang.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4659
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20251024152152.3981721-2-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Comprehensive Analysis

1. **Commit Message Analysis**
    - **Issue:** Devices using the AMD Van Gogh SoC (specifically
      mentioned is the "ROG Xbox Ally") fail to suspend properly. The
      system suffers a "power hang" and the AMD GPU driver crashes upon
      resume attempts.
    - **Cause:** The `amd_pmc` platform driver lacks the necessary
      identifiers and handlers for this specific SoC model.
    - **Context:** This is a bug fix for broken hardware functionality
      (suspend/resume), despite the subject line saying "Add support".
    - **External References:** Links to a specific bug report on GitLab
      (#4659).

2. **Code Changes & Technical Deep Dive**
    - **The Bug Mechanism:** The current stable driver is missing the
      PCI Device ID `0x1645` (Van Gogh). Consequently, `pci_match_id()`
      in `amd_pmc_probe` fails, and the driver never loads. Even if
      forced, `amd_pmc_get_os_hint()` would return `-EINVAL`, causing
      `amd_pmc_s2idle_prepare()` to fail or send incorrect messages to
      the System Management Unit (SMU).
    - **The Fix:**
        - Adds `AMD_CPU_ID_VG` (0x1645) to `pmc.h`.
        - Adds the ID to `pmc_pci_ids[]` table, allowing the driver to
          bind.
        - Adds cases to `amd_pmc_get_ip_info` and `amd_pmc_get_os_hint`
          to treat Van Gogh identically to Renoir (RN) and Yellow Carp
          (YC) SoCs.
    - **Scope:** The changes are extremely localized (approx. 5 lines of
      code added). It uses existing, proven code paths.

3. **Stable Kernel Rules Compliance**
    - **Criterion:** "It must NOT introduce new features".
    - **Exception:** **NEW DEVICE IDs**. The stable rules explicitly
      allow "Adding PCI IDs... to existing drivers" to enable hardware
      support. This commit falls squarely into this category.
    - **Criterion:** "It must fix a real bug".
    - **Met:** Yes, it fixes a system crash/hang on suspend.
    - **Criterion:** "It must be obviously correct".
    - **Met:** Yes, it simply maps a new ID to existing logic verified
      on similar hardware.

4. **Risk vs. Benefit**
    - **Benefit:** High. Fixes a critical usability issue (unable to
      suspend/resume) and prevents kernel crashes for users of popular
      handheld gaming devices.
    - **Risk:** Extremely Low. The change is guarded by the specific CPU
      ID. It does not alter logic for any currently supported hardware.
    - **Dependencies:** None. The driver structure and constants
      (`soc15_ip_blk`, `MSG_OS_HINT_RN`) are already present in stable
      trees (e.g., 6.1, 6.6).

5. **Conclusion**
  This is a textbook candidate for stable backporting. It addresses a
  hardware-specific crash by adding a missing PCI ID and routing it
  through existing driver logic, which is a permitted exception to the
  "no new features" rule.

**YES**

 drivers/platform/x86/amd/pmc/pmc.c | 3 +++
 drivers/platform/x86/amd/pmc/pmc.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index bd318fd02ccf4..cae3fcafd4d7b 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -106,6 +106,7 @@ static void amd_pmc_get_ip_info(struct amd_pmc_dev *dev)
 	switch (dev->cpu_id) {
 	case AMD_CPU_ID_PCO:
 	case AMD_CPU_ID_RN:
+	case AMD_CPU_ID_VG:
 	case AMD_CPU_ID_YC:
 	case AMD_CPU_ID_CB:
 		dev->num_ips = 12;
@@ -517,6 +518,7 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
 	case AMD_CPU_ID_PCO:
 		return MSG_OS_HINT_PCO;
 	case AMD_CPU_ID_RN:
+	case AMD_CPU_ID_VG:
 	case AMD_CPU_ID_YC:
 	case AMD_CPU_ID_CB:
 	case AMD_CPU_ID_PS:
@@ -717,6 +719,7 @@ static const struct pci_device_id pmc_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_RV) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_SP) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_SHP) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_VG) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_ROOT) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M60H_ROOT) },
 	{ }
diff --git a/drivers/platform/x86/amd/pmc/pmc.h b/drivers/platform/x86/amd/pmc/pmc.h
index 62f3e51020fdf..fe3f53eb59558 100644
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -156,6 +156,7 @@ void amd_mp2_stb_deinit(struct amd_pmc_dev *dev);
 #define AMD_CPU_ID_RN			0x1630
 #define AMD_CPU_ID_PCO			AMD_CPU_ID_RV
 #define AMD_CPU_ID_CZN			AMD_CPU_ID_RN
+#define AMD_CPU_ID_VG			0x1645
 #define AMD_CPU_ID_YC			0x14B5
 #define AMD_CPU_ID_CB			0x14D8
 #define AMD_CPU_ID_PS			0x14E8
-- 
2.51.0

