Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1F923392B;
	Sat, 30 May 2026 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164318; cv=none; b=VJVjDKNOQ3T/uBlVJt+5neRC7SDeG1LBIjCfC1bkXjcjN+u3al5y5eSLRzV2G45OJgNdr7Eh4sjutSlRa/q8QkpLdH7dOBMGRp8jJV/yK3YOHcPs+/OOQACjSCtWgowWul1qBpYGap+3uSD2JOpvqoEMUmUjqrQWChLu6nK/DKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164318; c=relaxed/simple;
	bh=KUQBwcGgSge74wFTvwBZKOWVSquxrJfWCDj8YbxfVUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN1sus0xqUzKmeyeQ9ABJL/02v8qrwew5XAnh6K0zAVIwrKhDoQU2PMT+/IGeAYv+qImH8wd/SarWp0dRMvSWQUhijaHket8e1ZLtxP4B59BuI2dgJNYCCnbGumekAx6J+kvmnUpTfZScR440f8zlIX1t3qs4W7DwH5ellnKQ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTb3A4f5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTb3A4f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45E81F00898;
	Sat, 30 May 2026 18:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164317;
	bh=E//6u3KnRZk1BkTQiI1e2R72cPx8vgGVmzQQMCqsfSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTb3A4f5dr0Ms5DzMLq2YC1ZAPUQi8GnqM1IHtX+mGbLYpc/yn+WLsZNhSIklkc6U
	 WqT3s0BUB9bJvqSNMQWmpNTKs6DMukOm8damrcPxwCm4F6sJpfSOO19MFwMZMH2Ku/
	 i3s6bZulSdKkKmrwpCFYUjRbLFKCK4CxbZNL2PNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 518/776] perf util: Kill die() prototype, dead for a long time
Date: Sat, 30 May 2026 18:03:52 +0200
Message-ID: <20260530160253.629268159@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f0d36ba77f2d..130c68dff4ce0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -14,7 +14,6 @@
 
 /* General helper functions */
 void usage(const char *err) __noreturn;
-void die(const char *err, ...) __noreturn __printf(1, 2);
 
 struct dirent;
 struct strlist;
-- 
2.53.0



