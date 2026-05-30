Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6F39478D;
	Sat, 30 May 2026 18:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166483; cv=none; b=gQWbPT9LL265k1vf80CTMmglyBOYyMNwcuCbpIKbmjuvi9cyOW8BRV7Tcx+N9vBwm6IBRbpkfAuZNxWxmpvBT1S471PeV3y4BwgEvHN6m3fLAiWtQH3F6LFdhQpTi7WoiZ3vkxgzNzg6mSBtubYEDHE8ymhNRsiD/zyhltkKdJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166483; c=relaxed/simple;
	bh=eJeyJY6j9Mt626q90tAIyDhUe3CHzWix3HMjafvyi70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NH0QX8yzJ1DN7DpEMoF9g4kGmKFWTy2VXrkhGV5KiCCekSBagwzCibAD3TR2nWckyQ58uJdrkqRIDbVIERsd3sKzvc1hPcJEMjFnBzox5DICST3rIP+l7iTTYO9nbQzqJAwYgSFNzg9scF79LhB5i0kQe2bpRnO5X/GPhEKJ70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBvWQzN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBvWQzN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEA01F00893;
	Sat, 30 May 2026 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166481;
	bh=3xot3XrCsK9RNLrDIxGTjSyGQPTAYwWooqU5PaE/3Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBvWQzN/tyXP06fMDO/TLiVL/ozLA0f6HGU0PYqzwTf1NGv2FzUsT6orS79ZpZwX0
	 0kQypp22dF0xDt6pauzBL0hZ9tujwm4EW6z056Mdy8CLlJaGr6CeTxH/ryQkZyoiAE
	 cK8nxT7VtcJOvMdfcel7LjDPoW7SCjAfkZelf3Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/589] perf util: Kill die() prototype, dead for a long time
Date: Sat, 30 May 2026 18:04:26 +0200
Message-ID: <20260530160234.919148105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



