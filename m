Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0496A352;
	Mon,  8 Apr 2024 13:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581800; cv=none; b=ZsSEiANoUvbKXxT1BfCK/nLTPuvUbcznDXYzXH4v81EaHlK8oKUr553eeWTh2HJjpQoeqpYlh90eiJ/gtptvuxixEuko0GzZmAI7Oey2kcMqj+vnSNQjEaQwY9FoOt7uprFUQwJo5xD+JQoJfm4orOrQD28u09LeXD9JoBJbax8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581800; c=relaxed/simple;
	bh=TgL+f6DTqmwzNEIHeG5HGeQFMlRHzdJ8sVEBLxNTtfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNg4ZRotGsTGDLOUMzcGdTB//2AUw4Az37Czkr9P5Nl5X4anEBhDfwuOUNxvAqZOQaqJ2qJpJ62wrv4Mcs8rOtBkY3riVBxll/1H93G6urG2DEtsqMXuVPGKP8SPdFJC40txCm+AJvXdFurt1zLxAVuDjoqm2PZC6BVG9uphw0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vdjuYre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vdjuYre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC45FC433C7;
	Mon,  8 Apr 2024 13:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581800;
	bh=TgL+f6DTqmwzNEIHeG5HGeQFMlRHzdJ8sVEBLxNTtfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vdjuYref60M1cjlb84TWSf4RNI+EtR1Nr/o/weU/SgiUIE6KqSdFg/t9KmFdok8N
	 Wn8FKH2eQmDSbPXX+W+806/quk84r+nAz83RDHjasmdiJxude5bu54LKiI/gAl+CcC
	 c4yrVeizBPmM96ummogUT4y5qUel8MQNs4EL+5Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 021/273] drm/xe/guc_submit: use jiffies for job timeout
Date: Mon,  8 Apr 2024 14:54:56 +0200
Message-ID: <20240408125309.952678533@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 9c1256369c10e31b5ce6575e4ea27fe2c375fd94 ]

drm_sched_init() expects jiffies for the timeout, but here we are
passing the timeout in ms. Convert to jiffies instead.

Fixes: eef55700f302 ("drm/xe: Add sysfs for default engine scheduler properties")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240314121554.223229-2-matthew.auld@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 2c5b70f74d61438a071a19370e63c234d2bd8938)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 9d5e3afef5057..bd1079aa88498 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1216,7 +1216,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 	init_waitqueue_head(&ge->suspend_wait);
 
 	timeout = (q->vm && xe_vm_in_lr_mode(q->vm)) ? MAX_SCHEDULE_TIMEOUT :
-		  q->sched_props.job_timeout_ms;
+		  msecs_to_jiffies(q->sched_props.job_timeout_ms);
 	err = xe_sched_init(&ge->sched, &drm_sched_ops, &xe_sched_ops,
 			    get_submit_wq(guc),
 			    q->lrc[0].ring.size / MAX_JOB_SIZE_BYTES, 64,
-- 
2.43.0



