Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBABE1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4872CC433EF;
	Wed, 28 Dec 2022 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244972;
	bh=u3SnCgFp29GHRkm8wbaqVy2Si25z1UqF0B7KqLJ/sb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdcnufPMhWY9BGwMOsDD+ajn6hN218RYEO+Iz0cPk7n+zWZ0MLXDLSGTKlLLSog3q
	 0ht0jm+imJbtxw/Ji4hKgMxHqjQEsQGUyJHeseo2LI7PqFQWn+0E09gbsFbNL0redN
	 QsQPN/4QCwXi3/YiWAhxp/lZHh0BtjM9iPLGoO/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	bpf@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0771/1146] perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number
Date: Wed, 28 Dec 2022 15:38:30 +0100
Message-Id: <20221228144351.091783434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit eadcab4c7a66e1df03d32da0db55d89fd9343fcc ]

This patch defines a macro RAW_SYSCALL_ARGS_NUM to replace the open
coded number '6'.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: bpf@vger.kernel.org
Link: https://lore.kernel.org/r/20221121075237.127706-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6bf8feedaf2c..40123f5688b2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -88,6 +88,8 @@
 # define F_LINUX_SPECIFIC_BASE	1024
 #endif
 
+#define RAW_SYSCALL_ARGS_NUM	6
+
 /*
  * strtoul: Go from a string to a value, i.e. for msr: MSR_FS_BASE to 0xc0000100
  */
@@ -108,7 +110,7 @@ struct syscall_fmt {
 		const char *sys_enter,
 			   *sys_exit;
 	}	   bpf_prog_name;
-	struct syscall_arg_fmt arg[6];
+	struct syscall_arg_fmt arg[RAW_SYSCALL_ARGS_NUM];
 	u8	   nr_args;
 	bool	   errpid;
 	bool	   timeout;
@@ -1226,7 +1228,7 @@ struct syscall {
  */
 struct bpf_map_syscall_entry {
 	bool	enabled;
-	u16	string_args_len[6];
+	u16	string_args_len[RAW_SYSCALL_ARGS_NUM];
 };
 
 /*
@@ -1658,7 +1660,7 @@ static int syscall__alloc_arg_fmts(struct syscall *sc, int nr_args)
 {
 	int idx;
 
-	if (nr_args == 6 && sc->fmt && sc->fmt->nr_args != 0)
+	if (nr_args == RAW_SYSCALL_ARGS_NUM && sc->fmt && sc->fmt->nr_args != 0)
 		nr_args = sc->fmt->nr_args;
 
 	sc->arg_fmt = calloc(nr_args, sizeof(*sc->arg_fmt));
@@ -1809,7 +1811,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		sc->tp_format = trace_event__tp_format("syscalls", tp_name);
 	}
 
-	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ? 6 : sc->tp_format->format.nr_fields))
+	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ?
+					RAW_SYSCALL_ARGS_NUM : sc->tp_format->format.nr_fields))
 		return -ENOMEM;
 
 	if (IS_ERR(sc->tp_format))
-- 
2.35.1



