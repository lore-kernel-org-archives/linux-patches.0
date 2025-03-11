Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C2F1C3BEB;
	Tue, 11 Mar 2025 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705501; cv=none; b=SkzalyXMMRNIiV8xSiLdrTaSdSUnHJFgWKUyRr3RKUsq8tK7GV3Td9/D4ECLdULldyEQ5pTV0jELY4vJnng1v5iABl2IL/lA569IAk9r9RpUPhCmbLPPIdXGK1MljCizQqoxxzOiAHqBavgherRk9Z1+TPl7VgExZIZN/8i7tGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705501; c=relaxed/simple;
	bh=6iLYX696aBbnefvEjphzakQw0CJdRDa/whAAM8u3rnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg9qxteLp1TjePrGHFOJ7P3aL4+coGWSCFHLkzGNuH8XPFby2Xk7iLgButTCOTDWzsfdiWPLfBojpwhX7ZsxzyJDzAwVz5ySxn+s1XqSoSmmVqeDBU3iLDyHgLXJzK7ziDBRgntyht3X5ueFb5hpBxfioyRYP30+pTaT0a3gznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0pr6m3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0pr6m3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C675C4CEEC;
	Tue, 11 Mar 2025 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705501;
	bh=6iLYX696aBbnefvEjphzakQw0CJdRDa/whAAM8u3rnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0pr6m3GgO3/gagxPthyKgLqzSxnZFaihVMQCCTqRHjJHy37kGyJ8DPpLB3CskPOR
	 m5o5gs1PmaewUmR/cA/0Du4uZG+/IFec2e8qBD/1mQOqpfiyT+ks36Q4ZNI53GNY6R
	 wikCllD6gWCb/oqqqUAjzjZ0qmbloWN3IXOfbcng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Jiachen Zhang <me@jcix.top>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/328] perf report: Fix misleading help message about --demangle
Date: Tue, 11 Mar 2025 15:56:50 +0100
Message-ID: <20250311145716.486685861@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiachen Zhang <me@jcix.top>

[ Upstream commit ac0ac75189a4d6a29a2765a7adbb62bc6cc650c7 ]

The wrong help message may mislead users. This commit fixes it.

Fixes: 328ccdace8855289 ("perf report: Add --no-demangle option")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiachen Zhang <me@jcix.top>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250109152220.1869581-1-me@jcix.top
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dc228bdf2bbc2..2f0917dbadcf4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1175,7 +1175,7 @@ int cmd_report(int argc, const char **argv)
 	OPT_STRING(0, "objdump", &report.annotation_opts.objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
-		    "Disable symbol demangling"),
+		    "Symbol demangling. Enabled by default, use --no-demangle to disable."),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
-- 
2.39.5



