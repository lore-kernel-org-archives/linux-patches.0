Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243501D63F3;
	Mon, 23 Mar 2026 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275357; cv=none; b=iWRYrruI4zacAVRnVtqznDYXL9bG62dAEEc3UtFpnp+SO8ltdCIqlZgNzvMVA+pkEoNMXbxBm6HY6iGZu2dlSY7vwXvaNL90oP4CIPMMy87X4X+/qZNBY/fsc1J+UavaxIdfzPvwJdIOgCH4llV6lexrZLu56yK9pkICnGWUNq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275357; c=relaxed/simple;
	bh=8glqN8qGyjI/k+WtqDqQozaJ7Kpp4iD1HmZBs62p+m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6y5aAZ8H43t4h5y/GllzcwmPW4PnpmJEdj7xy14xw1FAruu/bCt69LkvFLCrlLF+UCUI/Yizmy7JZRL2Ii0VK5aagSrFkIMArjvF3+fM4/F/K4xedEg1BX6EhBufaFoPj+1cS8TIcayr2yhtKdDfINAKxWZsjjvFEpxg5+r1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHY30QnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHY30QnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D5AC4CEF7;
	Mon, 23 Mar 2026 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275357;
	bh=8glqN8qGyjI/k+WtqDqQozaJ7Kpp4iD1HmZBs62p+m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHY30QnHWFdnJvvKKy3k/Aw5mRaP26G+zmnXeiVMyocWza59HKlLqrSTw5OVOkzef
	 UFY754nD+aBnO1xrGrTx33h9aYfBlZa99WcemsCotApS64nJjbbUe5TI7gpUsqT4wn
	 4jDxqiTRm4/pqqRMj8SN9ATUEsoz+bCC6xLWsk20=
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
Subject: [PATCH 6.12 070/460] perf ftrace: Fix hashmap__new() error checking
Date: Mon, 23 Mar 2026 14:41:06 +0100
Message-ID: <20260323134528.415955170@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a56cf8b0a7d40..09c484182d5bc 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -18,6 +18,7 @@
 #include <poll.h>
 #include <ctype.h>
 #include <linux/capability.h>
+#include <linux/err.h>
 #include <linux/string.h>
 
 #include "debug.h"
@@ -998,8 +999,12 @@ static int prepare_func_profile(struct perf_ftrace *ftrace)
 	ftrace->graph_tail = 1;
 
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



