Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EA0431A5C;
	Sat, 12 Sep 2026 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214593; cv=none; b=Y+IIjnnmYTvN0rrVb3TS7daXXMjCeZ7xDN2FkBNC0e6C3WtRj41nm7aQdk48meIMADWScEi+YLr61hw9/Xv02O+/5omiKZ8NE1JarkjH0D4iDHj9CqL67AAkKpa46I/Hp6Cv3I6T3vvQxWAgDHP2ynzxyquZS4t/SdNnSOrmNPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214593; c=relaxed/simple;
	bh=B7h4mkqegEsCbwNPO48Wnjv5/Ts/Pxq036vCk4BY56o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH18JrJPa881l0kxdYQgFaIMCkXI2IWcvyP04Chc6zRpVwQcoqzLdeYspDgmiNbvFKCVYfS8T+L9fkw5r6FbKsExgdwFBB52fT5S4oebVpjKfKzJIB2t7HwEc00DFIo1qDAsJ45/bNbVKX7stjiDf4d2MiduUQiZzURD1cvbiHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNeNCxnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNeNCxnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7341F000FF;
	Sat, 12 Sep 2026 12:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214592;
	bh=AH8JH8j+EI6B51ylvf5VD7P/7v5dqEJoQEAwUS4u9ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNeNCxnwU1vCuCMKU8U4efNbOdXbmALYYaKRTMnakeLaoMx3SAkOAFEVeMQDGSCFv
	 QSdrs9FLicYsaHb9wtc8aaRjsxbVLiLuwhcGJVdHwdZ1PryifTABO55kxs1ZByftSU
	 hMxi+If6H8AvgLTRB+TgxuIppK28JwkNAyNRtR2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	song@kernel.org,
	bpf@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0358/1376] perf test: Use sqrtloop workload to test bperf event
Date: Sat, 12 Sep 2026 08:46:24 +0200
Message-ID: <20260912065615.530797458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



