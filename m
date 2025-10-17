Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456763208;
	Fri, 17 Oct 2025 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714937; cv=none; b=o4fGRCvE+swgCDJqCSGTEOZFMvHxgLW/dJrs1Z27TpS6RPim8qfgeapaBflLoxYmdJJnJlmJ0YHoZS3emHKW+XN7J+IcayIt6mFbA7bbahu7S7nF6cN15RcJxYG16ALxJ9RAysAf0zLXFQbKjAkq76LlyNI8zT5m0/jBeyi6dOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714937; c=relaxed/simple;
	bh=sP6ZTuQ2IVg1YE7QJPNQU9IGNVX1vkl4Io5T7hvRJa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQPB4I5cB33J8EG8VdYpNE9MkOeSYOiG5GEJlTsqpy2VCIhogV4vMah7CIShoDtlWCf4l7bqvnC1OWx1MNJXOsRD5xJ93pG19IPqW+i6wOvjnylUtEJSwmpFcjdw01ZH/XtypRwSYseiNIroUbWUjEkmGwoDvSn2yEUdEACYTng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8ER3R3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8ER3R3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E997C4CEE7;
	Fri, 17 Oct 2025 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714937;
	bh=sP6ZTuQ2IVg1YE7QJPNQU9IGNVX1vkl4Io5T7hvRJa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8ER3R3Fu9h5GU/+oXkzfRcwxsRS6CLmjy43v8JhyzYllqHoCbSTbkQ9vZlBfLO4U
	 skqUj8DgHUNMAl7YP+red7JYe4KxkNm7Dz2EJ1vLhTgqR2oxqRQxTMIhIlrg5tpj7r
	 FIxdHIcD1ZKpDH9lvTJD/oq5XkEXJ2uZ3RVV3T10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ali Saidi <alisaidi@amazon.com>,
	German Gomez <german.gomez@arm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 040/371] perf arm_spe: Correct memory level for remote access
Date: Fri, 17 Oct 2025 16:50:15 +0200
Message-ID: <20251017145203.250588621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit cb300e3515057fb555983ce47e8acc86a5c69c3c ]

For remote accesses, the data source packet does not contain information
about the memory level. To avoid misinformation, set the memory level to
NA (Not Available).

Fixes: 4e6430cbb1a9f1dc ("perf arm-spe: Use SPE data source for neoverse cores")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 8ecf7142dcd87..3086dad92965a 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -670,8 +670,8 @@ static void arm_spe__synth_data_source_common(const struct arm_spe_record *recor
 	 * socket
 	 */
 	case ARM_SPE_COMMON_DS_REMOTE:
-		data_src->mem_lvl = PERF_MEM_LVL_REM_CCE1;
-		data_src->mem_lvl_num = PERF_MEM_LVLNUM_ANY_CACHE;
+		data_src->mem_lvl = PERF_MEM_LVL_NA;
+		data_src->mem_lvl_num = PERF_MEM_LVLNUM_NA;
 		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 		data_src->mem_snoopx = PERF_MEM_SNOOPX_PEER;
 		break;
-- 
2.51.0



