Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024873;
	b=opKK+xMU90AfEsV4Ibk9O53JbzPuxSrt7+/JroskHCOsoAVuln9UbFUeLOjlhwwfooPG
	 mCQviBfA8WT7LBvuzk5mFp+qJzqiZ+vSw/YFawUIR3OF5n8xIA/XvqjHMDyV2hiFT864p
	 vxdttplBRKdpsepgy7DZORR9ZMshSptWLGkkVO22zvm4acXkC1yxtHPPRH06/97PqU87o
	 RHEt1rAvgNUtMWq8bohRTYcXRfWzjugQSNnaK3T5ophYdnYqF0RwO6cojLVPKDVxTuNU/
	 Q8UDixtm5LaBj6SjnS60l+NFM0iksVHmWFPteGYD7C8I2X5vatqis3EJSEDrmhK9eEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6CqJaloCqjE7DBtZys7PPM9QLIRko1ON9/SY7icLpeI=;
	b=dKF0PHN0LRuBfyKMyOHpH1zK5+7ZzQb+N2FK9trrCTIDSWqLOfS1oG8hvibmTZet7zAy
	 KPqq3PZ3XSdDRx59twzLVK7Zg/oSO6Rujux9nMfZtQqW728sfRdgmGvpOAIY4HezISuRj
	 StoxcwrzU25Tb7tdJZ9zixoUESpxoTaz6l6ZBexlvhPTWUyGgyctowpeTyIYbs+TUWG93
	 TpTjhbj/AXI6u6Sjp7Zm+xyEIxQJ9pWzdP5j3xu+7xrEC+y4sTDdflnV4TqYPwl30/dnY
	 p+EWJzOknysb1oi0+XIo49lfjAds56V9zVPaH2AJQbFF/qO3vK61iH3aqeU0eOvxnMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9NWcID5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5069C606A31C;
	Wed, 18 Nov 2026 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9NWcID5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E241F000C4;
	Wed, 18 Nov 2026 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024872;
	bh=6CqJaloCqjE7DBtZys7PPM9QLIRko1ON9/SY7icLpeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9NWcID5IDZKL3Wo+UGxdhNxo2aDDhQMlICnpFXjT0vwJYCgwrRP9gFGh+kb4JQm7
	 92secCGKg2nPspCR3Mjz9C4xQU5uewqsIrTxATxZDyjL40YBu30IXs6nMQhyPySi0p
	 dofxiL5xpmFhupIYRqHXVMrNjDYaTjKcLE9AxzY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0880/2151] perf python: Initialize debug output on module load
Date: Wed, 18 Nov 2026 15:43:35 +0100
Message-ID: <20261118150154.363684203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1dfa4d0eec4d7..b63d4e2f027a9 100644
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
index 2fa9670bc51f0..aaae49748c13c 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -2269,6 +2269,7 @@ PyMODINIT_FUNC PyInit_perf(void)
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
+	perf_debug_setup();
 
 	Py_INCREF(&pyrf_evlist__type);
 	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
-- 
2.53.0



