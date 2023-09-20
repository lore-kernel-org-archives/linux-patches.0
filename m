Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C8E30F80
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8986C433C7;
	Wed, 20 Sep 2023 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213738;
	bh=a6V905g0m1ULMyIdxFjEVL3vrqAwCqaasRZZjEzpWrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL4jlv76w/v4L7Q+TuLcWUrOETM4x6g3nhG0YYqB3fWRuo9gjfalzkf5+FxlzhTpa
	 3nrDcZgX6OdEyHNlucQE561bY89OOgHE7Wb9I/Wczv0o09Myq9u3653fGksKqnLURw
	 tVKzBvzsZvRXXxceyqAclaHfw3SYxO10d0GSrz1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jin Yao <yao.jin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linuxarm@huawei.com,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 347/367] perf jevents: Make build dependency on test JSONs
Date: Wed, 20 Sep 2023 13:32:04 +0200
Message-ID: <20230920112907.480737592@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit 517db3b59537a59f6cc251b1926df93e93bb9c87 ]

Currently all JSONs and the mapfile for an arch are dependencies for
building pmu-events.c

The test JSONs are missing as a dependency, so add them.

Signed-off-by: John Garry <john.garry@huawei.com>
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linuxarm@huawei.com
Link: http://lore.kernel.org/lkml/90094733-741c-50e5-ac7d-f5640b5f0bdd@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 7822a8913f4c ("perf build: Update build rule for generated files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/Build | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/Build b/tools/perf/pmu-events/Build
index 215ba30b85343..a055dee6a46af 100644
--- a/tools/perf/pmu-events/Build
+++ b/tools/perf/pmu-events/Build
@@ -6,10 +6,13 @@ pmu-events-y	+= pmu-events.o
 JDIR		=  pmu-events/arch/$(SRCARCH)
 JSON		=  $(shell [ -d $(JDIR) ] &&				\
 			find $(JDIR) -name '*.json' -o -name 'mapfile.csv')
+JDIR_TEST	=  pmu-events/arch/test
+JSON_TEST	=  $(shell [ -d $(JDIR_TEST) ] &&			\
+			find $(JDIR_TEST) -name '*.json')
 
 #
 # Locate/process JSON files in pmu-events/arch/
 # directory and create tables in pmu-events.c.
 #
-$(OUTPUT)pmu-events/pmu-events.c: $(JSON) $(JEVENTS)
+$(OUTPUT)pmu-events/pmu-events.c: $(JSON) $(JSON_TEST) $(JEVENTS)
 	$(Q)$(call echo-cmd,gen)$(JEVENTS) $(SRCARCH) pmu-events/arch $(OUTPUT)pmu-events/pmu-events.c $(V)
-- 
2.40.1



