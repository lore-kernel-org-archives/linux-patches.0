Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D9147887B;
	Sat, 12 Sep 2026 11:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212635; cv=none; b=qHtG/e93ki6foaX2hBihLzTRsl94Mz8Jhk0PWxiM1qflD3QHbMJDfca0yJGHzuYfLmQxnV8IDL6i7IdbsXwrapJSuv01tLzo+oUzlgLUMAVdE28cO/yKAQLzttj4GR9VF/dctdAScFPNTu7Dy/GrfvWzdtzm2LJlQ3uZbfAdT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212635; c=relaxed/simple;
	bh=IVUQ1BvDTyDXagcyGYf468nQlvQoYFCcrVaGLOIneRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr6mtldPpdhrlEc89tloKbTNyx8+nVt/dlLkxiW6QQhYkVQQsV/lYF8XQki55wG3R5nFjgER4d+oIDfosdUk5C/Ln/5GGojjIWxIhB4ztx+CLAEX+ZCDvrkqPcK5EDSSFf2ATwlrUNqVzfA+HCjpRK9bBcLyUdm/VSue6yGDJ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2gO2mU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2gO2mU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C1F1F000FF;
	Sat, 12 Sep 2026 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212632;
	bh=vHw2ouSMxjHQ3IXMymigAwD7KmX+r8pF4IEly3mubjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2gO2mU1t+Yn70lKxyQU8Qdg6UFHIL0Ba81p1BlaOoY3g8QPBUEvv6vYMgBXz3Sl+
	 xOxkcQh5SanBdiRvVA2Y33o6iwDQqSbKIUTJb9HJXe+WF3a8W46EopnpsujIhHto4/
	 T5qpH3o5yeG3Z11fWFqMFXMdkLbdF+QPysPJ4VZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1477/1518] s390/entry: Use lay instead of aghik
Date: Sat, 12 Sep 2026 09:00:46 +0200
Message-ID: <20260912065656.970283079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 1c93edfd506ccaf9e9982dfdafc91cd2d444ad63 ]

Use the lay instruction instead of aghik. aghik is only available since
z196, therefore compiling the kernel for z10 results in this error:

   arch/s390/kernel/entry.S: Assembler messages:
   arch/s390/kernel/entry.S:165: Error: Unrecognized opcode: `aghik'

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511261518.nBbQN5h7-lkp@intel.com/
Fixes: f5730d44e05e ("s390: Add stackprotector support")
Reviewed-by: Jan Polensky <japo@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 114f25e9cf23f..3ca2378330bd5 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -162,7 +162,7 @@ SYM_FUNC_START(__switch_to_asm)
 	stg	%r3,__LC_CURRENT(%r13)		# store task struct of next
 	stg	%r15,__LC_KERNEL_STACK(%r13)	# store end of kernel stack
 	lg	%r15,__THREAD_ksp(%r1,%r3)	# load kernel stack of next
-	aghik	%r4,%r3,__TASK_pid
+	lay	%r4,__TASK_pid(%r3)
 	mvc	__LC_CURRENT_PID(4,%r13),0(%r4) # store pid of next
 	ALTERNATIVE "nop", "lpp _LPP_OFFSET(%r13)", ALT_FACILITY(40)
 #ifdef CONFIG_STACKPROTECTOR
-- 
2.53.0



