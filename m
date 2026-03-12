Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C619C26F288;
	Thu, 12 Mar 2026 20:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347162; cv=none; b=YuTIFvYwaYqy4WOmLla1gJY+adi6L8e2KPgZRm52EyKgQUR6YLEekUp34pmTgzjgw9cyrbgR1Kjdvpxk+IEFnDOnnLKUfzgT0BsdBFq5VDLmj9r+8sn8rctUjD7kFvjYHewI4Su2RHufXf1Gbi0lvpeFin5HNr4faCA4j7Ie/jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347162; c=relaxed/simple;
	bh=BgObVXn+AEJ4/r5qAN+rTdfs7JoHvGlhqcJs90JixbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoKhK7a3CKIkzd+cv6cfGcWjWgemZD/zwmA5iImnJpF2N3ecMJ6HHcoJEhc5da43iCH/wVxATo/V7pzCBB1UJguzGdZgEHSAw6wU025CXC9R/BqV+hkrLqJ5SFuOUn5W3MQRXRL5MtKLpbi26KdUcFUlTUNCuARwDwWfPOhl5oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVgK8LzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVgK8LzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C77EC4CEF7;
	Thu, 12 Mar 2026 20:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347162;
	bh=BgObVXn+AEJ4/r5qAN+rTdfs7JoHvGlhqcJs90JixbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVgK8LzMD5iDSTGTVO0n9Wxkf7W1qeeOb132eigRf0M96qndI0QtRmt6bSoURixBH
	 +BqBIJDUR+SLcWfq+V1caTRG4OJeQUVfJx2Omk6X6medJZ681KO8NSy7I/eN9+JSJE
	 TQgAcVCNrfutRCQDsKEEv2OjrTQzQZvH+AfiK0hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yujie Liu <yujie.liu@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/265] drm/sched: Fix kernel-doc warning for drm_sched_job_done()
Date: Thu, 12 Mar 2026 21:10:07 +0100
Message-ID: <20260312201026.270340685@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
index 4dde0dc525ce5..4f43c0fa4019f 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -404,6 +404,7 @@ static void drm_sched_run_free_queue(struct drm_gpu_scheduler *sched)
 /**
  * drm_sched_job_done - complete a job
  * @s_job: pointer to the job which is done
+ * @result: 0 on success, -ERRNO on error
  *
  * Finish the job's fence and wake up the worker thread.
  */
-- 
2.51.0



