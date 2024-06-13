Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF84B3209;
	Thu, 13 Jun 2024 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281175; cv=none; b=ZotGnddr2dQfc8P9pwLL+hFwLxs0Q6qnN5B9xyH+2BrLQU5KyqKemLL4NSOzJn+qCxiTGCBGXz2a5+s3/sJK1EDM4B+SAaop2M5UeI63bd/sbdpZ7NI6inuTMC8+lza8x1L+CGKi3haOO1s5aHkP6YOMR1OjZOjwWPz319A1aOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281175; c=relaxed/simple;
	bh=44B+8EKN0l6mVrigcEK2fZrCyK+gNXS2/I6zH/K9HLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETsTE7o485Qghv82lBEZBocD/F5N8YUzqgkajdvJ/epkC5GkxgIUvud+NnIPZMY2MY5lDY76z5FXH3yEUR1R6TFWN5qQctEs/Z/MYzhHkJHMshL4ZmdxbXsDCvOGqv+kOfaAwiovIsvzsw16ErRBYOK2IgiwOC1+KDy5hRWvC0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nq2j4P4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nq2j4P4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617AAC2BBFC;
	Thu, 13 Jun 2024 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281174;
	bh=44B+8EKN0l6mVrigcEK2fZrCyK+gNXS2/I6zH/K9HLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nq2j4P4/pYJTWMMLQ+EJ2Nu9SQyQP6TN34AY011b6GnTP/4Wl5a1o3SAlpweMbDkE
	 JMQ1N3h5Onkl2VLsS0RtEnET16sYo5JDzCYCJ13HzxrPYjitfo++oNkAYGPwAxJkwr
	 SdbIBqaVR1I7BFox+Dc9IKVbfowPYJrvxiQRGAVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/317] perf evlist: Use the right prefix for struct evlist sideband thread methods
Date: Thu, 13 Jun 2024 13:32:33 +0200
Message-ID: <20240613113252.780904236@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 08c83997ca87f9e162563a59ea43eabadc9e4231 ]

perf_evlist__ is for 'struct perf_evlist' methods, in tools/lib/perf/,
go on completing this split.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 88ce0106a1f6 ("perf record: Delete session after stopping sideband thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c       |  4 ++--
 tools/perf/builtin-top.c          |  4 ++--
 tools/perf/util/bpf-event.c       |  2 +-
 tools/perf/util/evlist.h          | 11 ++++-------
 tools/perf/util/sideband_evlist.c |  8 ++++----
 5 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 167cd8d3b7a21..a7d9f00382d9f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1548,7 +1548,7 @@ static int record__setup_sb_evlist(struct record *rec)
 		}
 	}
 #endif
-	if (perf_evlist__start_sb_thread(rec->sb_evlist, &rec->opts.target)) {
+	if (evlist__start_sb_thread(rec->sb_evlist, &rec->opts.target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
 		opts->no_bpf_event = true;
 	}
@@ -2066,7 +2066,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	perf_session__delete(session);
 
 	if (!opts->no_bpf_event)
-		perf_evlist__stop_sb_thread(rec->sb_evlist);
+		evlist__stop_sb_thread(rec->sb_evlist);
 	return status;
 }
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ee30372f77133..2cf4791290263 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1763,7 +1763,7 @@ int cmd_top(int argc, const char **argv)
 	}
 #endif
 
-	if (perf_evlist__start_sb_thread(top.sb_evlist, target)) {
+	if (evlist__start_sb_thread(top.sb_evlist, target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
 		opts->no_bpf_event = true;
 	}
@@ -1771,7 +1771,7 @@ int cmd_top(int argc, const char **argv)
 	status = __cmd_top(&top);
 
 	if (!opts->no_bpf_event)
-		perf_evlist__stop_sb_thread(top.sb_evlist);
+		evlist__stop_sb_thread(top.sb_evlist);
 
 out_delete_evlist:
 	evlist__delete(top.evlist);
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index c50d2c7a264fe..fccc4bf20c74f 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -530,7 +530,7 @@ int evlist__add_bpf_sb_event(struct evlist *evlist, struct perf_env *env)
 	 */
 	attr.wakeup_watermark = 1;
 
-	return perf_evlist__add_sb_event(evlist, &attr, bpf_event__sb_cb, env);
+	return evlist__add_sb_event(evlist, &attr, bpf_event__sb_cb, env);
 }
 
 void __bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9298fce53ea31..8b00e9a7c0fe2 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -112,14 +112,11 @@ int __evlist__add_default_attrs(struct evlist *evlist,
 
 int evlist__add_dummy(struct evlist *evlist);
 
-int perf_evlist__add_sb_event(struct evlist *evlist,
-			      struct perf_event_attr *attr,
-			      evsel__sb_cb_t cb,
-			      void *data);
+int evlist__add_sb_event(struct evlist *evlist, struct perf_event_attr *attr,
+			 evsel__sb_cb_t cb, void *data);
 void evlist__set_cb(struct evlist *evlist, evsel__sb_cb_t cb, void *data);
-int perf_evlist__start_sb_thread(struct evlist *evlist,
-				 struct target *target);
-void perf_evlist__stop_sb_thread(struct evlist *evlist);
+int evlist__start_sb_thread(struct evlist *evlist, struct target *target);
+void evlist__stop_sb_thread(struct evlist *evlist);
 
 int evlist__add_newtp(struct evlist *evlist, const char *sys, const char *name, void *handler);
 
diff --git a/tools/perf/util/sideband_evlist.c b/tools/perf/util/sideband_evlist.c
index ded9ced027973..90ed016bb3489 100644
--- a/tools/perf/util/sideband_evlist.c
+++ b/tools/perf/util/sideband_evlist.c
@@ -12,8 +12,8 @@
 #include <sched.h>
 #include <stdbool.h>
 
-int perf_evlist__add_sb_event(struct evlist *evlist, struct perf_event_attr *attr,
-			      evsel__sb_cb_t cb, void *data)
+int evlist__add_sb_event(struct evlist *evlist, struct perf_event_attr *attr,
+			 evsel__sb_cb_t cb, void *data)
 {
 	struct evsel *evsel;
 
@@ -94,7 +94,7 @@ void evlist__set_cb(struct evlist *evlist, evsel__sb_cb_t cb, void *data)
       }
 }
 
-int perf_evlist__start_sb_thread(struct evlist *evlist, struct target *target)
+int evlist__start_sb_thread(struct evlist *evlist, struct target *target)
 {
 	struct evsel *counter;
 
@@ -138,7 +138,7 @@ int perf_evlist__start_sb_thread(struct evlist *evlist, struct target *target)
 	return -1;
 }
 
-void perf_evlist__stop_sb_thread(struct evlist *evlist)
+void evlist__stop_sb_thread(struct evlist *evlist)
 {
 	if (!evlist)
 		return;
-- 
2.43.0



