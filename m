Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D8E3EDADF;
	Tue, 17 Mar 2026 16:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765742; cv=none; b=YRrjFrr17TbR4Q+ciSf284Ap9Jo/K09PT6X4av8+wdqVzbbbUqET+cSGk/NTB6qxiOLFutTvwlCHzOGxOsfZzkzSHhQqv5ghnpvYNMus+04bYtLPCkJTUFNHWosPqJEknvQnAnrdA+Y5YKHYJBYs33uWwCx6VbSOhno6MqGvSac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765742; c=relaxed/simple;
	bh=6yVLH/tX8QFR7alH7W7pnJTGc206Udk892KQTLwvQkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfKBxd7sPjhgyL1elRcz6a/BrNS9jsYO9cGFMqnN9XgQBP4wkJD8WF1P9xG3wVohXQdgacft/TR8OkKN3JRHxdIZiBOGi1bBswV0xHUB167ciD4cyLl7m3HU/ejSzUl7UhDDkRG/CpQq9NaS/Nlu4Vx2zuNlAKAJQLDgSoTe/+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0Dflu3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0Dflu3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85317C4CEF7;
	Tue, 17 Mar 2026 16:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765741;
	bh=6yVLH/tX8QFR7alH7W7pnJTGc206Udk892KQTLwvQkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0Dflu3oZBGgoGVjfOV+gWwsb36mMVL2QcTRXZGoQQi2d4gYlDpkcNCX2HNP6hXmL
	 ptgaAhVQsoDssN04afsIENxmvSnLJVeY2GpITN7mOJMh+bKpBvCHtiU/jcDgPvblJs
	 qO8H7VLO/1ac/3cTuwqppqORPvp6YKmzPMi2KoMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 084/378] perf ftrace: Fix hashmap__new() error checking
Date: Tue, 17 Mar 2026 17:30:41 +0100
Message-ID: <20260317163010.106323385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit be34705aa527872e5ce83927b7bc9307ba8095ca ]

The hashmap__new() function never returns NULL, it returns error
pointers. Fix the error checking to match.

Additionally, set ftrace->profile_hash to NULL on error, and return the
exact error code from hashmap__new().

Fixes: 0f223813edd051a5 ("perf ftrace: Add 'profile' command")
Suggested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 6b6eec65f93f5..4cc33452d79b6 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -18,6 +18,7 @@
 #include <poll.h>
 #include <ctype.h>
 #include <linux/capability.h>
+#include <linux/err.h>
 #include <linux/string.h>
 #include <sys/stat.h>
 
@@ -1209,8 +1210,12 @@ static int prepare_func_profile(struct perf_ftrace *ftrace)
 	ftrace->graph_verbose = 0;
 
 	ftrace->profile_hash = hashmap__new(profile_hash, profile_equal, NULL);
-	if (ftrace->profile_hash == NULL)
-		return -ENOMEM;
+	if (IS_ERR(ftrace->profile_hash)) {
+		int err = PTR_ERR(ftrace->profile_hash);
+
+		ftrace->profile_hash = NULL;
+		return err;
+	}
 
 	return 0;
 }
-- 
2.51.0



