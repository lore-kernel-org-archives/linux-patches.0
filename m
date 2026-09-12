Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C792DC792;
	Sat, 12 Sep 2026 10:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207347; cv=none; b=ZVi5YZmo81EwUDu3CieF3gaCcGI2ln+33Zd9yk252sIuetgGvfrFN0rbcne3TfbNZEGsOlQ2iIU2zfwd8K6z5C8EfEMhmwPX2oKF2Fd3mHJ+F0VjfR9PUW1ghJUyG3/ryZ//yTgJjbC9izzb1gPN2SEce7JEQCpOuqaAIh2ZPWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207347; c=relaxed/simple;
	bh=RvE80AtunitMXt6AnZLP7v7G+rhrZ1fG/it5JcNZjhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ5KPjoouE9Qg8cLIj+2NPMpN0Cm11I2c5QZsRkIVhZYhpSBhqmL7HuBMxKvll7H4pHuGWNQ3vuM7uvYFPX3DYQDq30CvONowqB8Eq8NDwJQFgbNYBgiPtWWLLusR0cUCehNboNus5LWqd4BQzbLtiEhMxfaOfAi9DrbP6GzzRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5LIpyQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5LIpyQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1241B1F000FF;
	Sat, 12 Sep 2026 10:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207346;
	bh=ZktB5q0yJoIi9Om6LCHyQY/eU5AfQi0WhLpa33GC9qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5LIpyQoWxH6QfFl2RcOBSnTNiV7EttZ8jkPoRSXN6BjLymKxR/ori6z6/buEF3Oy
	 er/jpwvD9c97l5lB2zSCJIJ6ok5lt8EJbeZ0oC0fPE6nsIS9mGf2gpf5AosrR7ZuPH
	 5fCiDQHKyf7azruQqrZXIGYEVGsLT+jhPK9aecBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0394/1518] tools/sched_ext: scx_qmap: Fix stale API name in comment
Date: Sat, 12 Sep 2026 08:42:43 +0200
Message-ID: <20260912065632.372214682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit 35f9cbbacb671e587c84e992e7b0098c39e895a4 ]

The comment above dispatch_highpri() still references
scx_bpf_dispatch[_vtime]_from_dsq(), which was renamed to
scx_bpf_dsq_move[_vtime]() in v6.13 to unload the overloaded
"dispatch" verb. The code below already uses the new names; only the
comment was left behind during the rename.

Fixes: 5cbb302880f5 ("sched_ext: Rename scx_bpf_dispatch[_vtime]_from_dsq*() -> scx_bpf_dsq_move[_vtime]*()")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_qmap.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bpf.c
index b76702bbf1ee8..19984b52323f5 100644
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -301,7 +301,7 @@ static void update_core_sched_head_seq(struct task_struct *p)
  * moving them to HIGHPRI_DSQ and then consuming them first. This makes minor
  * difference only when dsp_batch is larger than 1.
  *
- * scx_bpf_dispatch[_vtime]_from_dsq() are allowed both from ops.dispatch() and
+ * scx_bpf_dsq_move[_vtime]() are allowed both from ops.dispatch() and
  * non-rq-lock holding BPF programs. As demonstration, this function is called
  * from qmap_dispatch() and monitor_timerfn().
  */
-- 
2.53.0



