Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D68479876;
	Sat, 12 Sep 2026 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228989; cv=none; b=RQnJonJoFy+mhu9pWzX2rwMlkIN+SLFUJt3RHpo8rGAg60sYza2wJACPc1TyVJ8KbpFbBKCNK9WqPadtMYzMQ0QKO+TSVULScondiiE24N6O0ZUyyfn2OAKevnKV0B2wmy8DFsx2THkES06FEM/pmMGKhu+s0qB8kHter+3445Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228989; c=relaxed/simple;
	bh=FQUIi7q3lYRVQWHOtSMjqI3wD9LST0DuehMMz0E/occ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux0szrWiC88b18gnGWTJbRvg7XRC0papYOv+xiKdkinwU9gGRI2LmTg/+E+EiwuzQTPd4zV6ydmHE/mBKyc3kEUfZ3pgD8yT3g5bgKu+zDhpAw2P2giTA8SaQfP6UewXgHhZt0RBK5l/lJfZlBUgdvCkK+tGFSzXGs+Ggkh5Kn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDQR3IyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDQR3IyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99AB1F000FF;
	Sat, 12 Sep 2026 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228987;
	bh=RcU6JaixoARlEY6+zsv5ChBpcKSRoCGBas3x/4PGF6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDQR3IyT9Tjx7tW4ytCBTyGJtwayTC2qMBIdDTY98/5X8xESC7zJLORqCz/QdctFR
	 RYy9t2eAjONIXLAg5sES/bDo3VRN/3CM/jeUrTDwsPPFx4pTQEwwuzBaR7lA3EQyv6
	 c/Gy37P3sDcCwH6nzH3/kN2xKDhmHhKYtByF+/eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	song@kernel.org,
	bpf@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0497/1191] perf test: Use sqrtloop workload to test bperf event
Date: Sat, 12 Sep 2026 08:53:45 +0200
Message-ID: <20260912065559.396599418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



