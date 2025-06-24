Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DF622FF37;
	Tue, 24 Jun 2025 04:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738365; cv=none; b=lkJ90krzRdKfKSscSLAD2D85Y0Jsq6Vw6HXEBVSZiBd/5E6Vo16dWpe3/9IbAeuV12nYuwD/gWkfOrqma/9IX/61yFdA/I2NNniJPIisWgnoAIMyhCcJJ7ztQ/YIg9sB4cneDdvZ+Yhx2qSMcied+HWs6axBVMo+SQWttgnKKO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738365; c=relaxed/simple;
	bh=MVA3brsLjCF/D124uK+tYeTBJ8dxVCldFw9oN8n0iQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hLxM2rYFxb29c3Ze0z+yxz0PzNFq86RT0FsqF+HEIAqHqDstUa6mfqdKmLK84U2Xav6ZJTU6OgdV+yFYQMCa/NPom4mpLnZhmi2GmMR2ll/Hj140n94N0u7NhVYAm8SHAPQHxrgEALYKjcJew5PdPe3KltclYwpmtepbzf+ef/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVj4fIvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVj4fIvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD37C4CEF2;
	Tue, 24 Jun 2025 04:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738365;
	bh=MVA3brsLjCF/D124uK+tYeTBJ8dxVCldFw9oN8n0iQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVj4fIvD/832jvN0SoFGCVyuUsvsV572aNnR6ryZ6MZF0fZODjExo/qIzRxkcdFmP
	 FI351hYV3ROurgEj6UzrCF0nkAKmkYBWb+zqF6/tMCf0gDwDeNVMTSpNwTyAbAgDLA
	 2isv84kMF1xwxp5Ji+L/FZfLqrGZdtMljpbkMNu2WBwAHYewPD8yTPsoGNIknYz3Fe
	 Lc9q5uvVJGk1DhBiHmIcYSIWyyhi9yZTIT2nzZLYmbJPAL5ttly+4MzMpi8em7PbCE
	 y9UXckwgiO1xPPTw6KWkQW3EByqAQL6QzBr0EVtWSZddkmiOLgfu2u4iraRxfRlnuq
	 h7TjmUSd6Zm/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dlemoal@kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/15] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue, 24 Jun 2025 00:12:29 -0400
Message-Id: <20250624041238.84580-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041238.84580-1-sashal@kernel.org>
References: <20250624041238.84580-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.141
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fe5b391fc56f77cf3c22a9dd4f0ce20db0e3533f ]

On 32-bit ARCH=um, CONFIG_X86_32 is still defined, so it
doesn't indicate building on real X86 machines. There's
no MSR on UML though, so add a check for CONFIG_X86.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20250606090110.15784-2-johannes@sipsolutions.net
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a build failure**: The commit addresses a build breakage
   on 32-bit UML (User Mode Linux) where `CONFIG_X86_32` is defined but
   MSR (Machine Specific Register) support is not available. This
   prevents successful compilation when building for 32-bit UML.

2. **The fix is minimal and contained**: The change is a simple one-line
   modification that adds an additional check for `CONFIG_X86` alongside
   the existing `CONFIG_X86_32` check. The change from:
  ```c
  #ifdef CONFIG_X86_32
  ```
  to:
  ```c
  #if defined(CONFIG_X86) && defined(CONFIG_X86_32)
  ```
  This ensures MSR usage is only enabled on real x86 hardware, not on
  UML.

3. **Similar pattern to other backported fixes**: Looking at the similar
   commits, we see that:
   - Commit #1 (pata_cs5535 + UML) was backported (YES) - it added
     `depends on !UML` to prevent build issues
   - Commit #2 (dmaengine: idxd + UML) was backported (YES) - similar
     UML build fix

   These show a pattern where UML build fixes are considered important
for stable backporting.

4. **No functional changes for normal users**: The fix only affects
   build configurations and doesn't change any runtime behavior for
   users running on actual x86 hardware. This minimizes regression risk.

5. **Prevents allyesconfig/allmodconfig breakage**: As seen in similar
   commits, UML build failures can break comprehensive kernel build
   tests (allyesconfig/allmodconfig), which are important for continuous
   integration and testing.

6. **The issue affects a subsystem driver**: While pata_cs5536 is a
   specific driver for older AMD CS5536 hardware, build failures in any
   driver can impact kernel testing infrastructure and distributions
   that build comprehensive kernel packages.

The commit follows the stable tree rules by being a minimal, focused fix
for an actual bug (build failure) with very low risk of introducing new
issues.

 drivers/ata/pata_cs5536.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index ab47aeb5587f5..13daa69914cbe 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -27,7 +27,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/dmi.h>
 
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86) && defined(CONFIG_X86_32)
 #include <asm/msr.h>
 static int use_msr;
 module_param_named(msr, use_msr, int, 0644);
-- 
2.39.5

