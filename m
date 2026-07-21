Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B1841735B;
	Tue, 21 Jul 2026 19:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662408; cv=none; b=gOeQjjSBVfoyfDLLTV6tOIBkVvL5bET8Om9JQIkjtCbHYiIGAwlKpVtdiF/qhtdXnyLvxFHXJXzgVTVa4IpcbT1T8Z6IhTP4J17GEh511S2sEScIvIaDoTAgWHUXPYQM7ymb2n6jUBdqp9RgFifGG9HJJevLkSCwaUwpE/fs00c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662408; c=relaxed/simple;
	bh=SwAe1otbGk6SnmVp1tXnimmf+fCLbhKDfkrY+TbHWSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZqIPdBdRA9XQG6rccBnR4vLm60PkxMQjL3XA3vJPiE1cHci11YZNBurY3DJ/UZwnXJgeB2FLhgK7kG6KjeX1wHVHSJxN8TBbQJbLUiR9jrSsrAmNiBRmhgUH3zN+1StUGsBYyeTjQ54gfP9viqoFH/dOmWBm6iUVVe/qP6WBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzX5MOPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzX5MOPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A751F00A3A;
	Tue, 21 Jul 2026 19:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662407;
	bh=/FdA1I4X/z02T/pBorurCb0SB7huV7FyubDXZyaiOvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzX5MOPZIqlxtf7xnCkxodwEtL6NbQmF9POlxlqV+hH5Irh/xWkm9XsLXuey3l1b9
	 YGahHAAJpiU/ZKApjWs3VwWwcSKTjtATyIGAybPpS3YAF2LbkBzO8jFdDZv6WZNsET
	 +dcDT1eT2Up/P4e2HsDJ72zBOBoNnlwrFcbkfqqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Graham Woodward <graham.woodward@arm.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	nd@arm.com,
	mike.leach@linaro.org,
	linux-arm-kernel@lists.infradead.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0433/1276] perf arm-spe: Use ARM_SPE_OP_BRANCH_ERET when synthesizing branches
Date: Tue, 21 Jul 2026 17:14:36 +0200
Message-ID: <20260721152455.792328239@linuxfoundation.org>
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

From: Graham Woodward <graham.woodward@arm.com>

[ Upstream commit c1b67c85108f99af0a80aa9e59a2b94ad95428d7 ]

Instead of checking the type for just branch misses, we can instead
check for the OP_BRANCH_ERET and synthesise branches as well as
branch misses.

Signed-off-by: Graham Woodward <graham.woodward@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: Leo Yan <leo.yan@arm.com>
Cc: nd@arm.com
Cc: mike.leach@linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20241025143009.25419-3-graham.woodward@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 059e9100d82a ("perf event: Fix size of synthesized sample with branch stacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index fcacdd87c0d2b4..ce34cc5a2e7163 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -71,7 +71,7 @@ struct arm_spe {
 	u64				llc_access_id;
 	u64				tlb_miss_id;
 	u64				tlb_access_id;
-	u64				branch_miss_id;
+	u64				branch_id;
 	u64				remote_access_id;
 	u64				memory_id;
 	u64				instructions_id;
@@ -668,8 +668,8 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 		}
 	}
 
-	if (spe->sample_branch && (record->type & ARM_SPE_BRANCH_MISS)) {
-		err = arm_spe__synth_branch_sample(speq, spe->branch_miss_id);
+	if (spe->sample_branch && (record->op & ARM_SPE_OP_BRANCH_ERET)) {
+		err = arm_spe__synth_branch_sample(speq, spe->branch_id);
 		if (err)
 			return err;
 	}
@@ -1269,12 +1269,12 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
 	if (spe->synth_opts.branches) {
 		spe->sample_branch = true;
 
-		/* Branch miss */
+		/* Branch */
 		err = perf_session__deliver_synth_attr_event(session, &attr, id);
 		if (err)
 			return err;
-		spe->branch_miss_id = id;
-		arm_spe_set_event_name(evlist, id, "branch-miss");
+		spe->branch_id = id;
+		arm_spe_set_event_name(evlist, id, "branch");
 		id += 1;
 	}
 
-- 
2.53.0



