Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024944;
	b=BYjMgOV9RLdIsIydijMzOvODheOa27mwb402iXKLZgQI1dF4fkRpJC/A86L2EjQVDl5Y
	 7uhv4Gj5zhkFMIw9tfvlr3Jn+4fxMW5YzoAtzspiTFFrNpN8uHHX1zhphLvG0fmTA7bNX
	 U2h38EU8ceznEFa2iIk347sGOLuaY+NjFB6owm2+xtXxwwtgv0UzDt60g6GkYm3Dup9PU
	 bVlc7Hqk9fFqoEg2UpvWoFbZ5Nd0cAJgXtpRx/MuUCxN/t5vlqi5vzhuvarz7fS+qljOp
	 sbEiIuRjSkWeLg3rsEThQVpwhi6hUpF3S2j4+X14GpQOtFn/ALd6Hk7DUa7nFWEuzPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iozf+8q0TmmqtzvpECEWXYxKhGsGAvvhVAk98A/aSEg=;
	b=fpzKqs9KTQWFoVbnUA5vx1fWig0LWkJbB2Ez2FeHqxdEdmpdeg9Qn+UX336Akbd/Ndmq
	 Qck8OPLs1uW5vhgjC3SiWI+ASuws/HRlNH1oU2ZDCZixd4MpfrLUdYmNXCi6dcrvp0bWB
	 4vN9aJNlJLxGgwgewGbHI++IQduklcUz2GdtNiRJDvlnLIl1CiYKMm/MUHMd04KLZWIIm
	 Xnu685CjqQ7G0/bE7Ola9he7C0+3qaInWUEI8+YvMfkIf1z2eFg8rsSO4BwCy4iLJDu7K
	 KmdpJaShjbuailkOGdS07IPH/TSTsPBtarA+zMYyjzghdgoI6eQZqVbLhJuFl/W/RKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGIZxjLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21191606A31C;
	Wed, 18 Nov 2026 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGIZxjLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7790E1F000C4;
	Wed, 18 Nov 2026 18:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024944;
	bh=iozf+8q0TmmqtzvpECEWXYxKhGsGAvvhVAk98A/aSEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGIZxjLg4W8zVM+U1h1YV3BwOC30VGtIrj08I3x7LwPTCQ6K2qo/4XH3jVw22rv8+
	 /Q0P8LG20aX+GOXFkQafbId11Wsf1/8O+WrjS70UF0JD5aPUKvm8BvaY8h54Hattp5
	 gnvrwjf2pqVMDuBKzUzMfAK8O3Bu3hknYmL8tQRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Michal Pluta <michalpl2003@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0903/2151] perf test demangle: Fail when demangling fails
Date: Wed, 18 Nov 2026 15:43:58 +0100
Message-ID: <20261118150155.221801197@linuxfoundation.org>
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



