Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D8E51EE03;
	Wed, 30 Sep 2026 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789662; cv=none; b=YHS/ht7lcYZztM+gKJ5wQWp6kfR4ROK17ZcOWprEoaL4ZIsiM6cPvjIIfurnVtQXX8DgopCWdwEutbTk6Evye7WNRPypYFkQotXYkg+KEdm85XsjopamrTymP2ZZHQTdwcVbOOtzIXtmiY5/eGgjkKo9yVA3cvKG4JhnaJ37OHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789662; c=relaxed/simple;
	bh=9bITjkeG0YiaKnOVD3TgBCffMnH616n1LJRfmgHeoLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGqXBUELrdZLVFPJN9iLYpPmLxwRoBq3UyuODjBMmMn7X7Eo2JfDefUNgw1QdpY60O1xNSk96pFhMvW/tI7Ts0uRFgMjpeb2x3Xgo1tgSmfUHtThvuPP4OMeidqg1kxkbDG9kRaYx0C02W7kgsjCzt30mr1WLLJ+hpRrM0mlr6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnhRnch1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnhRnch1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30711F00898;
	Wed, 30 Sep 2026 17:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789661;
	bh=ybm5Rf2lLRUfnVu+mPvgPdQ3xY9nXaAp/AbmysrC/Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnhRnch1fJ52/qAxS/5/QmwhdWO6c6K+YfKuN9kf5WRWpQIRYQ3Mio9+5iSk9EDVf
	 7ZHTXbQhvqi2pUlLepjbCwDF5Ga1VM7w9Q6kknAQxrqOkgvGU1WzK1upnc3Ao7Mq2Q
	 52dJ0qAMset953GMVGRVLtls62qmyWUsRsc6hpmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Collin Funk <collin.funk1@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.12 557/877] perf test: Change all remaining #!/bin/sh to #!/bin/bash
Date: Wed, 30 Sep 2026 17:24:28 +0200
Message-ID: <20260930152426.662854492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


