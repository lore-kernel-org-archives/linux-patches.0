Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AAC1F1306;
	Sat, 25 Oct 2025 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408596; cv=none; b=g4F/Rn/w/NuWcImyLzk61xIc6n3C96GuS53Pmar3iWpMiy7ZShb9HxJC8gGMIua/kibhZ1wJNiIl8Mt1qUPnwdJDvjjU5pLV+bNJVeyIrT9g+KzzF+OulOIhD45cxKvazuoRiDwReU9booVvTmEpPCU428/KLBBf5/XBoHVY4cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408596; c=relaxed/simple;
	bh=f5Q6XhaAqrsLf6jXmJq0F6KEENoYSoqBobLAiDar4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9YZmDPBAN5dYhe5K4B4qm2ZI4KLR92P4/hf1XQJYz6Rz/NuMXseEsQvqJIqlDokLiGtTE5xCrCRjmfHLBSYYk5VstRrrRvuP/EfOGRYszvIbi2M7mOonJdoaUa0YGo8p3gLudR5WDqhljNooqDqWXOHKB6x0xdrhHVyCzzkAuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRgOI6dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRgOI6dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA29C4CEFB;
	Sat, 25 Oct 2025 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408595;
	bh=f5Q6XhaAqrsLf6jXmJq0F6KEENoYSoqBobLAiDar4dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRgOI6dw3TRHyFVvWJa9NJ0CGg67CspFf+yhOck9k2rnaCqdbSYesbhbM9Y35qG3q
	 Cc5x6zztz65FlLO5cWcm+zITK2r+J7EFnS8QjMTV2H+CoRZJs1k4GBOoWNDIOjq1vu
	 FTABuA0n2k12Mui5wlAIDgNK4NnVgvJ8p3Zo3a3rUFLuj/Lfys3bJdfQdAXP4kPQZK
	 UxNq7LOtKBzVHAWZp2ioLpOri691E0Jc0QUbWOmGYSdtBE0QhmQWsXX5ETj2FFwKR2
	 2/oG9GDTTKk2MhbA/7y1gU4pNyox+YKnIKRRJ6hkFjeWDibzxEkCOqPJpM7Wgtho2I
	 P7huZn+l4x2fA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17] fbcon: Use screen info to find primary device
Date: Sat, 25 Oct 2025 11:54:07 -0400
Message-ID: <20251025160905.3857885-16-sashal@kernel.org>
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

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit ad90860bd10ee3ed387077aed88828b139339976 ]

On systems with non VGA GPUs fbcon can't find the primary GPU because
video_is_primary_device() only checks the VGA arbiter.

Add a screen info check to video_is_primary_device() so that callers
can get accurate data on such systems.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20250811162606.587759-4-superm1@kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- Fixes a real user-visible bug: On systems where the boot display is
  driven by a non-VGA PCI display controller (class 0x03 but not VGA-
  compatible), fbcon and DRM sysfs couldn’t reliably identify the
  boot/primary GPU because `video_is_primary_device()` only compared to
  the VGA arbiter’s default device. This led to missing or incorrect
  primary-console mapping and the `boot_display` sysfs attribute not
  appearing or appearing on the wrong device.
- Small, contained change: The patch only updates
  `video_is_primary_device()` on x86 and adds one header include.
  - Adds `#include <linux/screen_info.h>` to access screen-info helpers
    (arch/x86/video/video-common.c:12).
  - Extends `video_is_primary_device()` to:
    - Filter to only display-class PCI devices via `pci_is_display()`
      (arch/x86/video/video-common.c:43), avoiding false positives on
      non-display functions.
    - Preserve the previous fast-path for legacy VGA via `pdev ==
      vga_default_device()` (arch/x86/video/video-common.c:46).
    - On CONFIG_SCREEN_INFO systems, use `screen_info_resources()` to
      obtain the boot framebuffer resources and match them against the
      device’s BARs with `pci_find_resource()` (arch/x86/video/video-
      common.c:50). If any memory resource matches, the device is the
      primary boot display (arch/x86/video/video-common.c:50–56).
    - Remains a no-op for non-PCI devices and when CONFIG_SCREEN_INFO is
      off, preserving prior behavior (arch/x86/video/video-common.c:31,
      50).
- Clear impact on existing callers:
  - fbcon uses `video_is_primary_device()` to pick the primary console
    mapping when CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is enabled
    (drivers/video/fbdev/core/fbcon.c:2950). This patch makes that
    detection work on non‑VGA boot GPUs.
  - DRM sysfs exposes `boot_display` only when
    `video_is_primary_device()` returns true
    (drivers/gpu/drm/drm_sysfs.c:534). This patch fixes `boot_display`
    visibility for non‑VGA boot GPUs.
  - Nouveau passes this to the GSP firmware as `bIsPrimary`
    (drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c:176),
    improving correctness in multi‑GPU systems.
- Low risk of regression:
  - x86-only change; no architectural upheaval.
  - Tight scoping: returns true only for display-class PCI devices that
    either are the VGA default or have a BAR covering a `screen_info`
    LFB resource. This reduces false positives and prevents non-display
    devices from being erroneously flagged as primary.
  - Falls back gracefully where screen-info helpers are unavailable
    (CONFIG guard).
  - Uses established helpers: `pci_is_display()`
    (include/linux/pci.h:764), `pci_find_resource()`
    (drivers/pci/pci.c:836), and `screen_info_resources()`
    (include/linux/screen_info.h:137; implemented in
    drivers/video/screen_info_generic.c:76).
- Not a feature, but a correctness fix: It aligns primary-GPU detection
  with what firmware set as the boot display, fixing fbcon/DRM behavior
  without altering subsystem architecture.

Given the clear bug fix, minimal scope, guarded usage, and direct
benefit to users on modern non‑VGA boot configurations, this is a good
candidate for stable backporting.

 arch/x86/video/video-common.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/video/video-common.c b/arch/x86/video/video-common.c
index 81fc97a2a837a..e0aeee99bc99e 100644
--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/screen_info.h>
 #include <linux/vgaarb.h>
 
 #include <asm/video.h>
@@ -27,6 +28,11 @@ EXPORT_SYMBOL(pgprot_framebuffer);
 
 bool video_is_primary_device(struct device *dev)
 {
+#ifdef CONFIG_SCREEN_INFO
+	struct screen_info *si = &screen_info;
+	struct resource res[SCREEN_INFO_MAX_RESOURCES];
+	ssize_t i, numres;
+#endif
 	struct pci_dev *pdev;
 
 	if (!dev_is_pci(dev))
@@ -34,7 +40,24 @@ bool video_is_primary_device(struct device *dev)
 
 	pdev = to_pci_dev(dev);
 
-	return (pdev == vga_default_device());
+	if (!pci_is_display(pdev))
+		return false;
+
+	if (pdev == vga_default_device())
+		return true;
+
+#ifdef CONFIG_SCREEN_INFO
+	numres = screen_info_resources(si, res, ARRAY_SIZE(res));
+	for (i = 0; i < numres; ++i) {
+		if (!(res[i].flags & IORESOURCE_MEM))
+			continue;
+
+		if (pci_find_resource(pdev, &res[i]))
+			return true;
+	}
+#endif
+
+	return false;
 }
 EXPORT_SYMBOL(video_is_primary_device);
 
-- 
2.51.0

