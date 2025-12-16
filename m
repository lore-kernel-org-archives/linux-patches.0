Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FDF343D8F;
	Tue, 16 Dec 2025 11:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886009; cv=none; b=DHEDjCIDR8LAMbZWbcpfRowiNdDVq7ApytWkK78nhuaJ2QhZd9IiAFbbrsSAzyOiA/ME5t1M2OHjpEm6gNqsv7xjvXoPuIuhVJAuKUkcnaY4SGNV/06ruaPLoc4ubQ3nJIvojQn0WJw8zFO20W1F/rUtb+F3WYrhgDz8mtk/m50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886009; c=relaxed/simple;
	bh=p0+uQCoh4o/ICUKv/BlSCh19/IT38XnQe8npnKLAtMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAiA5t4zf3712ztw6PVtYWR3rU57YvuI4se+H3YNgG35Ftzq3FPsgMPfqgu1UhB2FvA1DQiPozb3Ehsf/j64X5NGFKfOkJikcqt9ojYHB7MYgLbCuYzPs6QBrJPuvh8LiHluCAWilzfs4B+pzL6vOnKB06TOraLwlFpIob/tU8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaZtzmMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaZtzmMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63458C4CEF1;
	Tue, 16 Dec 2025 11:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886008;
	bh=p0+uQCoh4o/ICUKv/BlSCh19/IT38XnQe8npnKLAtMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaZtzmMSJH4wAW7cb87DUspWJZ8yx8pgr4yHbr3RWL68lTBoqPImSCs8Ymc7+M+i1
	 TUPfNeLZB86A4u8UznfOSzFFHRXWd3fVf8Va1XGFFvQZnHXCn8XK3qhpx++Wo28s1H
	 oIXEHhaLb/Mtv1gudRkbDD8sN8jb62/rC+jJYd44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 309/507] selftests/bpf: skip test_perf_branches_hw() on unsupported platforms
Date: Tue, 16 Dec 2025 12:12:30 +0100
Message-ID: <20251216111356.664881392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit 27746aaf1b20172f0859546c4a3e82eca459f680 ]

Gracefully skip the test_perf_branches_hw subtest on platforms that
do not support LBR or require specialized perf event attributes
to enable branch sampling.

For example, AMD's Milan (Zen 3) supports BRS rather than traditional
LBR. This requires specific configurations (attr.type = PERF_TYPE_RAW,
attr.config = RETIRED_TAKEN_BRANCH_INSTRUCTIONS) that differ from the
generic setup used within this test. Notably, it also probably doesn't
hold much value to special case perf event configurations for selected
micro architectures.

Fixes: 67306f84ca78c ("selftests/bpf: Add bpf_read_branch_records() selftest")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20251120142059.2836181-1-mattbobrowski@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/perf_branches.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_branches.c b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
index bc24f83339d64..06c7986131d96 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_branches.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
@@ -116,11 +116,11 @@ static void test_perf_branches_hw(void)
 	pfd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, PERF_FLAG_FD_CLOEXEC);
 
 	/*
-	 * Some setups don't support branch records (virtual machines, !x86),
-	 * so skip test in this case.
+	 * Some setups don't support LBR (virtual machines, !x86, AMD Milan Zen
+	 * 3 which only supports BRS), so skip test in this case.
 	 */
 	if (pfd < 0) {
-		if (errno == ENOENT || errno == EOPNOTSUPP) {
+		if (errno == ENOENT || errno == EOPNOTSUPP || errno == EINVAL) {
 			printf("%s:SKIP:no PERF_SAMPLE_BRANCH_STACK\n",
 			       __func__);
 			test__skip();
-- 
2.51.0



