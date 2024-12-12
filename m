Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873084F218;
	Thu, 12 Dec 2024 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023800; cv=none; b=XVDfsZ/7z0FFNEVOmCGEEbs7YyAO8NW9/rm+LVCQksVzOHoyZIqNCJOstqAqG7M5VI0QmPFyZfT+nYIyQdLsLG4uUCYL+wu7onOq+hLpQ6Ju5mdLXRt+RyGfI2iv5o9EuT9h8DszX3nkxeMq4VmAc09kh38+oqG4fmN8NQllwks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023800; c=relaxed/simple;
	bh=tT437XUkV8R24ZV0Yiv30gJ9fIZlns1uwh21usgLKuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApBw91iai1Cl70LPlndmEa4hdbuxP1HJ5oOsdt184/5ryKBkifrqjFvvpacVu1c+wDZtt23nbGPJnkwRelHczb+XcM7PpDGVxqh2sHG0Adbr6ZTdpC6Nb80wJHxFaJZMNkrYr/aAz0/1tQRp4K0pNy0j2NYy8jTxus1ZDlirZKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6793zE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6793zE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D60C4CECE;
	Thu, 12 Dec 2024 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023800;
	bh=tT437XUkV8R24ZV0Yiv30gJ9fIZlns1uwh21usgLKuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6793zE8bpwMXt1IxsSjc4e2O/r+NazVqHmPf4HNsVgv47oc387ducoT3hMPi/JZ9
	 ghP48wUzPyJxjdij/TKlZFlw4EYFfDHhhSf1N7h3VfoY2svjdPE4Juy4uvBJuVVVAu
	 kT7+82PVhJPi6Vb6u5rlDwA8B+7xXBu0igV9LiOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/459] x86/xen/pvh: Annotate indirect branch as safe
Date: Thu, 12 Dec 2024 15:56:34 +0100
Message-ID: <20241212144255.733193267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 82694854caa8badab7c5d3a19c0139e8b471b1d3 ]

This indirect jump is harmless; annotate it to keep objtool's retpoline
validation happy.

Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/4797c72a258b26e06741c58ccd4a75c42db39c1d.1611263462.git.jpoimboe@redhat.com
Stable-dep-of: e8fbc0d9cab6 ("x86/pvh: Call C code via the kernel virtual mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/head.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index afbf0bb252da5..b0490701da2ab 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -16,6 +16,7 @@
 #include <asm/boot.h>
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
+#include <asm/nospec-branch.h>
 #include <xen/interface/elfnote.h>
 
 	__HEAD
@@ -103,6 +104,7 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
 	/* startup_64 expects boot_params in %rsi. */
 	mov $_pa(pvh_bootparams), %rsi
 	mov $_pa(startup_64), %rax
+	ANNOTATE_RETPOLINE_SAFE
 	jmp *%rax
 
 #else /* CONFIG_X86_64 */
-- 
2.43.0



