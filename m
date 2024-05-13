Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88A179A3
	for <patches@lists.linux.dev>; Mon, 13 May 2024 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715614839; cv=none; b=N1pSdqF4sA2xHBH/823R1UfRHgYhJq6JgztX+rP4qluIZJFYxkcUe5N2UDbZk9F9zPrjmnf/vYS9+TGgeHOn1ed8OH9ByXrTAFRWy3VK81HktJvOhjTjpGGV0J3zn+/jD2RH93jkaiqeQWWE+swp9a+rrfrA3gRVj7vxP/Uypzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715614839; c=relaxed/simple;
	bh=dRf1wpTYcfdxHsutpWJSXKMZr7IAOjWboVwaF2rz86c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KSQsePbovwuNfyZaahOttkCUmaZlazMmQrwpZzzh1g+hJtFfvX9SiYvVMdjpO1qa6y0t7JeYvbUjbxesXAYupvpzDwBzrNywjF5l8/V8IBeDckJn9dnxXSxq9Vi5K0az+d4RAxIatDl5qVPA7ieY1NR81j8ZMDoW/bArDfQT76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dfzfv0Ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dfzfv0Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CBAC113CC;
	Mon, 13 May 2024 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715614838;
	bh=dRf1wpTYcfdxHsutpWJSXKMZr7IAOjWboVwaF2rz86c=;
	h=From:Date:Subject:To:Cc:From;
	b=Dfzfv0AyKyq8OMQXpwoGft1iuXOqN6CMSaWQd7wjz+sTvG3X97PAzx48lhUr/U4vW
	 eUCq6FgmRL4GwWKR9l9NNwdLxpl1TZyS22k2IVn1dn+sjacIEsRxhw1J8/U552XNSU
	 eEEMbhzDjBGWp4NCCRp0+c3VgNn/gl4MG7gpFbv9AFRn7ojJep1fhsPFFMoQdeysPq
	 cTG1nSuJp7WVgSrXQOUx3Qz+Ev2G1221xwcRHQ/BV94TCZ80GzilNYP5v9k+3rZ5FF
	 YVZTGpdSQCBO53FtEM6BaqLEBG/C16fFDLxFT8BK8k+UHHVYTdI7OSPy1g3Cbj7Heh
	 rYIssbO9f6vFQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 13 May 2024 08:40:27 -0700
Subject: [PATCH] f2fs: Add inline to f2fs_build_fault_attr() stub
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240513-f2fs-add-missing-inline-to-f2fs_build_fault_attr-v1-1-c3ce1c995fa2@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGo0QmYC/x2N0QqDMAwAf0XyvEDsLLL9yhils6kLdHU0dQzEf
 7f4eBzcbaBchBXu3QaFf6Ky5Ab9pYPp7fPMKKExGDID2f6K0URFHwJ+RFXyjJKTZMa6nMq9Vkn
 BRb+m6nytBQ2N3tJ0G4kstOy3cJT/uXw89/0AO0//ioIAAAA=
To: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1569; i=nathan@kernel.org;
 h=from:subject:message-id; bh=dRf1wpTYcfdxHsutpWJSXKMZr7IAOjWboVwaF2rz86c=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGlOJmXXtls2ay3XvJ+62Xf+9k/Tjxr3WZ5dr3psz3NV2
 RaR98vvd5SyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJrPrP8D9nVeEzwyUt935e
 Xt5kMEHp0IIXqy0Tuf8+XWdzybuqsLSb4X9k5SOxiOQFN99KvS47Jjcn+MW1iisGptlT7cu+ejo
 X5rAAAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building without CONFIG_F2FS_FAULT_INJECTION, there is a warning
from each file that includes f2fs.h because the stub for
f2fs_build_fault_attr() is missing inline:

  In file included from fs/f2fs/segment.c:21:
  fs/f2fs/f2fs.h:4605:12: warning: 'f2fs_build_fault_attr' defined but not used [-Wunused-function]
   4605 | static int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
        |            ^~~~~~~~~~~~~~~~~~~~~

Add the missing inline to resolve all of the warnings for this
configuration.

Fixes: 4ed886b187f4 ("f2fs: check validation of fault attrs in f2fs_build_fault_attr()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/f2fs/f2fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ef7de97be647..1974b6aff397 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4602,8 +4602,8 @@ static inline bool f2fs_need_verity(const struct inode *inode, pgoff_t idx)
 extern int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
 							unsigned long type);
 #else
-static int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
-							unsigned long type)
+static inline int f2fs_build_fault_attr(struct f2fs_sb_info *sbi,
+					unsigned long rate, unsigned long type)
 {
 	return 0;
 }

---
base-commit: 991b6bdf1b009832256f8bc3035d4bcba664657b
change-id: 20240513-f2fs-add-missing-inline-to-f2fs_build_fault_attr-207a50c97005

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

