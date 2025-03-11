Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B42255E37;
	Tue, 11 Mar 2025 15:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707508; cv=none; b=BvMtHPMfCqDU52Jsm/Fr3NmEUNn9rdtFI1TwTzIeMSpincIqeO/Myyaibbph/WZ7uM9RVABetuHKxtBIfLc9U5XaJVG+DR9moik8xj4hC42xNwwgRB1L8ZAheEjFawnoWMOuo4rYXXP+Ig6PYSeaHyYqC/0PjTsaXJbLJCS0BQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707508; c=relaxed/simple;
	bh=oc+O386Yz6cwTDbYEFmBgrH+Bbk3ryPf6Yrdlv/hFu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHE0BcOrwBoa82Bf0Yp1fgCakAVSSs7HqU1QFq5uaxVFWTcrV5cjIayDC8C+xYtbyjTVWtyTcG8z+8pe6XQdWWCYI51z2/aQQeqLR/LD6XRCV6JQFQGlu8YShnfYFiVF2MiW4OA5KbSfII3q2qNwiznQUUVKNtZGkzj+/LrKcHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsJGjbLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsJGjbLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6768C4CEEA;
	Tue, 11 Mar 2025 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707508;
	bh=oc+O386Yz6cwTDbYEFmBgrH+Bbk3ryPf6Yrdlv/hFu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsJGjbLanV4Q2SzxjYETf57mr+Vw1qXqrXM7utpfLe/H0pVe34DGdUfFwwqzYqvzz
	 RHI481aVrl1OyBXhiHaUB4NmTNYQGjtmjcL8tx2MlmYnp9u6RJqoyjm9eqzmuFOtYT
	 9Vvvw0kLQ/SFOf6XksO5D570F4t/QhlgxzsCZRMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yang <yang.yang29@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	"sh_def@163.com" <sh_def@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/462] kernel/acct.c: use dedicated helper to access rlimit values
Date: Tue, 11 Mar 2025 16:00:48 +0100
Message-ID: <20250311145813.439502106@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <yang.yang29@zte.com.cn>

[ Upstream commit 3c91dda97eea704ac257ddb138d1154adab8db62 ]

Use rlimit() helper instead of manually writing whole chain from
task to rlimit value. See patch "posix-cpu-timers: Use dedicated
helper to access rlimit values".

Link: https://lkml.kernel.org/r/20210728030822.524789-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: sh_def@163.com <sh_def@163.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 56d5f3eba3f5 ("acct: perform last write from workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index a7e29ca8f3591..2b2224b7ae55a 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -494,7 +494,7 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	/*
 	 * Accounting records are not subject to resource limits.
 	 */
-	flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+	flim = rlimit(RLIMIT_FSIZE);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	/* Perform file operations on behalf of whoever enabled accounting */
 	orig_cred = override_creds(file->f_cred);
-- 
2.39.5



