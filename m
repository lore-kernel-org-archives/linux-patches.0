Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1301C646;
	Tue,  3 Dec 2024 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239068; cv=none; b=otNsvrxVxYo+lqHKxjuFKLKH2fKDwCtDpRLj4TDIivxk1xrCdnXuvFtWThaZTo3ggL7ddszoEk7feggX6VCM3hvxXKcXhZrnxlQpHqQVc8eat0LZloxg4yvOwQ6UYcpTGXbDMoJLo1hvg34xmWzOvJIdF/WYO6ha5su+3NqOSmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239068; c=relaxed/simple;
	bh=Gftl4RKFvLWIg+pygxQg508aUEjFgZwBLSUPRUcv8EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcAjFg+9J4Xf3WRUD7wALW8fr/DoXJ0fj6wV8APvAd5nCmb3sFYhzUO/lRbuuXkpgk94A0ugorvSKhwYr3G0lOE6TIAqdq9OI1IA1Tho4KjLBTgwJjtJaNSnUl3tUPWYqdwWR264AChIQrtQEdJn5YzWKG+s6asmYByP0k3kVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCpSkCVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCpSkCVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65602C4CECF;
	Tue,  3 Dec 2024 15:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239067;
	bh=Gftl4RKFvLWIg+pygxQg508aUEjFgZwBLSUPRUcv8EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCpSkCVQlF2IP//ecfNxcRUXk31rK5Wb5ZK34u0mudNzg2uAvH0XXJtmDo/ufRkhL
	 O/fI2Yq40zPhbSu602fmQ4wtlnL6S3N7z2/I3nAvGihXm7aIv1+/GBPYsTfr2t3+56
	 wiHiDU+/5CFDWm5fGkHQnsTEnt2LODJBcf+aqrxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Ian Rogers <irogers@google.com>,
	mpetlan@redhat.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 492/817] perf test attr: Add back missing topdown events
Date: Tue,  3 Dec 2024 15:41:04 +0100
Message-ID: <20241203144015.079043369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veronika Molnarova <vmolnaro@redhat.com>

[ Upstream commit 6bff76af9635411214ca44ea38fc2781e78064b6 ]

With the patch 0b6c5371c03c "Add missing topdown metrics events" eight
topdown metric events with numbers ranging from 0x8000 to 0x8700 were
added to the test since they were added as 'perf stat' default events.
Later the patch 951efb9976ce "Update no event/metric expectations" kept
only 4 of those events(0x8000-0x8300).

Currently, the topdown events with numbers 0x8400 to 0x8700 are missing
from the list of expected events resulting in a failure. Add back the
missing topdown events.

Fixes: 951efb9976ce ("perf test attr: Update no event/metric expectations")
Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: mpetlan@redhat.com
Link: https://lore.kernel.org/r/20240311081611.7835-1-vmolnaro@redhat.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/attr/test-stat-default    |  90 ++++++++++----
 tools/perf/tests/attr/test-stat-detailed-1 | 106 +++++++++++-----
 tools/perf/tests/attr/test-stat-detailed-2 | 130 ++++++++++++-------
 tools/perf/tests/attr/test-stat-detailed-3 | 138 ++++++++++++++-------
 4 files changed, 320 insertions(+), 144 deletions(-)

diff --git a/tools/perf/tests/attr/test-stat-default b/tools/perf/tests/attr/test-stat-default
index a1e2da0a9a6dd..e47fb49446799 100644
--- a/tools/perf/tests/attr/test-stat-default
+++ b/tools/perf/tests/attr/test-stat-default
@@ -88,98 +88,142 @@ enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
+# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
 [event13:base-stat]
 fd=13
 group_fd=11
 type=4
-config=33280
+config=33024
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-be-bound (0x8300)
+# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
 [event14:base-stat]
 fd=14
 group_fd=11
 type=4
-config=33536
+config=33280
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
+# PERF_TYPE_RAW / topdown-be-bound (0x8300)
 [event15:base-stat]
 fd=15
 group_fd=11
 type=4
-config=33024
+config=33536
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
+# PERF_TYPE_RAW / topdown-heavy-ops (0x8400)
 [event16:base-stat]
 fd=16
+group_fd=11
 type=4
-config=4109
+config=33792
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
+# PERF_TYPE_RAW / topdown-br-mispredict (0x8500)
 [event17:base-stat]
 fd=17
+group_fd=11
 type=4
-config=17039629
+config=34048
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
+# PERF_TYPE_RAW / topdown-fetch-lat (0x8600)
 [event18:base-stat]
 fd=18
+group_fd=11
 type=4
-config=60
+config=34304
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
+# PERF_TYPE_RAW / topdown-mem-bound (0x8700)
 [event19:base-stat]
 fd=19
+group_fd=11
 type=4
-config=2097421
+config=34560
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
+# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
 [event20:base-stat]
 fd=20
 type=4
-config=316
+config=4109
 optional=1
 
-# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
 [event21:base-stat]
 fd=21
 type=4
-config=412
+config=17039629
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
 [event22:base-stat]
 fd=22
 type=4
-config=572
+config=60
 optional=1
 
-# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
 [event23:base-stat]
 fd=23
 type=4
-config=706
+config=2097421
 optional=1
 
-# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
 [event24:base-stat]
 fd=24
 type=4
+config=316
+optional=1
+
+# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+[event25:base-stat]
+fd=25
+type=4
+config=412
+optional=1
+
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+[event26:base-stat]
+fd=26
+type=4
+config=572
+optional=1
+
+# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+[event27:base-stat]
+fd=27
+type=4
+config=706
+optional=1
+
+# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+[event28:base-stat]
+fd=28
+type=4
 config=270
 optional=1
diff --git a/tools/perf/tests/attr/test-stat-detailed-1 b/tools/perf/tests/attr/test-stat-detailed-1
index 1c52cb05c900d..3d500d3e0c5c8 100644
--- a/tools/perf/tests/attr/test-stat-detailed-1
+++ b/tools/perf/tests/attr/test-stat-detailed-1
@@ -90,99 +90,143 @@ enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
+# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
 [event13:base-stat]
 fd=13
 group_fd=11
 type=4
-config=33280
+config=33024
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-be-bound (0x8300)
+# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
 [event14:base-stat]
 fd=14
 group_fd=11
 type=4
-config=33536
+config=33280
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
+# PERF_TYPE_RAW / topdown-be-bound (0x8300)
 [event15:base-stat]
 fd=15
 group_fd=11
 type=4
-config=33024
+config=33536
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
+# PERF_TYPE_RAW / topdown-heavy-ops (0x8400)
 [event16:base-stat]
 fd=16
+group_fd=11
 type=4
-config=4109
+config=33792
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
+# PERF_TYPE_RAW / topdown-br-mispredict (0x8500)
 [event17:base-stat]
 fd=17
+group_fd=11
 type=4
-config=17039629
+config=34048
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
+# PERF_TYPE_RAW / topdown-fetch-lat (0x8600)
 [event18:base-stat]
 fd=18
+group_fd=11
 type=4
-config=60
+config=34304
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
+# PERF_TYPE_RAW / topdown-mem-bound (0x8700)
 [event19:base-stat]
 fd=19
+group_fd=11
 type=4
-config=2097421
+config=34560
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
+# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
 [event20:base-stat]
 fd=20
 type=4
-config=316
+config=4109
 optional=1
 
-# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
 [event21:base-stat]
 fd=21
 type=4
-config=412
+config=17039629
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
 [event22:base-stat]
 fd=22
 type=4
-config=572
+config=60
 optional=1
 
-# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
 [event23:base-stat]
 fd=23
 type=4
-config=706
+config=2097421
 optional=1
 
-# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
 [event24:base-stat]
 fd=24
 type=4
+config=316
+optional=1
+
+# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+[event25:base-stat]
+fd=25
+type=4
+config=412
+optional=1
+
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+[event26:base-stat]
+fd=26
+type=4
+config=572
+optional=1
+
+# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+[event27:base-stat]
+fd=27
+type=4
+config=706
+optional=1
+
+# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+[event28:base-stat]
+fd=28
+type=4
 config=270
 optional=1
 
@@ -190,8 +234,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event25:base-stat]
-fd=25
+[event29:base-stat]
+fd=29
 type=3
 config=0
 optional=1
@@ -200,8 +244,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event26:base-stat]
-fd=26
+[event30:base-stat]
+fd=30
 type=3
 config=65536
 optional=1
@@ -210,8 +254,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_LL                 <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event27:base-stat]
-fd=27
+[event31:base-stat]
+fd=31
 type=3
 config=2
 optional=1
@@ -220,8 +264,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_LL                 <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event28:base-stat]
-fd=28
+[event32:base-stat]
+fd=32
 type=3
 config=65538
 optional=1
diff --git a/tools/perf/tests/attr/test-stat-detailed-2 b/tools/perf/tests/attr/test-stat-detailed-2
index 7e961d24a885a..01777a63752fe 100644
--- a/tools/perf/tests/attr/test-stat-detailed-2
+++ b/tools/perf/tests/attr/test-stat-detailed-2
@@ -90,99 +90,143 @@ enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
+# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
 [event13:base-stat]
 fd=13
 group_fd=11
 type=4
-config=33280
+config=33024
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-be-bound (0x8300)
+# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
 [event14:base-stat]
 fd=14
 group_fd=11
 type=4
-config=33536
+config=33280
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
+# PERF_TYPE_RAW / topdown-be-bound (0x8300)
 [event15:base-stat]
 fd=15
 group_fd=11
 type=4
-config=33024
+config=33536
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
+# PERF_TYPE_RAW / topdown-heavy-ops (0x8400)
 [event16:base-stat]
 fd=16
+group_fd=11
 type=4
-config=4109
+config=33792
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
+# PERF_TYPE_RAW / topdown-br-mispredict (0x8500)
 [event17:base-stat]
 fd=17
+group_fd=11
 type=4
-config=17039629
+config=34048
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
+# PERF_TYPE_RAW / topdown-fetch-lat (0x8600)
 [event18:base-stat]
 fd=18
+group_fd=11
 type=4
-config=60
+config=34304
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
+# PERF_TYPE_RAW / topdown-mem-bound (0x8700)
 [event19:base-stat]
 fd=19
+group_fd=11
 type=4
-config=2097421
+config=34560
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
+# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
 [event20:base-stat]
 fd=20
 type=4
-config=316
+config=4109
 optional=1
 
-# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
 [event21:base-stat]
 fd=21
 type=4
-config=412
+config=17039629
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
 [event22:base-stat]
 fd=22
 type=4
-config=572
+config=60
 optional=1
 
-# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
 [event23:base-stat]
 fd=23
 type=4
-config=706
+config=2097421
 optional=1
 
-# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
 [event24:base-stat]
 fd=24
 type=4
+config=316
+optional=1
+
+# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+[event25:base-stat]
+fd=25
+type=4
+config=412
+optional=1
+
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+[event26:base-stat]
+fd=26
+type=4
+config=572
+optional=1
+
+# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+[event27:base-stat]
+fd=27
+type=4
+config=706
+optional=1
+
+# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+[event28:base-stat]
+fd=28
+type=4
 config=270
 optional=1
 
@@ -190,8 +234,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event25:base-stat]
-fd=25
+[event29:base-stat]
+fd=29
 type=3
 config=0
 optional=1
@@ -200,8 +244,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event26:base-stat]
-fd=26
+[event30:base-stat]
+fd=30
 type=3
 config=65536
 optional=1
@@ -210,8 +254,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_LL                 <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event27:base-stat]
-fd=27
+[event31:base-stat]
+fd=31
 type=3
 config=2
 optional=1
@@ -220,8 +264,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_LL                 <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event28:base-stat]
-fd=28
+[event32:base-stat]
+fd=32
 type=3
 config=65538
 optional=1
@@ -230,8 +274,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1I                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event29:base-stat]
-fd=29
+[event33:base-stat]
+fd=33
 type=3
 config=1
 optional=1
@@ -240,8 +284,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1I                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event30:base-stat]
-fd=30
+[event34:base-stat]
+fd=34
 type=3
 config=65537
 optional=1
@@ -250,8 +294,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event31:base-stat]
-fd=31
+[event35:base-stat]
+fd=35
 type=3
 config=3
 optional=1
@@ -260,8 +304,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event32:base-stat]
-fd=32
+[event36:base-stat]
+fd=36
 type=3
 config=65539
 optional=1
@@ -270,8 +314,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event33:base-stat]
-fd=33
+[event37:base-stat]
+fd=37
 type=3
 config=4
 optional=1
@@ -280,8 +324,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event34:base-stat]
-fd=34
+[event38:base-stat]
+fd=38
 type=3
 config=65540
 optional=1
diff --git a/tools/perf/tests/attr/test-stat-detailed-3 b/tools/perf/tests/attr/test-stat-detailed-3
index e50535f45977c..8400abd7e1e48 100644
--- a/tools/perf/tests/attr/test-stat-detailed-3
+++ b/tools/perf/tests/attr/test-stat-detailed-3
@@ -90,99 +90,143 @@ enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
+# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
 [event13:base-stat]
 fd=13
 group_fd=11
 type=4
-config=33280
+config=33024
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-be-bound (0x8300)
+# PERF_TYPE_RAW / topdown-fe-bound (0x8200)
 [event14:base-stat]
 fd=14
 group_fd=11
 type=4
-config=33536
+config=33280
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / topdown-bad-spec (0x8100)
+# PERF_TYPE_RAW / topdown-be-bound (0x8300)
 [event15:base-stat]
 fd=15
 group_fd=11
 type=4
-config=33024
+config=33536
 disabled=0
 enable_on_exec=0
 read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
+# PERF_TYPE_RAW / topdown-heavy-ops (0x8400)
 [event16:base-stat]
 fd=16
+group_fd=11
 type=4
-config=4109
+config=33792
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
+# PERF_TYPE_RAW / topdown-br-mispredict (0x8500)
 [event17:base-stat]
 fd=17
+group_fd=11
 type=4
-config=17039629
+config=34048
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
+# PERF_TYPE_RAW / topdown-fetch-lat (0x8600)
 [event18:base-stat]
 fd=18
+group_fd=11
 type=4
-config=60
+config=34304
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
+# PERF_TYPE_RAW / topdown-mem-bound (0x8700)
 [event19:base-stat]
 fd=19
+group_fd=11
 type=4
-config=2097421
+config=34560
+disabled=0
+enable_on_exec=0
+read_format=15
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
+# PERF_TYPE_RAW / INT_MISC.UOP_DROPPING
 [event20:base-stat]
 fd=20
 type=4
-config=316
+config=4109
 optional=1
 
-# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+# PERF_TYPE_RAW / cpu/INT_MISC.RECOVERY_CYCLES,cmask=1,edge/
 [event21:base-stat]
 fd=21
 type=4
-config=412
+config=17039629
 optional=1
 
-# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.THREAD
 [event22:base-stat]
 fd=22
 type=4
-config=572
+config=60
 optional=1
 
-# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+# PERF_TYPE_RAW / INT_MISC.RECOVERY_CYCLES_ANY
 [event23:base-stat]
 fd=23
 type=4
-config=706
+config=2097421
 optional=1
 
-# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.REF_XCLK
 [event24:base-stat]
 fd=24
 type=4
+config=316
+optional=1
+
+# PERF_TYPE_RAW / IDQ_UOPS_NOT_DELIVERED.CORE
+[event25:base-stat]
+fd=25
+type=4
+config=412
+optional=1
+
+# PERF_TYPE_RAW / CPU_CLK_UNHALTED.ONE_THREAD_ACTIVE
+[event26:base-stat]
+fd=26
+type=4
+config=572
+optional=1
+
+# PERF_TYPE_RAW / UOPS_RETIRED.RETIRE_SLOTS
+[event27:base-stat]
+fd=27
+type=4
+config=706
+optional=1
+
+# PERF_TYPE_RAW / UOPS_ISSUED.ANY
+[event28:base-stat]
+fd=28
+type=4
 config=270
 optional=1
 
@@ -190,8 +234,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event25:base-stat]
-fd=25
+[event29:base-stat]
+fd=29
 type=3
 config=0
 optional=1
@@ -200,8 +244,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event26:base-stat]
-fd=26
+[event30:base-stat]
+fd=30
 type=3
 config=65536
 optional=1
@@ -210,8 +254,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_LL                 <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event27:base-stat]
-fd=27
+[event31:base-stat]
+fd=31
 type=3
 config=2
 optional=1
@@ -220,8 +264,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_LL                 <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event28:base-stat]
-fd=28
+[event32:base-stat]
+fd=32
 type=3
 config=65538
 optional=1
@@ -230,8 +274,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1I                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event29:base-stat]
-fd=29
+[event33:base-stat]
+fd=33
 type=3
 config=1
 optional=1
@@ -240,8 +284,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1I                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event30:base-stat]
-fd=30
+[event34:base-stat]
+fd=34
 type=3
 config=65537
 optional=1
@@ -250,8 +294,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event31:base-stat]
-fd=31
+[event35:base-stat]
+fd=35
 type=3
 config=3
 optional=1
@@ -260,8 +304,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_DTLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event32:base-stat]
-fd=32
+[event36:base-stat]
+fd=36
 type=3
 config=65539
 optional=1
@@ -270,8 +314,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event33:base-stat]
-fd=33
+[event37:base-stat]
+fd=37
 type=3
 config=4
 optional=1
@@ -280,8 +324,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_ITLB               <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_READ            <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event34:base-stat]
-fd=34
+[event38:base-stat]
+fd=38
 type=3
 config=65540
 optional=1
@@ -290,8 +334,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_PREFETCH        <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_ACCESS      << 16)
-[event35:base-stat]
-fd=35
+[event39:base-stat]
+fd=39
 type=3
 config=512
 optional=1
@@ -300,8 +344,8 @@ optional=1
 #  PERF_COUNT_HW_CACHE_L1D                <<  0  |
 # (PERF_COUNT_HW_CACHE_OP_PREFETCH        <<  8) |
 # (PERF_COUNT_HW_CACHE_RESULT_MISS        << 16)
-[event36:base-stat]
-fd=36
+[event40:base-stat]
+fd=40
 type=3
 config=66048
 optional=1
-- 
2.43.0



