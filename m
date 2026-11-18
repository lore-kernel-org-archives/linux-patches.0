Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042409;
	b=rCF0yQ5HtrlOQEd5/Pq+IO1swa8GepLSsRGKbFucw8hTjgV505i2Fw8XE9YDuZn4wzJu
	 E7QKrtljRPgdK5vav5CdKNs3kxdPB1dDN91ryL2iUKghYvBnirio7RWTDWlKMO/6VECue
	 Y+EvkRTZCB+quTbg3Jr/o91JyBwYzTtzQGA+hURCXJ0vNWcF4RE0GLRJMiWBrNNk8MIOM
	 LLFCSe1tacdhDSSICGZj31/r3gKw5XwRfEjT87kDXerEjrUcu3Rn4CVnVxtYGwIh+CaIk
	 zCRnyOgC6wb3DxkBNRkRkiCnqOH3OWyHXIMbKXAd1ANYNPFhICTfg8qvCuwITnoPKEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jsuFdHwrtiBW7yVBV9Vk36YTxFthgmGzOocgYX8bFUQ=;
	b=fVCvgVdDqFbchkHBULiKQx6Fy3Y4x0W0Sr7fdc2gn6bxMsYkUqpxCpF1XNdrA+bWjEau
	 rlo+am6kzIi/izJHD7SUNOrkVBvuJFYtHk0HUW2xFvrfqCDCJ+66kG+sm3t/HagX9IIhn
	 kd0RwxKi+osN2gXHySJB2UY7w2AqafSKeUhd4iJhcTaRnXY76Xw+h3Bz4J2L9ekQGU/Kf
	 fYoUSdcwqaZcyrSY5lL6guIliPv24G2B4M13kL2lP/RPcp1dinql1zRjiP9SGdFaGIzbr
	 imxvbC7H0fjZ/Wv/OoV7LX8QUALtAcjwSejOAPfAEo19wrzJNYV3TyYQ1yO9+SGl8Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A73LfRwr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEAF606A325;
	Wed, 18 Nov 2026 22:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A73LfRwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787661F000C4;
	Wed, 18 Nov 2026 22:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042409;
	bh=jsuFdHwrtiBW7yVBV9Vk36YTxFthgmGzOocgYX8bFUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A73LfRwrE93U+g/4Xp01m4cMWAQqAOr4JbHEhKPRmdsG8A+G1RefEswyrVIhcSOco
	 PPm8eWWUb33E6oipSECWVdV0PcRCPoqQGHM4WDOWI7XNpq6/ZF3nDWZlAQsZf2Q3HJ
	 UM03/Hql/4RFxT+wV6GZSCMDRWQzefDOgmLwLvbw=
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
Subject: [PATCH 6.6 3119/3318] perf c2c: Fix memory leaks on output fields
Date: Wed, 18 Nov 2026 16:02:21 +0100
Message-ID: <20261118150453.511777761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a4cf9de7a7b5a..0ee50c66e5353 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2093,6 +2093,11 @@ static int c2c_hists__reinit(struct c2c_hists *c2c_hists,
 	return hpp_list__parse(&c2c_hists->list, output, sort);
 }
 
+static void c2c_hists__exit(struct c2c_hists *c2c_hists)
+{
+	perf_hpp__reset_output_field(&c2c_hists->list);
+}
+
 #define DISPLAY_LINE_LIMIT  0.001
 
 static u8 filter_display(u32 val, u32 sum)
@@ -2496,7 +2501,7 @@ static void print_pareto(FILE *out)
 	ret = hpp_list__parse(&hpp_list, cl_output, NULL);
 
 	if (WARN_ONCE(ret, "failed to setup sort entries\n"))
-		return;
+		goto out;
 
 	nd = rb_first_cached(&c2c.hists.hists.entries);
 
@@ -2510,6 +2515,9 @@ static void print_pareto(FILE *out)
 		c2c_he = container_of(he, struct c2c_hist_entry, he);
 		print_cacheline(c2c_he->hists, he, &hpp_list, out);
 	}
+
+out:
+	perf_hpp__reset_output_field(&hpp_list);
 }
 
 static void print_c2c_info(FILE *out, struct perf_session *session)
@@ -3113,12 +3121,12 @@ static int perf_c2c__report(int argc, const char **argv)
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
@@ -3205,6 +3213,8 @@ static int perf_c2c__report(int argc, const char **argv)
 
 out_mem2node:
 	mem2node__exit(&c2c.mem2node);
+out_hists:
+	c2c_hists__exit(&c2c.hists);
 out_session:
 	perf_session__delete(session);
 out:
-- 
2.53.0



