Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C4471264;
	Tue, 21 Jul 2026 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660206; cv=none; b=AKxRDjiQXXJjQnxEuSXc8V+w0u6L7VnIaW2S01XD1ejveFJoiePpyDypBFF10h6ouIk2L1QUYDy7ITCa/bAW9LPcDm3ShRCXaEkFQIeQoxs+6xnPzHZO5XVC9VOaxnBYgn7LHoM+vSfGPHvNaRRamebi4ydif16S0YzIaHJLAM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660206; c=relaxed/simple;
	bh=tdsjTh+tZsZUOacoBcfro7XMZmdBfCqkSUhjU5igP8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzaOO1GjTGSiJM984bVyMfR5KVuf72RG7n831c0Zt3UNEX8o/oH596za4R6hYS31xLgmhrVauuAUwXKe1MWFrZhZzXUmQ0dNqcIqiXgu/xJBafy0t226i28N1OX6n8KzolxiGDtzfZV37nNNycG2q3yUrrTePPGrJNdkzUFV6sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gu1c3OBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gu1c3OBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127F61F000E9;
	Tue, 21 Jul 2026 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660205;
	bh=Ms4bofHE6THgooXpRllJUvPCjBptXpx8Ru1nrePqPmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gu1c3OBYakd8awKXfBVH1y73RIbLv2qqbdxJV+/DHI6Wd1SBNOgjwKOhSx0G0r/CP
	 oyJ3XY/9jo9g9l4/57zVff2icdZJaqTwELTx2OD5y6KbqXUjdZZrQp/HliVyXIll20
	 B9jDi+xZh/JFrAlvHpU3ytdtxYC9Qqb0kjKCtSws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ananth Narayan <ananth.narayan@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Manali Shukla <manali.shukla@amd.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0892/2077] perf test amd ibs: Fix incorrect kernel version check
Date: Tue, 21 Jul 2026 17:09:25 +0200
Message-ID: <20260721152613.855080726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 0b97e92393a178765ee1ea01fe5087efece2c425 ]

"AMD IBS sample period" unit test is getting skipped on kernel v7.x. Fix
the kernel version >= v6.15 check.

Fixes: 21fb366b2f457611 ("perf test amd: Skip amd-ibs-period test on kernel < v6.15")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ananth Narayan <ananth.narayan@amd.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Manali Shukla <manali.shukla@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/tests/amd-ibs-period.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/tests/amd-ibs-period.c b/tools/perf/arch/x86/tests/amd-ibs-period.c
index cee9e11c05e08c..6a92b3a23ed7a6 100644
--- a/tools/perf/arch/x86/tests/amd-ibs-period.c
+++ b/tools/perf/arch/x86/tests/amd-ibs-period.c
@@ -932,7 +932,7 @@ static bool kernel_v6_15_or_newer(void)
 	endptr++;
 	minor = strtol(endptr, NULL, 10);
 
-	return major >= 6 && minor >= 15;
+	return major > 6 || (major == 6 && minor >= 15);
 }
 
 int test__amd_ibs_period(struct test_suite *test __maybe_unused,
-- 
2.53.0



