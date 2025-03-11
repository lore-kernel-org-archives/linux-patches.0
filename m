Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722CE25F784;
	Tue, 11 Mar 2025 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706465; cv=none; b=N8109+MNGkh6dHCFCCGEnbTs86OubGJOXc6py6Wl5NA7KPiC9Apl6qQ+O/y8shaIpHmRv2TRPRULEwxp8Z/73uQGSjxD5OkFyqfNayKS5psgvxjb2gHGyA7b3A0IxW4h2gSSc6/LOjiiDBvRYR6Aj37W0GVQA/SbVbkeMx5znic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706465; c=relaxed/simple;
	bh=UvqqFIogvqE7TC0zqWNn0FrnQjORvbJ0svfBh0/gjws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbOf8GL6DggNAsMcgtJv5cL7utrmHHiqAy/Bh/WX+12zRx5ljllwhCXTq1jR+5qxae7y14W/aLBPxNVjmQlbzNwrc1QrgDSrn8bjaWUHfE+zXftGFPPmE/Ajcuvoxc+QRsk3XO4gfzQn6UYC8kZlC+h6Lj7dASodDlRY2zkYsPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNHw7Quf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNHw7Quf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DA3C4CEE9;
	Tue, 11 Mar 2025 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706465;
	bh=UvqqFIogvqE7TC0zqWNn0FrnQjORvbJ0svfBh0/gjws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNHw7QufulNjK1bPMfBDJTpS88MFblC5E2MArfqWk6nUIanc3/RkLO2y9R0LZMTAL
	 sGMRb91exfsIaazJsgOxImSFD4o7jslO9b80RWbHklYi++iYQIQM48MlTW+ik3wnvn
	 rkpbEbHMcdaG2XmAKcS81V5mV5md3vzQz0920k2M=
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
Subject: [PATCH 5.10 058/462] perf report: Fix misleading help message about --demangle
Date: Tue, 11 Mar 2025 15:55:24 +0100
Message-ID: <20250311145800.646576984@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b55ee073c2f72..575ad3c4fb373 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1276,7 +1276,7 @@ int cmd_report(int argc, const char **argv)
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



