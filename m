Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB3D273D8A;
	Tue,  5 Aug 2025 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399391; cv=none; b=s2EvtF80fK+XdyfY0/nNt5K9yHfw1zBYNHatQ8ooSbT2TfneH3kNPfNDCqnR9uzVtOS2fU1iO/FaNL+4vpYTzGgjx41OtIKTk7Vy7BL6WHdqx6ZFqZovf0u21+qUD72IlD4jBqYiR11xJn9CaBycgsdkwPHeX1dwLb7xHstYoks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399391; c=relaxed/simple;
	bh=fOHaPe9slU/CMDtJdHv7D2kYdV1d+04k91CrqWpFzoc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YMchWT8igWVB2iHXi4Iac3f1l03+3jEhCt66rUax74fd/sc/ZEXpzm2f0JBTnV7IMvJHXhrHmLjKKOG3MVLX2JURA4e0SvjF5G8grgkFz3Vd7Wg7SwgaD5rORTPQeECcWeu+zTYA0nKLasA+e2G0iH/I6suYvjcNT481z0xHDUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSWv/+ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSWv/+ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E8BC4CEF4;
	Tue,  5 Aug 2025 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399390;
	bh=fOHaPe9slU/CMDtJdHv7D2kYdV1d+04k91CrqWpFzoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSWv/+ngWUMZyPhJJEBMKZ1KeyYdKoVPVU9jhGUhziDCtgxMJhzPLLg/I5zVfxQRA
	 NMEbrn4vtqt4hzL5GYXIrM/TbiusqXIeR+CesuppUMQaE7Pacp2i2igF9gtkNAO7Ma
	 ZIfq1IKtzzhxBS5XBDaHSKVzY5wb9iZrcTLVxe+PIuBptGiFreb2cruUjTmGAgtvZX
	 eaCp78zq6uY7q742SmdOeeJYeYuMi1MNfeUd+b1r7cmryvpGrdxQtsNXRpp1i60sAC
	 0nf9NIFU7Vscso9laP9RWt4tGN6m7aP67qJg3tycCeeX7p8K5VCs54M8dQZsvz+qGJ
	 StKS3/JywZXIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-5.4] MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}
Date: Tue,  5 Aug 2025 09:08:37 -0400
Message-Id: <20250805130945.471732-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
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

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 844615dd0f2d95c018ec66b943e08af22b62aff3 ]

These functions are exported but their prototypes are not defined.
This patch adds the missing function prototypes to fix the following
compilation warnings:

arch/mips/kernel/vpe-mt.c:180:7: error: no previous prototype for 'vpe_alloc' [-Werror=missing-prototypes]
  180 | void *vpe_alloc(void)
      |       ^~~~~~~~~
arch/mips/kernel/vpe-mt.c:198:5: error: no previous prototype for 'vpe_start' [-Werror=missing-prototypes]
  198 | int vpe_start(void *vpe, unsigned long start)
      |     ^~~~~~~~~
arch/mips/kernel/vpe-mt.c:208:5: error: no previous prototype for 'vpe_stop' [-Werror=missing-prototypes]
  208 | int vpe_stop(void *vpe)
      |     ^~~~~~~~
arch/mips/kernel/vpe-mt.c:229:5: error: no previous prototype for 'vpe_free' [-Werror=missing-prototypes]
  229 | int vpe_free(void *vpe)
      |     ^~~~~~~~

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here is my assessment:

**Backport Status: YES**

This commit is suitable for backporting to stable kernel trees for the
following reasons:

1. **Fixes a compilation warning/error**: The commit addresses missing
   function prototype warnings that can cause build failures when
   compiling with `-Werror=missing-prototypes`. This is a build fix that
   prevents compilation issues.

2. **Minimal and contained change**: The patch only adds function
   prototypes to a header file (`arch/mips/include/asm/vpe.h`). It
   doesn't modify any actual implementation code, making it extremely
   low-risk.

3. **No functional changes**: The functions (`vpe_alloc`, `vpe_start`,
   `vpe_stop`, `vpe_free`) already exist and are exported via
   `EXPORT_SYMBOL()` in `arch/mips/kernel/vpe-mt.c`. The patch merely
   adds the missing declarations to the header file.

4. **Properly guarded with CONFIG**: The prototypes are correctly
   wrapped with `#ifdef CONFIG_MIPS_VPE_LOADER_MT`, matching the build
   configuration where these functions are compiled.

5. **Clear bug fix**: This addresses a specific issue where exported
   functions lack proper prototypes, which violates C standards and
   causes legitimate compiler warnings. The functions are already being
   exported (lines 192, 202, 223, 258 in vpe-mt.c show `EXPORT_SYMBOL`
   calls) but their prototypes were missing from the header.

6. **No risk of regression**: Since this only adds function declarations
   that match existing function definitions, there's virtually no risk
   of introducing new bugs or changing behavior.

7. **Follows stable kernel rules**: This is a clear bug fix (missing
   prototypes for exported symbols) that is self-contained and doesn't
   introduce new features or architectural changes.

The commit fixes a legitimate issue where functions are exported for use
by other modules but their prototypes aren't declared in the header
file, which can lead to build failures and potential issues with
function signature mismatches.

 arch/mips/include/asm/vpe.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/mips/include/asm/vpe.h b/arch/mips/include/asm/vpe.h
index 61fd4d0aeda4..c0769dc4b853 100644
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@ -119,4 +119,12 @@ void cleanup_tc(struct tc *tc);
 
 int __init vpe_module_init(void);
 void __exit vpe_module_exit(void);
+
+#ifdef CONFIG_MIPS_VPE_LOADER_MT
+void *vpe_alloc(void);
+int vpe_start(void *vpe, unsigned long start);
+int vpe_stop(void *vpe);
+int vpe_free(void *vpe);
+#endif /* CONFIG_MIPS_VPE_LOADER_MT */
+
 #endif /* _ASM_VPE_H */
-- 
2.39.5

