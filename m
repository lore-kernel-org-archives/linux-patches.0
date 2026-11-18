Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017959;
	b=nZKbai5LaDQDsDdMdMVVOa2b1oDeb1JXJIoVk7B1mcUYQnZC33d8MA1U+LG2cdqb7/H2
	 bAREOdlUq0ffld2ERNC0vKge03a+V6iF1lGkqqrDkU+JBz2X9XrQD/sZvFgBe/whuk4rI
	 4TiVzWuGhdIfp+gRzs2oTW6YZLhav2T3GjR8BVsdkRPLyOKh+H5kMslkXBQn9iaRKqBdf
	 g+nAbNn4lVQJic6+Wu3eBmpeRijKSkbLeRxGItfAgSwWqqU9oqwwwF3iD1yEm7vDI1agl
	 W6foGl6cJ0IExAJ7tBJ/s9otq+MsJw6y9qcxIWP5tKbx23X4jcOdvlA0wx7JZMLVFig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vbuTowRAbFJU6DQAuKu69/meemg7KpyNkukEJoVEimQ=;
	b=5QVxzRN/vmeOrZFcvBcbYbh6C1UG+bcO3Qz5byvT9/ckjqw1z5hlVcm7DnaAw5NUFE7b
	 5XUD8zyT8nax3SsAncPFYlpOUxuoNjf7RiEAyTqQfyQ977egcc9VmsaEB3GDPZX4teTsy
	 THT5eC84n/ySHEH+eXWCpT1yvKEFx6Zo/ZBrnWz+TfF9aQmBeIqjLsPwwDU1/X795jeJQ
	 47Kp8oq2rnVMGFAXOMJZZ1QuZ7Qn7WK556JjEuRbpiw24w3r1CKgwgW4rjC9SqZptSxPG
	 G0gTLBx3dszduZx3ISY34zoNDcSGSU1GJX8nS6Qr2PDqJkkyfdkWeiuEkeAi1uQd8KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMGiwk3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D58E606A325;
	Wed, 18 Nov 2026 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMGiwk3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50151F000C7;
	Wed, 18 Nov 2026 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017959;
	bh=vbuTowRAbFJU6DQAuKu69/meemg7KpyNkukEJoVEimQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMGiwk3ZPKUwBRzsaBluGPDEy1rucnwCmhL2DZ7Z5T46rdw1qz6IS89wdS4u/7qiX
	 PUYR2gvb6lGDZqBAOxEJfhg9T+1UbZnN6a6HWYA+pCFph9Gm7FBuZ43LqJdC9TrjyM
	 ZSHQJU+LK+zmbjoVYf+w+U0tG+FS8yvtXnAThXhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Michal Pluta <michalpl2003@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1070/2651] perf test demangle: Fail when demangling fails
Date: Wed, 18 Nov 2026 15:38:30 +0100
Message-ID: <20261118150326.503306728@linuxfoundation.org>
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

From: Michal Pluta <michalpl2003@gmail.com>

[ Upstream commit 0568396eac41b56874d6ac0c552df91262e2ccf6 ]

The Rust and Java demangle tests only log a NULL result from
dso__demangle_sym() and carry on, so a symbol that fails to demangle
doesn't fail the test.  Set TEST_FAIL.

Fixes: 07f2b1287c970e07 ("perf test demangle-java: Don't segv if demangling fails")
Fixes: bdf05ccd18414274 ("perf test demangle-rust: Add Rust demangling test")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Michal Pluta <michalpl2003@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/demangle-java-test.c    | 1 +
 tools/perf/tests/demangle-rust-v0-test.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/tests/demangle-java-test.c b/tools/perf/tests/demangle-java-test.c
index 0fb3e5a4a0ed2..a8eb0f4effad6 100644
--- a/tools/perf/tests/demangle-java-test.c
+++ b/tools/perf/tests/demangle-java-test.c
@@ -33,6 +33,7 @@ static int test__demangle_java(struct test_suite *test __maybe_unused, int subte
 		if (!buf) {
 			pr_debug("FAILED to demangle: \"%s\"\n \"%s\"\n", test_cases[i].mangled,
 				 test_cases[i].demangled);
+			ret = TEST_FAIL;
 			continue;
 		}
 		if (strcmp(buf, test_cases[i].demangled)) {
diff --git a/tools/perf/tests/demangle-rust-v0-test.c b/tools/perf/tests/demangle-rust-v0-test.c
index 904f966c65d78..ee4ddb61174b3 100644
--- a/tools/perf/tests/demangle-rust-v0-test.c
+++ b/tools/perf/tests/demangle-rust-v0-test.c
@@ -58,6 +58,7 @@ static int test__demangle_rust(struct test_suite *test __maybe_unused, int subte
 		if (!buf) {
 			pr_debug("FAILED to demangle: \"%s\"\n \"%s\"\n", test_cases[i].mangled,
 				 test_cases[i].demangled);
+			ret = TEST_FAIL;
 			continue;
 		}
 		if (strcmp(buf, test_cases[i].demangled)) {
-- 
2.53.0



