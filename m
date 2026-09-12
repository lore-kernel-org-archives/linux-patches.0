Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B13B38A2;
	Sat, 12 Sep 2026 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238221; cv=none; b=texffJYaIoooNi7w2nwh/QTTA8zr/fc6G6rwM9o9kWm5orALzYuCxALfiIcXIOpJwcglmJXQxvH0IVJBT3KOlK0jLIwz7txVEMDUpCeT7I30Rpeo7C5F4hMel5hzAW56+3eBcRqyh2ooz/wjZoQJ0HVQn6LxsKuJ48PM++W1Sx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238221; c=relaxed/simple;
	bh=mhhk9vPunMczjMH8F/i4IsbFOWXnWYnocHBZ48u7uR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LheHtVLb9G8LDtLCUI6GpzQaMuPzl598JV9/qGto/3Baov1v+BXoiacNRJCZ+vnlcgEZflp4pOMY+WI86C2cXnVyO9UR581FzlDVGP7LYTobXgR2QJoJY8ZDlgZODI/mh7iNvIzrbnXEdVVxU+R9LVpnU9RdJywARI5EHfpFvjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFr1foj6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFr1foj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF371F000FF;
	Sat, 12 Sep 2026 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238217;
	bh=Qz+/0hfORYCUel9nM+knQRB9xHnVzRA4DIeIasd4SrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFr1foj6c5T/Ib+sMUfCykkHcHEBxQZaNrtIpFSytLuBfj09afPR+dLxQLofz1cpX
	 PU329KMn2Syi10QXR5QIMR1xXVqBRg0NNN5XsE47iSzLvQX7lI5rToXSi6iz9d1Tz8
	 8A4s2NmjlzbDZUTcLcZHTHJklGw6eW3Y2qIN8ZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Song Liu <song@kernel.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/935] perf test bpf-counters: Add test for BPF event modifier
Date: Sat, 12 Sep 2026 08:57:27 +0200
Message-ID: <20260912065536.385670064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d9bd1d4264baddf7ab8baae86e91674d369f22de ]

Refactor test to better enable sharing of logic, to give an idea of
progress and introduce test functions. Add test of measuring both
cycles and cycles:b simultaneously.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20240416170014.985191-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: b02027776ac5 ("perf tests: Fix flakiness in BPF counters test on hybrid systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 75 ++++++++++++++-------
 1 file changed, 52 insertions(+), 23 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index 2d92098747746..61f8149d854e1 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -4,21 +4,59 @@
 
 set -e
 
+workload="perf bench sched messaging -g 1 -l 100 -t"
+
 # check whether $2 is within +/- 20% of $1
 compare_number()
 {
-       first_num=$1
-       second_num=$2
-
-       # upper bound is first_num * 120%
-       upper=$(expr $first_num + $first_num / 5 )
-       # lower bound is first_num * 80%
-       lower=$(expr $first_num - $first_num / 5 )
-
-       if [ $second_num -gt $upper ] || [ $second_num -lt $lower ]; then
-               echo "The difference between $first_num and $second_num are greater than 20%."
-               exit 1
-       fi
+	first_num=$1
+	second_num=$2
+
+	# upper bound is first_num * 120%
+	upper=$(expr $first_num + $first_num / 5 )
+	# lower bound is first_num * 80%
+	lower=$(expr $first_num - $first_num / 5 )
+
+	if [ $second_num -gt $upper ] || [ $second_num -lt $lower ]; then
+		echo "The difference between $first_num and $second_num are greater than 20%."
+		exit 1
+	fi
+}
+
+check_counts()
+{
+	base_cycles=$1
+	bpf_cycles=$2
+
+	if [ "$base_cycles" = "<not" ]; then
+		echo "Skipping: cycles event not counted"
+		exit 2
+	fi
+	if [ "$bpf_cycles" = "<not" ]; then
+		echo "Failed: cycles not counted with --bpf-counters"
+		exit 1
+	fi
+}
+
+test_bpf_counters()
+{
+	printf "Testing --bpf-counters "
+	base_cycles=$(perf stat --no-big-num -e cycles -- $workload 2>&1 | awk '/cycles/ {print $1}')
+	bpf_cycles=$(perf stat --no-big-num --bpf-counters -e cycles -- $workload  2>&1 | awk '/cycles/ {print $1}')
+	check_counts $base_cycles $bpf_cycles
+	compare_number $base_cycles $bpf_cycles
+	echo "[Success]"
+}
+
+test_bpf_modifier()
+{
+	printf "Testing bpf event modifier "
+	stat_output=$(perf stat --no-big-num -e cycles/name=base_cycles/,cycles/name=bpf_cycles/b -- $workload 2>&1)
+	base_cycles=$(echo "$stat_output"| awk '/base_cycles/ {print $1}')
+	bpf_cycles=$(echo "$stat_output"| awk '/bpf_cycles/ {print $1}')
+	check_counts $base_cycles $bpf_cycles
+	compare_number $base_cycles $bpf_cycles
+	echo "[Success]"
 }
 
 # skip if --bpf-counters is not supported
@@ -30,16 +68,7 @@ if ! perf stat -e cycles --bpf-counters true > /dev/null 2>&1; then
 	exit 2
 fi
 
-base_cycles=$(perf stat --no-big-num -e cycles -- perf bench sched messaging -g 1 -l 100 -t 2>&1 | awk '/cycles/ {print $1}')
-if [ "$base_cycles" = "<not" ]; then
-	echo "Skipping: cycles event not counted"
-	exit 2
-fi
-bpf_cycles=$(perf stat --no-big-num --bpf-counters -e cycles -- perf bench sched messaging -g 1 -l 100 -t 2>&1 | awk '/cycles/ {print $1}')
-if [ "$bpf_cycles" = "<not" ]; then
-	echo "Failed: cycles not counted with --bpf-counters"
-	exit 1
-fi
+test_bpf_counters
+test_bpf_modifier
 
-compare_number $base_cycles $bpf_cycles
 exit 0
-- 
2.53.0



