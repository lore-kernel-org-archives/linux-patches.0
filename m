Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B6F4F1;
	Sat, 12 Sep 2026 16:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232155; cv=none; b=uLx+pjL8fEJqAljC0rGt5ZkBErMoo9he9yqcHz9/21atPvdXykFjmDjOb1Pj+N4YzneX6W/QvR63oqdq6lW2zitx2Kj06UX7qcXbClT40zx1Af8Ra/716a/yMxN+RSElUNwjJ/h35fAqCKkoZaKINyd3fZoH7zRCxOgvy9IV2FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232155; c=relaxed/simple;
	bh=KWM0BmkD2x5USwb5dDFgdYbRyv35bf8hUi4BSePf2hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBFCmwl0CMNtiQogk6LHSC/ji/RfI2GuFrLaYFKwFcEifbyiawQpULhpiIo81JVMFTC/Fwz8fpF93bgkwNVDvde2WOQv11dQV36ge7naXNcE7spZsy4eyPszB2p51wWIvpqRJGF1R6/xBXrSVf9rcl+iKDUDg0eor376BzrkYUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3X9qKkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3X9qKkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F78D1F000FF;
	Sat, 12 Sep 2026 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232153;
	bh=K1ilyGfAVptOrvQkLH1O1jI0Tefk1flyJF9/H0xPrKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3X9qKkOYhA8YT7zLaQetTC37NaYp1Dm2IUXx3Rw5pVLdMd9zA0JI8fVWIkGiVm4M
	 Y+SCVIAtETwOd0WM64Sz6lST8h10xq5rbDTEZNXuHyJPs2p4T2x+k8ko/3cxTqUg6J
	 wQ7m2SRLtcP5Nql5mMo0D+5iI9k12GyAnO7gwlkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1142/1191] perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error
Date: Sat, 12 Sep 2026 09:04:30 +0200
Message-ID: <20260912065613.801468852@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 01439286514ce9d13b8123f8ec3717d7135ff1d6 ]

If amd_uncore_event_init() fails, return an error irrespective of the
pmu_version. Setting hwc->config should be safe even if there is an
error so use this opportunity to simplify the code.

Closes: https://lore.kernel.org/all/aTaI0ci3vZ44lmBn@stanley.mountain/

Fixes: d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore management")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/076935e23a70335d33bd6e23308b75ae0ad35ba2.1765268667.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index cc84ed9cc63af..33ccd42328207 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -546,14 +546,11 @@ static int amd_uncore_df_event_init(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int ret = amd_uncore_event_init(event);
 
-	if (ret || pmu_version < 2)
-		return ret;
-
 	hwc->config = event->attr.config &
 		      (pmu_version >= 2 ? AMD64_PERFMON_V2_RAW_EVENT_MASK_NB :
 					  AMD64_RAW_EVENT_MASK_NB);
 
-	return 0;
+	return ret;
 }
 
 static int amd_uncore_df_add(struct perf_event *event, int flags)
-- 
2.53.0



