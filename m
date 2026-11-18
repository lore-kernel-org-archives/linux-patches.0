Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020799;
	b=4kiSser16wLhUlU3qKRyKYgNSqBbZrtxN1byeFdH1cz+dFlJb6VUF4Y6pnnwk4Bfd3p9
	 slU1pbPIfDyOceM+OxLcq4AqDNlDvzL+gHbOH1zQjQkRU4Jom/kLj91bZFSHwWLZb7QHA
	 Tkbyoi0Jx6IO2ukh6yo1aLQxkVeq4tvZRrYESXnc1YDa6PKJj68dx1RkXj8fqrgslK8aL
	 p9cuFsT7m/1NXUklfFuGVX+Wsl7y5/RC6gYpUoMBGgV5agJB/97n/CYeMFJj3CmQkxQmL
	 7GuLU2ELhkAHoX+2RSyRPZ+a2SQlvmN+DO1TWECObWj0hzPvx5MCAHxtZPspdnf6DCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=USXndKyYgs7DN0ukRKxbMejZ9zgFZvme5H5G2qVz7dk=;
	b=tQ9djncMc+B07lG8DGrX68hu9luQmRlZqjWWSs0UcDLvegLkP3MAo/J2jCS0KY1Y4nyD
	 ALbYCha+Q/uVZOh3pD9WFZmLk/yIjUW3GRYWnuF4BQ6khXyx5sYijQY/YZ9N+bJIFRR47
	 OC/tL2Jw1ooigHc6m3oV7CO4zgGsrMeINV+v1fkIA1X1wmz4ewjUc7J4jUeXMmr0EG1s/
	 vKAOBTu3J3vxrlNr5kLIi2jdX3kZ8fiGQfO3VCLKHfixYAwRFDzrlLPfksvov3FXCT1K0
	 hoa+/yV7ST9nNFzz+OieniK9wge1gdXOScIFp2zrWAtkwqgbcqWNpwSOtkZjiDoS4UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUdQGg1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0CA606B5B1;
	Wed, 18 Nov 2026 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUdQGg1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E481F000C5;
	Wed, 18 Nov 2026 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020799;
	bh=USXndKyYgs7DN0ukRKxbMejZ9zgFZvme5H5G2qVz7dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUdQGg1uDtkPAUnE9rGlEgFyambKlxj7DEg6hH6sp6iThLSk8BqvYNBKRNbgOyAtt
	 3/I2Vuz81Ud6OxzBqYfTosqvp1lQUn/UxqPVW1MhBcParj/Iy6/KfniQCl6eEVNqUv
	 Y4a3TXYWcudUpgSjN9LYfI3hCbNCeL9F/G/xEMaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2080/2651] perf test attr: Fix legacy event encodings in group tests
Date: Wed, 18 Nov 2026 15:55:20 +0100
Message-ID: <20261118150400.915143455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 599311bca66459fc4a7e5acf970b14dee60f88a7 ]

Since commit b1c5efbfd92e ("perf parse-events: Remove hard coded legacy
hardware and cache parsing"), event names are resolved with sysfs/JSON
priority over the legacy encodings, so bare cache-misses and
instructions now become the core PMU sysfs/JSON events (on x86 type 4,
configs 0x412e and 0xc0) rather than the legacy
PERF_TYPE_HARDWARE/config=3 and config=1 events the tests expect, e.g.:

  expected config=3, got 0
  expected disabled=0, got 1
  expected mmap=0, got 1
  expected comm=0, got 1
  expected freq=0, got 1
  expected enable_on_exec=0, got 1
  expected task=0, got 1
  FAILED '.../test-record-group-sampling1' - match failure

The shown diff is against the cycles group leader, as no result event
matches the expected cache-misses member anymore.

Request the legacy encodings explicitly with the legacy-hardware-config
term, added in commit 0012e0fa221bf9cc ("perf jevents: Add
legacy-hardware and legacy-cache json"), keeping the original
attribute expectations unchanged, in:

  test-record-group1
  test-record-group2
  test-record-group3
  test-record-group-sampling
  test-record-group-sampling1
  test-record-group-sampling2
  test-stat-group1

This went unnoticed until tests/attr.sh stopped ignoring attr.py's
return value.

Fixes: b1c5efbfd92eb84d ("perf parse-events: Remove hard coded legacy hardware and cache parsing")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/attr/README                     | 10 +++++-----
 tools/perf/tests/shell/attr/test-record-group-sampling |  4 ++--
 .../perf/tests/shell/attr/test-record-group-sampling1  |  4 ++--
 .../perf/tests/shell/attr/test-record-group-sampling2  |  4 ++--
 tools/perf/tests/shell/attr/test-record-group1         |  2 +-
 tools/perf/tests/shell/attr/test-record-group2         |  2 +-
 tools/perf/tests/shell/attr/test-record-group3         |  2 +-
 tools/perf/tests/shell/attr/test-stat-group1           |  2 +-
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/tests/shell/attr/README b/tools/perf/tests/shell/attr/README
index 67c4ca76b85d5..c7b49cdf87297 100644
--- a/tools/perf/tests/shell/attr/README
+++ b/tools/perf/tests/shell/attr/README
@@ -49,10 +49,10 @@ Following tests are defined (with perf commands):
   perf record --call-graph dwarf kill		(test-record-graph-dwarf)
   perf record --call-graph fp kill              (test-record-graph-fp)
   perf record --call-graph fp kill              (test-record-graph-fp-aarch64)
-  perf record -e '{cycles,instructions}' kill   (test-record-group1)
-  perf record -e '{cycles/period=1/,instructions/period=2/}:S' kill (test-record-group2)
-  perf record -e '{cycles,cache-misses}:S' kill (test-record-group-sampling1)
-  perf record -c 10000 -e '{cycles,cache-misses}:S' kill (test-record-group-sampling2)
+  perf record -e '{cycles,default_core/legacy-hardware-config=1/}' kill (test-record-group1)
+  perf record -e '{cycles/period=1234000/,default_core/legacy-hardware-config=1,period=6789000/}:S' kill (test-record-group2)
+  perf record -e '{cycles,default_core/legacy-hardware-config=3/}:S' kill (test-record-group-sampling1)
+  perf record -c 10000 -e '{cycles,default_core/legacy-hardware-config=3/}:S' kill (test-record-group-sampling2)
   perf record -D kill                           (test-record-no-delay)
   perf record -i kill                           (test-record-no-inherit)
   perf record -n kill                           (test-record-no-samples)
@@ -67,5 +67,5 @@ Following tests are defined (with perf commands):
   perf stat -d kill                             (test-stat-detailed-1)
   perf stat -dd kill                            (test-stat-detailed-2)
   perf stat -ddd kill                           (test-stat-detailed-3)
-  perf stat -e '{cycles,instructions}' kill     (test-stat-group1)
+  perf stat -e '{cycles,default_core/legacy-hardware-config=1/}' kill (test-stat-group1)
   perf stat -i -e cycles kill                   (test-stat-no-inherit)
diff --git a/tools/perf/tests/shell/attr/test-record-group-sampling b/tools/perf/tests/shell/attr/test-record-group-sampling
index 86a940d7895d7..766aadef2f1f9 100644
--- a/tools/perf/tests/shell/attr/test-record-group-sampling
+++ b/tools/perf/tests/shell/attr/test-record-group-sampling
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = --no-bpf-event -e '{cycles,cache-misses}:S' kill >/dev/null 2>&1
+args    = --no-bpf-event -e '{cycles,default_core/legacy-hardware-config=3/}:S' kill >/dev/null 2>&1
 ret     = 1
 kernel_until = 6.12
 
@@ -15,7 +15,7 @@ inherit=0
 fd=2
 group_fd=1
 
-# cache-misses
+# cache-misses, explicitly requested with the legacy hardware encoding
 type=0
 config=3
 
diff --git a/tools/perf/tests/shell/attr/test-record-group-sampling1 b/tools/perf/tests/shell/attr/test-record-group-sampling1
index 4748ab7bf6843..5be9a1a2a4ff0 100644
--- a/tools/perf/tests/shell/attr/test-record-group-sampling1
+++ b/tools/perf/tests/shell/attr/test-record-group-sampling1
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = --no-bpf-event -e '{cycles,cache-misses}:S' kill >/dev/null 2>&1
+args    = --no-bpf-event -e '{cycles,default_core/legacy-hardware-config=3/}:S' kill >/dev/null 2>&1
 ret     = 1
 kernel_since = 6.12
 
@@ -30,7 +30,7 @@ inherit=1
 fd=2
 group_fd=1
 
-# cache-misses
+# cache-misses, explicitly requested with the legacy hardware encoding
 type=0
 config=3
 
diff --git a/tools/perf/tests/shell/attr/test-record-group-sampling2 b/tools/perf/tests/shell/attr/test-record-group-sampling2
index e0432244a0eb7..c05225167ec34 100644
--- a/tools/perf/tests/shell/attr/test-record-group-sampling2
+++ b/tools/perf/tests/shell/attr/test-record-group-sampling2
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = --no-bpf-event -c 10000 -e '{cycles,cache-misses}:S' kill >/dev/null 2>&1
+args    = --no-bpf-event -c 10000 -e '{cycles,default_core/legacy-hardware-config=3/}:S' kill >/dev/null 2>&1
 ret     = 1
 kernel_since = 6.12
 
@@ -36,7 +36,7 @@ write_backward=0
 fd=2
 group_fd=1
 
-# cache-misses
+# cache-misses, explicitly requested with the legacy hardware encoding
 type=0
 config=3
 
diff --git a/tools/perf/tests/shell/attr/test-record-group1 b/tools/perf/tests/shell/attr/test-record-group1
index eeb1db392bc9c..0437ea4939e88 100644
--- a/tools/perf/tests/shell/attr/test-record-group1
+++ b/tools/perf/tests/shell/attr/test-record-group1
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = --no-bpf-event -e '{cycles,instructions}' kill >/dev/null 2>&1
+args    = --no-bpf-event -e '{cycles,default_core/legacy-hardware-config=1/}' kill >/dev/null 2>&1
 ret     = 1
 
 [event-1:base-record]
diff --git a/tools/perf/tests/shell/attr/test-record-group2 b/tools/perf/tests/shell/attr/test-record-group2
index 891d41a7bddf7..ca5bbf441968f 100644
--- a/tools/perf/tests/shell/attr/test-record-group2
+++ b/tools/perf/tests/shell/attr/test-record-group2
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = --no-bpf-event -e '{cycles/period=1234000/,instructions/period=6789000/}:S' kill >/dev/null 2>&1
+args    = --no-bpf-event -e '{cycles/period=1234000/,default_core/legacy-hardware-config=1,period=6789000/}:S' kill >/dev/null 2>&1
 ret     = 1
 kernel_until = 6.12
 
diff --git a/tools/perf/tests/shell/attr/test-record-group3 b/tools/perf/tests/shell/attr/test-record-group3
index 249be884959ea..8191b3af936de 100644
--- a/tools/perf/tests/shell/attr/test-record-group3
+++ b/tools/perf/tests/shell/attr/test-record-group3
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = --no-bpf-event -e '{cycles/period=1234000/,instructions/period=6789000/}:S' kill >/dev/null 2>&1
+args    = --no-bpf-event -e '{cycles/period=1234000/,default_core/legacy-hardware-config=1,period=6789000/}:S' kill >/dev/null 2>&1
 ret     = 1
 kernel_since = 6.12
 
diff --git a/tools/perf/tests/shell/attr/test-stat-group1 b/tools/perf/tests/shell/attr/test-stat-group1
index 1746751123dcb..fa2ca74e4cf29 100644
--- a/tools/perf/tests/shell/attr/test-stat-group1
+++ b/tools/perf/tests/shell/attr/test-stat-group1
@@ -1,6 +1,6 @@
 [config]
 command = stat
-args    = -e '{cycles,instructions}' kill >/dev/null 2>&1
+args    = -e '{cycles,default_core/legacy-hardware-config=1/}' kill >/dev/null 2>&1
 ret     = 1
 
 [event-1:base-stat]
-- 
2.53.0



