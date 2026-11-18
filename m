Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027221;
	b=nKmAznuu/oMTbFppyxo7NU66YAndcx+Q8ZTM7CdVxKiI3XUnmwIPLUrAipv7w2pi+ZFa
	 SHKrLtnlJF4ovGwA8RrTGpUErzeJ3xG6zSlh78kGZbwMhQAs+IINxUJQ5AHM9n61yT5Gf
	 o3cJr1SsePm4dbiXwl4UYsLi4R0XNd1uN7y3N6VZBa1rS1nLmsuZU/5+2+zKw8HlVJU64
	 x5ib/6sGdljhGGa57V1ndXWjDxZT3F5a5zrp7m2F7y3PNjapENmkylVDckb3KjSZ+k9oO
	 QRy4QEBMXKnGlXpQ7TytRKmaOOSc+hYMtEA9qd7NEfPOUnMfnp+AdkAhMP8PE0BldRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dYOC0qmnjR3ZHpIgCqCP7zPGLmDC/Bio8gu60ulxQDE=;
	b=FKtQi55fH77yCt6EKfhsR8ZSNCiVkoI+lMzNVNMXr8uuN7c9MqH5AfiUopdUbRFk8CXj
	 Pw0uEkDG4jEzO3aqGR8R+0kgWWUqba8sSXQ+sMoS6hUYrw/CBcVpq8CQY1gTpXuKMwaHe
	 9wYiPa+ronjPnm4ctFX+4ReWFCCsEtgyBTz+X7QVIxyADWg001tYyqsWgbxb0YlTcV6x4
	 7DW8jyyaYn3KZ24EN/9Rs5D46yCTmkXTdiJK5d5fwySQGRnEErtBVVxY0VQpZ5gLnf+YV
	 b9oC8Tp4lhD1eHHvqGZp9YdhqloQv07Rcf0gp3eVoaITRtN7tiCI74KxvYWoMEfbihg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnAHO21o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40D6606A335;
	Wed, 18 Nov 2026 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnAHO21o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1841F000C5;
	Wed, 18 Nov 2026 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027221;
	bh=dYOC0qmnjR3ZHpIgCqCP7zPGLmDC/Bio8gu60ulxQDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnAHO21o8++FEEAjRoCAUwoXXe1MpPkaVrIO0m+O8mu1w7MnSCOYhP84FckaTcduY
	 WPJXhBQ4MYCg1tRntZfDh/c5WzFfrLQJ8412rYVEOahOm3Rp38mZjcaa33kYRBUZs+
	 eGCgahCQKCnJfn7XGN+3CdeFo+Uvh/u+7yaWloE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1713/2151] perf evsel: Mark the event as supported when retrying an open
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150224.222536117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit cc956e0cd6a405fbc6ad3055cbbdb178562ef27d ]

Opening a group with perf record on a machine with perf_event_paranoid >
1 and no CAP_PERFMON fails the first perf_event_open() with EACCES, after
which evsel__open_cpu() clears evsel->supported; evsel__fallback() then
adds exclude_kernel and record__open() retries, and the retry succeeds
with supported left false.  get_group_fd() treats unsupported events as
ungroupable, so the retry opens the group members without their leader:

  sys_perf_event_open: pid 12345 cpu 0 group_fd -1
  FAILED '.../test-record-group-sampling1' - group failure

which fails the group subtests of "perf test 82", the Perf attribute
expectations test, when it is run as a regular user, while it passes as
root or with CAP_PERFMON, where the first open doesn't fail.

commit 2cc7aa995ce9 ("perf stat: Refactor retry/skip/fatal error handling")
dropped the pos->supported = true that record__open() did after a
successful open and moved the resets into the stat code only, while
saying "When an event is tried the supported is set to true again".  Do
that in evsel__open_cpu(), which every open entry point funnels through,
so that a retry describes its own try instead of the previous failure.

Fixes: 2cc7aa995ce9ecd8 ("perf stat: Refactor retry/skip/fatal error handling")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0da2c56745c10..11b74d56d0601 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2665,6 +2665,12 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 	enum rlimit_action set_rlimit = NO_CHANGE;
 	struct perf_cpu cpu;
 
+	/*
+	 * A failed attempt being retried after evsel__fallback() would
+	 * otherwise keep group members out of their group in get_group_fd().
+	 */
+	evsel->supported = true;
+
 	if (evsel__is_retire_lat(evsel)) {
 		err = evsel__tpebs_open(evsel);
 		goto out;
-- 
2.53.0



