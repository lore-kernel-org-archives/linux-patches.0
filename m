Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDA73451CF;
	Sat, 12 Sep 2026 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222536; cv=none; b=rYaHIFZdOTLpyW1Py8c13juP74quq1OgcJ3N8+10PkusvNZdRg2fDke5XXWmhk8lNms1ZG2WPBs1cYTiRnyxNgrIluYfVA0vylhXpnvims0rcCQhcusKXekMChceeYzLdkfGMAvUT2VJYnZ+x125kIEu3z/u06e36FfbRybbzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222536; c=relaxed/simple;
	bh=zelPC7OXnKQvojhVdCqYnqdEn5YKcWIqiQAn4Ifw/gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6oY0b+LbxDlcx7a5/m4Cv1baLAoLqHjq9ZofTdudf4CMHG8PEI0szZFy+8pS1wtfa7/qMrZyqjj/jwit0VpnF+JQNOG7O2bfBG5teQyQbFSNEqxUF7B2b/GOJWcq6/YxoWsdn3SAgini6rKrsoXYRkPkG3WmDhEaYEkVWLKXlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wh0QHw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wh0QHw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FAD1F00893;
	Sat, 12 Sep 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222534;
	bh=tVUvnqMBfpYfFFkdYwjyh1zYaV+1NJ5x4eRxxzLCGFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wh0QHw9Qnjp5XKspxV5+YHYHNxjXhXKiV6PM/Lh5rcXDbnJzv8IBLjKF5NcVvY4O
	 QOisbje1cJik3lSNzJpYfc9cjdac9CTFMQOwu0rz8EV2cMjalqLcZImMKN1lKiM7oq
	 MfVsb+C98tKGGqJyMXmlHn8jEHSTQ7dhweCWIH4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	song@kernel.org,
	bpf@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0606/1424] perf test: Use sqrtloop workload to test bperf event
Date: Sat, 12 Sep 2026 08:50:38 +0200
Message-ID: <20260912065620.863993388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



