Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D5332C931;
	Fri, 17 Oct 2025 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714222; cv=none; b=THj3M1an2vJjvdxNPkSRiRMuPqpbhtr5bnKuE4l9u11Xx4mGofOAIv92Oao18u8UDQfFCjcf2BPCO1T8GH6hlJBYY/jnHmZjQ19abtXJ5HbaRNlzm58lwmbYGUCByr7RzBJfH83/JZGBmlBrWAjiWNk4c4AYYuW//ERDrikfzmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714222; c=relaxed/simple;
	bh=OjCny0HLemGW6V36Txh0NbN5DIowv9KhmcdFkdhXp1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5PbvPsMqTvwjj+jRjzbQwP6PfhJAM98Vtgw2LjTZ3e8+v3tB2if8Nx6WRDcoTTwRqdBL+L9pFOdIRHQHtqK62+1u2ecwcg6HadR36Dsyc4TYNHDDJ0yVp14jWPwfjQjihvK6HKWilHPjRVr0qF6nCwWIvgt25HUmVg6BdPyy2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLiJumm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLiJumm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE5EC4CEE7;
	Fri, 17 Oct 2025 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714221;
	bh=OjCny0HLemGW6V36Txh0NbN5DIowv9KhmcdFkdhXp1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLiJumm8fq2P8KOrSwrqkNHBld0Gx6E2Xsy8I+WDwO4TP27sisb5GqQXi5YSq/dNv
	 DXAOqe2tilsiq//ypb1uZRIh7zZwf/ObSa2VbIi0AGPRWI3+Z7CBYBVsP/HKwuAY1z
	 wXY+hEpl1shqrsd6rNseRdnburAUTAwT0bDNd43Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/277] perf test: Update sysfs path for core PMU caps
Date: Fri, 17 Oct 2025 16:50:34 +0200
Message-ID: <20251017145148.140156618@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit b9228817127430356c929847f111197776201225 ]

While CPU is a system device, it'd be better to use a path for
event_source devices when it checks PMU capability.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250509213017.204343-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 48314d20fe46 ("perf test shell lbr: Avoid failures with perf event paranoia")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record_lbr.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record_lbr.sh b/tools/perf/tests/shell/record_lbr.sh
index 32314641217e6..ab6f2825f7903 100755
--- a/tools/perf/tests/shell/record_lbr.sh
+++ b/tools/perf/tests/shell/record_lbr.sh
@@ -4,7 +4,8 @@
 
 set -e
 
-if [ ! -f /sys/devices/cpu/caps/branches ] && [ ! -f /sys/devices/cpu_core/caps/branches ]
+if [ ! -f /sys/bus/event_source/devices/cpu/caps/branches ] &&
+   [ ! -f /sys/bus/event_source/devices/cpu_core/caps/branches ]
 then
   echo "Skip: only x86 CPUs support LBR"
   exit 2
-- 
2.51.0



