Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018021;
	b=Rex3we/OMS0asBCDgRK2y6wSLwwlHbQE+XOfftJQVqwTlBImHYwF7V5sGKmYMb2wnRmg
	 2X8o1KN45zmxRtsv0AfyZj0xwzcLqDVOmhaOlqUZn5US/5vUq34ciRyXUtaE1kuSHXwjw
	 tKdkxg/cZAmc6Jy+4e7zQDxdW35KjdSUzs0nwUEUgbsIaheVWVI7BwgYP56Uc2vFecuG/
	 vW0phS06JV2HORzEA+Wr8n9LHrK4ONkyX60zIgzR3TPWrgSNCu0heuLRgNy+uDnzGeSUa
	 TDU92SteM8XQ6GqYbL6a67WOiQKrbZ5YKgxOEaolI4pw3LxiJNNGBjgR3x7NEUJH6vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YtsUOwtbZxpzkdZZCyN7g4vQPxjQyLF7g/4nCv3zyyw=;
	b=PlfJHcUDVQayH06vpJAOn7j1otVIeihtLL8XhAG1/Sc0hU/WlXLQsNg/kJmWoxCDhhzn
	 3MyBs32LkrnmlaLVlqv49G/NQwsnrf2WOyh6gBfW/IJKtv1EfDVK6+8m2L7ckw3np13hE
	 /zDQlidB2RlW0oIwNXzcbiXdKUVLP4pCNw4rCAMOCrEJ1tKTElC1H0KjFOdtDil/eL0mN
	 5+cqGSdZO+L3Gubkd1vNWi9iWBWgNOMSQZ5MDeWFpZ79q/Ba/CArJ6FHzmMgmFuJi+SP7
	 8SNff0S7Vydmv5FyXFa/1h2RdzFbAPt5BH8OYs0XhIfhXwj25QuvDWgnMOeKdvZYlMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZZalIjK/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD91606A31C;
	Wed, 18 Nov 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZalIjK/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C58A1F000C4;
	Wed, 18 Nov 2026 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018020;
	bh=YtsUOwtbZxpzkdZZCyN7g4vQPxjQyLF7g/4nCv3zyyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZalIjK/YZXTAui9TqGCKJmIFFeKB8idzzkZj/YWhuV8M7rwlH/914eEob8P6kgJi
	 eouyFvPh7TBo+pA1RxNeLO13Wv0lZu0DQXRvt9zpGIOUGJJYGrIv/Rl+W+jpJp8By8
	 E/Ys6b+L0D4XIcH6y+HuQ1Cvnn3urkN5ZaRUPxOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1041/2651] perf python: Initialize debug output on module load
Date: Wed, 18 Nov 2026 15:38:01 +0100
Message-ID: <20261118150325.442871784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 3d13b3f1f3a7cd33d1847a4b87c3198089b6c4a7 ]

Unlike the perf binary's main(), PyInit_perf() does not call
perf_debug_setup(). As a result, the first warning or error printed from
the perf Python C extension hits debug_file() with _debug_file == NULL
and emits 'debug_file not set' without a trailing newline before the
actual diagnostic message.

Call perf_debug_setup() in PyInit_perf() and add the missing trailing
newline to the fallback warning in debug_file().

Fixes: ec49230cf6dda704 ("perf debug: Expose debug file")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/debug.c  | 2 +-
 tools/perf/util/python.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 6b5ffe81f1412..b7095519419e6 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -55,7 +55,7 @@ FILE *debug_file(void)
 {
 	if (!_debug_file) {
 		debug_set_file(stderr);
-		pr_warning_once("debug_file not set");
+		pr_warning_once("%s not set\n", __func__);
 	}
 	return _debug_file;
 }
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index c504b83be39fb..58052a4e6a1f0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -4245,6 +4245,7 @@ PyMODINIT_FUNC PyInit_perf(void)
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
+	perf_debug_setup();
 
 	Py_INCREF(&pyrf_evlist__type);
 	PyModule_AddObject(module, "evlist", (PyObject *)&pyrf_evlist__type);
-- 
2.53.0



