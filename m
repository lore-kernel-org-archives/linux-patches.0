Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E556247F3C6;
	Sat, 12 Sep 2026 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238205; cv=none; b=gYykD1WWkSLkRseQxFRZFNq2EmGmx6bugwXK3I8PKoaMq3SJAeqY26V1wfBwC8vZIdOiUFyfu6y33a33J/N3mw4iVG6Dl6vgt9M3zvOv7NYNBk4gPZ/TfCDC+TXorv2FSaZ9UqVy0nMhtfm+mLdZeb39VOQd2LZUVxn6zGiF61k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238205; c=relaxed/simple;
	bh=W14+PoQNY/9fbIbM04iHIi0T2ey3VN+8RBRIZHsQebk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVD/4EJi41pwlhBUvZHsyuGX9bQNmdPrm2/9q0s1UikRWFpVz8dqA4TI76lG5sk/JuEoRTGKyHX7beNf/nZb2nkkDtqSjqnNqjnbb+JRiKooh56Bi6kCyFUgYN8FmPCKob5fU9r0znVd22obichWnYoxdrm/cg3kw8FQzDK8cxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtMkhcjB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtMkhcjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24011F000FF;
	Sat, 12 Sep 2026 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238203;
	bh=iejkqyzbVlmMHi77zsN8XyyqvQVmT9k74+Bf1WSDee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtMkhcjBKMeqPP+hbL40sZuUWxmQbZO0VdS0EIgM9RVgh+KHbDuvlUpATeiBt9zVr
	 N/W3f9A1J7NfuAEw1Sg0zRuVuCBQRCXCaUVcsR3g5ci40bdOg9xULkQ4sYGj9pPABU
	 4ZerJC4vmdguxR/p7rtCezEtjThZa789JcEaFXdA=
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
Subject: [PATCH 5.15 415/935] perf tests stat_bpf_counters: Fix usage of == to address shellcheck warning
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065536.341381366@linuxfoundation.org>
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



