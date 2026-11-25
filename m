Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618817;
	b=XOTGJCioOrNhtyYwTjhrs/jRKEHdIUa+zHq2sNEAg/+t4tHX8iKYIsBAuNDqlklY4Bda
	 SenKvyicX47mHjp23WMcTH2K5LfsH3QOxmJC/1V/FQz4bu/A4jgwWJFSL2AXRUeGmtzW+
	 8q0VmzTlPnIGI4Tws6ieZMzmhlAZNAZLjRWbd3m26WdfA96EkRckSLz5yW6xkHW6QwFFI
	 vD07mnENE7pHkDr9NyWK3YhaxrPTVOI2CVdFEWTVR1afpFqmlQS8kwTkFhsKttM2s5Mp5
	 XuLaywNsx/7vR6qSEDUq1vzYvekFHC/MmVcBBByBQy9oaojFNuEa4STX9FfLQ0k+HZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxiyo+JK8+AZKqTLOXwWFRREPl4Cw7PkTdK1AACdh8s=;
	b=Fo27wQ5Niig8zJrNKfW5XvUmTvtI9spnZHGqGwcab8igF6BwScWD7Su+Nz0B22K6gsWR
	 JkxrNYf2ywx2rOKtKmPmCVx+4O01m4O24VmRp2OThKwgHmzAWHNF+Zfc1Rnm+keiX/JB/
	 kuoZJNB3INY5ExhH228yUu0T8p5SfP2eVMe2nKbVXWZiFFwjRKb3g/tVKFioI7v24/ZCV
	 8bvyLmF3zgNKDMtwMWEf2qpiulrbt+bCLRAGBdVYGS/k02Cv5GKhdV5p9tEZJXkYutvg0
	 nPqSiVWRqYShgoSmppmiPDTdF5QZfnvlNr7Xf0XygvNIDTDFLBWZeMuCcRUEryKRGMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8Uv1YTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312DC606A323;
	Wed, 25 Nov 2026 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8Uv1YTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251371F000C0;
	Wed, 25 Nov 2026 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618816;
	bh=rxiyo+JK8+AZKqTLOXwWFRREPl4Cw7PkTdK1AACdh8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8Uv1YTvMAYjG+z7OJK3+s8CPukbuCCgsxMm2R/ekoZtxKAgddGorfKzdtpkz3YIW
	 HMKjMLeoy+zwNvSv3VAqqkHG4q2WssuBtLkHSM5+gL0lLVIX7uPvl5OPkWe10GsrY/
	 I5+E1Adn3FDfWesMUV2BaIEqgwmVe8r5WX+e7JJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahad Bhuiya <rahadbhuiya2021@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an SCX_TASK_READY task
Date: Wed, 25 Nov 2026 15:28:19 +0100
Message-ID: <20261125143830.189554233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>

[ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]

Tasks in SCX_TASK_READY are attached to a scheduler but outside the ext
class, such as RT/DL tasks, or non-SCHED_EXT tasks under a partial switch.
The scheduler's BPF code can still update their dsq_vtime and slice (for
instance, via ops.cgroup_move() as done by scx_flatcg).

Because __scx_disable_and_exit_task() currently breaks out of the state
switch for SCX_TASK_READY without calling scx_reset_task_fields(), these
fields are not cleared when the task leaves the scheduler. If the task is
subsequently moved to another cgroup/sub-scheduler and later switches to
SCHED_NORMAL, the new scheduler's ops.enable() sees stale dsq_vtime from
the previous scheduler's clock.

Call scx_reset_task_fields() in the SCX_TASK_READY case of
__scx_disable_and_exit_task() to ensure SCX-managed fields are properly
reset when leaving the scheduler.

Fixes: 5771e79e461e ("sched_ext: Reset dsq_vtime and slice when a task leaves SCX")
Signed-off-by: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 50d5185bcd548..fd9f949f3647f 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
 		args.cancelled = true;
 		break;
 	case SCX_TASK_READY:
+		scx_reset_task_fields(task_rq(p), p);
 		break;
 	case SCX_TASK_ENABLED:
 		scx_disable_task(sch, p);
-- 
2.53.0



