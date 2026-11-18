Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056727;
	b=Vs06HbhRpKdZKOB8VoM4fiAcvmM9FVqIZXpScN/xUpUJwy6m30i6pQ6w9SGUQEb5RVq4
	 wE8QHcsVrFgcNJ/muzJ2BAV+lKGUL+y/d0SHTX5YPRpKtX4X1jaBLXl82NJNPFxlmMmSc
	 q04AR6ufUKTYOsX8wh0bQYU4TnFU74R5dHVI712gsqLmWjPWFpDTTyP31qHU4gEjgG24C
	 zY5L/5VA3ZMZLs0gi82Ha34h1cBwOQ/6jWks8jd9UuBh3hAboX6rj21xLEMOrcWuiHAHV
	 MOOqI22ZJzZ0y5Jg2ui3JFC4sRYc8o1DksjsT4HU6gOeztdW1MPstbZgbaP2NwXUZiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PEbPEcBqWnBskAxeMCKCeBlSbe1yQW1Zd82ExxtzTMQ=;
	b=N+vRTBoTDE/8pz9sXcsG8fbAzcGyVybKoJ29myLTH6Rkf1DbGpuE4wTgOPFNRZE8qsBM
	 ezwM25XnoQpC1ppwJtLIAo5Xf49SiLLXJa/6+DUt97twmJrkeRYbEUTZ+xaxHZ6pzv0nC
	 l9+OJekCystSgJ06EatNiUrXZ01svpeV/xyT241OJj3XgGIfS6NPSdckV1Zdfvzf4OGF0
	 P7+4IK080Sh8g17/CtWOLazh7qGRnKIj7398kDmECge06VDTFgUK2Cc+xxAJdkuJpw44y
	 UXGsWmuIz+KsWqJH9WeCvkjyC0wM4ofazQ6clz47jqrBflzrjUWmYxLl4bddi/+NBZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3Qo4glw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81566606A325;
	Thu, 19 Nov 2026 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3Qo4glw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24001F000C4;
	Thu, 19 Nov 2026 02:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056727;
	bh=PEbPEcBqWnBskAxeMCKCeBlSbe1yQW1Zd82ExxtzTMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3Qo4glwe87aOZn/HN2Y9wLMWllqNIEy7/7DXMvynJWHk3R3OgjDf92eHBuxEmJyI
	 2I0/0OKDKqDTDwPj+27aZtRLm15S+w+ZRkAToSk34o+/ew5ly9C7dAeWUYkil8mLZT
	 dxOzXVjfpjbOsTz0DO0QRoW5W+mk5ldyKHabFkg8=
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
Subject: [PATCH 5.15 2092/2214] perf c2c: Fix memory leaks on output fields
Date: Wed, 18 Nov 2026 16:02:48 +0100
Message-ID: <20261118150134.304405216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 75fe1f4c6dd03..72cb9aea91dcf 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -1858,6 +1858,11 @@ static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
 	return hpp_list__parse(&c2c_hists->list, output, sort);
 }
 
+static void c2c_hists__exit(struct c2c_hists *c2c_hists)
+{
+	perf_hpp__reset_output_field(&c2c_hists->list);
+}
+
 #define DISPLAY_LINE_LIMIT  0.001
 
 static u8 filter_display(u32 val, u32 sum)
@@ -2217,7 +2222,7 @@ static void print_pareto(FILE *out)
 	ret = hpp_list__parse(&hpp_list, cl_output, NULL);
 
 	if (WARN_ONCE(ret, "failed to setup sort entries\n"))
-		return;
+		goto out;
 
 	nd = rb_first_cached(&c2c.hists.hists.entries);
 
@@ -2231,6 +2236,9 @@ static void print_pareto(FILE *out)
 		c2c_he = container_of(he, struct c2c_hist_entry, he);
 		print_cacheline(c2c_he->hists, he, &hpp_list, out);
 	}
+
+out:
+	perf_hpp__reset_output_field(&hpp_list);
 }
 
 static void print_c2c_info(FILE *out, struct perf_session *session)
@@ -2816,12 +2824,12 @@ static int perf_c2c__report(int argc, const char **argv)
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
@@ -2890,6 +2898,8 @@ static int perf_c2c__report(int argc, const char **argv)
 
 out_mem2node:
 	mem2node__exit(&c2c.mem2node);
+out_hists:
+	c2c_hists__exit(&c2c.hists);
 out_session:
 	perf_session__delete(session);
 out:
-- 
2.53.0



