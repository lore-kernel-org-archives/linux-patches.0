Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27C6198E85;
	Thu,  6 Jun 2024 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683471; cv=none; b=J3JjuzhhDO0Zg0VDC+x5VaAyTjFonAW4f3Vd6F9+OPTErIcE4jNuMVASPZcfRgh9yfqF0NT29ReSUWIyy7tnai3hr68XdYygJYF2qN64G2DMFuqf2Iw5U1xIFxnNWt8xrUtT/vgPZ2iRHP9q748+Y5HRi95SfCs3wsB5MaNKQlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683471; c=relaxed/simple;
	bh=C7CDtVi1b7b/lubj0MF4DPIyFgk9dObnl4sLKDT5i1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6rEuoEwdc6fKEQ1NLl7whfRs+LDl9ou08IVUvGyLnYnuh/a6IqwNZIpIHuI9FkPraHNMLkFJrx3m5Px1X7aATJaqIR1w3Nsh0jy/38QGGcj6sxghJdA/HI1x9DFjb464KQmgDJtD1US9MrQZFmejg0EI++/nnw8k1O79sBAmyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiIXTNM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiIXTNM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAEEC2BD10;
	Thu,  6 Jun 2024 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683470;
	bh=C7CDtVi1b7b/lubj0MF4DPIyFgk9dObnl4sLKDT5i1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiIXTNM8U0QQtUt1rw/lxCOSN/C36enzGsCNWNOD2z+Fhi/jupoEkQ2vdkdWLJOZQ
	 0Ni1qjWOQqhCgA/GRZ2J7J1IiVJCwj/IMi7wKVlA4Ka5hFMoK2JDkPXYmQs7R9YjKn
	 KX2gNLUVeviY+2g6Xvk42gh4BfzkH9MpkMbf62uE=
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
Subject: [PATCH 6.1 339/473] perf ui browser: Avoid SEGV on title
Date: Thu,  6 Jun 2024 16:04:28 +0200
Message-ID: <20240606131711.113854997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d09b4cbec6e06..5d6f4f25c33d0 100644
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



