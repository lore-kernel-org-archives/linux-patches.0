Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A1B61FA8;
	Thu, 30 Nov 2023 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzB4jSI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A9DC433CC;
	Thu, 30 Nov 2023 22:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385112;
	bh=JEaFerCUDwe48QKSwckLoMx80uIKCciMd5KEOPBRb2s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hzB4jSI7hBe8cbmO+E1BB/XAg0QKNIL+NcOKoXfK5E57pjUpravVLKP+fthYYiI0q
	 ZELyEfEN7YfZlJXgebPszfZbtzAkV+i4ha+cispT85i5evv/yIGvAq5yGXuwe0PXVc
	 8jMcd7ToitrMgy/ku3agVTahqGY86laA8R5FzLHyUIhC26kXVe0fYsNgfmHNURb6/I
	 jN+YXpHY1lc5QAlyCcrRuxBEjVLOebwywZkIcITJ5AQNfYPO7Xo2OMO4PUtUZF/e5D
	 PdaHN+7UcL9y774IImHH9gUO/3n1hYIFSArlRZnguFbt1zt2qlRUn2HXj/r2sY5+zp
	 T+TCc51dpCviw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:27 -0700
Subject: [PATCH 14/19] hexagon: process: Add internal prototype for
 do_work_pending()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-14-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1313; i=nathan@kernel.org;
 h=from:subject:message-id; bh=JEaFerCUDwe48QKSwckLoMx80uIKCciMd5KEOPBRb2s=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwv1ewn7bTymn5V7ZIKXw9N0RHf9bbdeWBHU90J62T
 2wJs6NERykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjItXRGhoMWfpPnv52ub3pb
 sjZjte4s8faFxuuXJc7YuYz3x/KLdXGMDC/+rIt+lrGhfFlIluWMu89nXveKXfZ6/w4lz2OHnFi
 1FRgA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/process.c:155:5: warning: no previous prototype for function 'do_work_pending' [-Wmissing-prototypes]
    155 | int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
        |     ^
  arch/hexagon/kernel/process.c:155:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    155 | int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
        | ^
        | static

This function is only referenced from assembly, so it does not
technically need a prototype. Add one right above the definition anyways
to clear up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 51e37fc92857..2a77bfd75694 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -153,6 +153,7 @@ unsigned long __get_wchan(struct task_struct *p)
  * Returns 0 if there's no need to re-check for more work.
  */
 
+int do_work_pending(struct pt_regs *regs, u32 thread_info_flags);
 int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 {
 	if (!(thread_info_flags & _TIF_WORK_MASK)) {

-- 
2.43.0

