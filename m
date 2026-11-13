Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590700;
	b=IT9BLJltCQijQ9wxi1TUNeGlztndGS8XpvYNigp28oQWDF8+V/1WqAV7XI7DAzsglq/L
	 vHg4XuYOjHMcQ0lQJBbJs5UiF+EQmmsnwkQ9InHOfnbYR6+3XXfsX89BAUVvLbScSpPpX
	 FOb4KH+5Vxg0qimnASw7qD+sTPVXnZLdFos2szBq/iWMhr+mmCfbQSD+V+ZLtRM3vmbO1
	 EBuI+/KVxdMcbBIPTCjTfmp8rin9Dp6pWTjlB1jvs0ytl6nKg53zjwegOzREw0xyO0GNn
	 5a07Qu2uaMzmTmQURbe5c1g0w5IY9JiMgFpeXdPzhEIiaQGG7iN2WYy1IuU8J3VrGiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JhSgDqOW9KXQSJuLIo+X1JGl4GMeQGFxJ6Ese9ewU/Y=;
	b=LW6sbBJVJw2i9oYAG+00dHWDcdAF2ujNAyCzWNZedXNs9NvkcAMcsomB+HxJK7ib1/KD
	 sbR97jcCIzMZdYwxS714YgPMW1YnpsZJiFCWOPuCH9mRj544qkVqFBXrG99wFk052yRFG
	 6kll3PLaLn/Lmp357N+cx16QBC3/v85AOiRfPSF+6bZKfWaBfbiAr9UTcQgVFGD/9kPvx
	 QKF8SZf/4OgMFU+2mvANVT8njYbe9DbZPhdKfCbPrOwE4+bMQo+6kRDJRcPPow/KSzWwi
	 rv74JgixQVCPaiutZEeAv6ObwS1LzJ1WIFHzyjCpPDgUrabec33eI30r7sN5rzta5Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDqCXMJp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E882606B22B;
	Fri, 13 Nov 2026 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDqCXMJp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5481F000C6;
	Fri, 13 Nov 2026 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590700;
	bh=JhSgDqOW9KXQSJuLIo+X1JGl4GMeQGFxJ6Ese9ewU/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDqCXMJpUU/pPkDk2cSZA+YBPaK8OxtnkS0icnt68/MBx6UE1TkPAc/n8N4FrPH5P
	 WOAEABtY83T1cOEVS/xaCOckLlN/kvYYf+4uEM3djVreUZb4DJDa65VfJzf6kk8UZB
	 eun3/5ruwWdUhYH/Vjm4uy4rJEGHHHqMn+PmKRH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 611/686] perf evsel: Close the fds opened so far when disabling missing features
Date: Fri, 13 Nov 2026 10:52:24 -0500
Message-ID: <20261113153842.596417864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 16d1234793d42a5a594db99522845996ab8e0d29 ]

evsel__open_cpu() opens the events one by one and, when an open fails
with EINVAL and evsel__detect_missing_features() has a feature to leave
out, goes back to fallback_missing_features to open them all again from
start_cpu_map_idx, without closing what the abandoned attempt opened:
the fd of every CPU or thread that was opened before the failing one is
overwritten in the FD() array, leaking it.

Close them first, the same way out_close does when returning an error,
leaving the entries at -1 for the retry.

Fixes: af954f76eea5 ("perf tools: Check fallback error and order")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/sashiko-outbox-173532@kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4fa7cbc51047c..654e9bbd66f98 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2642,6 +2642,19 @@ static bool evsel__detect_missing_features(struct evsel *evsel, struct perf_cpu
 	return false;
 }
 
+static void evsel__close_fds(struct evsel *evsel, int start_cpu_map_idx,
+			     int cpu_map_idx, int thread, int nthreads)
+{
+	do {
+		while (--thread >= 0) {
+			if (FD(evsel, cpu_map_idx, thread) >= 0)
+				close(FD(evsel, cpu_map_idx, thread));
+			FD(evsel, cpu_map_idx, thread) = -1;
+		}
+		thread = nthreads;
+	} while (--cpu_map_idx >= start_cpu_map_idx);
+}
+
 static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 		struct perf_thread_map *threads,
 		int start_cpu_map_idx, int end_cpu_map_idx)
@@ -2792,8 +2805,14 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 	if (err == -EMFILE && rlimit__increase_nofile(&set_rlimit))
 		goto retry_open;
 
-	if (err == -EINVAL && evsel__detect_missing_features(evsel, cpu))
+	if (err == -EINVAL && evsel__detect_missing_features(evsel, cpu)) {
+		/*
+		 * The restart opens the events again, so close what this
+		 * attempt opened before its entries are overwritten.
+		 */
+		evsel__close_fds(evsel, start_cpu_map_idx, idx, thread, nthreads);
 		goto fallback_missing_features;
+	}
 
 	if (evsel__precise_ip_fallback(evsel))
 		goto retry_open;
@@ -2803,14 +2822,7 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 		threads->err_thread = thread;
 
 	old_errno = errno;
-	do {
-		while (--thread >= 0) {
-			if (FD(evsel, idx, thread) >= 0)
-				close(FD(evsel, idx, thread));
-			FD(evsel, idx, thread) = -1;
-		}
-		thread = nthreads;
-	} while (--idx >= start_cpu_map_idx);
+	evsel__close_fds(evsel, start_cpu_map_idx, idx, thread, nthreads);
 	errno = old_errno;
 out:
 	if (err)
-- 
2.53.0



