Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68354142911;
	Thu, 13 Jun 2024 11:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278847; cv=none; b=I3bIi6JTtlynMuxQLG0G3nJiNCfIh+/HiTo0RMQ1OiIzWcstESsZHKrcQ/YYjj3zjkXAx0KZDk6bz54YE0m2leU+b/dsk7UjXH1gT2sPfU7CR4FR9g3htb34G0qcfkJw20rqhux2J5UDOEPI4GI8Z7NYF4AfZK47x5DE4UXeHOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278847; c=relaxed/simple;
	bh=QHTgu12HCCzzjyFaXlE9Bx8PUci9DWI5WpU/zt1tatQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vyev7tssHSoTuq6jKhD3MIG9R9xvI2jNkFU0nSw39FpZLK6tTUJx2eYNB5F9MSmfN8TiJfEQHGuzCo9ku1XQwKmk5B5SymzSiyZknCbXBrQBjwzS/Pr8s/mmcXZ0cHCwAUde8JKeItmS0jePz39DKC6Cg1HPH3au9MMU/mphRrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnUpSv/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnUpSv/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD1C2BBFC;
	Thu, 13 Jun 2024 11:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278847;
	bh=QHTgu12HCCzzjyFaXlE9Bx8PUci9DWI5WpU/zt1tatQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnUpSv/L80jXnpXJVc578yGvo1/1JAWUAVv261SNYQEd8nQf23xJTYR+K0bA/xeCq
	 L1+LsYgZHEQZK0bq7VIZmrhW38UuoYbLqtW9p7InXaAC2dcfRCwlFJfvUca8sldGZU
	 4chNgJxv5Fs7caMAmPOa0D5XuQFDucNV7rGvGS5M=
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
Subject: [PATCH 4.19 090/213] perf annotate: Get rid of duplicate --group option item
Date: Thu, 13 Jun 2024 13:32:18 +0200
Message-ID: <20240613113231.481125774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d12430fe9c783..17d008b706c92 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -537,8 +537,6 @@ int cmd_annotate(int argc, const char **argv)
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



