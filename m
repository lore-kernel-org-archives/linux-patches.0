Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032693;
	b=A4D+iPXy3yLYckCXotQ5V4breuQ3tJ6lcJ1tJgh40dhGbR4ORGETXtdrtzkzV2uMRIkS
	 apuSU9crszw6Dke5+j1kSz0QQ5t1D4WsW5SPdRRbTXN1w4lZrhi5i8M7UXgxxtnR/zXU7
	 XDP41dQVtj9zpC17p6mZCED74Ql/EzRtVAt3JzDIEx0ynbwetqS9xz54t28FmCGVJKopv
	 HA79lH9l6eU19PHD+CD4UCw54Eb25xB8xa5GvsyerajA5KQxDZTR50U5WC49/wNc0gici
	 t/gW/bZ1nspoElPFj34km6qJZyAJaBToGtZ3ZHJmEEyfIHFwZVANBjMrk6UTbr+HHGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bGRN/+UUHLk666aw+UYziPB+m3Bl3THV6JmkFKcn+Jc=;
	b=zDmuWraOnbDQVWqvtIIReCLQ+EqImC/C80HkU7GlpOgDiyJjvZZZKvRPrxrBtVazpdVR
	 ajW5hL9G6Nz/VN0evLTRFchBAnLpdIzHODfxxhE7OGnNcMDh1z0tcNWhD5daSkl04sivG
	 meud6GblLxUQ1SnhMEHOeQvSwMeXvwymh3yVRg/dgO0Nh5PSpn/gVDLQdmP5KRobhHFHs
	 CUuIMferdBbdq7WCVd+7law/UyHJ6D18tXq9aUk6pITU3/Q3vQp1p/hWCQGYvKQmOTKj7
	 MunKD5ci/U42BvIb3ER+1W5qzfZEUfeF6qg5CXg8HIqmFh30TWy0iL/9Eelj5ZyMNLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Hboz1OH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34B4606A334;
	Wed, 18 Nov 2026 20:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Hboz1OH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA411F000C4;
	Wed, 18 Nov 2026 20:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032692;
	bh=bGRN/+UUHLk666aw+UYziPB+m3Bl3THV6JmkFKcn+Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Hboz1OH72m7Es55z61BzgSZxYhBUG7OQa/GnxT2goPvmn+UN1Iw/SQBNJlKaAkY/
	 vQz3J0SLq8JbCtinV6v/42knll59DnkmoqiYRzn2U0sUps9ftf85B6n0+OWxGkkLzc
	 kF5Ngktb4X6o49elL2v3fVrcFnCOP7ZsIS5Nmg3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1501/1756] perf c2c: Fix memory leaks on output fields
Date: Wed, 18 Nov 2026 16:00:28 +0100
Message-ID: <20261118150108.684166621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 7d0fe18bc905a4bf59271e2f7ecc95479caebd7b ]

The perf_hpp_list was not freed after use.  Let's add it for the main
c2c hists list in perf c2c report and a local list in print_pareto().

Previously it was detected by ASAN like below.

  =================================================================
  ==42183==ERROR: LeakSanitizer: detected memory leaks

  Indirect leak of 1064 byte(s) in 7 object(s) allocated from:
      #0 0x7f17334ef24f in calloc (/lib64/libasan.so.8+0xef24f) (BuildId: 61e8165ca90f7a4f06b73f064a938c76deaae079)
      #1 0x0000005fa099 in zalloc  ../../lib/zalloc.c:8
      #2 0x0000004faf6d in get_format  tools/perf/builtin-c2c.c:1978
      #3 0x0000004fb45e in c2c_hists__init_output  tools/perf/builtin-c2c.c:2004
      #4 0x0000004fb7de in __hpp_list__parse  tools/perf/builtin-c2c.c:2047
      #5 0x0000004fbae9 in hpp_list__parse  tools/perf/builtin-c2c.c:2085
      #6 0x0000004fee13 in print_pareto  tools/perf/builtin-c2c.c:2563
      #7 0x0000004ffcd7 in perf_c2c__hists_fprintf  tools/perf/builtin-c2c.c:2708
      #8 0x000000500ab5 in perf_c2c_display  tools/perf/builtin-c2c.c:2949
      #9 0x0000005045c3 in perf_c2c__report  tools/perf/builtin-c2c.c:3522
      #10 0x000000505caa in cmd_c2c  tools/perf/builtin-c2c.c:3676
      #11 0x0000005df50e in run_builtin  tools/perf/perf.c:383
      #12 0x0000005df9b1 in handle_internal_command  tools/perf/perf.c:436
      #13 0x0000005dfd7f in run_argv  tools/perf/perf.c:480
      #14 0x0000005e02d6 in main  tools/perf/perf.c:581
      #15 0x7f1729450680 in __libc_start_call_main (/lib64/libc.so.6+0x3680) (BuildId: 85075e2ae2e13352a1413d41c327dacf6461526c)
      #16 0x7f1729450797 in __libc_start_main@GLIBC_2.2.5 (/lib64/libc.so.6+0x3797) (BuildId: 85075e2ae2e13352a1413d41c327dacf6461526c)
      #17 0x000000409c34 in _start (tools/perf/perf+0x409c34) (BuildId: 36a64600776d92e4ab7dfd5ca20c92280d72a645)

  SUMMARY: AddressSanitizer: 1064 byte(s) leaked in 7 allocation(s).

Fixes: c75540e3160fb586 ("perf c2c report: Add dimension support")
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 15e1fce71c722..850aa3b7d3fec 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2076,6 +2076,11 @@ static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
 	return hpp_list__parse(&c2c_hists->list, output, sort);
 }
 
+static void c2c_hists__exit(struct c2c_hists *c2c_hists)
+{
+	perf_hpp__reset_output_field(&c2c_hists->list);
+}
+
 #define DISPLAY_LINE_LIMIT  0.001
 
 static u8 filter_display(u32 val, u32 sum)
@@ -2475,7 +2480,7 @@ static void print_pareto(FILE *out)
 	ret = hpp_list__parse(&hpp_list, cl_output, NULL);
 
 	if (WARN_ONCE(ret, "failed to setup sort entries\n"))
-		return;
+		goto out;
 
 	nd = rb_first_cached(&c2c.hists.hists.entries);
 
@@ -2489,6 +2494,9 @@ static void print_pareto(FILE *out)
 		c2c_he = container_of(he, struct c2c_hist_entry, he);
 		print_cacheline(c2c_he->hists, he, &hpp_list, out);
 	}
+
+out:
+	perf_hpp__reset_output_field(&hpp_list);
 }
 
 static void print_c2c_info(FILE *out, struct perf_session *session)
@@ -3105,12 +3113,12 @@ static int perf_c2c__report(int argc, const char **argv)
 	err = setup_nodes(session);
 	if (err) {
 		pr_err("Failed setup nodes\n");
-		goto out_session;
+		goto out_hists;
 	}
 
 	err = mem2node__init(&c2c.mem2node, &session->header.env);
 	if (err)
-		goto out_session;
+		goto out_hists;
 
 	err = setup_callchain(session->evlist);
 	if (err)
@@ -3197,6 +3205,8 @@ static int perf_c2c__report(int argc, const char **argv)
 
 out_mem2node:
 	mem2node__exit(&c2c.mem2node);
+out_hists:
+	c2c_hists__exit(&c2c.hists);
 out_session:
 	perf_session__delete(session);
 out:
-- 
2.53.0



