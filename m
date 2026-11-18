Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030527;
	b=kZ8AbmN7dbBxzD5oH+9S37rYA4RLVhPlzeiXmYaRaPgaLRG46y7YO5ZNSqBG9gX3GwY7
	 Gw6WLKh/WmFk8pm7/WYW1T0Dfx8nBPZVKMSALx48VQ9EYjc6SLBmV1EZwDIDBEwLoqZed
	 KyPVhwUTXnUzoV3+wh58PTMYoaD3JYrogqbKnme2ELhbC6HGO7pkBGHbNhRJicTO1tkMQ
	 6K24rw+ubK1T/Fq+HN2UAGbcddCg3JXixaRLEfAhA2QRVTrdT+WPeExjsqw4BFpCy9E/I
	 0WNUnBjvL8G7fHlZaStdkrtJtHfV+3zhEu8UA6EHTFlCNO6UyyNnVHMxJrcQoT25dyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X1Fj8rdfwue1TMsCHs1L08ppec2T7dVf1bTmdfXy9Eg=;
	b=fIghcmdoItfqwbI4c/7UbDm6wjg5WnjIp96JivSYLRa8YNZPnA2VF5LNzPv9gr7fmS/5
	 QOXS41cdOjPm+WiH74ZjMwCxrHHQfvq04RXD8ki+tEOMETubRhL+K4XjMQnnloWiKWsPr
	 I1K/9kAmvlknkPl1YZ5RdexVCTb3R1s3+lFUKCrPIrHVHNl6Nyk1qLFVjLGre2oUiGPCS
	 aa0rwVZPSJRBIuYeN/uxYJZS+Oab6T4rIRKr7N2nuPuEQGqi17D9iR4RtOLLivoRJS+kw
	 R2v2RcjNfvrZp6oFIi5p8vdm9uJQu0eM1mWVg4Gv/iQbgCHOCeApTOV235+3R0ShycQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im5OrroU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9F5606C42B;
	Wed, 18 Nov 2026 19:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im5OrroU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F361F000C6;
	Wed, 18 Nov 2026 19:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030526;
	bh=X1Fj8rdfwue1TMsCHs1L08ppec2T7dVf1bTmdfXy9Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im5OrroUSerqXJZILSKsx024uIzgaKH7c8EAR5N0SNgjpaWnK7kC5X4ub53vo8iY/
	 1MXdTi/vbV+Gs9tseK0kpzcCnIac9ykYU9Y9Jt/+Rsi5S3WMC+Ub1pzqfB9weASBzY
	 mJ+TWdynnfA0e59vumuLXKkkrkYk7h0ZVK59c9Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0695/1756] perf python: Initialize debug output on module load
Date: Wed, 18 Nov 2026 15:47:02 +0100
Message-ID: <20261118150036.866211196@linuxfoundation.org>
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
index bd968b4883cbd..5b53c9f8ec66f 100644
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
index 66d3b0c633b25..7b9b6d464a3e0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1371,6 +1371,7 @@ PyMODINIT_FUNC PyInit_perf(void)
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
+	perf_debug_setup();
 
 	Py_INCREF(&pyrf_evlist__type);
 	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
-- 
2.53.0



