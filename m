Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBD546F48A;
	Tue, 21 Jul 2026 19:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662852; cv=none; b=Ad1YY/iY80aw4hkPeZCSl/ju9C+P/yJDINJ6zt8IvJUnXwaQvTBlbVgaf9RAt/HffWuF2OvTiPf793OIwjHz4vbwnngHv/nTfW1Zy/YulWUCSoPoW0uKYJrySLhJcmvb/k+RSy5FLsAPbwe372S040cCYcN0YyO+MJBQu5P8GkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662852; c=relaxed/simple;
	bh=qwyt4UWuTZqCoeCY4DnDjli+pX6IH1+gEWe8NH/8+rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIT43EdnFfny0pShRnf4cKv9+ji7xAOJtKam1naBqowx6xiKyAmSIO8VE3IO67UcB0GYS+ChTqq0+fchA8NSvZPj8rm7KcIyPkc5n+zj4DU6+3Tg1FH2d0Sm5G17dpQUChEJSgSww+L8EC4ET0IHki0CEbqrOfVjrwEkkzgV6jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhGhKF0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhGhKF0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954A51F000E9;
	Tue, 21 Jul 2026 19:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662851;
	bh=4reyHoUWyYHXvZsTJtor+OLlolNgMs2Ezxb1y2TgYdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhGhKF0IU8lN84FuRXYuA8mqRTdGuwb42m8sOBsdb80YGk9Xqu8oL3KsGd4uJIp5T
	 ZIdvus3atV7llfswdCSfRxkGykBFhWYcNT4uviQ//pScFjAT+OOTdD+xQW9cVDicIo
	 Ppi9ysJRYFwUoCHes2oBKYbrTw3Asp4bGkZda2B0=
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
Subject: [PATCH 6.12 0558/1276] perf: Remove redundant kernel.h include
Date: Tue, 21 Jul 2026 17:16:41 +0200
Message-ID: <20260721152458.604357561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 741df3614a09ac..d0ccc727593ca2 100644
--- a/tools/perf/arch/arm64/util/header.c
+++ b/tools/perf/arch/arm64/util/header.c
@@ -1,4 +1,3 @@
-#include <linux/kernel.h>
 #include <linux/bits.h>
 #include <linux/bitfield.h>
 #include <stdio.h>
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 3fd669817eb9bf..776bef4e00156e 100644
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



