Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050362;
	b=HXkhGNtWXqrfPy/T0OCl+fB30PGK+oOd0xcUuFdGTqInBEHVHdGXwZXoAvnOExyPTGte
	 1jMqR9uJV/yoo4XuMJY8ZaDIYB7IAw5iB+ime6255xZP8w8fB3LEhWlBMWOxav7L0xPuW
	 43LeIi+hKJXuWFnB50cmi3MvJeJc2UwtLdQdR2AyTP2CBiS+85vq7TFK4RiupsQRSMS3d
	 eCoxTmmzRIblLAP/D5/f6Ls88KcRSnxPscqTIEP0x3PLvxyLBozNgNRPzR8YlUoEaR7aY
	 YzaqUTCcblaCT99ZDsEQtfM5dz286xMsB5NIMJZ8UisppsYUv2qElj9nEDYEcv5sFFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rKcpnC2LQ9QBJo84W6g02hu+9VIQazPH8XOo/E/yP0=;
	b=c81B6N8LjJPw9RHqgCHAhXC8hWqvZ9fAG4LKAJfwtn3jkuTWzZZGWWRgl532834fzTez
	 cdIr+6p17gymfEpB7Eo4D1MoTMV99X82j9Pm4c0z44aiXDEkGkl2HHACbl/0fyw1a4ybJ
	 JJ9AMOxuZGqmcO9pvQJjZFDRS25Ra2K6PvRhH+oUQ+7xsuA0bIAe/GJcnYkHBNTjdxwp8
	 lKQaQk3WqZKODT57Bzu8K4IX5UpesYI0NBh/xtuXHX/ncj441AKtKwuWvuqCvLtlot+2K
	 bDiqSy5oxtJoM7XZWDj4+nSCt/nYan6lpnpByu9UmfSsz+5Y7td6W02JIjd2y3FWrlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZjZ+P4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16AF606A337;
	Thu, 19 Nov 2026 01:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZjZ+P4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEBA1F000C5;
	Thu, 19 Nov 2026 01:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050361;
	bh=/rKcpnC2LQ9QBJo84W6g02hu+9VIQazPH8XOo/E/yP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZjZ+P4CCF55CpgR/rf34MR+L/Osf2SBe1s5myA8uXldY1PQG5CsSqf9jSqu79/jT
	 aw7YwTKGV8j7j+yKGC0op2Uj4zXR8WzxMa31l90Xxcrkl80pgbbLhojvmjfKEUbxJ8
	 p4MnqnKU3UKWKc5jzDo2hXQJ19nMGxSCXgs86Epc=
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
Subject: [PATCH 6.1 2682/2857] perf c2c: Fix memory leaks on output fields
Date: Wed, 18 Nov 2026 16:01:56 +0100
Message-ID: <20261118150338.144448595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a9190458d2d50..734d3c7bc07ba 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2087,6 +2087,11 @@ static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
 	return hpp_list__parse(&c2c_hists->list, output, sort);
 }
 
+static void c2c_hists__exit(struct c2c_hists *c2c_hists)
+{
+	perf_hpp__reset_output_field(&c2c_hists->list);
+}
+
 #define DISPLAY_LINE_LIMIT  0.001
 
 static u8 filter_display(u32 val, u32 sum)
@@ -2490,7 +2495,7 @@ static void print_pareto(FILE *out)
 	ret = hpp_list__parse(&hpp_list, cl_output, NULL);
 
 	if (WARN_ONCE(ret, "failed to setup sort entries\n"))
-		return;
+		goto out;
 
 	nd = rb_first_cached(&c2c.hists.hists.entries);
 
@@ -2504,6 +2509,9 @@ static void print_pareto(FILE *out)
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



