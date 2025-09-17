Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BBB333A9F;
	Wed, 17 Sep 2025 12:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113990; cv=none; b=miyhoyIcst5hH3SYXbfw6NtjG0kU/kcQ3eHPFAe8k0szjEkC+lyKtfNcAPaQ9kMrnNBiwOX5kwiAig7VymLM51t34jOrDerngP45Laov1n3DuKCfqtWyg5l3guRfCeqIOHIjWkQ4GeETYGLoghxqLe+Prlry8iWgcIARXnw8a6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113990; c=relaxed/simple;
	bh=YTSPhMCkD9NsRv3ot8YUikNJHMGr4W8/fMp/zLvhHac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4V1goYESWdtXfRmBWVgc42+v0ddf+FrLMVEed8+pIARc4ApT3mP58mQSGCi3uJPK5UmWe2NXK5zFqWc7L3QpTAU5FYDs4JCDnT9WEcyAW0xrp9Xe3r5XthcyMteTZiAfxUDxutQjhtnc7MHMg02Sf6YBmGEbup37o6lW/fY7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWlldLq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWlldLq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45ECC4CEF5;
	Wed, 17 Sep 2025 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113990;
	bh=YTSPhMCkD9NsRv3ot8YUikNJHMGr4W8/fMp/zLvhHac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWlldLq4UlbRjUWOe/owj/1n/XB+0Utbgqd/pTKFe+IhC2XECz1GnZxoT07IzJ7jq
	 6mexFX5DMknLQaHTlnajhoe6wor7SLmw4rD3iSia1hSSzKghIlvT1JFovuYhCR/fLE
	 HbUD3PI2g+lQIh2kEnYh8lRb0xtHaAgDwwM857hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/78] ftrace/samples: Fix function size computation
Date: Wed, 17 Sep 2025 14:34:35 +0200
Message-ID: <20250917123329.916686583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 80d03a40837a9b26750a25122b906c052cc846c9 ]

In my_tramp1 function .size directive was placed above
ASM_RET instruction, leading to a wrong function size.

Link: https://lore.kernel.org/aK3d7vxNcO52kEmg@vova-pc
Fixes: 9d907f1ae80b ("samples/ftrace: Fix asm function ELF annotations")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-modify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/ftrace/ftrace-direct-modify.c b/samples/ftrace/ftrace-direct-modify.c
index 39146fa83e20b..cbef49649ce01 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -36,8 +36,8 @@ asm (
 "	movq %rsp, %rbp\n"
 "	call my_direct_func1\n"
 "	leave\n"
-"	.size		my_tramp1, .-my_tramp1\n"
 	ASM_RET
+"	.size		my_tramp1, .-my_tramp1\n"
 
 "	.type		my_tramp2, @function\n"
 "	.globl		my_tramp2\n"
-- 
2.51.0



