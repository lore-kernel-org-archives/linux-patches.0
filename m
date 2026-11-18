Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017230;
	b=SUu2LEgIvX9c68JM2nM/GfTdLeAQwVh2NKh2HF5s1ngXY/pD1iztkNC6fViWTQ0iFGkx
	 JUv5EfF9JMuyaFPgV5sLSW2sxOqr3Xn7auwdSZJGTBs/SjQoWyzJIEnAAA8huZz7DzY4v
	 hEVtbd3lZgM4pKShXuWyNWOaYqVEdvWnNv0DIXIz1ii8ZcMw8n23h7tFFJBbEVvyLt2Uo
	 o1Jvv6axzMJTojgfTiZiJHgJMd2U1QeZFOrADBe3Ki5CmgotaUA1DycjA/aU4fqQwV5u9
	 4GJv7EwdjvWTERrNQ4OQSNKVY4SlvmX/EHqj/jS1gIohQ6/hP6I+Pxx7wRUnQhU6JSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sCSVhurw5zkony5O3qm1vI+DeGr6KFVnu74RF0YXSAs=;
	b=qpvsx8aEW6Hu2WJIRo3WpZFBDcqnVWIflaaKDRMtu0b6fHpOpcO2tbwKAb6jGss6QTAF
	 Z0ZbbMNUzZBIKDByo68nxVUD4JGtVEnBazP7PtygLNV5wHaObsYYescl3hjmIayUyxXyF
	 rWcXzEGyUHBruFFRb7w4VQzxRadTxMHp+S9aM1KgJfCNI9R4Ev05QAhi+6aBufqHMdSHT
	 cfeJDwTqtExtyBUBzwQvp9uzgL/LgyZiRdNLAJJHL95CxZ+Wqp2BDn8VoGSR0mnWkNMnx
	 8vKBIZ8huWJ5O/tP/nOwCXfE5jNOknZqH462QBCEPWFCAcDeYLQZYTgEvy5567K7u2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6ZeeJ01;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F09B606A32A;
	Wed, 18 Nov 2026 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6ZeeJ01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6512F1F000C4;
	Wed, 18 Nov 2026 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017229;
	bh=sCSVhurw5zkony5O3qm1vI+DeGr6KFVnu74RF0YXSAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6ZeeJ01aSSuKsHySEATugO1QPskoRejjOuPdG3SuNDI9OGcX4Cr2u+jK7lmupx70
	 aJXBXODn82pWiPgmUCKyyJZUKv+x5XJDFmI2cTeAFBBFGjfqcN/oOosltHD8RYDmmb
	 UHaCjbbFqAPeGrUDO+ADIG99sDGMEUEN0051eQZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Jens Remus <jremus@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0809/2651] perf evsel: Improve callchain warning for s390
Date: Wed, 18 Nov 2026 15:34:09 +0100
Message-ID: <20261118150317.020538350@linuxfoundation.org>
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

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit 1eb782d60d9926f0e3c3131c568c3ea0fa69d0fb ]

On s390 the kernel uses s390 back chain instead of frame pointers for
stack tracing of user space since v6.7 commit aa44433ac4ee ("s390: add
USER_STACKTRACE support").  This is because frame pointers on s390
cannot be used for stack tracing. [1]

This requires user space to maintain a s390 back chain.  For instance
user space to be built with compiler option '-mbackchain' (instead of
'-fno-omit-frame-pointer' used on other architectures, which should
better not be used on s390 [1]).  Only few distributions and users build
user space with '-mbackchain'.  Therefore '--call-graph fp' may in
practice not produce the expected results.

Commit ca76fb67ebdd ("perf evlist: Improve default event for s390")
changed the default '-g' option to 'dwarf' on s390 and added a warning
for s390 that wrongly claimed that "Framepointer unwinding lacks kernel
support".  This warning resulted from a misinterpretation of comments
in s390 cpumsf_pmu_event_init().

The restriction in cpumsf_pmu_event_init() applies to callchain sampling
with the s390 CPU Measurement Sampling Facility (CPUMSF) hardware PMU.
CPUMSF events, such as 'cycles', do not support callchain sampling.
This is independent of whether perf uses the 'fp' or 'dwarf' call-graph
mode.  The CPUMSF PMU provides samples collected asynchronously, making
it impossible to associate a callchain to the historic IPs.  Therefore
callchains can only be used with software events on s390.

Remove the incorrect warning.  The kernel supports the 'fp' call-graph
mode on s390 by walking the back chain.  Do not replace it with a
hint to use 'dwarf' when the resulting callchain is incomplete.  Such a
suggestion could imply that 'fp' is inherently inferior.  The same
general limitation exists on other architectures when user space is not
built with frame pointers (i.e. '-fno-omit-frame-pointers').

Instead, warn on s390 when callchain sampling is requested with an event
provided by the CPUMCF or CPUMSF hardware PMUs, because that combination
is not supported.

Update the perf record documentation to state that 'dwarf' is the
default call-graph mode on s390 and that 'fp' uses back chain instead
of frame pointers on s390.

Note that '--call-graph fp' may also be useful for other applications,
such as OpenJDK maintaining a s390 back chain (does not require JVM
option '-XX:+PreserveFramePointer' on s390):

  $ perf record --call-graph fp ... -- \
    java -XX:+UnlockDiagnosticVMOptions -XX:+DumpPerfMapAtExit ...

[1]: s390: Stack tracing using Frame Pointer, Back Chain, and SFrame,
     https://conf.gnu-tools-cauldron.org/opo25/talk/Y3CVHY/

Fixes: ca76fb67ebdd5e1a ("perf evlist: Improve default event for s390")
Reviewed-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-record.txt | 7 ++++++-
 tools/perf/util/evsel.c                  | 6 +++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 178f483140ed9..dc72606cb25d4 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -293,7 +293,7 @@ OPTIONS
 
 --call-graph::
 	Setup and enable call-graph (stack chain/backtrace) recording,
-	implies -g.  Default is "fp" (for user space).
+	implies -g.  Default is "fp" for user space (s390 uses "dwarf").
 
 	The unwinding method used for kernel space is dependent on the
 	unwinder used by the active kernel configuration, i.e
@@ -329,6 +329,11 @@ OPTIONS
 	enable deferred user callchain which will collect user-space callchains
 	when the thread returns to the user space.
 
+	On s390, the "fp" method uses back chain instead of frame pointers,
+	which requires user space to maintain a back chain (e.g. compiler
+	option -mbackchain).  Without a maintained back chain this produces
+	bogus call graphs.  In that case use "dwarf" instead.
+
 -q::
 --quiet::
 	Don't print any warnings or messages, useful for scripting.
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 94fcf532cee42..41e69d6904cdb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1092,9 +1092,9 @@ static void __evsel__config_callchain(struct evsel *evsel, const struct record_o
 	bool function = evsel__is_function_event(evsel);
 	struct perf_event_attr *attr = &evsel->core.attr;
 
-	if (EM_HOST == EM_S390 && param->record_mode == CALLCHAIN_FP) {
-		pr_warning_once(
-			"Framepointer unwinding lacks kernel support. Use '--call-graph dwarf'\n");
+	if (EM_HOST == EM_S390 && evsel->pmu && !perf_pmu__is_software(evsel->pmu)) {
+		pr_warning_once("Cannot use hardware PMU 'cpum_cf' / 'cpum_sf' event with callchain. "
+				"Use a software 'cpu-clock' / 'task-clock' event.\n");
 	}
 
 	evsel__set_sample_bit(evsel, CALLCHAIN);
-- 
2.53.0



