Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F7C31E10D;
	Mon, 18 Aug 2025 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521788; cv=none; b=UXBE4kBwg3oSIE2TRLzYaPLXfEwrjhme0CRZ8GV6a9uSpoVWAqRE3ZpRlloe/ahpeGKzzPN8sKvUojjAxDNe9r35H4X+vJrfClkd8XBtdguccw3WuTpvpouE4vusB/nZTDV4Llt5xY6uIJ+DL7U7DWbdHcggUCVBOvZL7eWhHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521788; c=relaxed/simple;
	bh=ozsfhQAjuHUkRMH+kPqBmQGowoOBQudc6Xk5eiPzGY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ6UaqLTjq/+oPqFeBB3uXg3kwb1G2kG8VZRShyr8nLcJwesDWPrLQfhOxIKuJ/1CsOoPvYs5YVfDESKRouOCTiXOyAy3Z8b88j/Sl7mf39D8f1iofb5wWBYI/L7LOk3WbFD2p8uc2yujwLFtZtSgFqQmD4JNacznQEqeh63UG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O4/tF01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O4/tF01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF635C4CEEB;
	Mon, 18 Aug 2025 12:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521788;
	bh=ozsfhQAjuHUkRMH+kPqBmQGowoOBQudc6Xk5eiPzGY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O4/tF01oObT/p5vbRWTX8AHmkVhEBzlGRJWC4sSwKBmRkKUu5HC8ve1gX0b1yOED
	 BWvDzwnxIg+3Bh7IsQqSX8xD82yLQKA+K1LuD5Yz+pBrHrY9tp59lJAxLgo6yYZGQX
	 hjpMiedkJnNHnUmfj96wxdy56yWYWMZhsGumIc4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/444] selftests: tracing: Use mutex_unlock for testing glob filter
Date: Mon, 18 Aug 2025 14:42:29 +0200
Message-ID: <20250818124453.527927785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



