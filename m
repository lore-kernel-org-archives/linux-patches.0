Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212164;
	b=y0hTBca1jVDoRalIndgXulTL+I4HX3x1gFkjRchqrhXdeqKZJM+xYtn7h3poGWmbgb5E
	 iMsdcqggVSUAP4ySe0+6GN0b+Fma6P9aXZv4MWm1lg0yA9UxPol1QDCqJ9zhL4xPsQ2Qa
	 bhwH1A5pNIOz1SW7lhgBQ5ug9ias1/A83X3jZSN1yt54el8Qery98XBy95Zkbw35oXYgq
	 rrBBYr5RqTasNNkZk2aUCQEUAma4qtZncWU5XaPntE7vaj2vtr61d37FBjP3u4NaygF+9
	 80ELiUwJyWLxYj2ArfIGWYi2QxbWOA6v27YUqAJW50S5+jQb+pEg2JgxsJ0CS3Hrjjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ahC/qt3zBFxGPDSltgEDpFi0xq+u6sYz/c7YFAOvbCc=;
	b=uBQ4FkB0ym5ET4PUy/p8Bmiog40x2Wfo6vhegHvjAt8jN8KseFo4WRghocd7F7OQRNtb
	 4AjKsNBKErvXwbM2WDBPc3uzRwHn5c/XaAPPN+ThbOotW6PMEgl/Ad39jGzlkLeU7KPsT
	 lmwv4tFPsJDtTOf3cg0qZ8KhwreQJO+TNTyZeHrAsv6Rrmh3qcbJL/dMRqxx9f49hET9x
	 iDOLBpXuCdG6CEvJnhf1VyVLGPbUu3okSNCOG9FcWiy/yk3fnUNX+O67wJQ+cKX1C6MHi
	 vaUicIn2hXB2R8pwo6hHb7ekhmYSlyWn/l8BxDr4waOOf1JzeSs/x1RBM7UfsN9ZUww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3h+RTLk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC214606A31C;
	Wed, 28 Oct 2026 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3h+RTLk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0421F01825;
	Wed, 28 Oct 2026 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212163;
	bh=ahC/qt3zBFxGPDSltgEDpFi0xq+u6sYz/c7YFAOvbCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3h+RTLkmE3GB1yTMJvJYt4xCyvPWZvzAIl18ydmga1rKr3FfECYuW6XCYSzWeBPr
	 lZdZX0vvRx8QO5Cgh+1ooa1UqJyPm14uQ/Sfj7WaQXB+DJgTmoe2xGVLW7W5lJW8Fs
	 0B3Wu93Rb3VuziAILMbyIqasXDI73Jbq3brwR9ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0058/1887] perf tools: Fix a asan issue in parse_events_multi_pmu_add()
Date: Wed, 28 Oct 2026 17:35:54 +0100
Message-ID: <20261028170500.547496796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit 66c9598bd8916c6c1319d0100ac916cac89d4b0e upstream

In the parse_events_multi_pmu_add() it passes the 'config' variable
twice to parse_events_term__num() - one for config and another for
loc_term.  I'm not sure about the second one as it's converted to
YYLTYPE variable.  Asan reports it like below:

  In function ‘parse_events_term__num’,
      inlined from ‘parse_events_multi_pmu_add’ at util/parse-events.c:1602:6:
  util/parse-events.c:2653:64: error: array subscript ‘YYLTYPE[0]’ is partly outside
                                      array bounds of ‘char[8]’ [-Werror=array-bounds]
   2653 |                 .err_term  = loc_term ? loc_term->first_column : 0,
        |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
  util/parse-events.c: In function ‘parse_events_multi_pmu_add’:
  util/parse-events.c:1587:15: note: object ‘config’ of size 8
   1587 |         char *config;
        |               ^~~~~~
  cc1: all warnings being treated as errors

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230331202949.810326-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5973f46c23755..b77686a7bd26c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1585,7 +1585,7 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 
 	if (parse_events_term__num(&term,
 				   PARSE_EVENTS__TERM_TYPE_USER,
-				   config, 1, false, &config,
+				   config, 1, false, NULL,
 					NULL) < 0) {
 		free(config);
 		goto out_err;
-- 
2.53.0



