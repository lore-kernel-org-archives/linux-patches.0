Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023927;
	b=HtXtR+EfU1jYxEyfUQCO7VFPd9iHU0tVyl9VGJiMb+/TNHqD1OGFxGzs9UYai3OH3QAB
	 C2+xrzAFCw1bRC3OUX2cZBfdjFBcNsCXngYEqYxQjNh5ESPcpzdmaOsbnmft/JmHmxCQd
	 HZIR0gjGME/Brve2opjU7TdVL/7MexQIF4WfqIejcn6lzdRHIUaGcLJjq3vrIrELk5YO4
	 X2vKgH/l6W1GLLgLSBXSjoUeYdc0ezeXlvad46ZvafwOYlelZZ4ksdyYCc9YPbkl74zgY
	 8qWNS44q5co/3lbFOR5CDNUN4IJA4zQiD7Gdu1WnAjzBAyv3qabKtMqCo8hFg+1K34w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkYSCQI0jdmlSe+y3wRAxFb8jv9MIuUDekyXfMPv1Hs=;
	b=mI+o7vQTe2cSyp0FDt2lGDurPd4SyuTheRoUFryINag8sNSXJNaigWUeHq3OXtsAAcID
	 rjaW8qul6GTJUzYmIenFyJ6ThckYCng3YeDC10xR0ODOHB6v8eBbbihR+l2j8pDGxfhwM
	 lneuqUH6evlH2uxECIjpxxOgiUFCO/osUfiiYJy9VbtPXpISNS50U+W0ca4i+mFbSGInl
	 vZEdR6caVRj/37GV3fyuKoRuTbtBO0OvLweqxs4rX25MJ1UZZrhTmEpEMXOw1HhXrcr9d
	 IyfttR4DY6aec6tlyOgaaGFoM/33JzxZqILQQyFhHgBj9U97BFxS8CCblQ7BZeYTEww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjuLPBhK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E00F606A325;
	Wed, 18 Nov 2026 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjuLPBhK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB3D1F000C4;
	Wed, 18 Nov 2026 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023927;
	bh=LkYSCQI0jdmlSe+y3wRAxFb8jv9MIuUDekyXfMPv1Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjuLPBhKSIt0R5zqPIQxBrpG/bIVmAN/FFdodzzP23vAYUzdL+3UrR/ruAAPDq9vB
	 y213ZbD+gdPwznt05RvQTztRxkDKnCFusD+Rxnrqba2f4pJxvNAqgVAZt5CttV+vG0
	 f8lFKAfkGv7r5iMdWrI38f+mc++XXwrIJhlY7ho4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0543/2151] perf topdown: Dont require config1==0 for a slots event
Date: Wed, 18 Nov 2026 15:37:58 +0100
Message-ID: <20261118150141.764316194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 0824af00a8d2ede0d8bc70bdc0b493ecfd167900 ]

arch_is_topdown_slots() requires config1 == 0, so it misidentified
"cpu/slots,metrics_clear=1/" as not being the slots event, and an
additional slots event gets inserted, which fails event scheduling
since the group now needs two fixed counter 3.

  $ perf stat -e "{cpu/slots,metrics_clear=1/,cpu/topdown-retiring/}" -- sleep 1
  WARNING: events were regrouped to match PMUs
       <not counted>      slots
     <not supported>      cpu/slots,metrics_clear=1/
       <not counted>      cpu/topdown-retiring/

Drop the config1 == 0 check from arch_is_topdown_slots(). This is
safe: config1 has no bearing on the event's identifying config value
(TOPDOWN_SLOTS, 0x0400).

The attr.type == PERF_TYPE_RAW check is what actually matters: only the
core PMU is registered with PERF_TYPE_RAW, and on x86, 0x400 is
guaranteed to be slots event on core CPU.

arch_is_topdown_metrics() keeps its own config1 == 0 check, since
genuine metrics events have no "metrics_clear" and config1 remains 0.

Add a test verifying that an explicit "slots,metrics_clear=1" event in
a group does not trigger an extra slots event injection.

Fixes: 5b546de9cc177936 ("perf topdown: Use attribute to see an event is a topdown metic or slots")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
[ Add missing stdio.h and string.h as noticed by Sashiko ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/tests/topdown.c | 30 +++++++++++++++++++++++++++++
 tools/perf/arch/x86/util/topdown.c  |  3 +--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/x86/tests/topdown.c b/tools/perf/arch/x86/tests/topdown.c
index 221f2c4bbb615..2ccbfa0ebbb41 100644
--- a/tools/perf/arch/x86/tests/topdown.c
+++ b/tools/perf/arch/x86/tests/topdown.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <errno.h>
+#include <stdio.h>
+#include <string.h>
 #include "arch-tests.h"
 #include "../util/topdown.h"
 #include "debug.h"
@@ -229,10 +231,38 @@ static int test__x86_topdown_slots_injection(struct test_suite *test __maybe_unu
 	return TEST_OK;
 }
 
+/*
+ * An explicit "slots,metrics_clear=1" event is still the slots event and
+ * must not cause an extra slots event to be injected into the group.
+ */
+static int test__x86_topdown_metrics_clear(struct test_suite *test __maybe_unused,
+					   int subtest __maybe_unused)
+{
+	struct perf_pmu *pmu;
+	char event_str[128];
+	int ret;
+
+	if (!topdown_sys_has_perf_metrics())
+		return TEST_OK;
+
+	pmu = perf_pmus__find_by_type(PERF_TYPE_RAW);
+	if (!pmu || !perf_pmu__has_format(pmu, "metrics_clear"))
+		return TEST_OK;
+
+	snprintf(event_str, sizeof(event_str),
+		 "{%s/slots,metrics_clear=1/,%s/topdown-retiring/}",
+		 pmu->name, pmu->name);
+	ret = test_sort(event_str, 2, 1);
+	TEST_ASSERT_EQUAL("explicit metrics_clear slots event isn't duplicated", ret, TEST_OK);
+
+	return TEST_OK;
+}
+
 static struct test_case x86_topdown_tests[] = {
 	TEST_CASE("topdown events", x86_topdown),
 	TEST_CASE("topdown sorting", x86_topdown_sorting),
 	TEST_CASE("topdown slots injection", x86_topdown_slots_injection),
+	TEST_CASE("topdown metrics_clear no extra slots", x86_topdown_metrics_clear),
 	{ .name = NULL, }
 };
 
diff --git a/tools/perf/arch/x86/util/topdown.c b/tools/perf/arch/x86/util/topdown.c
index bafd285119d7a..64bc64e335a2a 100644
--- a/tools/perf/arch/x86/util/topdown.c
+++ b/tools/perf/arch/x86/util/topdown.c
@@ -37,8 +37,7 @@ bool topdown_sys_has_perf_metrics(void)
 bool arch_is_topdown_slots(const struct evsel *evsel)
 {
 	return evsel->core.attr.type == PERF_TYPE_RAW &&
-	       evsel->core.attr.config == TOPDOWN_SLOTS &&
-	       evsel->core.attr.config1 == 0;
+	       evsel->core.attr.config == TOPDOWN_SLOTS;
 }
 
 bool arch_is_topdown_metrics(const struct evsel *evsel)
-- 
2.53.0



