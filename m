Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61F83590C6;
	Fri,  9 Jan 2026 11:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959692; cv=none; b=eea1L0QTbbbwSCuYW/i3zhTtjoRnOTMwkG7si/h7uOUWhb4YBMNJzZEQ8Le54R4hYJ9USpIa4LaJgAcN52QKjFC4VaEBOgQ4AwiaHR7fR1j4gak5HsuHalTrP/w/6UO/K3WMQX5gcPj2xrWJLcYYDi0wiaPylr8BHw65x/QwIGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959692; c=relaxed/simple;
	bh=BG4A6O3F3h9GPzKALFWDo+rwL54nDKPmcf20D2AO8MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hwd+XgDNfxzinMlYsduQa/qzpe7FyDlAjRUd13kD0jKXbknutrmE7VuefSOtbbPG9zI461d0iAKTlHKixJb5zugMHvm+g2zRDlT/qMVACJ2fqxaRCzTvBz0TcQTusl2yFE5eAv+TxCPLinGeFgKCqSkj52ek98DFeqmfhziCm1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3dFTH/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3dFTH/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25725C4CEF1;
	Fri,  9 Jan 2026 11:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959692;
	bh=BG4A6O3F3h9GPzKALFWDo+rwL54nDKPmcf20D2AO8MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3dFTH/Y3XVY2QJ0zMhvfEJWMVSynVw+HnC2yAlCZI9UgrRom0wpBT1GkyL2cLEgi
	 NgR1rY6kY6pJt4KPJLuJ9U3o3w5xO10Y44Ah6LaP2F7s/0BsKS1F7i5GC1uNlKucQS
	 Jm72kmofx6b5B76uHXaIOXsckQpXOJrRgBSf/VY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Changbin Du <changbin.du@huawei.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	German Gomez <german.gomez@arm.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Li Dong <lidong@vivo.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Ming Wang <wangming01@loongson.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Nick Terrell <terrelln@fb.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Wenyu Liu <liuwenyu7@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/737] perf maps: Add maps__load_first()
Date: Fri,  9 Jan 2026 12:34:08 +0100
Message-ID: <20260109112138.104073876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit e77b0236cd0cd1572c6a9b25097b207eab799e74 ]

Avoid bpf_lock_contention_read touching the internal maps data structure
by adding a helper function. As access is done directly on the map in
maps, hold the read lock to stop it being removed.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Guilherme Amadio <amadio@gentoo.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Li Dong <lidong@vivo.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Ming Wang <wangming01@loongson.cn>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Wenyu Liu <liuwenyu7@huawei.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20231207011722.1220634-20-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 553d18c98a89 ("perf lock contention: Load kernel map before lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_lock_contention.c |  2 +-
 tools/perf/util/maps.c                | 13 +++++++++++++
 tools/perf/util/maps.h                |  2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_lock_contention.c b/tools/perf/util/bpf_lock_contention.c
index e7dddf0127bce..a73f39540a3d4 100644
--- a/tools/perf/util/bpf_lock_contention.c
+++ b/tools/perf/util/bpf_lock_contention.c
@@ -285,7 +285,7 @@ int lock_contention_read(struct lock_contention *con)
 	}
 
 	/* make sure it loads the kernel map */
-	map__load(maps__first(machine->kmaps)->map);
+	maps__load_first(machine->kmaps);
 
 	prev_key = NULL;
 	while (!bpf_map_get_next_key(fd, prev_key, &key)) {
diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 9a011aed4b754..9c7618b7d5e92 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -713,3 +713,16 @@ int maps__merge_in(struct maps *kmaps, struct map *new_map)
 	}
 	return err;
 }
+
+void maps__load_first(struct maps *maps)
+{
+	struct map_rb_node *first;
+
+	down_read(maps__lock(maps));
+
+	first = maps__first(maps);
+	if (first)
+		map__load(first->map);
+
+	up_read(maps__lock(maps));
+}
diff --git a/tools/perf/util/maps.h b/tools/perf/util/maps.h
index a689149be8c43..d9f65f9e6d092 100644
--- a/tools/perf/util/maps.h
+++ b/tools/perf/util/maps.h
@@ -145,4 +145,6 @@ void __maps__sort_by_name(struct maps *maps);
 
 void maps__fixup_end(struct maps *maps);
 
+void maps__load_first(struct maps *maps);
+
 #endif // __PERF_MAPS_H
-- 
2.51.0



