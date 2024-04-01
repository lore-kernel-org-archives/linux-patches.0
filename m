Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD84446AC;
	Mon,  1 Apr 2024 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987824; cv=none; b=PDKi3rvbJIxt0WcqUQuGifG6QTCFcAa3oBuIesTdGcbJimsYPdXXmI9oo3LerQ0cgr7AxhGfSxRM9qAHUvWSuL+6u8PYJp4hESAAMZo85w2BBHJEOvMbok6NOMazfuuED9qon5HDTyQk7HdkkVj8dT9ZwpAZRvKO8UleODhbSqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987824; c=relaxed/simple;
	bh=wGpKSRzMuNDVyjz9say515/9xey5lKkwU92WWPCh/KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuHZCfPX/zFeYGoa0RBISF2ICQ/v5UalKcA76nsPo6HbIHx1y8qSqcKHu5uGn2LrxjlqwBWtE2MvQy+EFV39TUJNMsMJ/bBizG3QPir2W4oDCQIO0+J+wxFV8UXvJ2zfI7Z+v567SBmh/nwhvnB2stG0NNhvLKn+q8aalazvLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po3uPh99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po3uPh99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771CFC433C7;
	Mon,  1 Apr 2024 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987824;
	bh=wGpKSRzMuNDVyjz9say515/9xey5lKkwU92WWPCh/KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po3uPh990jGdW41WInrT1+fnmU19lQYehl/qmXECsDpLxzIiZtitxdF7B//5m6rEw
	 zrNChk13S0YI4SYDfMJ8e7D8VuCjKlyDcGUMK7aNeASOoIaGsohZCpKP66HnYMDeTF
	 4DERdOslh+TYtaeehI0o8/j5k3X6jl+Ba6aJrLDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.8 391/399] Revert "x86/bugs: Use fixed addressing for VERW operand"
Date: Mon,  1 Apr 2024 17:45:57 +0200
Message-ID: <20240401152600.840562454@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


