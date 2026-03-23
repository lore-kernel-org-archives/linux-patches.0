Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319FA3ACEF1;
	Mon, 23 Mar 2026 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274874; cv=none; b=NJLJloXfoiNPvAdO2xagaHVX/BBqrDsgdu7E2QEUCn9VHgw6ir4w7nHSS/Qj2iLNC8Os1xzIwcc4O6pSyWanyvphYR2WduxHF5U/uF2nx2em7Y4rKz+OYV/tkp5KuxJSR3GDZeVmSTxDQO3g6CHTgxW6eVcO7gRZSek230D+86I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274874; c=relaxed/simple;
	bh=wJNp1PFTbr08YSHzwQRyLSXyNCNyiJIzRpLopMGzy6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyj76lfwW2Qy2nmLGpsH9FuzwWrQhtGmuo0gOfw6eLsxq4naaPfkmmrURY0xXCgfYeRGk69BbH0xF+ua19/4iOwX0P+GlaasLf1rkxWtme8MJ5BWP6QU5zc4RUd8/8pVcR4tIPkBIHA0nq3X9MCg46GKafV68LU2C2vB/DhP4O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAyQvvLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAyQvvLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A19CC4CEF7;
	Mon, 23 Mar 2026 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274873;
	bh=wJNp1PFTbr08YSHzwQRyLSXyNCNyiJIzRpLopMGzy6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAyQvvLo9BBsGT6oVHuF/n1pzyNXXW6lLM+bwuwN0gDa+BZGMKsTsLoKGa1TdgJSH
	 KnzyU5QGpzLjUHF+4woTKGIczcq1rtJhRl9Yne9hnMUYKB9o29Y6tD3Yz2ZJLXXJU+
	 YK/22YuXnnBmdYjaGbhwTEox0ZJLkIj1JGg7psoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaudia Kloc <klaudia@vidocsecurity.com>,
	=?UTF-8?q?Dawid=20Moczad=C5=82o?= <dawid@vidocsecurity.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/212] netfilter: xt_time: use unsigned int for monthday bit shift
Date: Mon, 23 Mar 2026 14:46:01 +0100
Message-ID: <20260323134508.199165682@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenny Guanni Qu <qguanni@gmail.com>

[ Upstream commit 00050ec08cecfda447e1209b388086d76addda3a ]

The monthday field can be up to 31, and shifting a signed integer 1
by 31 positions (1 << 31) is undefined behavior in C, as the result
overflows a 32-bit signed int. Use 1U to ensure well-defined behavior
for all valid monthday values.

Change the weekday shift to 1U as well for consistency.

Fixes: ee4411a1b1e0 ("[NETFILTER]: x_tables: add xt_time match")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 6aa12d0f54e23..61de85e02a40f 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -227,13 +227,13 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	localtime_2(&current_time, stamp);
 
-	if (!(info->weekdays_match & (1 << current_time.weekday)))
+	if (!(info->weekdays_match & (1U << current_time.weekday)))
 		return false;
 
 	/* Do not spend time computing monthday if all days match anyway */
 	if (info->monthdays_match != XT_TIME_ALL_MONTHDAYS) {
 		localtime_3(&current_time, stamp);
-		if (!(info->monthdays_match & (1 << current_time.monthday)))
+		if (!(info->monthdays_match & (1U << current_time.monthday)))
 			return false;
 	}
 
-- 
2.51.0



