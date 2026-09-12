Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72087416842;
	Sat, 12 Sep 2026 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228969; cv=none; b=i54e/dDjPYnJ8EZaIKI8iKyNddd8BvA31144Ktuq9dwOmxv1QeInuNG8wD0aQWtIH7J+MBVdb1WPZBEKHrer+uGOnLvzLktNgW/tl0BnBgSbLVYIg4JbnPlVSszJnAxoaJuLJv0tqmcWytnXn3PNCeNhQDtnWMBprgxPWYwsGgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228969; c=relaxed/simple;
	bh=8SYgCkczK+fn8Bes2sCUTaSqr1UdctoG/dUEs1NWVsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO1O1EYyTuOKbqsZPIac5zbp3AYzgwJYRmNhS5SLIjlK1BzarPn4rjEK/PQDtbAzk25DTvy3njObtaU2GWtZTYVV3jsIH0c6N26vyJykBqAMWalnR0QoApEnFD7JJBofKCJ8S2UdrUR//BVoslVTeUS+J/gatq1Csty1aMP1La4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhzmuwkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhzmuwkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297271F000FF;
	Sat, 12 Sep 2026 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228968;
	bh=lTCdta7tqo18hZwWAZEXcR+HjTit0+vU2+AYaLl5MMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhzmuwkjcR4Cn1VGp0NG1Iq762w0jhbauMQ2ioj6k7vfHjaP+Y29MNV2q7w5nR4TY
	 7dulHslt6JTshFGE7CsDPWNvstl65P0xfgEOmNYhmLnUYgXEvVXMFwDejA0ZG65eqr
	 HRNQXecsSV5uDbUpWAQqC9GkGvMpMsBspOgrsyFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0493/1191] perf tests stat_bpf_counters: Fix usage of == to address shellcheck warning
Date: Sat, 12 Sep 2026 08:53:41 +0200
Message-ID: <20260912065559.304319358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit d10eedd87bb3e7678c3a0f77a5cfe7150a318ee2 ]

Running shellcheck on stat_bpf_counter.sh generates below
warning:

   In tests/shell/stat_bpf_counters.sh line 34:
   if [ "$base_cycles" == "<not" ]; then
                       ^-- SC3014 (warning): In POSIX sh, == in place of = is undefined.

   In tests/shell/stat_bpf_counters.sh line 39:
   if [ "$bpf_cycles" == "<not" ]; then
                      ^-- SC3014 (warning): In POSIX sh, == in place of = is undefined.

Fix this by using "=" instead of "==" to work for
all shells.

Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230709182800.53002-10-atrajeev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: b02027776ac5 ("perf tests: Fix flakiness in BPF counters test on hybrid systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index 6bf24b85294c7..a87bb2814b4c6 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -31,12 +31,12 @@ if ! perf stat -e cycles --bpf-counters true > /dev/null 2>&1; then
 fi
 
 base_cycles=$(perf stat --no-big-num -e cycles -- perf bench sched messaging -g 1 -l 100 -t 2>&1 | awk '/cycles/ {print $1}')
-if [ "$base_cycles" == "<not" ]; then
+if [ "$base_cycles" = "<not" ]; then
 	echo "Skipping: cycles event not counted"
 	exit 2
 fi
 bpf_cycles=$(perf stat --no-big-num --bpf-counters -e cycles -- perf bench sched messaging -g 1 -l 100 -t 2>&1 | awk '/cycles/ {print $1}')
-if [ "$bpf_cycles" == "<not" ]; then
+if [ "$bpf_cycles" = "<not" ]; then
 	echo "Failed: cycles not counted with --bpf-counters"
 	exit 1
 fi
-- 
2.53.0



