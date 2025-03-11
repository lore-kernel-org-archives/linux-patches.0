Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6517E110;
	Tue, 11 Mar 2025 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706187; cv=none; b=eYkbIi4xN7RZcbYZkoEFJp8XyZb8FcAtJZGZWYZJ6BQhoqyNn1gSA8m+p13GHEmoYbEzyrsgZudKmRcEZTuWNqvBdoWjNoXfY095XDorigRSguL1w643KPmLWx2rhlGkv1IDp9+FcIUECT57sfbIGEhUaKODkZE2U8DWPJgB4ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706187; c=relaxed/simple;
	bh=8atRGGi9WdjC6DyHKP0mpLz8dRH7eqMads1IqJZhgSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqyXHdfH1Jr/EqplaF114sBUYeTX0mdCWOQyMjsyLiHz5JVnVB7hcxKKpreeBWOXCf+PBsHHSV+ketMjE6Stv/rkAkCGLa2pO/WHL7JzU6GHeNpw6kI9vM6bbYF0FJYQ8pwEniwJ8O1heJgQQ2bVpxE9RFMQFHQ+wLuiAYyw77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GuglquJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GuglquJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2272CC4CEE9;
	Tue, 11 Mar 2025 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706187;
	bh=8atRGGi9WdjC6DyHKP0mpLz8dRH7eqMads1IqJZhgSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GuglquJLsLz71Xzy4/0ZY3ELqcR4sDuE9yVH/I7a9nGqTmabWKIrbfATsKAoshYV
	 NUb3V7/UohPYTssIycUVJL+q1leuNiLSjH8CCfx4rwz6mDUtcKzVGrc9aisHz9TnOr
	 JcMSZdl5Of+TjAsPMGHoyIdUhaXlQ83NhMiLDA/Q=
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
Subject: [PATCH 5.4 274/328] kernel/acct.c: use dedicated helper to access rlimit values
Date: Tue, 11 Mar 2025 16:00:44 +0100
Message-ID: <20250311145725.803601612@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 79f93a45973fa..cdfe1b0ce0e39 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -492,7 +492,7 @@ static void do_acct_process(struct bsd_acct_struct *acct)
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



