Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEA54825A1;
	Sat, 12 Sep 2026 18:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238210; cv=none; b=KJimo1afyvRTpgRsPuzLOnwwSS7+zDsgXrUyq531TB2i3t5FtQhWdW6it8VvMwes3sNO1uiEeyinBS4eUL0kLEDb3l6I7TavTx4AJjjAg94ugdTf8lL6wh0+8U65Uv6M7p9SKAYJKTyWkWyQNXlqCd2ksARcPiP5K5rV0OX+OHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238210; c=relaxed/simple;
	bh=78n/zVz6svAi0MHxP12nsLMTrcFZSjuw+qbB9CIXV2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOd1XGh+zxsv2gwuxOZCFGzcFsCJ2rC/YvyXNCkxyRIpMmEFaN5QtMs6nOmOw2iuq4n5EZPVh04wFDrM37Zj/2Cd61eXV2wdD1gilWD5niUin9oWxhirQ7T4qwEXFlcgUxH5DuCIYAZrx1OPvxmqmLolP2shWRPm7r+SKlkMCeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3B3+U0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3B3+U0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4538D1F000FF;
	Sat, 12 Sep 2026 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238208;
	bh=c61YGt1Cqn3skOgQWglbEDmsVnOYfixYwLwJ9Wy5BP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3B3+U0bNEJeOQJ3/I97oq8X+pg6lnth0km6H+Wt/TzzWaKLhlOQ3IYwANCi2BwJQ
	 CvxRrL5wVcYkeRy7d3gqd1pFr0Ps57TPI10AKVzeQhuxoViJ524lVs4GQYAFza5yCb
	 dtow6zu2LJoEjaaAQLH+RYwVpHB74eYkiqClrnNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	gor@linux.ibm.com,
	hca@linux.ibm.com,
	sumanthk@linux.ibm.com,
	svens@linux.ibm.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/935] perf test: raise limit to 20 percent for perf_stat_--bpf-counters_test
Date: Sat, 12 Sep 2026 08:57:26 +0200
Message-ID: <20260912065536.363678705@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 999eea92e8d7a1ffa83f7dc89c83d8ed1e746fa9 ]

This test case often fails on s390 (about 2 out of 10) because the
10% percent limit on the difference between --bpf-counters event counting
and s390 hardware counting is more than 10% in all failure cases.
Raise the limit to 20% on s390 and the test case succeeds.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: gor@linux.ibm.com
Cc: hca@linux.ibm.com
Cc: sumanthk@linux.ibm.com
Cc: svens@linux.ibm.com
Link: https://lore.kernel.org/r/20240108084009.3959211-1-tmricht@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: b02027776ac5 ("perf tests: Fix flakiness in BPF counters test on hybrid systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index a87bb2814b4c6..2d92098747746 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -4,19 +4,19 @@
 
 set -e
 
-# check whether $2 is within +/- 10% of $1
+# check whether $2 is within +/- 20% of $1
 compare_number()
 {
        first_num=$1
        second_num=$2
 
-       # upper bound is first_num * 110%
-       upper=$(expr $first_num + $first_num / 10 )
-       # lower bound is first_num * 90%
-       lower=$(expr $first_num - $first_num / 10 )
+       # upper bound is first_num * 120%
+       upper=$(expr $first_num + $first_num / 5 )
+       # lower bound is first_num * 80%
+       lower=$(expr $first_num - $first_num / 5 )
 
        if [ $second_num -gt $upper ] || [ $second_num -lt $lower ]; then
-               echo "The difference between $first_num and $second_num are greater than 10%."
+               echo "The difference between $first_num and $second_num are greater than 20%."
                exit 1
        fi
 }
-- 
2.53.0



