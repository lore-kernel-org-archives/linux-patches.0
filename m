Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25321D172E;
	Wed,  2 Oct 2024 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878074; cv=none; b=EQ9vCnhaaZr5WI6Sos/GcdNVtt+eYGSA+rZbA74kBn3jBjD+6Jr8Mz0I47XLe0jCZ9kvpc6biq4kk4//aJET/QBmme2aUauqywrmgqhPwFts6GmfHNxFlQeaM7OePsyiu/mvpSwuti2CXKY4eF5SppFp8Y2yi9ueBxfDxjfM0uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878074; c=relaxed/simple;
	bh=KoTFAteWV4sheTpo66zy0nbw5WnXODK+k8kv77BM0XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m94zApXaH+0n5kJYIVCrLYVbZI4EvGJCZl8imIzyw/gSvEtUww5w6jKL0UzUWikh1FFwEX1TiIbx+BX+gyRWcG0LsED5Q/ZFsplHOV+PpLkkO3vn7zOKJUpAaU/68zCpxznLm6fx5xJFhbe3hDE2lJ4VFmP+gZLa15dfPLj3B+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vg51lpdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vg51lpdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA15C4CEC2;
	Wed,  2 Oct 2024 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878073;
	bh=KoTFAteWV4sheTpo66zy0nbw5WnXODK+k8kv77BM0XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vg51lpdYlaDoxxDxsrVRCgGKRtago7OZUGTkH3GQeAwuSCs6F/Gv2gbVwkDPytkZB
	 j4CQvIxkC8+l1mptdU8rfGiQBgpA3hwH90xTO0HbttdPNZxUdgXHabmaaNePxG64Ck
	 FG5+gr6AxH7wtpuyV2Iak4mBThJwi1kDrFHHvHg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Benjamin Gray <bgray@linux.ibm.com>,
	coresight@lists.linaro.org,
	gankulkarni@os.amperecomputing.com,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 292/634] perf scripts python cs-etm: Restore first sample log in verbose mode
Date: Wed,  2 Oct 2024 14:56:32 +0200
Message-ID: <20241002125822.637226547@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit ae8e4f4048b839c1cb333d9e3d20e634b430139e ]

The linked commit moved the early return on the first sample to before
the verbose log, so move the log earlier too. Now the first sample is
also logged and not skipped.

Fixes: 2d98dbb4c9c5b09c ("perf scripts python arm-cs-trace-disasm.py: Do not ignore disam first sample")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Benjamin Gray <bgray@linux.ibm.com>
Cc: coresight@lists.linaro.org
Cc: gankulkarni@os.amperecomputing.com
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240723132858.12747-1-james.clark@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/scripts/python/arm-cs-trace-disasm.py | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/scripts/python/arm-cs-trace-disasm.py b/tools/perf/scripts/python/arm-cs-trace-disasm.py
index d973c2baed1c8..7aff02d84ffb3 100755
--- a/tools/perf/scripts/python/arm-cs-trace-disasm.py
+++ b/tools/perf/scripts/python/arm-cs-trace-disasm.py
@@ -192,17 +192,16 @@ def process_event(param_dict):
 	ip = sample["ip"]
 	addr = sample["addr"]
 
+	if (options.verbose == True):
+		print("Event type: %s" % name)
+		print_sample(sample)
+
 	# Initialize CPU data if it's empty, and directly return back
 	# if this is the first tracing event for this CPU.
 	if (cpu_data.get(str(cpu) + 'addr') == None):
 		cpu_data[str(cpu) + 'addr'] = addr
 		return
 
-
-	if (options.verbose == True):
-		print("Event type: %s" % name)
-		print_sample(sample)
-
 	# If cannot find dso so cannot dump assembler, bail out
 	if (dso == '[unknown]'):
 		return
-- 
2.43.0



