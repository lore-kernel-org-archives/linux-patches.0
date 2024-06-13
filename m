Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4535413C69C;
	Thu, 13 Jun 2024 12:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281228; cv=none; b=GiynkfSbm9WicIuNTBdOmBkHWpcjt2yzJLo7Dm4R+nNaAYrDdaBvd3YEs0CPfp1C/UPndueH5ktSOI0TOEQh8vnklkEKYVtqBoPVlfUt6Qi38J0PUI2ll+XPjS5Ph2HZvQ5RLf7V+naPS3b2HDWVWLC0np4/TYm7p3mN6lkTkf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281228; c=relaxed/simple;
	bh=m3tvPW+ID9jA/f0oO4ASTacpjSkI08eBBL/R0b/9KIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtSRGfTG6fq5Y1qXYmcmRdEGCv6iGrwOLCbxGA9nuPDxANw8nmyqNaFyxS7EhAAayjPSUCxyMx/PWfswiWxhJEKT6KzG/yG9/G5b4itzCGB3Pl9a3xpyJSEke8gXa867zhEBTen3Gq0b8wvY/GJiE7o2alqSPUkBqMsfKQdrbfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwgN1YMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwgN1YMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB61C2BBFC;
	Thu, 13 Jun 2024 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281228;
	bh=m3tvPW+ID9jA/f0oO4ASTacpjSkI08eBBL/R0b/9KIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwgN1YMUAP3+zas4hgpcn6IZhYHLt7muBGgictPk6mHfUPqQodpyTPOqpG8d6Cqta
	 iIV3KuxDEZ6CqG0unxO0uOI6xqvFCTM0HwieFMZk+yGk8CVz0mOuUstw7HOOFPAds2
	 6i+KPfiyaB7iebV7bLCZBadsV6wC/jLg0ogtwILY=
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
Subject: [PATCH 5.10 183/317] perf ui browser: Avoid SEGV on title
Date: Thu, 13 Jun 2024 13:33:21 +0200
Message-ID: <20240613113254.639846046@linuxfoundation.org>
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
index 6fa4f123d5ff7..b84b87b939573 100644
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



