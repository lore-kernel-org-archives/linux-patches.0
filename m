Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D389384;
	Thu, 13 Jun 2024 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282179; cv=none; b=XT99Nig7Uz3ZdzGklASJo+LL9qSJt8+QIVQ0fVp2c/tVEO0CLtViIyBGbmxJsLSu5euDmNEtXJOzfurb3Vscgfx+OCyhfmwj6pC0Iqs4PHYpgdt/WrxD/1IDHrxo32UkF/qTPXw5jmV4RWF1uE7ewnNciqq3nf4SUg41cKQm+Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282179; c=relaxed/simple;
	bh=r/jbONSJlvHoA1qM80YVVKuY/jEL5/6oAHivBnKpYEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IntCwFoRd2ruNpXKgPn0NL5VFQDjnjgukIvcZxzpyjcFnxdvj73GNm2qFMNAMaY2R7LRSvlVI8SiENwp6GPlLL+/fHeUY7J8VLi3x9c2qYkYBAOqJL/xQxdwrnqIo3gUnJBTf6wDgkqFz32TX+aqHAHRIC5c3SaRanI8SOKJ++4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4MkDEl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4MkDEl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ECFC2BBFC;
	Thu, 13 Jun 2024 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282179;
	bh=r/jbONSJlvHoA1qM80YVVKuY/jEL5/6oAHivBnKpYEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4MkDEl72SY7ASQlcg8FXa1hkrDguN9ePtgMZmyw4CtSaemRp+3YrR8v11D24sZEO
	 TA5kXFaJrkjwYIFLoTWG4rmkhQCi1wpta85LoRGmzUoOURvMgJvmR+LY2PWpHdYTa8
	 LqnhtIHe4LbvZxQaQQCk2QXsFjXKpE4at7peJ1u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jin Yao <yao.jin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/402] perf annotate: Get rid of duplicate --group option item
Date: Thu, 13 Jun 2024 13:32:19 +0200
Message-ID: <20240613113309.249462661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 374af9f1f06b5e991c810d2e4983d6f58df32136 ]

The options array in cmd_annotate() has duplicate --group options.  It
only needs one and let's get rid of the other.

  $ perf annotate -h 2>&1 | grep group
        --group           Show event group information together
        --group           Show event group information together

Fixes: 7ebaf4890f63eb90 ("perf annotate: Support '--group' option")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240322224313.423181-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-annotate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 05eb098cb0e3b..592d92092614e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -541,8 +541,6 @@ int cmd_annotate(int argc, const char **argv)
 		    "Enable symbol demangling"),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
-	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
-		    "Show event group information together"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
-- 
2.43.0



