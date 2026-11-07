Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064968;
	b=s4R9KmYNuR68h9AtSKdSf+t6DUpTgmzkpWXk74gHhCaKbwYi0IwfBNPkJTShzDTG6t/a
	 rfh/aciUfSjsH+jJyDyG1rGbtqImWuXmHBjcY2A/1zY96BFsZ9rsmuO+H1ACkGyeH76hQ
	 M41NhbjgedYI0DzMR8YnMEo13UjORbN1Z+YWx/2S3b8CsbDkGjTayEvrM31vW/CEbSiP7
	 /VKh+6Q5tKF9GJ+tjJ315IdvAtja6eeU/rMco6EY+nGhQlfA9R6E6ConOcDnsZBrkddcU
	 pNiFIzquUHG1b/gIXJHDr9edncMlIVqz+3faSjfnE7GNcXQ+Z05O/Ao1XQVP4eCBh/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ssrlz/79x+0bz6+7ORbKkiTsOt+c0Yv63oJ2eeFAQ/U=;
	b=mEPHwB/TXbUa9FkZM2ZL3HfxzzS10Dvu9AKunLgDM4Lu0eG7uyqry1rWwUlUTLE+7RY6
	 DMzweJ+hQ4qTna5DhFYaHBwsyQfwDIn5bMgk6IgRED03+0ii6tDkLgZ9Gfsahs9XlUI+t
	 wQRsa+fzr3odJ93LmPX15o7yLHhHuO0l13yBNoRE5Gtopi6TASVZan/KPI+OqKAwIE0/X
	 zETrfjVhAa4vubPhzYK9OqUL15ChV79e6SOpbnKypRapwGkV6lR4ZKv/1zy9L8Z1Q9mYs
	 SlfSCVBSFu89ibwb//D9yX4zZtU0sW0N47j8GetjrbrIQPJ294kWewH+fAmzh/7DSpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4W0Zqyz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C9C606A334;
	Sat,  7 Nov 2026 15:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4W0Zqyz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BE01F008A1;
	Sat,  7 Nov 2026 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064967;
	bh=ssrlz/79x+0bz6+7ORbKkiTsOt+c0Yv63oJ2eeFAQ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4W0ZqyzBpOjp7mJY9+65PQPb2cDUJCPD6qQ/4Z0ddVZ1a3jkumtd6yYj1dGVo97D
	 HZLvFa4+FthhBOMSqOkyqCVv0UfiL+Y4Q3Iz9kv192v/BAUakXW4fpYvKsvGEkIDQs
	 ArdPcM09QIpVPgiihEOFOjAdfkxbPx6qyY6UvxBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0850/1257] perf python: Free the parse error entries when parsing fails
Date: Sat,  7 Nov 2026 08:52:26 -0500
Message-ID: <20261107135002.803408185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 39e0022c89abcdc1a811dfc0aeec2a2b9010b660 ]

pyrf__parse_events() prints the entries parse_events_error__print()
receives with the details of a failed parse, but returns without freeing
them, leaking whatever parse_events_error__handle() allocated, so call
parse_events_error__exit() on both paths, as the other parse_events()
callers do.

The perf test attr core PMU probe takes this failure path on machines
without a core PMU, where the leak then happens on every test run.

Fixes: f081defccd93 ("perf python: Add parse_events function")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/sashiko-outbox-173525@kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index d8a842621cda0..c504b83be39fb 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -3469,10 +3469,12 @@ static PyObject *pyrf__parse_events(PyObject *self, PyObject *args)
 	perf_evlist__set_maps(evlist__core(evlist), cpus, threads);
 	if (parse_events(evlist, input, &err)) {
 		parse_events_error__print(&err, input);
+		parse_events_error__exit(&err);
 		PyErr_SetFromErrno(PyExc_OSError);
 		evlist__put(evlist);
 		return NULL;
 	}
+	parse_events_error__exit(&err);
 	result = pyrf_evlist__from_evlist(evlist);
 	evlist__put(evlist);
 	return result;
-- 
2.53.0



