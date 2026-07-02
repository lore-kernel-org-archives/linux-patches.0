Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B1399D0B;
	Thu,  2 Jul 2026 16:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009931; cv=none; b=HtiQzf9AsBwBOuOI1z5OPyqLpCtRASLjn6cM4LIlEbloa8/aCOMHIUlCDieAaKvFyG5/CAcqijRbw/OdN6rhRiIWdAv5Iy6u/335MBEchyboRbqOvS+gZgQlq9dsr3A0kpz5bArnuvN0HTjXdNQoITAAk6tqLZBhRWkBic7V6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009931; c=relaxed/simple;
	bh=aeZcYLCwIi5dbgRlq6T82PoN9hIpLGSlb1d1+cIikcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6R2q9cZ5ZAyB2dZGmlVRF3OhhFSQUAQeIsCWDjqOnDUBl3YCgMCnFJRK9y4KZGnXd6V00I/9VeKPy+huZxx+RDELt3D02ql6/0+rN9M/PeGhAr2fYrd1zbLpA379mAvOyEK3aSsbG7jOZwChcoA/ly6IcKsBOACdhA9wNHRtL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU6iWQwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU6iWQwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51401F000E9;
	Thu,  2 Jul 2026 16:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009930;
	bh=Qz7H0f8sY6gyw0t0o/5aPtYh4dSAUAyqDkdayM6QvPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qU6iWQwtKoBZ/GkGJWgEcpcUeOwVGKEx3kIxTzxiX4mby/0YkKa1LpRj0KfiMwTYc
	 ybGDTUNZJrOWMIWV+tu0ZkZ/fo/JlyzN7CuvBjKPZYTnt7MV7YvVOxJPYQvhSiON/r
	 ++nGQqMn9xK6BXVcb5X3HxKThhPp8QSbN2wVNuFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/129] perf block-range: Move debug code behind ifndef NDEBUG
Date: Thu,  2 Jul 2026 18:19:24 +0200
Message-ID: <20260702155113.081402858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 984a785f25e5b5db5fa673130b60dca6ca794406 ]

Make good on a comment and avoid a unused-but-set-variable warning.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20230330183827.1412303-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 616b14b47a86 ("perf build: Conditionally define NDEBUG")
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/block-range.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/perf/util/block-range.c b/tools/perf/util/block-range.c
index 1be43265750137..680e92774d0cde 100644
--- a/tools/perf/util/block-range.c
+++ b/tools/perf/util/block-range.c
@@ -11,11 +11,7 @@ struct {
 
 static void block_range__debug(void)
 {
-	/*
-	 * XXX still paranoid for now; see if we can make this depend on
-	 * DEBUG=1 builds.
-	 */
-#if 1
+#ifndef NDEBUG
 	struct rb_node *rb;
 	u64 old = 0; /* NULL isn't executable */
 
-- 
2.53.0



