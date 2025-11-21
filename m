Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFD830F93B;
	Fri, 21 Nov 2025 13:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731222; cv=none; b=sFBMBnffww0uIqFwF4wcL9iuyr9f9utAtc4hWnHhZWOJxwkHGj+dWHQbqN8VSb5YWNEGP1jhD0H3Nx8oVZCAoQskQk8VwaO7N3Vn6bfhm+9cnbJwsnZihBQs/GhwPQiQEsAp2+ZDxuEFeDSoV01HxQhUQqOOy0RFGZ1XCs6JHyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731222; c=relaxed/simple;
	bh=gOKwVzia8hzpc+R3OVhT3xtddWXOvdJmUk7rm1K9F9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WH6fmCehXCV89vzkRxCK+KQO4ySoZwpDuo2qg8fuqBOrUX9gfdkU8YYOFmsxNxbrvN6PVOiMqRRAJRY6cB8SCd7hdeHta7q6ILWUMav+r9rUmC6y7gR//zsoJlm2p/YZZp0qfb//KyGhc7xC6KhoOCn6J94P3PtqmUVYEd900os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeslH6w6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeslH6w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312BEC4CEF1;
	Fri, 21 Nov 2025 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731221;
	bh=gOKwVzia8hzpc+R3OVhT3xtddWXOvdJmUk7rm1K9F9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeslH6w6Dg1gnYYF2He0FNCmGMgUqo71mIHtLAs4tR4VqSzoUgUnKhK1qU5GouiI5
	 hW3/v2auHYU0mLg1zb99kol7wWXdnINzPitMb3X3pf/2pTX9o+xs2f/05o5pC4oKtF
	 JGsRclpaAT74NyPH+TSCu5rr/KZDvj34K/51Wnas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Blake Jones <blakejones@google.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Collin Funk <collin.funk1@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nam Cao <namcao@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/247] perf test shell lock_contention: Extra debug diagnostics
Date: Fri, 21 Nov 2025 14:11:20 +0100
Message-ID: <20251121130159.500690665@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 8b93f8933d37591d17c59fd71b18fc61966d9515 ]

In test_record_concurrent, as stderr is sent to /dev/null, error
messages are hidden. Change this to gather the error messages and dump
them on failure.

Some minor sh->bash changes to add some more diagnostics in
trap_cleanup.

Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Blake Jones <blakejones@google.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Collin Funk <collin.funk1@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250821163820.1132977-5-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 3c723f449723 ("perf test: Fix lock contention test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/lock_contention.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/lock_contention.sh b/tools/perf/tests/shell/lock_contention.sh
index d33d9e4392b06..7248a74ca2a32 100755
--- a/tools/perf/tests/shell/lock_contention.sh
+++ b/tools/perf/tests/shell/lock_contention.sh
@@ -7,14 +7,17 @@ set -e
 err=0
 perfdata=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
 result=$(mktemp /tmp/__perf_test.result.XXXXX)
+errout=$(mktemp /tmp/__perf_test.errout.XXXXX)
 
 cleanup() {
 	rm -f ${perfdata}
 	rm -f ${result}
+	rm -f ${errout}
 	trap - EXIT TERM INT
 }
 
 trap_cleanup() {
+	echo "Unexpected signal in ${FUNCNAME[1]}"
 	cleanup
 	exit ${err}
 }
@@ -75,10 +78,12 @@ test_bpf()
 test_record_concurrent()
 {
 	echo "Testing perf lock record and perf lock contention at the same time"
-	perf lock record -o- -- perf bench sched messaging -p 2> /dev/null | \
+	perf lock record -o- -- perf bench sched messaging -p 2> ${errout} | \
 	perf lock contention -i- -E 1 -q 2> ${result}
 	if [ "$(cat "${result}" | wc -l)" != "1" ]; then
 		echo "[Fail] Recorded result count is not 1:" "$(cat "${result}" | wc -l)"
+		cat ${errout}
+		cat ${result}
 		err=1
 		exit
 	fi
-- 
2.51.0



