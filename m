Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E85E2BB1B;
	Fri, 15 Nov 2024 06:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653844; cv=none; b=CeOR4DDMCRC5FPJ0t1BB6yLtFHZgNVLpt6iry0hqSNK6ZzULkCnKWEpqm2wc8MtfqH13HEVSlvlceAS41aTcFbG0mTSt/XLeXCV20/pVbrwlXFh6lBuClTc4CNjEl7JEVmviZKRehbVvW6zXJWPrnQBlktHNPijlD+seWIu7NuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653844; c=relaxed/simple;
	bh=hNSwvdI3GQevt28ntCCnCr0MF2uSm+DSonau+cMToGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLlREQ0iBOvT8NSimAOv2GJTGwG1G8YoX0s/w3JcUIpFGmC4wDt/mqtcGnB/fKhyn/MfMTiQBUg5Hak81ObuZLLiwcpYTIdMx7Xz5jgPEdjuZf+VmGCgFUdSrrzwPmF4/NkFWyMSzEBwTY9b8VksiqctbYX42yK1VeUDsw9okVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iL4rtzs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iL4rtzs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4636C4CECF;
	Fri, 15 Nov 2024 06:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653843;
	bh=hNSwvdI3GQevt28ntCCnCr0MF2uSm+DSonau+cMToGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL4rtzs9FnaSNL65IdQW/CHzj1rkK5VamNy6Iz8vNxYiXTogu55zSZln+HDR00llf
	 18COkcxf9JQf++FZWQiBTqMdMisbqGS41czP6EUWAKlxqHUL0IWDk/rFATBUHaSx8R
	 UXrqSXq2Ghtin1ki2SzrF+OG3WgaLu5pmg3cHnlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	German Gomez <german.gomez@arm.com>,
	James Clark <james.clark@arm.com>,
	Nick Terrell <terrelln@fb.com>,
	Sean Christopherson <seanjc@google.com>,
	Changbin Du <changbin.du@huawei.com>,
	liuwenyu <liuwenyu7@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Song Liu <song@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Liam Howlett <liam.howlett@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>
Subject: [PATCH 5.10 51/82] Revert "perf hist: Add missing puts to hist__account_cycles"
Date: Fri, 15 Nov 2024 07:38:28 +0100
Message-ID: <20241115063727.397985268@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

Revert "perf hist: Add missing puts to hist__account_cycles"

This reverts commit a83fc293acd5c5050a4828eced4a71d2b2fffdd3.

On x86 platform, kernel v5.10.228, perf-report command aborts due to "free():
invalid pointer" when perf-record command is run with taken branch stack
sampling enabled. This regression can be reproduced with the following steps:

	- sudo perf record -b
	- sudo perf report

The root cause is that bi[i].to.ms.maps does not always point to thread->maps,
which is a buffer dynamically allocated by maps_new(). Instead, it may point to
&machine->kmaps, while kmaps is not a pointer but a variable. The original
upstream commit c1149037f65b ("perf hist: Add missing puts to
hist__account_cycles") worked well because machine->kmaps had been refactored to
a pointer by the previous commit 1a97cee604dc ("perf maps: Use a pointer for
kmaps").

To this end, just revert commit a83fc293acd5c5050a4828eced4a71d2b2fffdd3.

It is worth noting that the memory leak issue, which the reverted patch intended
to fix, has been solved by commit cf96b8e45a9b ("perf session: Add missing
evlist__delete when deleting a session"). The root cause is that the evlist is
not being deleted on exit in perf-report, perf-script, and perf-data.
Consequently, the reference count of the thread increased by thread__get() in
hist_entry__init() is not decremented in hist_entry__delete(). As a result,
thread->maps is not properly freed.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: James Clark <james.clark@arm.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: liuwenyu <liuwenyu7@huawei.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org # 5.10.228
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/hist.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -2624,6 +2624,8 @@ void hist__account_cycles(struct branch_
 
 	/* If we have branch cycles always annotate them. */
 	if (bs && bs->nr && entries[0].flags.cycles) {
+		int i;
+
 		bi = sample__resolve_bstack(sample, al);
 		if (bi) {
 			struct addr_map_symbol *prev = NULL;
@@ -2638,7 +2640,7 @@ void hist__account_cycles(struct branch_
 			 * Note that perf stores branches reversed from
 			 * program order!
 			 */
-			for (int i = bs->nr - 1; i >= 0; i--) {
+			for (i = bs->nr - 1; i >= 0; i--) {
 				addr_map_symbol__account_cycles(&bi[i].from,
 					nonany_branch_mode ? NULL : prev,
 					bi[i].flags.cycles);
@@ -2647,12 +2649,6 @@ void hist__account_cycles(struct branch_
 				if (total_cycles)
 					*total_cycles += bi[i].flags.cycles;
 			}
-			for (unsigned int i = 0; i < bs->nr; i++) {
-				map__put(bi[i].to.ms.map);
-				maps__put(bi[i].to.ms.maps);
-				map__put(bi[i].from.ms.map);
-				maps__put(bi[i].from.ms.maps);
-			}
 			free(bi);
 		}
 	}


