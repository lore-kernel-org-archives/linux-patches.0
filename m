Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617794;
	b=UK6SRc8opIjWwSDinuAEXilroFr28YNKi+6BmOsjOuGCZUQpS06jUqUOVHtJpf148gZw
	 mBxcH2awM6mA72Op6XDjImXLE0wWXXZbPYd2KjA7ydGLPSYxHhZ5TxjjZkrn+hZN4EypU
	 dhykVHreYTQIOoLaKsM4T7Fj8Xs1As7JkOYLFIjFEEULexzfAJSyjySNN4TGv0Sb8GtTR
	 qAQaUgK7RUfCiDCcutq9lDBXzAvj4TnikAw05RJCN/uJrUK+uVjoZ6Oo9Bxbl+wKU3/up
	 1pJZNluZqgPxDe/ptLfV/NFO5Iy3P2N/BfRwULzSHgwotxbpmsBrXj2XWdYvdMoo33A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5UoYMpBojywVlfc1CwOPQ3fZ3p9iHSogaG0gnoC9DPc=;
	b=r5Q1m0V7gSD01U+bwwXGkiFxAUXGa3auCLhWdXDY5ZldRXaKjYfxd79OfN+Bk0we3F0s
	 u2RDPR7cgyho1mLsDIi+dJJKq1DwZ6ngBxrXnzOwrf8UvZtpqpZxxVXH8Cvem5L+clZKw
	 aBPkmPkktITyiWdXSP7WE1NFXQS5keBbOrDerlpGOKdpNF+3M7f/QJ6dOMm+arwhljEhB
	 93OYBFd/+bj/GElLQMeozYr9RFHWHBwL6dqwv2TVFpBAy7zf8lsB75fgZjjLren1D7XeB
	 +qSPrOvXYnvMGs8RoXTcnZ+y3rd30tHjOnyKzbF9SMZ2/yWdSpap2hwXGxNe6qPn1gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+LbRBW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38401606A321;
	Wed, 25 Nov 2026 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+LbRBW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28E11F000D1;
	Wed, 25 Nov 2026 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617793;
	bh=5UoYMpBojywVlfc1CwOPQ3fZ3p9iHSogaG0gnoC9DPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+LbRBW5Xde0NDQyTcUaAAPHusSdDOL+ofVZgDsdh1YmkEMXvhjCuZHUdSqtcwfUQ
	 lGHKFGEId0PvWIQ1jgnJXKSFHdM5BvP9reFAAIxm2nuNkv5hDR1VhBj8mKaw56QVDw
	 2ElG9EKS7SAG1WHhrG8FTlCgtlkryeNoZXsQTuJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0069/1005] sched_ext: Call ops.sub_attach() only while the cgroup is online
Date: Wed, 25 Nov 2026 15:23:27 +0100
Message-ID: <20261125143823.360773115@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 0aba89317f386f43c946d91238af28250b4dbc60 ]

The parent's ops.sub_attach() runs before the enable work checks that the
cgroup is still online, so the parent can get an attach for a cgroup whose
rmdir already returned. That complicates parents where cgroup cleanup and
sub-scheduler attach race.

Check CSS_ONLINE and call ops.sub_attach() under cgroup_lock(), so that the
parent sees an attach only for a cgroup that is online.

Fixes: ebeca1f930ea ("sched_ext: Introduce cgroup sub-sched support")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/internal.h |  4 ++++
 kernel/sched/ext/sub.c      | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index 68703b10d8998..2f35b98adb72b 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -839,6 +839,10 @@ struct sched_ext_ops {
 	 * @sub_attach: Attach a sub-scheduler
 	 * @args: argument container, see the struct definition
 	 *
+	 * The sub-scheduler's cgroup is online for the whole call. If it goes
+	 * offline after the sub-scheduler is accepted, ops.sub_detach()
+	 * follows.
+	 *
 	 * Return 0 to accept the sub-scheduler. -errno to reject.
 	 */
 	s32 (*sub_attach)(struct scx_sub_attach_args *args);
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index cb75d1912a7b8..4dc3bb12aca3a 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -2064,8 +2064,21 @@ void scx_sub_enable_workfn(struct kthread_work *work)
 		.cgroup_path = sch->cgrp_path,
 	};
 
+	/*
+	 * The cgroup stays online across ops.sub_attach(), so the parent never
+	 * sees an attach for a cgroup that rmdir already removed.
+	 */
+	cgroup_lock();
+	if (!(cgrp->self.flags & CSS_ONLINE)) {
+		cgroup_unlock();
+		scx_error(sch, "cgroup is not online");
+		ret = -ENODEV;
+		goto err_disable;
+	}
 	ret = SCX_CALL_OP_RET(parent, sub_attach, NULL,
 			      &sub_attach_args);
+	cgroup_unlock();
+
 	if (ret) {
 		ret = scx_ops_sanitize_err(sch, "sub_attach", ret);
 		scx_error(sch, "parent rejected (%d)", ret);
-- 
2.53.0



