Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D0335074;
	Fri, 17 Oct 2025 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714020; cv=none; b=q/7u5jWfZvU5XLdl1BtpTRpGdv4z4BRg1MBsVqg6iPuo4ZRQlO+RFDr8P97toA6oYPdTr/c9lQ4DzHDWkQ5bwsJb/ZfvBxzy1qdCnCD3SF+WLBZxe9piyavRBasCiiW9cX8hZk0G1XDwY/vyGBPBlaWc1Jqx96cWpbU4d9AE3Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714020; c=relaxed/simple;
	bh=XFiIlztGF5J0Jn4XgCDcUI0ujsToq0b575g5XAx5KF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbK8ZUCQALFL6ZwZe/akRx5Mo0ze5Di2qwG0zPkpqH2ZrnmVG31zv1n5GX4ZfYPr/g7zOSdrRa29I5KRVm5vJUegVpZIa2IwaJjkNjgpInjePsma2RPL2c91zF8mcMS57p2fKyNUw0DFZwZd1lmA91Wb3Dx7qRe3h8bOKIwbJcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzRLHvLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzRLHvLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C583C4CEF9;
	Fri, 17 Oct 2025 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714020;
	bh=XFiIlztGF5J0Jn4XgCDcUI0ujsToq0b575g5XAx5KF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzRLHvLDTsFqAM5NXyKarUfjuRleYUQ+A2BlwYPrVduRtMd+n2v3gDebGn4VGZFid
	 yy7KNLxA1KUl+TlIkAkToPNIaRyIPfseo/7Nh9nni+Cdpr/mrBjIi3QB3+QRAVP+eA
	 3NAUHufyBmBBPAv7AJCR/+l4VVq41o9CCt0h0+oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.6 201/201] perf test stat: Avoid hybrid assumption when virtualized
Date: Fri, 17 Oct 2025 16:54:22 +0200
Message-ID: <20251017145142.142372435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

commit f9c506fb69bdcfb9d7138281378129ff037f2aa1 upstream.

The cycles event will fallback to task-clock in the hybrid test when
running virtualized. Change the test to not fail for this.

Fixes: 65d11821910bd910 ("perf test: Add a test for default perf stat command")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241212173354.9860-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/shell/stat.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -161,7 +161,11 @@ test_hybrid() {
   # Run default Perf stat
   cycles_events=$(perf stat -- true 2>&1 | grep -E "/cycles/[uH]*|  cycles[:uH]*  " -c)
 
-  if [ "$pmus" -ne "$cycles_events" ]
+  # The expectation is that default output will have a cycles events on each
+  # hybrid PMU. In situations with no cycles PMU events, like virtualized, this
+  # can fall back to task-clock and so the end count may be 0. Fail if neither
+  # condition holds.
+  if [ "$pmus" -ne "$cycles_events" ] && [ "0" -ne "$cycles_events" ]
   then
     echo "hybrid test [Found $pmus PMUs but $cycles_events cycles events. Failed]"
     err=1


