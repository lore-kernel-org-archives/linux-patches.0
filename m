Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F0C2FC893;
	Sat, 25 Oct 2025 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408976; cv=none; b=DGJEmBvUtg9wm6lX9G6fxvLCsKj1J7TUfjBu0gW/Gn2lF1xnk+0Ooap7N5I+ZiK/m027xa6WEQJ8X9v5kaLrU8gapcFsa3gyKmYdQNOmi+qLROsHwT9b2qtrNfpcHcwxcGAn+Z4wrAYNi6bZxx4YECykwSAJ1zqs1EYRbWv30nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408976; c=relaxed/simple;
	bh=2SdthvlkodHN4wo5h7iHStMzcgbvHBnyJ+7+se77QiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WeK1f1FnCbwBxoUfDttyEm30BcnEBYyIgh4xpvY3jj2ojhoEIuENi9Xhg3Jang0Kn9wYjsRf8vHedQKCEt0py7grS0dms1yO/45PcFX2OPYUPcw7WDorAdCECCdFdT1cWo2aHUo+J66fJjONxp9I+ldgN134njcNruFOV8FQ1NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bh7FrtNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bh7FrtNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF4FC4CEFB;
	Sat, 25 Oct 2025 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408976;
	bh=2SdthvlkodHN4wo5h7iHStMzcgbvHBnyJ+7+se77QiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bh7FrtNTlGeo+inz+sjRJ0iiWFuCuRFmnTUPehnN94VMKwrZygmuCWjY+cM3ED+c+
	 UpjZJtUGoJjlBrXuR/0yc3368vegnk/F5R0NRfTzG35J5336vaDzlLBoGA4bPaYxRv
	 jAWJfupeCbMEP4UYjSbFx8/QXfVLgvN2bll2v3utVeJgkx++QMAo/CIqNJ6O05ALfa
	 zfqnm21RJi1q31XpYhGino77RPgqzJuoFPjCuntt3HHVZwvFT+O9rgus8NVG5JTbv+
	 cUZ/7fS7t6xT/yaG4xAKC1ptb9gDaVYkxqJ9/UNIOtsbrKMJpEd6UHqsp8JTNomZ3M
	 NuaUFwSsamAMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	kernel test robot <lkp@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] Fix access to video_is_primary_device() when compiled without CONFIG_VIDEO
Date: Sat, 25 Oct 2025 11:56:31 -0400
Message-ID: <20251025160905.3857885-160-sashal@kernel.org>
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

[ Upstream commit 6e490dea61b88aac9762c9f79a54aad4ea2e6cd1 ]

When compiled without CONFIG_VIDEO the architecture specific
implementations of video_is_primary_device() include prototypes and
assume that video-common.c will be linked. Guard against this so that the
fallback inline implementation that returns false will be used when
compiled without CONFIG_VIDEO.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506221312.49Fy1aNA-lkp@intel.com/
Link: https://lore.kernel.org/r/20250811162606.587759-2-superm1@kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: When CONFIG_VIDEO=n, several arch headers still declare
  and “reserve” video_is_primary_device(), which suppresses the generic
  fallback in include/asm-generic/video.h and assumes an out-of-line
  implementation is linked. This causes either build/link fragility or
  wrong semantics in non-VIDEO builds. The patch ensures the generic
  inline fallback (returns false) is used when CONFIG_VIDEO=n.
- Generic fallback location: include/asm-generic/video.h:27-34 defines
  the inline default and its guard:
  - It only provides the fallback if the macro alias is not already
    defined.
  - The fallback returns false, which is the safe default for non-VIDEO
    builds.

- Specific header fixes:
  - arch/parisc/include/asm/video.h:9-13 changes the guard to require
    CONFIG_STI_CORE && CONFIG_VIDEO before declaring the prototype and
    alias. This prevents suppressing the generic fallback when
    CONFIG_VIDEO=n.
  - arch/sparc/include/asm/video.h:19-23 wraps the prototype and alias
    in #ifdef CONFIG_VIDEO, allowing the generic fallback when
    CONFIG_VIDEO=n.
  - arch/x86/include/asm/video.h:17-21 wraps the prototype and alias in
    #ifdef CONFIG_VIDEO, same effect.

- Why this matters in practice:
  - Call sites exist outside strict VIDEO configurations and expect a
    safe default:
    - drivers/gpu/drm/drm_sysfs.c:534 checks video_is_primary_device()
      to decide visibility of a sysfs attribute. With CONFIG_VIDEO=n,
      the fallback false avoids exposing the “boot_display” attribute
      inappropriately.
    - drivers/video/fbdev/core/fbcon.c:2945 uses it in primary
      selection; with CONFIG_VIDEO=n, fallback false avoids unintended
      remapping.
  - Previously, arch headers could suppress the fallback and force
    linkage to out-of-line variants (e.g., arch/x86/video/video-
    common.c, arch/sparc/video/video-common.c, arch/parisc/video/video-
    sti.c) even in non-VIDEO builds, leading to:
    - Build/link brittleness if the out-of-line object is not built in a
      given config.
    - Inconsistent behavior when CONFIG_VIDEO=n (e.g., reporting a
      primary display device) instead of the intended always-false
      fallback.

- Scope and risk:
  - The change is minimal and contained to three arch headers.
  - No runtime behavior change when CONFIG_VIDEO=y; only affects non-
    VIDEO builds by allowing the existing generic fallback.
  - No architectural changes, ABI shifts, or behavioral changes in
    normal VIDEO-enabled configs.
  - Addresses a real build/behavior issue reported by kernel test robot
    (Reported-by in commit message).

- Stable backport criteria:
  - Fixes a build/semantics bug that can affect users and CI in valid
    configs.
  - Small, straightforward, and low risk.
  - Not a new feature; purely a correctness/guard fix aligning with
    generic header’s design.

Given the above, this is a good candidate for stable backport.

 arch/parisc/include/asm/video.h | 2 +-
 arch/sparc/include/asm/video.h  | 2 ++
 arch/x86/include/asm/video.h    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/video.h b/arch/parisc/include/asm/video.h
index c5dff3223194a..a9d50ebd6e769 100644
--- a/arch/parisc/include/asm/video.h
+++ b/arch/parisc/include/asm/video.h
@@ -6,7 +6,7 @@
 
 struct device;
 
-#if defined(CONFIG_STI_CORE)
+#if defined(CONFIG_STI_CORE) && defined(CONFIG_VIDEO)
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
 #endif
diff --git a/arch/sparc/include/asm/video.h b/arch/sparc/include/asm/video.h
index a6f48f52db584..773717b6d4914 100644
--- a/arch/sparc/include/asm/video.h
+++ b/arch/sparc/include/asm/video.h
@@ -19,8 +19,10 @@ static inline pgprot_t pgprot_framebuffer(pgprot_t prot,
 #define pgprot_framebuffer pgprot_framebuffer
 #endif
 
+#ifdef CONFIG_VIDEO
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
+#endif
 
 static inline void fb_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
diff --git a/arch/x86/include/asm/video.h b/arch/x86/include/asm/video.h
index 0950c9535fae9..08ec328203ef8 100644
--- a/arch/x86/include/asm/video.h
+++ b/arch/x86/include/asm/video.h
@@ -13,8 +13,10 @@ pgprot_t pgprot_framebuffer(pgprot_t prot,
 			    unsigned long offset);
 #define pgprot_framebuffer pgprot_framebuffer
 
+#ifdef CONFIG_VIDEO
 bool video_is_primary_device(struct device *dev);
 #define video_is_primary_device video_is_primary_device
+#endif
 
 #include <asm-generic/video.h>
 
-- 
2.51.0

