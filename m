Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE1E183CBF;
	Tue, 30 Jul 2024 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356227; cv=none; b=J85kp+Gzcw9MvjoGmpk9ypYJoQCzGAkmnAMPjJzx6HvAuRtnfnfM903+0nD6FV8zBhrvCMj1X5LysakBd24AoSpf0v90qFHTeEtZufynZcamkd7CDUJyGVSglvN7LzRd77HXD9V69/pgOSdJ+3uSgUmMwc4tUHY+2a51awOkPH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356227; c=relaxed/simple;
	bh=WZkc0GdqszdnYYx1qOtUDIxLNaTT+9v10IAvkFZMnb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMVURK4c77VKzgpUvJjiYLthHvAXqlLsACWHfKn3j7iNlRopPjU2J7zSvccJogHtjLXhf+7HjWFYPe63YpzUVc9+s1PtorSe/Z9x1nIebPS+x1T+4QIsufo9ceYeAivkT7bXpiwN+7OgbeeNhVcTiD9iAxHKMTqT8Xli03+rTGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmDeD8P7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmDeD8P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E5EC32782;
	Tue, 30 Jul 2024 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356227;
	bh=WZkc0GdqszdnYYx1qOtUDIxLNaTT+9v10IAvkFZMnb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmDeD8P7V89e/K112dFUfdlWoGyuqs3rA0bPtF5mRTPzq8uyYbU5UnW8NRZHxAJWF
	 5YxqWfDX0oYKVjkDxWeBZR2oiqorPPa3gTQOr0LLlI0Pke6mmOUXhAfk1oSlHEzLrj
	 AyvglX3Mkf5Q5xHVqKfstaShz+wzG7y4CyzoSJM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Rogers <irogers@google.com>,
	spoorts2@in.ibm.com,
	Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/440] perf tests: Fix test_arm_callgraph_fp variable expansion
Date: Tue, 30 Jul 2024 17:46:31 +0200
Message-ID: <20240730151622.047214609@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 33fe7c08446af6dda0ff08ff4fa9c921e574477f ]

$TEST_PROGRAM is a command with spaces so it's supposed to be word
split. The referenced fix to fix the shellcheck warnings incorrectly
quoted this string so unquote it to fix the test.

At the same time silence the shellcheck warning for that line and fix
two more shellcheck errors at the end of the script.

Fixes: 1bb17b4c6c91 ("perf tests arm_callgraph_fp: Address shellcheck warnings about signal names and adding double quotes for expression")
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: spoorts2@in.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Link: https://lore.kernel.org/r/20230622101809.2431897-1-james.clark@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: ff16aeb9b834 ("perf test: Make test_arm_callgraph_fp.sh more robust")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_arm_callgraph_fp.sh | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/shell/test_arm_callgraph_fp.sh b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
index 1380e0d12dce3..66dfdfdad553f 100755
--- a/tools/perf/tests/shell/test_arm_callgraph_fp.sh
+++ b/tools/perf/tests/shell/test_arm_callgraph_fp.sh
@@ -15,7 +15,8 @@ cleanup_files()
 trap cleanup_files EXIT TERM INT
 
 # Add a 1 second delay to skip samples that are not in the leaf() function
-perf record -o "$PERF_DATA" --call-graph fp -e cycles//u -D 1000 --user-callchains -- "$TEST_PROGRAM" 2> /dev/null &
+# shellcheck disable=SC2086
+perf record -o "$PERF_DATA" --call-graph fp -e cycles//u -D 1000 --user-callchains -- $TEST_PROGRAM 2> /dev/null &
 PID=$!
 
 echo " + Recording (PID=$PID)..."
@@ -33,8 +34,8 @@ wait $PID
 # 	76c leafloop
 # ...
 
-perf script -i $PERF_DATA -F comm,ip,sym | head -n4
-perf script -i $PERF_DATA -F comm,ip,sym | head -n4 | \
+perf script -i "$PERF_DATA" -F comm,ip,sym | head -n4
+perf script -i "$PERF_DATA" -F comm,ip,sym | head -n4 | \
 	awk '{ if ($2 != "") sym[i++] = $2 } END { if (sym[0] != "leaf" ||
 						       sym[1] != "parent" ||
 						       sym[2] != "leafloop") exit 1 }'
-- 
2.43.0



