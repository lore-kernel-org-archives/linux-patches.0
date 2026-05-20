Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD8134DB46;
	Wed, 20 May 2026 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300979; cv=none; b=g534lRZHT563NrnzEom/QIpwlE41bo56vwGtWx2wHqmGSEdHcFwBUQjPp0sHLleL+NtS9SbuKnnDf/d3hTUsza2/UR6Ac6DhJJqSU5vpjPtDlORBPA56B4G98xMjEx5k7iz3AUwFqBq59QipCbWI5wTQ6lUk53pumQLJEqzwzsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300979; c=relaxed/simple;
	bh=Yzi2jtPze8XxRnhhxBnW0eT8kdF8hJCFn5flar6/l+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpI65zqx33VAmBf9B2UIozbuLEM2jumm4bb4pp86AX1d1To1pDz6gNj0zvsJZ4v/bW/t0SBu3/WtkhTzmhX9+QAIhOAI6W3g+QMKLyfqS5K8hpba0pcmRflx/JOgO2cnGZxhC1QEfWSgtZCECEcQj66DByy34uCdMmHPBQRX1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GptmOz70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GptmOz70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2871F00893;
	Wed, 20 May 2026 18:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300977;
	bh=VhGIPw19TBKVAMNBwI8v6c9WpGlYIUE0o/B6YBV0p6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GptmOz70w0JmOHwJEgraifUbqpJGvP1pa47DmamzLe0z5Ey0h7pG3P8Kam1/1tnzk
	 /oGEzGBZNy9j9ElvLlg9/KuwH5CafyIR2zm2knEQRUicFXZOE+TYmB8bRyWMgkm8wt
	 4OAGYCb9g9JtP85BoLojM3ITLwYNdTcs4on2ZtXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/666] perf util: Kill die() prototype, dead for a long time
Date: Wed, 20 May 2026 18:19:50 +0200
Message-ID: <20260520162119.465893855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e5cce1b9c82fbd48e2f1f7a25a9fad8ee228176f ]

In fef2a735167a827a ("perf tools: Kill die()") the die() function was
removed, but not the prototype in util.h, now when building with
LIBPERL=1, during a 'make -C tools/perf build-test' routine test, it is
failing as perl likes die() calls and then this clashes with this
remnant, remove it.

Fixes: fef2a735167a827a ("perf tools: Kill die()")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/util.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 9966c21aaf048..bc30d038817db 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -26,7 +26,6 @@ extern bool perf_guest;
 
 /* General helper functions */
 void usage(const char *err) __noreturn;
-void die(const char *err, ...) __noreturn __printf(1, 2);
 
 struct dirent;
 struct strlist;
-- 
2.53.0



