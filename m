Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CE12DBF75;
	Tue, 21 Jul 2026 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657493; cv=none; b=sezOOaNv9PA+UOJR5hwgbC4XLFNhCewM1FsVVWcNL2ujBdWnBvg/I699Ad3hWp+O9hhSs94lvZhGanZqM3FyiAMyU8JOnP7kob81S8y41GCp8Kxv3gbCsDXRxYxqknO86neObgT9phIbtamWOSohvXEmTlJEjdubj62PlA4RfT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657493; c=relaxed/simple;
	bh=ChKTHJqQ89d4dx7QbgkNTUXzPfXLvL6ZkuFLSzdLirU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDm2NAoAySMtmFozzCWOAw2Gf8yqRB5SyIyRL8WSuXiQQwmZp/Gb7V62tJZ+uHN9KOmbXLAhut4i3Og8SWmNwZ6mKzxj+S+ecyGnQb9s2Ny3Z3ujvL0ONIBUGxwClZhHQS0v54N9fDQS6xJZPTN4rHZLF6ECGLAr5JqQIhM0+kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTr10wpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTr10wpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7511F000E9;
	Tue, 21 Jul 2026 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657492;
	bh=0o/wTxjHegm1dZVBeN1WGC39M66f0C57RLN2E+wse8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTr10wpKxyJyEYoTCFSfYdJUuw28PXwKGuWzE9Vrm7fshTky6icOLExL9J0D6+rOV
	 4soPIvra7uWnB1gxpT6/RYES5CiEvIq+ZYfMtc4BHS1JWJQ5ZftxAJ7zx55EwIyKIg
	 D5t5uxXvWDV1J15KZHvc/GquQ1BlQWrHYfCGpNZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0783/1611] perf: Remove redundant kernel.h include
Date: Tue, 21 Jul 2026 17:14:59 +0200
Message-ID: <20260721152532.996883563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 7a0ba3891104da77cfd1a16d41699e0fdf45603a ]

Now that the bitfield dependency is resolved, the explicit inclusion of
kernel.h is no longer needed.

Remove the redundant include.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 542e88a4c6f7 ("perf cs-etm: Reject CPU IDs that would overflow signed comparison")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm64/util/header.c | 1 -
 tools/perf/util/cs-etm.c            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/perf/arch/arm64/util/header.c b/tools/perf/arch/arm64/util/header.c
index f445a2dd629344..cbc0ba101636bf 100644
--- a/tools/perf/arch/arm64/util/header.c
+++ b/tools/perf/arch/arm64/util/header.c
@@ -1,4 +1,3 @@
-#include <linux/kernel.h>
 #include <linux/bits.h>
 #include <linux/bitfield.h>
 #include <stdio.h>
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 0e30d67ec18464..f939eb9edf7c7f 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -6,7 +6,6 @@
  * Author: Mathieu Poirier <mathieu.poirier@linaro.org>
  */
 
-#include <linux/kernel.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/coresight-pmu.h>
-- 
2.53.0



