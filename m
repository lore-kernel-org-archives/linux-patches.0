Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234B647ECED;
	Sat, 12 Sep 2026 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238231; cv=none; b=jPybcrPwRELDf+W7qMD+eaRIYH7Kuycfy4+6SXzzRL2ySqZFdKJkZqkD2gQzXPK7+irVsYPn5DttfCKup1U0LC0OTUFTLdQCORl5Xlya9FJuCimsj1i1EiNddOB025JQzBeHlTUsU+lx49z9VVyapkTQGv2l96Gp5aXlPq4Pyes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238231; c=relaxed/simple;
	bh=PUQQXneD8odZRZJ3xTbfytHLaR/fdy13y28xxTXe6t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf2TFyU7jdvgcZTsnb+SOj4qdmIphHxLYng2ElghAn/fJSN0vzqP6Y8YeyAKdrP7dzwL98d7apP7bc5TfSmViY0bMHN4BXuaFAolqXWJyKiD6ejwQ6olfrRScr3QQ83dPZ01j2WjJ2wDdd+zQAsn9lAj8Xqx/Jem5H7qdI/v00c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+pR4ftX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+pR4ftX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CB01F000FF;
	Sat, 12 Sep 2026 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238228;
	bh=i1xShRJ8JVkPClILX+t7dhLq4al3FfQZKbRbUCg2aRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+pR4ftX/xJVxj9pPiJahYca0RLvjNjrQpv7ZklIErFV0FZIx03F3WIGXjNZdtvcu
	 qVGHkxeWobmb0ga1XGB9IwjvD3WneAy4LvCrL6H4A1H05Pn/elMXJNYW/QHJAw6ols
	 tJD7AoFbNmfPQEQvk25NWuPeiKY6Ef3/+uHSC0xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	song@kernel.org,
	bpf@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/935] perf test: Use sqrtloop workload to test bperf event
Date: Sat, 12 Sep 2026 08:57:29 +0200
Message-ID: <20260912065536.433167426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit d36e5b36a2928b30e09ff59ce5ce2d5df935176e ]

Replace `brstack` workload with `sqrtloop` workload, because `sqrtloop`
workload contains fork(), which is suitable for testing the bperf event
inheritance feature.

Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Cc: song@kernel.org
Cc: bpf@vger.kernel.org
Link: https://lore.kernel.org/r/20241021110201.325617-3-wutengda@huaweicloud.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: b02027776ac5 ("perf tests: Fix flakiness in BPF counters test on hybrid systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index f250b7d6f773f..831f02add75e5 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -4,7 +4,7 @@
 
 set -e
 
-workload="perf test -w brstack"
+workload="perf test -w sqrtloop"
 
 # check whether $2 is within +/- 20% of $1
 compare_number()
-- 
2.53.0



