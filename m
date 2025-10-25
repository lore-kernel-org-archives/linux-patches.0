Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D343093C1;
	Sat, 25 Oct 2025 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409743; cv=none; b=YtKy+c1UmYncBU6CBjqbs7fb1Ca8GMI08dR5+kQ1uXA2WKzeQbikLR+VSP3SOm6M1teDexviomAo7HYbhy66NNHgI87HbP4uWCFKE0UdaA9zfYoqj6RP5ia5/ya4UPwxVCXwHa2jHcpMpjQ4jNbkNRgwWvjLA/wys+jya/ndKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409743; c=relaxed/simple;
	bh=gtB4My9xNPJe49k+2kiGNFIt+E+DTr869ijIgZM1dvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uTWIQXyX5D4EwGH3F1IU1+bJMOiRtge91rNSIWwwNb5bAKCbh11kc5VEPSNZoB6kQDoJC5+FP0p2a8C0RMM3FBXUxwIZ1lGklz2VI/WEUZ3ab2/qY4vPqKbI/iVEGDPMg3Ld+0XU0B6yUE4Y62sQv8GNYydeGHicoqHTQIjEmiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1sot9w4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1sot9w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CCAC4CEF5;
	Sat, 25 Oct 2025 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409741;
	bh=gtB4My9xNPJe49k+2kiGNFIt+E+DTr869ijIgZM1dvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1sot9w45aNf8GJ9FlEAUq/o8Va4kJfrKvcgKYLZMTN0zFqiTRWv0umgblMQClsD/
	 IYXogTpgXPCiTmuvHZCtlkop6353C72ZgN2IvzTrerI0iKx6ANY6Edyom7+JqVV93H
	 fnxzXYqUs5CPYPkLlSQZ41Gk3lNaF9SN3EktVvhyzyK92RLPsevEMkOFch9khSTqT4
	 BcvNnuT7MglucIK27WfVkvSNWTerdWo5YhcHqPCqp73hTF8A1pnHWbu7tZZW1GxAcC
	 g0nP9judjMtAMjfSBfEG/fTzeP7vQncotD1ru3CmWdveXtNNFCtsuq9kfTyP/FanBu
	 Tz4z7XzMwDe4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Harrison <John.C.Harrison@Intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	michal.wajdeczko@intel.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/xe/guc: Add more GuC load error status codes
Date: Sat, 25 Oct 2025 12:01:16 -0400
Message-ID: <20251025160905.3857885-445-sashal@kernel.org>
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

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 45fbb51050e72723c2bdcedc1ce32305256c70ed ]

The GuC load process will abort if certain status codes (which are
indicative of a fatal error) are reported. Otherwise, it keeps waiting
until the 'success' code is returned. New error codes have been added
in recent GuC releases, so add support for aborting on those as well.

v2: Shuffle HWCONFIG_START to the front of the switch to keep the
ordering as per the enum define for clarity (review feedback by
Jonathan). Also add a description for the basic 'invalid init data'
code which was missing.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250726024337.4056272-1-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a good stable backport
- Fixes real-world hangs/timeouts: New GuC firmware versions can report
  additional fatal load status codes. Without this patch, the Xe driver
  may continue waiting until the generic timeout, causing long delays
  and poorer diagnostics. Recognizing these as terminal failures is a
  correctness and robustness fix, not a feature.
- Small and contained: Changes are limited to two Xe files, only
  touching enums and switch cases that read GuC status. No architectural
  changes, no API/UAPI changes, no behavior change unless the new error
  codes are actually returned.
- Forward-compatibility with newer GuC: Distros often update GuC via
  linux-firmware independently of the kernel. This patch keeps older
  kernels robust when paired with newer GuC blobs.
- Low regression risk: Older GuC won’t emit the new codes, so behavior
  is unchanged there. New codes are explicitly fatal, so aborting
  earlier is the correct action. Additional logging improves triage.

What changes and why they matter
- Add new GuC load error codes in the ABI header
  - drivers/gpu/drm/xe/abi/guc_errors_abi.h:49 defines `enum
    xe_guc_load_status`. This patch adds:
    - `XE_GUC_LOAD_STATUS_BOOTROM_VERSION_MISMATCH = 0x08` (fatal)
    - `XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR = 0x75` (fatal)
    - `XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG = 0x76` (fatal)
  - In current tree, the relevant region is at
    drivers/gpu/drm/xe/abi/guc_errors_abi.h:49–72. Adding these entries
    fills previously unused values (0x08, 0x75, 0x76) and keeps them in
    the “invalid init data” range where appropriate, preserving ordering
    and ABI clarity.

- Treat the new codes as terminal failures in the load state machine
  - drivers/gpu/drm/xe/xe_guc.c:517 `guc_load_done()` is the terminal-
    state detector for the load loop.
  - Existing fatal cases are in the switch at
    drivers/gpu/drm/xe/xe_guc.c:526–535.
  - The patch adds the new codes to this fatal set, so `guc_load_done()`
    returns -1 immediately instead of waiting for a timeout. This
    prevents long waits and aligns behavior with the intended semantics
    of these GuC codes.

- Improve diagnostics for new failure modes during load
  - drivers/gpu/drm/xe/xe_guc.c:593 `guc_wait_ucode()` logs the reason
    for failure.
  - New message cases are added to the `ukernel` switch (today at
    drivers/gpu/drm/xe/xe_guc.c:672–685):
    - A logging case for `HWCONFIG_START` was reordered to the front for
      clarity (still “still extracting hwconfig table.”)
    - New diagnostics for:
      - `INIT_DATA_INVALID`: “illegal init/ADS data”
      - `KLV_WORKAROUND_INIT_ERROR`: “illegal workaround KLV data”
      - `INVALID_FTR_FLAG`: “illegal feature flag specified”
  - These improve visibility into what went wrong without altering
    control flow beyond early abort on fatal codes.

Cross-check with i915 (parity and precedent)
- i915 already handles one of these newer codes:
  - `INTEL_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR` is defined and
    handled in i915 (drivers/gpu/drm/i915/gt/uc/abi/guc_errors_abi.h:24
    and :39; drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c:118, 245),
    confirming this class of additions is standard and low risk.
- Bringing Xe up to parity on load error handling is consistent with
  upstream direction and improves stability for GuC firmware evolution.

Stable criteria assessment
- Bug fix that affects users: Yes — avoids long waits and wedges with
  clearer diagnostics when GuC reports new fatal statuses.
- Minimal and contained: Yes — a handful of enum entries and switch
  cases in two Xe files.
- No architectural changes: Correct — only error-code recognition and
  messaging.
- Critical subsystem: It’s a GPU driver; impact is localized to GuC
  bring-up, not core kernel.
- Explicit stable tags: Not present, but the change is a standard, low-
  risk, forward-compat fix consistent with stable rules.
- Dependencies: None apparent; the new constants are self-contained.
  Note: in some branches the header’s response enum is named
  `xe_guc_response_status` (drivers/gpu/drm/xe/abi/guc_errors_abi.h:9),
  not `xe_guc_response` as in the posted diff context. This patch does
  not alter that enum and the backport simply adds entries to
  `xe_guc_load_status`, so this naming difference does not block the
  backport.

Potential risks and why they’re acceptable
- Earlier abort on these statuses vs. timing out: That is intended;
  these codes are designated fatal by GuC. For older GuC which never
  emit them, behavior is unchanged.
- No ABI or userspace exposure: The enums are internal to the
  driver/firmware interface.

Conclusion
- This is a targeted robustness fix for GuC load error handling,
  consistent with established patterns in i915, with minimal risk and
  clear user benefit. It should be backported to stable.

 drivers/gpu/drm/xe/abi/guc_errors_abi.h |  3 +++
 drivers/gpu/drm/xe/xe_guc.c             | 19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/abi/guc_errors_abi.h b/drivers/gpu/drm/xe/abi/guc_errors_abi.h
index ecf748fd87df3..ad76b4baf42e9 100644
--- a/drivers/gpu/drm/xe/abi/guc_errors_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_errors_abi.h
@@ -63,6 +63,7 @@ enum xe_guc_load_status {
 	XE_GUC_LOAD_STATUS_HWCONFIG_START                   = 0x05,
 	XE_GUC_LOAD_STATUS_HWCONFIG_DONE                    = 0x06,
 	XE_GUC_LOAD_STATUS_HWCONFIG_ERROR                   = 0x07,
+	XE_GUC_LOAD_STATUS_BOOTROM_VERSION_MISMATCH         = 0x08,
 	XE_GUC_LOAD_STATUS_GDT_DONE                         = 0x10,
 	XE_GUC_LOAD_STATUS_IDT_DONE                         = 0x20,
 	XE_GUC_LOAD_STATUS_LAPIC_DONE                       = 0x30,
@@ -75,6 +76,8 @@ enum xe_guc_load_status {
 	XE_GUC_LOAD_STATUS_INVALID_INIT_DATA_RANGE_START,
 	XE_GUC_LOAD_STATUS_MPU_DATA_INVALID                 = 0x73,
 	XE_GUC_LOAD_STATUS_INIT_MMIO_SAVE_RESTORE_INVALID   = 0x74,
+	XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR        = 0x75,
+	XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG                 = 0x76,
 	XE_GUC_LOAD_STATUS_INVALID_INIT_DATA_RANGE_END,
 
 	XE_GUC_LOAD_STATUS_READY                            = 0xF0,
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 270fc37924936..9e0ed8fabcd54 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -990,11 +990,14 @@ static int guc_load_done(u32 status)
 	case XE_GUC_LOAD_STATUS_GUC_PREPROD_BUILD_MISMATCH:
 	case XE_GUC_LOAD_STATUS_ERROR_DEVID_INVALID_GUCTYPE:
 	case XE_GUC_LOAD_STATUS_HWCONFIG_ERROR:
+	case XE_GUC_LOAD_STATUS_BOOTROM_VERSION_MISMATCH:
 	case XE_GUC_LOAD_STATUS_DPC_ERROR:
 	case XE_GUC_LOAD_STATUS_EXCEPTION:
 	case XE_GUC_LOAD_STATUS_INIT_DATA_INVALID:
 	case XE_GUC_LOAD_STATUS_MPU_DATA_INVALID:
 	case XE_GUC_LOAD_STATUS_INIT_MMIO_SAVE_RESTORE_INVALID:
+	case XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR:
+	case XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG:
 		return -1;
 	}
 
@@ -1134,17 +1137,29 @@ static void guc_wait_ucode(struct xe_guc *guc)
 		}
 
 		switch (ukernel) {
+		case XE_GUC_LOAD_STATUS_HWCONFIG_START:
+			xe_gt_err(gt, "still extracting hwconfig table.\n");
+			break;
+
 		case XE_GUC_LOAD_STATUS_EXCEPTION:
 			xe_gt_err(gt, "firmware exception. EIP: %#x\n",
 				  xe_mmio_read32(mmio, SOFT_SCRATCH(13)));
 			break;
 
+		case XE_GUC_LOAD_STATUS_INIT_DATA_INVALID:
+			xe_gt_err(gt, "illegal init/ADS data\n");
+			break;
+
 		case XE_GUC_LOAD_STATUS_INIT_MMIO_SAVE_RESTORE_INVALID:
 			xe_gt_err(gt, "illegal register in save/restore workaround list\n");
 			break;
 
-		case XE_GUC_LOAD_STATUS_HWCONFIG_START:
-			xe_gt_err(gt, "still extracting hwconfig table.\n");
+		case XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR:
+			xe_gt_err(gt, "illegal workaround KLV data\n");
+			break;
+
+		case XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG:
+			xe_gt_err(gt, "illegal feature flag specified\n");
 			break;
 		}
 
-- 
2.51.0

