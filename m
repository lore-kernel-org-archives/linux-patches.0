Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AB425F7B9;
	Thu, 28 May 2026 20:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000386; cv=none; b=k3LnRUykh1+Cye+7q7R5GM+/55ZK7F1pHBqhBaxhHjavX4pDDLMHUlGwIk1evja/aRjS7QYm60zmS4gPzQJ5UXpVPtNJYwv2Hm6zctcEqKKyZhTwFTeUzKbTo64TpMi2rTgCjExMpAJ38OiJIU9TJd7FeRsjdLVK7MZL6wIDCSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000386; c=relaxed/simple;
	bh=KoqxNawXKmDyIIV1dvrNwhFI+fHx40/PhmYeLPdCNks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QliXFv8DpvQS/sqz3kaS7mJyxXmvs/+ZYgekegtZ6AG+7vW5stNO9tXN0OL6px1JGVHeAFTX5TErpMr9cNyP7+xcHCSE3lsU7SzHFqcdcjeYyKsUAPgtWhgLHthx/NplwB2ul+tNK0hF2VgkCyhw2dQ9LNATU0lXu44MYHrlPCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7VYKrH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7VYKrH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E33C1F000E9;
	Thu, 28 May 2026 20:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000385;
	bh=mXXBllLOioJ+SBm0S2lm4Eri6PwSqnQPAifpmV8Mx1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7VYKrH5EC4dZt5BI9r3JhJMShusVAVRHgkzGwv/aSJ4YgEvzXyplguGFfdqP5nKM
	 CAfhsdjpckL5MHLzw4yn/6t0sqpCodzEcxKm8VmFUZTsY4U8w+p8vgchNkx1mL5Y0a
	 M306gAhNVdncTv8SgGPE9FemF0/raUsd9ArfEyu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/272] Revert "perf tool_pmu: Fix aggregation on duration_time"
Date: Thu, 28 May 2026 21:46:23 +0200
Message-ID: <20260528194629.642219819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

This reverts commit 310be445ab1028315627b326516f193511cb1c97.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/tool_pmu.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/perf/util/tool_pmu.c b/tools/perf/util/tool_pmu.c
index 3d1d6b3352ec7..f41fed39d70d8 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -392,14 +392,8 @@ int evsel__read_tool(struct evsel *evsel, int cpu_map_idx, int thread)
 		delta_start *= 1000000000 / ticks_per_sec;
 	}
 	count->val    = delta_start;
+	count->ena    = count->run = delta_start;
 	count->lost   = 0;
-	/*
-	 * The values of enabled and running must make a ratio of 100%. The
-	 * exact values don't matter as long as they are non-zero to avoid
-	 * issues with evsel__count_has_error.
-	 */
-	count->ena++;
-	count->run++;
 	return 0;
 }
 
-- 
2.53.0



