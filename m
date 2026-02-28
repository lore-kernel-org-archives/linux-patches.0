Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB3A373141;
	Sat, 28 Feb 2026 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301511; cv=none; b=drADyRNYEnIIfvQsQ4ELnhyDX1IivOZMsbor8l8dl8jwqxp0PoJRJ5r1+4lm8VQ3bK0oXx5LxgTa0xsNzvc9jHt7QnBC6doOpDHpH5Qlanui5anXutyOcFlgNC7U6XILUMBNOd6O6KHnrY3zXBorzhvIbSy1vaNObgxpK16hvVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301511; c=relaxed/simple;
	bh=G4eFtNv3Fsch3fZYKLdT73Hxi+luVylOgZvfXpQleOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AujUmNZboWVAVnBi1vsSWe9CwK9Z4xC2c4lgmapd5O8a8062t4XwLAc5yPk7yGnYRzAXGiVhXXGJt6Zxa4dMUzzxSbeKUjVoQyqTGOCcNx9eYisdu3GU5Mlh77WZUUz0a8+I7KJB7Y+/CFtBaITwsC6dXW/JhbkYfk/Cw1zVCzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHYkeb8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHYkeb8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00120C19423;
	Sat, 28 Feb 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301511;
	bh=G4eFtNv3Fsch3fZYKLdT73Hxi+luVylOgZvfXpQleOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHYkeb8k2htw2/kE5eorRxMH3u0Q1Vcn4WgvvxxMOUyKMgjPZfTCyFnYNZnw6kW8O
	 MC+3IYUScMtfPI1iu/4rV2pIWYDXcwqE1bOFi1Bvp7Fcy/liKsEtYKIzPOA7DjPQgK
	 vtuyz3qwumrFpsURJiWvZU0bHJgB2zu8SCpT9iBqosHNtP1TeSd2BYOwnQqY3jmlfM
	 si2F5F4GdV/pN1dea8mhAsUf9gUFT0gSNG0mk5lsjgJW4QAl4nO2t2Ths+T50DV6r8
	 M5o7j/8bFeVkgxIns7wFPYepZzvLJsOgm+f9vsD+9KE363ejnzboNlkpOt9spBNdhj
	 PmP33N8YQFOug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 697/752] tracing: Fix to set write permission to per-cpu buffer_size_kb
Date: Sat, 28 Feb 2026 12:46:48 -0500
Message-ID: <20260228174750.1542406-697-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit f844282deed7481cf2f813933229261e27306551 ]

Since the per-cpu buffer_size_kb file is writable for changing
per-cpu ring buffer size, the file should have the write access
permission.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/177071301597.2293046.11683339475076917920.stgit@mhiramat.tok.corp.google.com
Fixes: 21ccc9cd7211 ("tracing: Disable "other" permission bits in the tracefs files")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 907923d5f8bbb..e1d902464e080 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9183,7 +9183,7 @@ tracing_init_tracefs_percpu(struct trace_array *tr, long cpu)
 	trace_create_cpu_file("stats", TRACE_MODE_READ, d_cpu,
 				tr, cpu, &tracing_stats_fops);
 
-	trace_create_cpu_file("buffer_size_kb", TRACE_MODE_READ, d_cpu,
+	trace_create_cpu_file("buffer_size_kb", TRACE_MODE_WRITE, d_cpu,
 				tr, cpu, &tracing_entries_fops);
 
 	if (tr->range_addr_start)
-- 
2.51.0

