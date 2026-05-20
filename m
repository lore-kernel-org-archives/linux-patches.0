Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346A034EF05;
	Wed, 20 May 2026 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296035; cv=none; b=ogwxhGVGyIdOrIJfZI2dwrYomCOzdkmjGtkUpZf1YXJxCS+loT9q2t7ShWsiCFSJ4ysE5jQQMSnzhnjI0LhiWWqmYhvDct5mbJL/wMktCjxAvZINrFYC5Ek6vcN30S5+DKGn2s4y+OHE8Hyyl0/oKVf8xs5B2f0O5LadOKKG4Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296035; c=relaxed/simple;
	bh=Aw8aTNk9CFQK4stRts0DsoaxWDAaUs3uhf156ojFMP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d11xCae5t9EyxwJ8qR85FMtekC0t1iZOcFyMV7qoI8QYDHDt6fe11lePz+s9ge4Mi5bBidq2BBt76pk1AF1flLz9EdTlwNrTU3fofFM7kiU8fsw5EfAyr0K6+05bNx0UoN8s52yat96b30ly1n3I4MCG29CYVcRB77X+UrseWIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sej3e6xL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sej3e6xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921F11F000E9;
	Wed, 20 May 2026 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296034;
	bh=iinyYzr70WI9xcXVxRurPmcd+8gHYWB5AlRTazUU22g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sej3e6xLJh4V5du9gJhqC0xYNavSivbhubqZZYGAkEVHcPrfCmuJp+qS3vUlG0Qsq
	 HpMNUQPw+ZiObI5UcwGvOnD+kgH+ttpgOZsaqFYPsqGSUuAWVwLSEvqoxsLwWoN8y3
	 X1MecILWaWH+AXGVGW9GNTUgKh1RlBYFWbbfCGzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0644/1146] perf test: Skip perf data type profiling tests for s390
Date: Wed, 20 May 2026 18:14:54 +0200
Message-ID: <20260520162202.756884254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit eb27e1c885ea75c1661188a548d100c8bce5970a ]

Test case 'perf data type profiling tests' fails on s390 with this
error:

  # ./perf mem record -- ./perf test -w code_with_type
  failed: no PMU supports the memory events
  # echo $?
  255
  #

because s390 does not support memory events at all. According to the
man page, perf annotate --code-with-type only works with memory
instructions only.  As command 'perf mem record ...' is not supported
on s390, skip this test for s390.

Output before:
 # ./perf test 'perf data type profiling tests'
 77: perf data type profiling tests                        : FAILED!

Output after:
 # ./perf test 'perf data type profiling tests'
 77: perf data type profiling tests                        : Skip

Fixes: f60a5c22967b8 ("perf tests: Test annotate with data type profiling and rust")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/data_type_profiling.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/tests/shell/data_type_profiling.sh b/tools/perf/tests/shell/data_type_profiling.sh
index fb47b7213b335..eca694600a047 100755
--- a/tools/perf/tests/shell/data_type_profiling.sh
+++ b/tools/perf/tests/shell/data_type_profiling.sh
@@ -15,6 +15,10 @@ err=0
 perfdata=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
 perfout=$(mktemp /tmp/__perf_test.perf.out.XXXXX)
 
+# Check for support of perf mem before trap handler
+perf mem record -o /dev/null -- true  2>&1 | \
+  		grep -q "failed: no PMU supports the memory events" && exit 2
+
 cleanup() {
   rm -rf "${perfdata}" "${perfout}"
   rm -rf "${perfdata}".old
-- 
2.53.0



