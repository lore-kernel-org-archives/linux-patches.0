Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1346D090;
	Tue, 21 Jul 2026 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657145; cv=none; b=jTDSupsOUqgGoEOM/iq0/kwScD9P0+hqJ1/y5i7WBImbYYRW0dI488Dh7iqt6S2r2zBwAlf2XIHdq90drA8bJ8uQ8jc43oj/3d6cYklwDfj8jjTIJkg9Qia04n0nikuqqe2qsZrXjKgzqNT1nm/WBKl1EtQ1k2y0hZC4QoXlKQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657145; c=relaxed/simple;
	bh=QkI9wiEQ1D9N6X+FIStoy48I1XAW1lmLVMVW93C0qVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fygatwV6e+Krk5coosLeSWGt1sdm5j5vvT4clR8Xo5YI/UL1MRK8fEKZnVHzouJ1K+TSu00bHDzsz0vEYJ0UxTKmpD7JZa+YuAbYaCpoaG6DgSsxukKxTbJIg1L1KvMq3qOe2GLFVY/77hZgTQJuOUuHOhtNxtUP3ay0vpZoGKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YK6vHwEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YK6vHwEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FC91F000E9;
	Tue, 21 Jul 2026 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657144;
	bh=868EZkbX7QM0o7YBU2FS+fakq8CVjR+OTtaa7Ld+gJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YK6vHwEQAg5sNwLY2gEgZHydmLu5N44IqYSLY95D3RqtPAxIuIsgT/BQaQjvhQ81T
	 rVa3FqNxSQNorqqXkfRsBPdAg4gKNkwZ5AjuVUYHBz8CGuOAtKISh/XJrxDnT+FrI5
	 g82ScKI3Gr2CSYcULZ95uR9gl7eOdqicwWAoNtCI=
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
Subject: [PATCH 6.18 0611/1611] perf test amd ibs: Fix incorrect kernel version check
Date: Tue, 21 Jul 2026 17:12:07 +0200
Message-ID: <20260721152529.129061158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 223e059e04deb0..986ac34d218fb7 100644
--- a/tools/perf/arch/x86/tests/amd-ibs-period.c
+++ b/tools/perf/arch/x86/tests/amd-ibs-period.c
@@ -933,7 +933,7 @@ static bool kernel_v6_15_or_newer(void)
 	endptr++;
 	minor = strtol(endptr, NULL, 10);
 
-	return major >= 6 && minor >= 15;
+	return major > 6 || (major == 6 && minor >= 15);
 }
 
 int test__amd_ibs_period(struct test_suite *test __maybe_unused,
-- 
2.53.0



