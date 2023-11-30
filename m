Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311D25813C;
	Thu, 30 Nov 2023 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfqE1ITX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0A8C433C7;
	Thu, 30 Nov 2023 22:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385107;
	bh=SVPEVE6jGpQLfxAuiZ4m6xynr9TrCwheUOcY3U+w6+s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OfqE1ITXwArIMwcVSJs0wPHAOUlyWG5oU0VInBEpqCOn215cS2akrgN/d6GHViQjL
	 0rLQJl//rFBHtmaAliugCe51m6nBH4xvuLSpC+BKv4Ep4EzpqB8N76dDdwkwF7pDlV
	 nLCJpvRvRDHZIKknj7Ww4Y7YM6+JNUVDZVcFAQ+5P4cV1nZKLjCXmMExPOBUj3jX57
	 3vMxDFKZLcDSqdMuwms8dXIltg791yzd3+9SCebJxN/n1h1HQNxph2F14rbuyK1/B/
	 u1yJ7y01nas/X9IjNOSKyKAA0D6ngIMPiBT1CIGvTmkH9+yA4h4iFKB0r7dDyBri1z
	 K+6Dbv2EJde3w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:18 -0700
Subject: [PATCH 05/19] hexagon: vm_fault: Mark do_page_fault() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-5-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1221; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SVPEVE6jGpQLfxAuiZ4m6xynr9TrCwheUOcY3U+w6+s=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwr1sK58nqX/0FAn6/WiKm6S7K6+bnjurN2PgxmU5X
 ++s+bqoo5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwkWICRYdNcofTI1Cevtd9F
 FXxxmF6rG9mydNXv2Wxxn0oOLi/jXsjIcL52ouUqb3Frm116/jd2vtF8cmzP4h8C06d84BHlrcm
 YxAsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/mm/vm_fault.c:36:6: warning: no previous prototype for function 'do_page_fault' [-Wmissing-prototypes]
     36 | void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
        |      ^
  arch/hexagon/mm/vm_fault.c:36:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     36 | void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
        | ^
        | static

This function is not used outside of this translation unit, so mark it
as static.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/mm/vm_fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/mm/vm_fault.c b/arch/hexagon/mm/vm_fault.c
index 7295ea3f8cc8..ab0f0a791e00 100644
--- a/arch/hexagon/mm/vm_fault.c
+++ b/arch/hexagon/mm/vm_fault.c
@@ -33,7 +33,7 @@
 /*
  * Canonical page fault handler
  */
-void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
+static void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;

-- 
2.43.0

