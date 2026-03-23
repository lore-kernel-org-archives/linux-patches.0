Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB683947A6;
	Mon, 23 Mar 2026 14:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275064; cv=none; b=uZhNmbNBPbwMeuTwl+AwnJya6Kb4J0TWiqzShirK9WSuL3kawaxwGzEmL1ne/SitYI6YvwsxfmNmZJ1tuiS2Izjeo8/PROj8AY00Qj1wjRQhne4cQeMyKNOue7/0k9pdH5J5VlMC3gp9LuZyGt21E3Bd8lXy8sofVu5n6DY6vH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275064; c=relaxed/simple;
	bh=YxhwtmF0wfjOhTFg51h9dPUpho76OFYinC/Lvlyrz7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5exP52oeAhrz4kZJPsXSeXZVbOTvcYl33KXdh/+84nmivEhnEAI3+x2ep/3h6f5StczG+3oWGIrZKGvKL7GMB9IqYA4dX7iBzEHGfXgnTp30s781EVkWOhXdWKmtCNkeX6x1SYaqU2BckJtHy3A+VwEiVdf3jFhAaZe8Rho+ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8DBodce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8DBodce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26093C4CEF7;
	Mon, 23 Mar 2026 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275064;
	bh=YxhwtmF0wfjOhTFg51h9dPUpho76OFYinC/Lvlyrz7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8DBodce3bQ21HLHi6dGuPAJKXDikx7YozdE20ZmShYQTYKQrQGL81Plqwjt377oU
	 3m5RAtJ7luf8dnWfRersNF1EmX8MEBIkgvW0VCBIIDr4XJqmos0sXgr4p90GX2fkQj
	 fGcOI2TSMK+3bVmwQHbcIjXuazShtJxKNyMXS684=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/212] fs/tests: exec: Remove bad test vector
Date: Mon, 23 Mar 2026 14:47:09 +0100
Message-ID: <20260323134510.355475638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit c4192754e836e0ffed95833509b6ada975b74418 ]

Drop an unusable test in the bprm stack limits.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net
Fixes: 60371f43e56b ("exec: Add KUnit test for bprm_stack_limits()")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tests/exec_kunit.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
index f412d1a0f6bba..1c32cac098cf5 100644
--- a/fs/tests/exec_kunit.c
+++ b/fs/tests/exec_kunit.c
@@ -94,9 +94,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3 + sizeof(void *)),
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 *  + sizeof(void *)),
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-- 
2.51.0



