Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FF417A303;
	Tue, 26 Aug 2025 12:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212796; cv=none; b=lqrcLljZiJv/od/mmKgBCzUQS6hVRIwKyb1fW41qVl4JQR2RvjG7qSsVX7OpENiCtFQ1C0C27OYS5FDt56JF0ZXrNiux/GcOPtBqzktou9IKFiiKJgbf8qujKuGmKXXS/SusfBoVwKgJwwUSWcj4dZ2r0+7P4t5neEzmRjYSofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212796; c=relaxed/simple;
	bh=YYvhYnSdCdbyABJG+EFr1f9okkWBoG3hV+Ve6QOPcxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgUzAlIQV9lfGgD/2fL3AdgEKaGESaJhO26UbSQvMNH5+GU0GqGQHTwttFQBq5GCQ1VA1gtaPpYrdPWLTr1vQGgb2WDkcl+iLCwDkmuUPuGoGmyT9iynLOvYBcZJxGxOIlj/8+yAuB4OdNkADm+xsvDkZ23m0kh4lVhaQfBflcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9QO8GvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9QO8GvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF03C4CEF4;
	Tue, 26 Aug 2025 12:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212795;
	bh=YYvhYnSdCdbyABJG+EFr1f9okkWBoG3hV+Ve6QOPcxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9QO8GvFoPDyQlfZgt4EN3OzQpuLpIspjn6L+z3g783gd3enx7W38+ZAJD0mIs3Td
	 BDFpzGiKCOy2GRG3WAyo9ozL6RvT6jEDwbrmPVV/yO81OvPD4OaGBfl0ct26nk+UJJ
	 lIDMG81OOPpt5emnfurlmqmaerB2xkUWIB9XsIs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/587] selftests: tracing: Use mutex_unlock for testing glob filter
Date: Tue, 26 Aug 2025 13:04:15 +0200
Message-ID: <20250826110955.637078409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit a089bb2822a49b0c5777a8936f82c1f8629231fb ]

Since commit c5b6ababd21a ("locking/mutex: implement
mutex_trylock_nested") makes mutex_trylock() as an inlined
function if CONFIG_DEBUG_LOCK_ALLOC=y, we can not use
mutex_trylock() for testing the glob filter of ftrace.

Use mutex_unlock instead.

Link: https://lore.kernel.org/r/175151680309.2149615.9795104805153538717.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
index 4b994b6df5ac..ed81eaf2afd6 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
@@ -29,7 +29,7 @@ ftrace_filter_check 'schedule*' '^schedule.*$'
 ftrace_filter_check '*pin*lock' '.*pin.*lock$'
 
 # filter by start*mid*
-ftrace_filter_check 'mutex*try*' '^mutex.*try.*'
+ftrace_filter_check 'mutex*unl*' '^mutex.*unl.*'
 
 # Advanced full-glob matching feature is recently supported.
 # Skip the tests if we are sure the kernel does not support it.
-- 
2.39.5



