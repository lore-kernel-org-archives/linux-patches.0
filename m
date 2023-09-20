Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29818658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51892C433C8;
	Wed, 20 Sep 2023 11:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210646;
	bh=gMOYELr0Yw9JtSJmQcY7P4V0uPegjpU1czjBLhVqXB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3znkCrJ9fB4XScWQFtf7RoK7wZBSxpmCcRnTvw26tRkz+0aPQE0alfNT0A1EZWNt
	 ZNNpJGHsulHymfFtx9SqRYSH0nfgtVtrdHaBP7zFVvszXupJh/dF9b7pJ0R5uwRCK+
	 EQT9zA6/dlxww45+5TA28fTnQdk1PTRy9Gzy+aBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <David.Kaplan@amd.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 152/211] x86/ibt: Avoid duplicate ENDBR in __put_user_nocheck*()
Date: Wed, 20 Sep 2023 13:29:56 +0200
Message-ID: <20230920112850.584691164@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7575e5a35267983dcbeb1e0d3a49d21ae3cf0b82 ]

Commit cb855971d717 ("x86/putuser: Provide room for padding") changed
__put_user_nocheck_*() into proper functions but failed to note that
SYM_FUNC_START() already provides ENDBR, rendering the explicit ENDBR
superfluous.

Fixes: cb855971d717 ("x86/putuser: Provide room for padding")
Reported-by: David Kaplan <David.Kaplan@amd.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230802110323.086971726@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/putuser.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 1451e0c4ae22a..235bbda6fc823 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -56,7 +56,6 @@ SYM_FUNC_END(__put_user_1)
 EXPORT_SYMBOL(__put_user_1)
 
 SYM_FUNC_START(__put_user_nocheck_1)
-	ENDBR
 	ASM_STAC
 2:	movb %al,(%_ASM_CX)
 	xor %ecx,%ecx
@@ -76,7 +75,6 @@ SYM_FUNC_END(__put_user_2)
 EXPORT_SYMBOL(__put_user_2)
 
 SYM_FUNC_START(__put_user_nocheck_2)
-	ENDBR
 	ASM_STAC
 4:	movw %ax,(%_ASM_CX)
 	xor %ecx,%ecx
@@ -96,7 +94,6 @@ SYM_FUNC_END(__put_user_4)
 EXPORT_SYMBOL(__put_user_4)
 
 SYM_FUNC_START(__put_user_nocheck_4)
-	ENDBR
 	ASM_STAC
 6:	movl %eax,(%_ASM_CX)
 	xor %ecx,%ecx
@@ -119,7 +116,6 @@ SYM_FUNC_END(__put_user_8)
 EXPORT_SYMBOL(__put_user_8)
 
 SYM_FUNC_START(__put_user_nocheck_8)
-	ENDBR
 	ASM_STAC
 9:	mov %_ASM_AX,(%_ASM_CX)
 #ifdef CONFIG_X86_32
-- 
2.40.1



