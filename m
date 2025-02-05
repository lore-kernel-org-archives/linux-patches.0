Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC66A14A088;
	Wed,  5 Feb 2025 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764557; cv=none; b=TnuWU2vOIgBoR/QIZxzuXRYkAOmzHN3I3IUB99/Dq64YWYMSOVUWBFk0+tHRgdxpGIfePkD4LqOoJaPS47ZQ6l7L//RMC1uqZaM+j2YSk6VKzMvqRbhGHonVuldB6lCmF0W47r0AsFtrwBzlzgvKloBHP12PhhR5gtCKKroMOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764557; c=relaxed/simple;
	bh=mPizTqHmOy3r10QBf4yw1OvzH8N3I4Cwg5ftg7sJhvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLf2IQEqBz0XtWG2rIOLXljL1jWHvAJ4a94O1A07dbOX7smeDGEzGiHu+l78TYvUI9clM6sdyPs0mNn7khJ/bXr98+1skofr1f8ZdU8npUyuEwkWr6WGunb7hQxbQXKAnaGOI0bgWai6OWZJt8c417bH+j2bJcjmxXjqEFC2lJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lg+TJns+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lg+TJns+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF320C4CEDD;
	Wed,  5 Feb 2025 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764557;
	bh=mPizTqHmOy3r10QBf4yw1OvzH8N3I4Cwg5ftg7sJhvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lg+TJns+7JjluQkwTkUZlsL3Wg8CS2MYglgjRk8iRB5hjXqngt8fmDXwZswMK+kvz
	 IlVF13g7nEDgjl5pwSwzzU+dqCZbMiy9UIwjScLEMWRKYKVl0RbZsosroOm1YVPold
	 T1OxS1ltS0Ye5X4abGa9VaNqLO+3dYCgiLCD1M8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Jiachen Zhang <me@jcix.top>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/393] perf report: Fix misleading help message about --demangle
Date: Wed,  5 Feb 2025 14:41:41 +0100
Message-ID: <20250205134427.263254803@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiachen Zhang <me@jcix.top>

[ Upstream commit ac0ac75189a4d6a29a2765a7adbb62bc6cc650c7 ]

The wrong help message may mislead users. This commit fixes it.

Fixes: 328ccdace8855289 ("perf report: Add --no-demangle option")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiachen Zhang <me@jcix.top>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250109152220.1869581-1-me@jcix.top
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cd2f3f1a75633..54b06db597862 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1352,7 +1352,7 @@ int cmd_report(int argc, const char **argv)
 	OPT_STRING(0, "addr2line", &addr2line_path, "path",
 		   "addr2line binary to use for line numbers"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
-		    "Disable symbol demangling"),
+		    "Symbol demangling. Enabled by default, use --no-demangle to disable."),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
-- 
2.39.5



