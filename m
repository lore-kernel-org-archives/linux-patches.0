Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19363E;
	Mon,  1 Apr 2024 16:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990552; cv=none; b=Y6TNS13LgyCIUGizmAvvlQmza+ZbVBwitgi+0xuBimqnemmiXIK40uiHSt5yrpGYeTN+DbCjmkPpcKdj8E7x0W6uNQSKZscGJb6+pdkgY/G0ZBV6my65rQONLzDXc1pWrUaI9cricZi7IcFbAN57RmJsZAw1NNJRQSjjlU1DjMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990552; c=relaxed/simple;
	bh=S5oPVoRAd0IpZgw9R899DYtLVQ/zEqPbM/8nBT5AtJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsS8Hucg0BpSrgMPc+B/rRSjFvdkpSgfwIZwLTdqWAtyoveFjewptIX3le6EjqUpqes9rz4W239eSY+J+wldluUp4Lu+FenN2eCFNaEigqIzhvpQS0KQ/6Lstjbuu+bVZ3LLTLe+7CwA92H0PhTl1ip9ZKKkLTnn1wkSoUGCv4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2ylvV7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2ylvV7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6A4C433C7;
	Mon,  1 Apr 2024 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990551;
	bh=S5oPVoRAd0IpZgw9R899DYtLVQ/zEqPbM/8nBT5AtJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2ylvV7OhLBGtY/UkcZm37eQTD5+lZXoF55QG39w5aaZF/HaWk4tfYe0qYOfnsQBP
	 R2qioESFPKUb6mpnEgzMvsCd4tvdx2S05JtHC5A5qQx1BxIKXdnm56/rRnJi86s5ob
	 ljYg9rAZohHma2tCI700QKPX6hdg+L+gdp12AGG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.6 389/396] Revert "x86/bugs: Use fixed addressing for VERW operand"
Date: Mon,  1 Apr 2024 17:47:18 +0200
Message-ID: <20240401152559.510745934@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -337,7 +337,7 @@
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 .macro CLEAR_CPU_BUFFERS
-	ALTERNATIVE "", __stringify(verw mds_verw_sel), X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", __stringify(verw _ASM_RIP(mds_verw_sel)), X86_FEATURE_CLEAR_CPU_BUF
 .endm
 
 #else /* __ASSEMBLY__ */


