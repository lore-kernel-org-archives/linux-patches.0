Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B871E895;
	Mon,  1 Apr 2024 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989244; cv=none; b=RTdnxlX0bQ7CG1ivfmsSf21+/vIW6+H3yPPA06CLbrKBFn5EqOZKei/eVKSTPpdsln3hfG+ThvXgieb5RXWBUUyqWhgPkr2hd2rAlG6hsNaU0klzvz9DzDAyhpbmSsNgH/gExPRGHTx06zCg4r5a/R57XZrhDwIN5jt4E9Zvl7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989244; c=relaxed/simple;
	bh=EEcM5N8D68YrnppjX/t3gfopCFs/vqHYhEOWeLcIHt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzmg918oejfY9CJIWxBcucfr9g4F0BRBCBSapfV4Y+ObxlVxajfrOD/XLl+f+AIm3IHzquOTuszQHzvurBzCGQ0iz1HtAAMPAtYJFGPfsDaNIsgaf2sg6eXu2ZJfC3G8bff5hijVFq8FEFK3/dWWQQPsnqEHdpaOg8InSfSv3uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4WlDZgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4WlDZgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E1DC43390;
	Mon,  1 Apr 2024 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989244;
	bh=EEcM5N8D68YrnppjX/t3gfopCFs/vqHYhEOWeLcIHt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4WlDZgB+22plTSfC5ttxp3GlPvFrqPS6LuzKi1C1owcsXjT2OPYwBEuujOag4jqk
	 0Z/y8qeGLpoJXVv722E5vD7A6mXhFEh2klsVbBdMAK2DSHkAeoPBlwt6wDms8M/dd0
	 rMDLe1uvfJgy/1Itv0reNVy838Kg6PXpKk2rWD+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.7 425/432] Revert "x86/bugs: Use fixed addressing for VERW operand"
Date: Mon,  1 Apr 2024 17:46:52 +0200
Message-ID: <20240401152606.103305985@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 532a0c57d7ff75e8f07d4e25cba4184989e2a241 upstream.

This was reverts commit 8009479ee919b9a91674f48050ccbff64eafedaa.

It was originally in x86/urgent, but was deemed wrong so got zapped.
But in the meantime, x86/urgent had been merged into x86/apic to
resolve a conflict.  I didn't notice the merge so didn't zap it
from x86/apic and it managed to make it up with the x86/apic
material.

The reverted commit is known to cause some KASAN problems.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -332,7 +332,7 @@
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 .macro CLEAR_CPU_BUFFERS
-	ALTERNATIVE "", __stringify(verw mds_verw_sel), X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", __stringify(verw _ASM_RIP(mds_verw_sel)), X86_FEATURE_CLEAR_CPU_BUF
 .endm
 
 #else /* __ASSEMBLY__ */


