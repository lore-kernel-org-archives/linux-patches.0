Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606AF3195F6;
	Wed, 17 Sep 2025 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113663; cv=none; b=st9bR8/MlOUHql7aFSvHug7WKZGgBRh4sL7F+NSDofPWcvw/wyQ7eobUrjYY7sT/t/60GhQQ7pZx+pqK48eQtStRTvLl1va2hsqjoJ+WLWjYM50fBWDprGQYlSUYmva33S327BOPUGNh+cX2Fgry240ed0J9q7K7bkscpAlmWF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113663; c=relaxed/simple;
	bh=dTe1guehP4lFNtxqisNPkh04cLkeeCgrJclCaa2rJGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgjCRnUbd/oNMMz/V1vGkSG+89R3aMhyXwvYffCyCU0TDxPIE1ykJOaXzNwU2Hh8bJkpIOJnybZUD+GiGtvavvuPPBwyyVAuAnMn2rc3F5jLxW0xYQvCTsJz/5d8G5cmPQhfdD6WzfUp/mm+3Kp8qcRSa0wcfiI81P2EdND1Ln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1WrpIYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1WrpIYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D25FC4CEF5;
	Wed, 17 Sep 2025 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113661;
	bh=dTe1guehP4lFNtxqisNPkh04cLkeeCgrJclCaa2rJGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1WrpIYvnPfHvyKJJ1QT53nVcUpHoE2vT5D4xdepL1leQ5x4tfO/d71HpcSmd9c0Z
	 N7G0t/R1q2SnayIit8AB7mKcAzH+5ZGHF+L1rtdR8Q9sSIdgTBVZYQ68Vax7rIKabT
	 q3bNtLe+oT+mAnqsX+MjJA77vubR6npecTyTlxQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/101] ftrace/samples: Fix function size computation
Date: Wed, 17 Sep 2025 14:33:58 +0200
Message-ID: <20250917123337.232186044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e2a6a69352dfb..b40f85e3806fc 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -40,8 +40,8 @@ asm (
 	CALL_DEPTH_ACCOUNT
 "	call my_direct_func1\n"
 "	leave\n"
-"	.size		my_tramp1, .-my_tramp1\n"
 	ASM_RET
+"	.size		my_tramp1, .-my_tramp1\n"
 
 "	.type		my_tramp2, @function\n"
 "	.globl		my_tramp2\n"
-- 
2.51.0



