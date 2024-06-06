Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6F41A01C7;
	Thu,  6 Jun 2024 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683635; cv=none; b=Lde0hJv18S8A7+V0JLTpNcSA4sXfUTSACETj3PPXcgDe1+mLcKrj6eSqrSe/ZCTkVIUERXFaM18PLB2g3FzTxYapyP/Q2Rzh4RQ8MVnSe/4CUiWI6/mVSNfsdO0gd1IpyOPoOb4faPbsS2UbIIuAoMnbi6UnaTpwXtEvECilTdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683635; c=relaxed/simple;
	bh=R/elOJObMfkaE8lleEP8vxVwUa4BolI3zKJWIZ1HHD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CochtY2Ge7NZlPVmDwVoIMpK7aP2ehiye2i8mdJCTAYbQq6hoLa7iqPQGGjADdQqr0MxndWmcZmOoXhKDEIPfWPaAG/O3UyE59xdIx3rfpL5L4FNwMbBrF7Oo18tepXmts7nZ1XmcvZWujFQJA3HDf5Lb8qSd491Yd9LHtSApMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDmTirj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDmTirj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02933C32781;
	Thu,  6 Jun 2024 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683635;
	bh=R/elOJObMfkaE8lleEP8vxVwUa4BolI3zKJWIZ1HHD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDmTirj06V1+K1o2wi/4DNADxfeqdX4m0dcEHgzGSZzOr3+FKhqJxbBTbdTek2I+/
	 ORHBdzVP6yTLh+N978uZucyazvWjPjRCJ0+p8/2f5F4VaM4ePJgwP4z1wtc9ofCcp5
	 v8R+umpJXuKIS2TP6MtRMkKiqtikcZPsbZLayv48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/744] perf ui browser: Avoid SEGV on title
Date: Thu,  6 Jun 2024 16:02:59 +0200
Message-ID: <20240606131748.711749825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 90f01afb0dfafbc9b094bb61e61a4ac297d9d0d2 ]

If the title is NULL then it can lead to a SEGV.

Fixes: 769e6a1e15bdbbaf ("perf ui browser: Don't save pointer to stack memory")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240508035301.1554434-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index c4cdf2ea69b72..19503e8387385 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -203,7 +203,7 @@ void ui_browser__refresh_dimensions(struct ui_browser *browser)
 void ui_browser__handle_resize(struct ui_browser *browser)
 {
 	ui__refresh_dimensions(false);
-	ui_browser__show(browser, browser->title, ui_helpline__current);
+	ui_browser__show(browser, browser->title ?: "", ui_helpline__current);
 	ui_browser__refresh(browser);
 }
 
-- 
2.43.0



