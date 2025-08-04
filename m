Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D9619AD90;
	Mon,  4 Aug 2025 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267165; cv=none; b=QFgwcGIW+zqJsGzw7RV/1ISm5xFFBrYQC0JEjjA4KwJLvjKZfDDee4YA1NQmeFaf2CaDKx6YI+F2kCCczPMn0S7pTpayiRe6pGpXbju1CwVoiqaj7QH2o8czIHyIp8i2BbqDDiQZfRJIpYvyJvLVecL7t+YQcAncwNrlmf2UHdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267165; c=relaxed/simple;
	bh=YnbkvnmtNLvjCP8IyfHoAyXB8ez09+84Y28R1X7smsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P7220x8+Q7QOP0awgljb+c7d2Nq8LD/l1PywJGPQP/GZAZPsg/9aJodXF7FYQtEeA1Wt/ZKUMhjTOSxMNcqUVwmfCTyipRPXuoE4Y4EK4OfYNHq0/vYokQfGErs3KRGg7ddApgCHpNIIHmxGoXZlTX5aowHEaUdSdGBWg5PoFvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2ZLnKtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2ZLnKtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F0CC4CEEB;
	Mon,  4 Aug 2025 00:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267165;
	bh=YnbkvnmtNLvjCP8IyfHoAyXB8ez09+84Y28R1X7smsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2ZLnKtjweBStLmuOJHGf2/rLmuXlQ5HrsDqYWBOqSGp0otpXWZe6YdpaFxd3e2aa
	 2fHkXBQKsAspwKrmHTjfFESnO0lANlTgc2XelHy4a/UjuXsKjh5RTaRv8Lr7uuZnsh
	 RE2/gkcmyXw/dBrlnGKWBCcNXoU3Dn49bqKTTzRYRG8rI/s8YzXXtCdYKm2MQiIPic
	 e5WR7c4gBQA5Xa04ymqtU5j/g1Q2EiXN+Qvn74qdJPXoD+wL2fEXcGa58mwBXEu6wy
	 PqpbsB0hUzV/xFMACLXP8ZSh7tn8KdoBZH3uG/yP/H3CrVW4/acObwbFw+uYEVQDGu
	 CUvkAA6TwRZ/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Robinson <pbrobinson@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16 52/85] reset: brcmstb: Enable reset drivers for ARCH_BCM2835
Date: Sun,  3 Aug 2025 20:23:01 -0400
Message-Id: <20250804002335.3613254-52-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 1d99f92f71b6b4b2eee776562c991428490f71ef ]

The BRCMSTB and BRCMSTB_RESCAL reset drivers are also
used in the BCM2712, AKA the RPi5. The RPi platforms
have typically used the ARCH_BCM2835, and the PCIe
support for this SoC can use this config which depends
on these drivers so enable building them when just that
arch option is enabled to ensure the platform works as
expected.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20250630175301.846082-1-pbrobinson@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. **Nature of the Change**
The commit makes a simple Kconfig dependency update to enable two
existing reset controller drivers (`RESET_BRCMSTB` and
`RESET_BRCMSTB_RESCAL`) for the `ARCH_BCM2835` platform. The changes
are:
- Lines 54-55: Adds `ARCH_BCM2835` to the depends and default lines for
  `RESET_BRCMSTB`
- Lines 63-64: Adds `ARCH_BCM2835` to the depends and default lines for
  `RESET_BRCMSTB_RESCAL`
- Line 67: Updates the help text to mention BCM2712 alongside BCM7216

### 2. **This is a Bug Fix**
This commit fixes a configuration bug where the Raspberry Pi 5 (BCM2712)
platform, which uses `ARCH_BCM2835`, cannot properly enable critical
reset controllers needed for PCIe functionality. Without this fix, users
building kernels for RPi5 with just `ARCH_BCM2835` enabled would have
non-functional PCIe support.

### 3. **Minimal and Contained Change**
The commit is extremely minimal - it only modifies 6 lines in a single
Kconfig file. It doesn't touch any C code, doesn't change any logic, and
only updates build configuration dependencies. This is the ideal type of
change for stable backporting.

### 4. **No Side Effects**
The change has no negative side effects:
- It only enables building existing drivers for an additional platform
- The drivers themselves are already tested and working (used by BRCMSTB
  platforms)
- The change is additive - it doesn't remove or modify existing
  functionality
- No API/ABI changes

### 5. **Platform-Specific Fix**
While the change is platform-specific (Raspberry Pi 5/BCM2712), it's
important because:
- RPi platforms are widely used
- PCIe support is critical functionality
- The fix enables existing, tested code to be built for a platform that
  needs it

### 6. **Clear Hardware Support Issue**
From the commit message, this addresses a real hardware support issue
where the BCM2712 (RPi5) SoC reuses the same reset controller IP blocks
as other Broadcom STB SoCs but couldn't enable them due to missing
Kconfig dependencies.

### 7. **Low Risk**
The risk of regression is essentially zero because:
- Only affects kernel builds that explicitly enable `ARCH_BCM2835`
- Doesn't change behavior for existing platforms
- The drivers being enabled are mature and already in use

### 8. **Follows Stable Rules**
This perfectly fits the stable kernel criteria:
- Fixes a real bug (missing hardware support)
- Obviously correct (just adding platform to existing dependency)
- Small change (6 lines)
- Already tested (has Acked-by from Broadcom maintainer)

The commit enables essential functionality (PCIe support via reset
controllers) for a popular platform (Raspberry Pi 5) through a minimal,
risk-free configuration change. This is exactly the type of fix that
should be backported to ensure stable kernels properly support current
hardware.

 drivers/reset/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index d85be5899da6..ec8c953cb73d 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -51,8 +51,8 @@ config RESET_BERLIN
 
 config RESET_BRCMSTB
 	tristate "Broadcom STB reset controller"
-	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default ARCH_BRCMSTB
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || COMPILE_TEST
+	default ARCH_BRCMSTB || ARCH_BCM2835
 	help
 	  This enables the reset controller driver for Broadcom STB SoCs using
 	  a SUN_TOP_CTRL_SW_INIT style controller.
@@ -60,11 +60,11 @@ config RESET_BRCMSTB
 config RESET_BRCMSTB_RESCAL
 	tristate "Broadcom STB RESCAL reset controller"
 	depends on HAS_IOMEM
-	depends on ARCH_BRCMSTB || COMPILE_TEST
-	default ARCH_BRCMSTB
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || COMPILE_TEST
+	default ARCH_BRCMSTB || ARCH_BCM2835
 	help
 	  This enables the RESCAL reset controller for SATA, PCIe0, or PCIe1 on
-	  BCM7216.
+	  BCM7216 or the BCM2712.
 
 config RESET_EYEQ
 	bool "Mobileye EyeQ reset controller"
-- 
2.39.5

