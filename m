Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016469;
	b=q0o/j303Y3qmfuJXtrxkDl9igHWtiYCOf4a069bPvvWP5jF0Q7q5FlrDSUSRfzxrclnB
	 IA3siHBFAaJgDJJqIpNoKXCcl+qSESmBr9GU43C8xOqr0nxnNj5hNiKI21FTxl8Ucn52P
	 1g3kIi0CplnSkiI1WjgXK/nt/qbyjix+db2/28G3zS0MUPnLG3lZ0lUVjlLV2HxnzXSQy
	 EKx7Ttpa9ehmAB+UIoytO+P52sgv2jUwGFFZfvbU5pXLedclZSWDW52+6x3D5ElC++Oea
	 FArN8z+cMYbMNqaIVAlSJNmgXKich1f0GdZC723MRsks5x+aMVoHrKDsimEFfTs9q0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kjjIKdau81ZQyNKA46RlcEqAfetn1UE7bnofxXyUKlI=;
	b=pAy1uLWzWMr+PGV3e8DgDJJTVneLDBIXgPKXknLqDxNrS6IohOWc5s5MM3uZQdH0/PaC
	 zJ2rJHqGYcXzVn/8iwPZJni6W/0OOU8kGl/dv2741cP/zG9HD+p8Pj9YVQuXm9O6ySKcV
	 jIzj8dzO+KXDBaod5SqYRYUOZJoecGnk3uhtB/Wdc/VPk+8JqGHzeLpyzGd9safaB8jy7
	 oJfopbk+1LXr2xH8PikxHuudwtteK+24i1xVhDfAq50p9zu2WMWndbg9jXztFjP3IwA3f
	 XuqnsfZKhz4785sjDngexV33QuGXZOH4Oln2FHJDvpHPvgfhLTJ6rTxyxOdfydcOJSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/fiWsKS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B09606A320;
	Wed, 18 Nov 2026 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/fiWsKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E071F000C4;
	Wed, 18 Nov 2026 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016469;
	bh=kjjIKdau81ZQyNKA46RlcEqAfetn1UE7bnofxXyUKlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/fiWsKS/vSM25Y3MYSMUwra2GtlhQ2NDxN053xL87lrR7RpCuzp9m/8JuFbgZW6v
	 lEKmJsuyMLV2u439XMLYjY+liKCFyIEp+jAJNc4+n+1XzFR+GCzjTa7fHMW4GlkoKk
	 xZSo0jTiE2Z8K4IswAtPaOlPwey0OXP63yeyb5mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0540/2651] perf record: Fix unhandled POLLHUP on non_perf_event descriptors
Date: Wed, 18 Nov 2026 15:29:40 +0100
Message-ID: <20261118150307.194789335@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 3cbb16ccd7d8c7377058195b48c721e99ee158aa ]

When processing POLLHUP on a non_perf_event control descriptor,
evlist__finalize_ctlfd() is invoked to finalize the setup, correctly
setting the core evlist's poll array file descriptor to -1. However,
this finalized teardown state is never propagated back to the
individual thread's local replica of the pollfd array.

Consequently, on the next iteration of the main recording loop,
record__update_evlist_pollfd_from_thread() performs a strict
equivalence check between the core evlist's array and the thread's
localized poll array, detecting that the fd values no longer match.
This causes an immediate -EINVAL abort and a premature teardown.

Fix the underlying logic within
record__update_evlist_pollfd_from_thread() to sustainably propagate
the finalized teardown statuses (-1) originating from the core evlist
back to the thread's localized poll structure. This correctly
maintains synchronization and entirely prevents the unhandled
index mismatch crashes.

Additionally, add a unit test that explicitly validates that
fdarray__filter() preserves its invariants regarding
fdarray_flag__nonfilterable items to guard against regressions.

Fixes: fb4751e79c45cb48 ("perf record: Fix teardown hang on system-wide multi-threaded sessions")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Gemini:gemini-3.1-pro
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c    |  4 ++++
 tools/perf/builtin-record.c | 15 +++++++++++++++
 tools/perf/tests/fdarray.c  | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index 67b73481df27e..3200746d16578 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -116,6 +116,10 @@ int fdarray__filter(struct fdarray *fda, short revents,
 		return 0;
 
 	for (fd = 0; fd < fda->nr; ++fd) {
+		/*
+		 * Explicitly bypass nonfilterable items (e.g. control descriptors).
+		 * This ensures their fd, events, and revents remain completely untouched.
+		 */
 		if (fda->priv[fd].flags & fdarray_flag__nonfilterable)
 			continue;
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a57987851cf03..ad81458989b53 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1169,6 +1169,21 @@ static int record__update_evlist_pollfd_from_thread(struct record *rec,
 		int e_pos = rec->index_map[i].evlist_pollfd_index;
 		int t_pos = rec->index_map[i].thread_pollfd_index;
 
+		if (e_entries[e_pos].fd == -1 || e_entries[e_pos].events == 0) {
+			/*
+			 * If the control file descriptor was closed, then evlist__ctlfd_process()
+			 * will have called evlist__finalize_ctlfd() on the PREVIOUS loop iteration
+			 * to cleanly set the core evlist's e_entries[e_pos].fd to -1.
+			 *
+			 * Since nonfilterable items are skipped by fdarray__filter(), the
+			 * thread's local t_entries[t_pos] retains its original state.
+			 * We must explicitly propagate the finalized -1 state to t_entries
+			 * BEFORE evaluating the strict equivalence check below.
+			 */
+			t_entries[t_pos].fd = -1;
+			t_entries[t_pos].events = 0;
+		}
+
 		if (e_entries[e_pos].fd != t_entries[t_pos].fd ||
 		    e_entries[e_pos].events != t_entries[t_pos].events) {
 			pr_err("Thread and evlist pollfd index mismatch\n");
diff --git a/tools/perf/tests/fdarray.c b/tools/perf/tests/fdarray.c
index 40983c3574b12..23860edb8ef09 100644
--- a/tools/perf/tests/fdarray.c
+++ b/tools/perf/tests/fdarray.c
@@ -80,6 +80,38 @@ static int test__fdarray__filter(struct test_suite *test __maybe_unused, int sub
 		goto out_delete;
 	}
 
+	fdarray__init_revents(fda, POLLHUP);
+	fda->priv[2].flags = fdarray_flag__nonfilterable;
+
+	pr_debug("\nfiltering all but fda->entries[2] (nonfilterable):");
+	fdarray__fprintf_prefix(fda, "before", stderr);
+
+	/*
+	 * Note: fdarray__filter() in tools/lib/api/fd/array.c evaluates the
+	 * fdarray_flag__nonfilterable flag at the very top of its loop via an
+	 * early continue. Therefore, it completely skips all processing for this
+	 * descriptor, guaranteeing its fd, events, and revents fields remain
+	 * entirely untouched by the filter mask evaluation below it.
+	 */
+	nr_fds = fdarray__filter(fda, POLLHUP, NULL, NULL);
+	fdarray__fprintf_prefix(fda, " after", stderr);
+
+	if (nr_fds != 0) {
+		pr_debug("\nfdarray__filter()=%d != 0, should be 0\n",
+			 nr_fds);
+		goto out_delete;
+	}
+	if (fda->entries[2].fd == -1) {
+		pr_debug("\nfdarray__filter() illegally modified nonfilterable fd!");
+		goto out_delete;
+	}
+	if (fda->entries[2].revents != POLLHUP) {
+		pr_debug("\nfdarray__filter() illegally modified nonfilterable revents!");
+		goto out_delete;
+	}
+
+	fda->priv[2].flags = 0; /* reset flags */
+
 	pr_debug("\n");
 
 	err = 0;
-- 
2.53.0



