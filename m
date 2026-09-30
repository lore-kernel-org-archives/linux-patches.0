Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610CE33D4E9;
	Wed, 30 Sep 2026 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786785; cv=none; b=ng0jQJavsWeAp2i5m/6B5g0La1PTLJYXu/+S9ZTwna9hAAN64GcIftPVa+Naof5vGFcLlBWpPcY0SErV/L9Gd1IWsRnqyCgq3W5BboNFCF3CM32YdMh0QGIYFHBwsY56jgVSzpx23OUE0po6iyo37SsCaTAWARejWwhb84fD+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786785; c=relaxed/simple;
	bh=IvYIyxPiFxG1LIULmlKcLmqnXutiRtFFnhBXjIKgQ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM0tI06tD6XM36L+8Br55QTQSoRKYYW1UE16LtxPJkb7+iRjjmhQvKXpvfaYwvI9Dk9ndsDfK6qvu+xM/8Xj1bNrjsryl6vbo7iN4mgFFgn8nVBdhCAqUV3iah0+30qSd7Cf5odl2grVkJ6+0OmTQov/Q9yr6meikx+P9jg2nIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu6y1ez4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu6y1ez4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2521F000FF;
	Wed, 30 Sep 2026 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786784;
	bh=2m5Sn7MIUsce89X9sCdOUFeWSyhDYjRuMyGh9dj7X0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hu6y1ez4VNVCOwOb+QKm2JtJxCkBMA44a6mIgjDZnRfkLBYZMYU3UVmCmV7LyuKEX
	 KvhGfoB/Z+2Zmd8Kpa7XVrASp0AA1zA/NOsXpWdvUS6pFYj/STrC7VlLfCPACaCNQj
	 dKF2fhfB8Hd7E8e/CKgTFyuTPlpQZf3tC9plNh1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Collin Funk <collin.funk1@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 977/982] perf test: Change all remaining #!/bin/sh to #!/bin/bash
Date: Wed, 30 Sep 2026 17:28:33 +0200
Message-ID: <20260930152437.729611829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

commit 2f5d370dec3f800b44bbf7b68875d521e0af43cd upstream.

There are 43 instances of posix shell tests and 35 instances of bash. To
give us a single consistent language for testing in, replace
all #!/bin/sh to #!/bin/bash. Common sources that are included in both
different shells will now work as expected. And we no longer have to fix
up bashisms that appear to work when someone's system has sh symlinked
to bash, but don't work on other systems that have both shells
installed.

Although we could have chosen sh, it's not backwards compatible so it
wouldn't be possible to bulk convert without re-writing the existing
bash tests.

Choosing bash also gives us some nicer features including 'local'
variable definitions and regexes in if statements that are already
widely used in the tests.

It's not expected that there are any users with only sh available due to
the large number of bash tests that exist.

Discussed in relation to running shellcheck here:
https://lore.kernel.org/linux-perf-users/e3751a74be34bbf3781c4644f518702a7270220b.1749785642.git.collin.funk1@gmail.com/

Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Collin Funk <collin.funk1@gmail.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250623-james-perf-bash-tests-v1-1-f572f54d4559@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>

When commit b02027776ac5 ("perf tests: Fix flakiness in BPF counters
test on hybrid systems") was backported to several stable series
(v5.15.221, v6.1.188, v6.6.157, v6.12.110, v6.18.52, v7.2.6) it
introduced specific bash syntax. For versions after 2f5d370dec3f ("perf
test: Change all remaining #!/bin/sh to #!/bin/bash") in v6.17-rc1 this
is not a problem as the shebang was already hanged to #!/bin/bash. For
the older stable series this introduced invalid syntax if #!/bin/sh is
not bash:

	$ sh -n tools/perf/tests/shell/stat_bpf_counters.sh
	tools/perf/tests/shell/stat_bpf_counters.sh: 12: Syntax error: "(" unexpected

	$ checkbashism tools/perf/tests/shell/stat_bpf_counters.sh
	possible bashism in tools/perf/tests/shell/stat_bpf_counters.sh line 52 (bash arrays, ${name[0|*|@]}):
		base_instructions=$(perf stat --no-big-num -e instructions:u -- "${workload[@]}" 2>&1 | \
					awk -v i=0 -v c=0 '/instructions/ { \
						if ($1 != "<not") { i++; c += $1 } \
					} END { if (i > 0) printf "%.0f", c; else print "<not" }')
	possible bashism in tools/perf/tests/shell/stat_bpf_counters.sh line 57 (bash arrays, ${name[0|*|@]}):
		bpf_instructions=$(perf stat --no-big-num --bpf-counters -e instructions:u \
					-- "${workload[@]}"  2>&1 | \
					awk -v i=0 -v c=0 '/instructions/ { \
						if ($1 != "<not") { i++; c += $1 } \
					} END { if (i > 0) printf "%.0f", c; else print "<not" }')
	possible bashism in tools/perf/tests/shell/stat_bpf_counters.sh line 68 (bash arrays, ${name[0|*|@]}):
		stat_output=$(perf stat --no-big-num \
			-e instructions/name=base_instructions/u,instructions/name=bpf_instructions/bu \
			-- "${workload[@]}" 2>&1)

Change shebang for the stat_bpf_counters.sh script.

No upstream commit exists for this change as for versions post 6.17-rc1
the scripts were converted to #!/bin/bash already.

Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # perf stat --bpf-counters test
 # SPDX-License-Identifier: GPL-2.0
 


