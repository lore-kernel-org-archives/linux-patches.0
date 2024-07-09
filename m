Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC33B55E4C;
	Tue,  9 Jul 2024 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524688; cv=none; b=furWu7WpEukGLW549uXafqorYG4XbyPDKFqROPMwSa5IEknMcusokJ0bx4SCClnfRO7eKOpPQZ76oQ2zs8TSwG2ceNHhpJbmXPGQwPDMhBuL4wY5tjnxE7WZEzDK6yeJ2w/pcrbHizQoxGdOsolyikYz629YK1yuz3uS+gH6VIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524688; c=relaxed/simple;
	bh=CK1Z9dFboG0U/GsGwB82KGPylkF2cqMUDFfg2//Iy2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyvF4oMRxCI4PPcpnvpgakykxWPUuj7wf3I6JiMABz6/VfVFaVduLn2i/sAikhj9d4XCtVDdbaF/0efDMmNcVVAVBbsu9mvr7b2vWPuTrBj6GbfBbLd+YnWS9V2kHS3PJVORma170n/Ar64oQ8rQoDkSL58Z733x0FlelLWrSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF3Zx2aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF3Zx2aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F54C3277B;
	Tue,  9 Jul 2024 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524688;
	bh=CK1Z9dFboG0U/GsGwB82KGPylkF2cqMUDFfg2//Iy2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF3Zx2aWblypo9Mrtglx3jJHdBGpBPsM/Iz60LC27SRAQ0bczbeGSKtNda6AdJwMW
	 aRYrqHmkkhQ7gIajld+RWVvC+OoeI0Y2iM9G0ECocz9pvbeQ08CTPUMuXTmcic7gQZ
	 c6MUx0louoefNfsX0f4hjsr8my2l3F1ANBJDjoE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 068/102] f2fs: Add inline to f2fs_build_fault_attr() stub
Date: Tue,  9 Jul 2024 13:10:31 +0200
Message-ID: <20240709110654.027294102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 0d8968287a1cf7b03d07387dc871de3861b9f6b9 upstream.

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
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4533,8 +4533,8 @@ static inline bool f2fs_need_verity(cons
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


