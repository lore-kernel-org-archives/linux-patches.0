Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30BA2EE264;
	Tue, 17 Jun 2025 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177169; cv=none; b=cJt9iQwykUwMfgwBflE3Dq2Yvq6Ol03JkT6J3s57Nh4z7Fbt8sB4KrOgt0cJ4i4XRsnNAVIVStHEOMInV3NFOLUeLdGu22KYL71nyz0B+iY/6No9xCY+IcKQMWaLIgV5VuU+APudC4VEqrpE3Kq09XN6bAeV9hd752u8GWm7S4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177169; c=relaxed/simple;
	bh=9rAn1cX6998rGRWvKBFlgYzypZk1rM/dQwZUvLTe0Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eq+P2P4s/J8njebUx2iItupJeuG5sD97PKJlaDuTKCNeZOBcw8BmXaVjJnuq0LLDRXkrBdhywO4YbhpqXcpClZgsptJOK31algKi2ITU633NutAn+ilftKTVWttpqrYpJUtb5K02KB+aueEDWwdwVP3SeUgE1/LgZyKYFf9NGBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q80/PS7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q80/PS7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B380AC4CEE3;
	Tue, 17 Jun 2025 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177169;
	bh=9rAn1cX6998rGRWvKBFlgYzypZk1rM/dQwZUvLTe0Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q80/PS7t9XSD+xitcHeTGOBIFwCJ2eKLxk4uWXzfAy0d1fwhW5KOnyjD99/KNyV9u
	 5VGAaEl7jxFy8pLe6iBEJ5jFTdeUd6zeqtywhbxxOmiB3yJGmC5yTvfJY3u7F54vzX
	 jauou6vSlJv8rvYFE+JetmyEJySg6GcqaB4PoTPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Ben Gainey <ben.gainey@arm.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Graham Woodward <graham.woodward@arm.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	=?UTF-8?q?Krzysztof=20=C5=81opatowski?= <krzysztof.m.lopatowski@gmail.com>,
	Leo Yan <leo.yan@linux.dev>,
	Levi Yun <yeoreum.yun@arm.com>,
	Li Huafei <lihuafei1@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	=?UTF-8?q?Martin=20Li=C5=A1ka?= <martin.liska@hey.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Song Liu <song@kernel.org>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Steve Clevenger <scclevenger@os.amperecomputing.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yujie Liu <yujie.liu@intel.com>,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Zixian Cai <fzczx123@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/512] perf callchain: Always populate the addr_location map when adding IP
Date: Tue, 17 Jun 2025 17:24:29 +0200
Message-ID: <20250617152431.878284150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit a913ef6fd883c05bd6538ed21ee1e773f0d750b7 ]

Dropping symbols also meant the callchain maps wasn't populated, but
the callchain map is needed to find the DSO.

Plumb the symbols option better, falling back to thread__find_map()
rather than thread__find_symbol() when symbols are disabled.

Fixes: 02b2705017d2e5ad ("perf callchain: Allow symbols to be optional when resolving a callchain")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Ben Gainey <ben.gainey@arm.com>
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Graham Woodward <graham.woodward@arm.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Krzysztof Łopatowski <krzysztof.m.lopatowski@gmail.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Levi Yun <yeoreum.yun@arm.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin Liška <martin.liska@hey.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Song Liu <song@kernel.org>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Steve Clevenger <scclevenger@os.amperecomputing.com>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Cc: Veronika Molnarova <vmolnaro@redhat.com>
Cc: Weilin Wang <weilin.wang@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yujie Liu <yujie.liu@intel.com>
Cc: Zhongqiu Han <quic_zhonhan@quicinc.com>
Cc: Zixian Cai <fzczx123@gmail.com>
Link: https://lore.kernel.org/r/20250529044000.759937-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 6 ++++--
 tools/perf/util/thread.c  | 8 ++++++--
 tools/perf/util/thread.h  | 2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 9be2f4479f525..20fd742984e3c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1974,7 +1974,7 @@ static void ip__resolve_ams(struct thread *thread,
 	 * Thus, we have to try consecutively until we find a match
 	 * or else, the symbol is unknown
 	 */
-	thread__find_cpumode_addr_location(thread, ip, &al);
+	thread__find_cpumode_addr_location(thread, ip, /*symbols=*/true, &al);
 
 	ams->addr = ip;
 	ams->al_addr = al.addr;
@@ -2076,7 +2076,7 @@ static int add_callchain_ip(struct thread *thread,
 	al.sym = NULL;
 	al.srcline = NULL;
 	if (!cpumode) {
-		thread__find_cpumode_addr_location(thread, ip, &al);
+		thread__find_cpumode_addr_location(thread, ip, symbols, &al);
 	} else {
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
@@ -2104,6 +2104,8 @@ static int add_callchain_ip(struct thread *thread,
 		}
 		if (symbols)
 			thread__find_symbol(thread, *cpumode, ip, &al);
+		else
+			thread__find_map(thread, *cpumode, ip, &al);
 	}
 
 	if (al.sym != NULL) {
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 0ffdd52d86d70..309d573eac9a9 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -406,7 +406,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp, bo
 }
 
 void thread__find_cpumode_addr_location(struct thread *thread, u64 addr,
-					struct addr_location *al)
+					bool symbols, struct addr_location *al)
 {
 	size_t i;
 	const u8 cpumodes[] = {
@@ -417,7 +417,11 @@ void thread__find_cpumode_addr_location(struct thread *thread, u64 addr,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(cpumodes); i++) {
-		thread__find_symbol(thread, cpumodes[i], addr, al);
+		if (symbols)
+			thread__find_symbol(thread, cpumodes[i], addr, al);
+		else
+			thread__find_map(thread, cpumodes[i], addr, al);
+
 		if (al->map)
 			break;
 	}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 6cbf6eb2812e0..1fb32e7d62a4d 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -122,7 +122,7 @@ struct symbol *thread__find_symbol_fb(struct thread *thread, u8 cpumode,
 				      u64 addr, struct addr_location *al);
 
 void thread__find_cpumode_addr_location(struct thread *thread, u64 addr,
-					struct addr_location *al);
+					bool symbols, struct addr_location *al);
 
 int thread__memcpy(struct thread *thread, struct machine *machine,
 		   void *buf, u64 ip, int len, bool *is64bit);
-- 
2.39.5



