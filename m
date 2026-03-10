Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8965B425CC7;
	Tue, 10 Mar 2026 11:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142182; cv=none; b=tx5rp5R1j6j2EDwAz7AnbSXvKqB6ceh/I/GLGTDDlFNjdLkEmyn1RF6wS7e76iRMsL1zR1yFvgULOiUJKnGajomYjfh7qvTqg0H8YDPYfQYeNsvm0OmCmS7WpKHJ6VAorQwihTxUc4QPvLguQB9yf2rPI5d6UglFGAJ6Q46jOB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142182; c=relaxed/simple;
	bh=R3vuIlyIF6i6VmvwVzzJLIqHcBAaW6MPUvYXMmb1Aok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdwKF3lDWevNryykmr3bmNqt1ro4exZpLrkFP8HuEWktsyBu5vniC0e6wKGa2fPxe8Ii6QEb4vXKPhP1r4IQPHvvVRSKD9UcAspLxtScANQrth23qwBF6Mwj8ZAJdEU+apsNup0xhptnaVhlDI8Wk9lpNFVaCfzHtZS2CXs6H6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pavh6vhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pavh6vhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B74C2BCB0;
	Tue, 10 Mar 2026 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142182;
	bh=R3vuIlyIF6i6VmvwVzzJLIqHcBAaW6MPUvYXMmb1Aok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pavh6vhQBDEG0hY+BDHOaSVpLajrpSq0Zsat+L/6J6u0W4potw4Nh6/M04D7ptAS7
	 nm0H4+6MQbGKJFME0mwMD4yNBMzUSbUrQ9bgPKPhK95Cb7s/4OcrbSJSogQ1g66JTf
	 kuFPXid4V9EWHmX3idyIB+VruT14WXlxR7p5AYwLshhPcxZMtCVm1030zjPZupQWeV
	 xPS0C3t1egUek5we0wFbIz8EBSO7ABkAitTonc3zJi1bcI1EGDIWiMQBXZaxeUOQrG
	 V26lPFWSb/SsgymkSqDKoat5AwcSULVrM37WpSztrkz+SxrSWsX2xtsFUkiXrc8sOx
	 H0GgBAH9LIGXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yujie Liu <yujie.liu@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/314] drm/sched: Fix kernel-doc warning for drm_sched_job_done()
Date: Tue, 10 Mar 2026 07:18:50 -0400
Message-ID: <fde6ad6ff7a39c515e252c9d037ef4120be0c0d9.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yujie Liu <yujie.liu@intel.com>

[ Upstream commit 61ded1083b264ff67ca8c2de822c66b6febaf9a8 ]

There is a kernel-doc warning for the scheduler:

Warning: drivers/gpu/drm/scheduler/sched_main.c:367 function parameter 'result' not described in 'drm_sched_job_done'

Fix the warning by describing the undocumented error code.

Fixes: 539f9ee4b52a ("drm/scheduler: properly forward fence errors")
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
[phasta: Flesh out commit message]
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20260227082452.1802922-1-yujie.liu@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index c39f0245e3a97..3f138776d35fb 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -361,6 +361,7 @@ static void drm_sched_run_free_queue(struct drm_gpu_scheduler *sched)
 /**
  * drm_sched_job_done - complete a job
  * @s_job: pointer to the job which is done
+ * @result: 0 on success, -ERRNO on error
  *
  * Finish the job's fence and resubmit the work items.
  */
-- 
2.51.0

