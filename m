Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFECE367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DF8C340E7;
	Sat, 26 Feb 2022 03:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845054;
	bh=9w6nj+vfsclp2nD/Fbt10tUJnWck/t9iRVcxDsSPfMk=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=KPLzSg/OHZq1SXQ6oUZ1MvQqVYcLM/KMLnrxH1iZrSG8YUu1pVg0l9tJtlS6sPuDp
	 nssA4mGNXvl04woSMBjqp7woE1nvhXyENMLPUPAd0iK5Lf8gwBGXWLMjovqXGfmxU1
	 csINX8wKFWnUWbJA1DEOqZryrJxzxXZluu8cJdCU=
Date: Fri, 25 Feb 2022 19:10:53 -0800
To: yzaikin@google.com,sfr@canb.auug.org.au,keescook@chromium.org,mcgrof@kernel.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 01/12] MAINTAINERS: add sysctl-next git tree
Message-Id: <20220226031054.47DF8C340E7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: MAINTAINERS: add sysctl-next git tree

Add a git tree for sysctls as there's been quite a bit of work lately to
remove all the syctls out of kernel/sysctl.c and move to their respective
places, so coordination has been needed to avoid conflicts.  This tree
will also help soak these changes on linux-next prior to getting to Linus.

Link: https://lkml.kernel.org/r/20220218182736.3694508-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-sysctl-next-git-tree
+++ a/MAINTAINERS
@@ -15567,6 +15567,7 @@ M:	Iurii Zaikin <yzaikin@google.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git sysctl-next
 F:	fs/proc/proc_sysctl.c
 F:	include/linux/sysctl.h
 F:	kernel/sysctl-test.c
_
