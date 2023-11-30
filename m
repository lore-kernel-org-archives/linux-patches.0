Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BDE61FA9;
	Thu, 30 Nov 2023 22:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6qHnYsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBADEC433CB;
	Thu, 30 Nov 2023 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385114;
	bh=ygz8GAkUCKmbvaeQv/om8b01h6YC5bgvaFU+BzjZ6z8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=c6qHnYsgCWuCU2nlmsTLUgNl45JKy6I/X9RETzQvamPINGeFLAn81V5kVsBm74LgR
	 HPy+RiPRtFnaP7fH4SRVCkWVbDUZ4DxPfDt9uqE3R5aDWtr2MKBNtYYnIJgT68WsAJ
	 6R90OL4HQ3Nnie9DG2dD4s5RLfrMqaaPYeOPX3Sbx+9/2RkIEMSkxS70raUL+C4PBR
	 0wyvfCRv3I3FlnrbaFoPTcxh3kdbAFVFCtI6V09XDm3QLVzW2oXscxCKtJ9L/ITwN+
	 oc6q3SL6Frt7OQNwgSwP/NZAN2epwKPEIKxzgefAy4nefydElwgd8UENdBVIm7+fgm
	 EK0t+UQPL7euw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:31 -0700
Subject: [PATCH 18/19] hexagon: traps: Remove sys_syscall()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-18-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1052; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ygz8GAkUCKmbvaeQv/om8b01h6YC5bgvaFU+BzjZ6z8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwv0hh+Zcf/pyrqe41/LmCT0H5WfX2+/5dMVm5s6Gq
 nNRL+bzdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJWGUzMvy6cX3yWfvVUx64
 vmzc8VPy7gX7BCveO4kfxGWrFjse8XZkZNge/H/B78bojQEvnFkC9z7UtePsq/oYmiHCskbHZe8
 uFwYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/traps.c:335:6: warning: no previous prototype for function 'sys_syscall' [-Wmissing-prototypes]
    335 | long sys_syscall(void)
        |      ^
  arch/hexagon/kernel/traps.c:335:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    335 | long sys_syscall(void)
        | ^
        | static

This function is not used anywhere, so remove it.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/traps.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 6447763ce5a9..3f6ff43cb514 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -331,13 +331,6 @@ void do_genex(struct pt_regs *regs)
 	}
 }
 
-/* Indirect system call dispatch */
-long sys_syscall(void)
-{
-	printk(KERN_ERR "sys_syscall invoked!\n");
-	return -ENOSYS;
-}
-
 void do_trap0(struct pt_regs *regs)
 {
 	syscall_fn syscall;

-- 
2.43.0

