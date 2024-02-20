Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E71A612D7;
	Tue, 20 Feb 2024 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464097; cv=none; b=OIbUoouPKw4SBoJGZsTz9vt1JgmGAiNtk5Y8kyOdEMDxuyZuLKAGyZS8KleWDY0O4xanbyyglTYcuLmrzZvpzj/mIA16e0okcAKiHLComXrGigdHGjapjVp6EQ02nF1K4bF3ATPH1Ak/C52O9winNU4r4/am0dIAkfTROcxn1+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464097; c=relaxed/simple;
	bh=AIUmJDoCwJBKkc2WYy1GK4uy5xgeN+4WCM/g9HuDLcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1SdKfdsURlr3ryEAK+LXO4WCxp9h0+EzfkW7ucPTLm71lkNTYe0tMZgZVTdFUmuNxiiApQwj55h4V7fslw65Hsqmk6Fs/ldBWu2jsWRhhHbCe0q8dlj0qzTR3KireLZ5dF+KGE1TWRWD2mtOapsgmKr9sEhY3hWFE9I7ON3AdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3ZiGv2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3ZiGv2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1043DC433C7;
	Tue, 20 Feb 2024 21:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464097;
	bh=AIUmJDoCwJBKkc2WYy1GK4uy5xgeN+4WCM/g9HuDLcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3ZiGv2yEhtMKw+Poie6l1abtQOzm1WIpiW2QT0eV56Kh/7+LSyo+bDmifatON9N7
	 fAHCMShzVd+b7IigEIctw33YA6MwjMRbNu7rkp4JE3/ZuxDWtAmYz826WRmzSV/Hf9
	 NgBB/9QQ1ZY+xNq18E59nU2ekbskuX8lwJoCRZvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 251/331] tracing: Fix HAVE_DYNAMIC_FTRACE_WITH_REGS ifdef
Date: Tue, 20 Feb 2024 21:56:07 +0100
Message-ID: <20240220205645.718661699@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

commit bdbddb109c75365d22ec4826f480c5e75869e1cb upstream.

Commit a8b9cf62ade1 ("ftrace: Fix DIRECT_CALLS to use SAVE_REGS by
default") attempted to fix an issue with direct trampolines on x86, see
its description for details. However, it wrongly referenced the
HAVE_DYNAMIC_FTRACE_WITH_REGS config option and the problem is still
present.

Add the missing "CONFIG_" prefix for the logic to work as intended.

Link: https://lore.kernel.org/linux-trace-kernel/20240213132434.22537-1-petr.pavlu@suse.com

Fixes: a8b9cf62ade1 ("ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5331,7 +5331,7 @@ static int register_ftrace_function_nolo
  * not support ftrace_regs_caller but direct_call, use SAVE_ARGS so that it
  * jumps from ftrace_caller for multiple ftrace_ops.
  */
-#ifndef HAVE_DYNAMIC_FTRACE_WITH_REGS
+#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS
 #define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_ARGS)
 #else
 #define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)


